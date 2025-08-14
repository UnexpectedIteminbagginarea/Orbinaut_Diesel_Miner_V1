#!/bin/bash

# DIESEL Miner - Alkanes Protocol
# Version 1.0 - Mempool-aware edition
# 
# This script mines DIESEL tokens on the Alkanes protocol
# It includes mempool transaction tracking to prevent UTXO locking errors
#
# SETUP REQUIRED: See SETUP_CHECKLIST.md for configuration instructions

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
ENV_FILE=".env"
DEFAULT_FEE_RATE=10
DIESEL_CONTRACT="2,0"  # DIESEL token contract ID
MINT_OPCODE="77"       # Minting opcode
LAST_TX_FILE="last_diesel_tx.txt"  # Store last transaction ID
MEMPOOL_CHECK_INTERVAL=30  # How often to check mempool status

# Function to load environment
load_env() {
    if [ ! -f "$ENV_FILE" ]; then
        echo -e "${RED}Error: $ENV_FILE not found${NC}"
        echo -e "${YELLOW}Please create a .env file with:${NC}"
        echo "MNEMONIC=\"your twelve word mnemonic phrase\""
        echo "SANDSHREW_PROJECT_ID=\"your_sandshrew_project_id\""
        exit 1
    fi
    
    source "$ENV_FILE"
    
    if [ -z "$MNEMONIC" ]; then
        echo -e "${RED}Error: MNEMONIC not set in $ENV_FILE${NC}"
        exit 1
    fi
    
    # Export required environment variables
    # TODO: Replace with your Sandshrew project ID
    export SANDSHREW_PROJECT_ID="${SANDSHREW_PROJECT_ID:-YOUR_SANDSHREW_PROJECT_ID_HERE}"
    export MNEMONIC="$MNEMONIC"
    
    echo -e "${GREEN}Environment loaded successfully${NC}"
}

# Function to check wallet balance
check_balance() {
    echo -e "${YELLOW}Checking wallet balance...${NC}"
    
    # Get wallet address from mnemonic
    local wallet_info
    wallet_info=$(oyl-local account mnemonicToAccount "$MNEMONIC" -p bitcoin 2>/dev/null)
    
    if [ $? -ne 0 ]; then
        echo -e "${RED}Error getting wallet information${NC}"
        return 1
    fi
    
    # Extract native segwit address (bc1q...)
    local address
    address=$(echo "$wallet_info" | grep -o '"nativeSegwit":"[^"]*"' | cut -d'"' -f4)
    
    if [ -z "$address" ]; then
        echo -e "${YELLOW}Could not extract address from wallet info${NC}"
        # TODO: Add your fallback address here if needed
        # address="YOUR_FALLBACK_ADDRESS_HERE"
        return 1
    fi
    
    echo -e "${BLUE}Wallet address: $address${NC}"
    
    # Use accountUtxos which works better with mnemonic
    local balance_info
    balance_info=$(oyl-local utxo accountUtxos -p bitcoin 2>&1)
    
    # Calculate total spendable balance from all UTXOs
    local spendable=0
    if echo "$balance_info" | grep -q "satoshis"; then
        # Extract only the satoshi values using specific pattern
        # This looks for "satoshis: NUMBER" and extracts just the NUMBER
        spendable=$(echo "$balance_info" | sed -n 's/.*satoshis: \([0-9]*\).*/\1/p' | awk '{sum+=$1} END {print sum}')
    fi
    
    if [ -z "$spendable" ] || [ "$spendable" = "0" ]; then
        echo -e "${RED}Could not determine balance or no balance found${NC}"
        echo -e "${YELLOW}Please ensure your wallet has sufficient BTC for fees${NC}"
        return 1
    fi
    
    # Convert satoshis to BTC
    local balance_btc
    balance_btc=$(echo "scale=8; $spendable / 100000000" | bc)
    
    echo -e "${GREEN}Current balance: $balance_btc BTC ($spendable sats)${NC}"
    
    # Check if balance is sufficient for transaction
    local min_balance_sats=5000  # Minimum ~5000 sats for a transaction
    if [ -n "$spendable" ] && [ "$spendable" -lt "$min_balance_sats" ]; then
        echo -e "${RED}Insufficient balance. Minimum required: 0.00005 BTC${NC}"
        return 1
    fi
    
    return 0
}

# Function to check current DIESEL balance
check_diesel_balance() {
    echo -e "${YELLOW}Checking DIESEL balance...${NC}"
    
    # Get wallet address
    local wallet_info
    wallet_info=$(oyl-local account mnemonicToAccount "$MNEMONIC" -p bitcoin 2>/dev/null)
    local address
    address=$(echo "$wallet_info" | grep -o '"taproot":"[^"]*"' | cut -d'"' -f4)
    
    if [ -z "$address" ]; then
        echo -e "${YELLOW}Could not extract taproot address${NC}"
        # TODO: Add your taproot address here if needed
        # address="YOUR_TAPROOT_ADDRESS_HERE"
        return 1
    fi
    
    echo -e "${BLUE}Checking tokens for: $address${NC}"
    
    # Get alkanes/tokens for the address
    local token_info
    token_info=$(oyl-local provider alkanes -method getAlkanesByAddress -params "{\"address\":\"$address\"}" -p bitcoin 2>&1)
    
    # Parse DIESEL balance if present
    local diesel_balance=0
    if echo "$token_info" | grep -q "DIESEL"; then
        diesel_balance=$(echo "$token_info" | grep -A2 "DIESEL" | grep "balance" | grep -o '[0-9]*' | head -1)
    fi
    
    if [ -n "$diesel_balance" ] && [ "$diesel_balance" -gt 0 ]; then
        echo -e "${GREEN}Current DIESEL balance: $diesel_balance${NC}"
    else
        echo -e "${YELLOW}No DIESEL tokens found (or unable to parse balance)${NC}"
    fi
}

# Function to check if transaction is still in mempool
check_tx_in_mempool() {
    local tx_id=$1
    
    if [ -z "$tx_id" ]; then
        return 1  # No transaction to check
    fi
    
    echo -e "${YELLOW}Checking mempool for transaction: ${tx_id:0:8}...${NC}"
    
    # Check transaction status via mempool.space API
    local tx_status
    tx_status=$(curl -s "https://mempool.space/api/tx/$tx_id/status" 2>/dev/null)
    
    # Check if confirmed (has block_height)
    if echo "$tx_status" | grep -q "block_height"; then
        echo -e "${GREEN}Previous transaction confirmed!${NC}"
        return 1  # Not in mempool (confirmed)
    elif echo "$tx_status" | grep -q "confirmed.*false"; then
        echo -e "${YELLOW}Transaction still in mempool, waiting...${NC}"
        return 0  # Still in mempool
    else
        # If we can't determine status, assume it's not in mempool
        echo -e "${YELLOW}Could not determine transaction status${NC}"
        return 1
    fi
}

# Function to wait for previous transaction to clear
wait_for_tx_confirmation() {
    if [ ! -f "$LAST_TX_FILE" ]; then
        echo -e "${GREEN}No previous transaction to wait for${NC}"
        return 0
    fi
    
    local last_tx
    last_tx=$(cat "$LAST_TX_FILE")
    
    if [ -z "$last_tx" ]; then
        return 0
    fi
    
    echo -e "${BLUE}Checking status of last transaction...${NC}"
    
    while check_tx_in_mempool "$last_tx"; do
        echo -e "${YELLOW}Waiting $MEMPOOL_CHECK_INTERVAL seconds before checking again...${NC}"
        sleep "$MEMPOOL_CHECK_INTERVAL"
    done
    
    # Clear the file once confirmed
    > "$LAST_TX_FILE"
    echo -e "${GREEN}Ready to send new transaction!${NC}"
}

# Function to mine DIESEL (simple version)
mine_diesel() {
    local fee_rate=${1:-$DEFAULT_FEE_RATE}
    
    # Check if we should wait for previous transaction
    wait_for_tx_confirmation
    
    echo -e "${BLUE}=== DIESEL Mining Transaction ===${NC}"
    echo -e "${YELLOW}Contract: $DIESEL_CONTRACT${NC}"
    echo -e "${YELLOW}Operation: Mint (opcode $MINT_OPCODE)${NC}"
    echo -e "${YELLOW}Fee Rate: $fee_rate sat/vB${NC}"
    echo -e "${YELLOW}Note: After the protocol change, you'll receive DIESEL proportional to your fee${NC}"
    echo
    
    # Construct the transaction data
    local tx_data="${DIESEL_CONTRACT},${MINT_OPCODE}"
    
    echo -e "${GREEN}Transaction data: $tx_data${NC}"
    echo
    echo -e "${YELLOW}⚠️  This will use real Bitcoin for the transaction fee${NC}"
    echo -e "${YELLOW}⚠️  The amount of DIESEL received will be proportional to fee paid${NC}"
    echo
    echo -n "Proceed with DIESEL minting? (y/n): "
    read -r confirm
    
    if [ "$confirm" != "y" ]; then
        echo -e "${YELLOW}Mining cancelled${NC}"
        return
    fi
    
    echo -e "${GREEN}Broadcasting transaction...${NC}"
    
    # Execute the alkane transaction
    local result
    result=$(oyl-local alkane execute \
        -data "$tx_data" \
        -feeRate "$fee_rate" \
        -p bitcoin \
        -m "$MNEMONIC" 2>&1)
    
    # Check if transaction was successful
    if echo "$result" | grep -q "txId"; then
        # Extract transaction ID - try multiple patterns
        local tx_id
        tx_id=$(echo "$result" | grep -o '"txId":"[^"]*"' | cut -d'"' -f4)
        
        if [ -z "$tx_id" ]; then
            # Try with spaces around colon
            tx_id=$(echo "$result" | grep -o '"txId" *: *"[^"]*"' | grep -o '[a-f0-9]\{64\}')
        fi
        
        if [ -z "$tx_id" ]; then
            # Try plain text format
            tx_id=$(echo "$result" | grep -o 'txId: [a-zA-Z0-9]*' | cut -d' ' -f2)
        fi
        
        if [ -z "$tx_id" ]; then
            # Last resort - look for any 64-character hex string
            tx_id=$(echo "$result" | grep -o '[a-f0-9]\{64\}' | head -1)
        fi
        
        echo -e "${GREEN}✅ Transaction sent successfully!${NC}"
        echo -e "${GREEN}Transaction ID: $tx_id${NC}"
        echo -e "${BLUE}Track at: https://mempool.space/tx/$tx_id${NC}"
        echo
        echo -e "${YELLOW}Your DIESEL will be minted when the transaction confirms${NC}"
        echo -e "${YELLOW}Amount received depends on your fee relative to others${NC}"
        
        # Store transaction ID for mempool tracking
        echo "$tx_id" > "$LAST_TX_FILE"
        
        # Store transaction for tracking
        echo "$tx_id $(date '+%Y-%m-%d %H:%M:%S') fee:${fee_rate}" >> diesel_mining_history.log
        
    else
        echo -e "${RED}Transaction failed${NC}"
        echo -e "${RED}Error: $result${NC}"
        return 1
    fi
}

# Function to monitor and auto-mine on new blocks
monitor_and_mine() {
    local fee_rate=${1:-$DEFAULT_FEE_RATE}
    local interval=${2:-30}  # Check interval in seconds
    
    echo -e "${BLUE}=== Starting DIESEL Mining Monitor ===${NC}"
    echo -e "${YELLOW}Fee Rate: $fee_rate sat/vB${NC}"
    echo -e "${YELLOW}Check Interval: $interval seconds${NC}"
    echo -e "${YELLOW}Press Ctrl+C to stop${NC}"
    echo
    
    local last_block=0
    
    while true; do
        # Get current block height
        local current_block
        current_block=$(curl -s "https://mempool.space/api/blocks/tip/height")
        
        if [ -n "$current_block" ] && [ "$current_block" -gt "$last_block" ]; then
            echo -e "${GREEN}New block detected: $current_block${NC}"
            
            # Mine DIESEL for the new block
            mine_diesel "$fee_rate"
            
            last_block=$current_block
        fi
        
        # Wait before checking again
        sleep "$interval"
    done
}

# Function to show usage
show_usage() {
    echo "Usage: $0 [command] [options]"
    echo
    echo "Commands:"
    echo "  mine [fee_rate]     - Mine DIESEL once with specified fee rate (default: $DEFAULT_FEE_RATE)"
    echo "  monitor [fee_rate]  - Monitor blocks and auto-mine on new blocks"
    echo "  balance            - Check BTC and DIESEL balances"
    echo "  help               - Show this help message"
    echo
    echo "Examples:"
    echo "  $0 mine              # Mine with default fee rate"
    echo "  $0 mine 15           # Mine with 15 sat/vB fee"
    echo "  $0 monitor 12        # Auto-mine on new blocks with 12 sat/vB"
    echo "  $0 balance           # Check wallet balances"
    echo
    echo "Setup:"
    echo "  1. Create a .env file with your MNEMONIC and SANDSHREW_PROJECT_ID"
    echo "  2. Install oyl-local CLI (see documentation)"
    echo "  3. Ensure wallet has BTC for fees (minimum ~0.00005 BTC)"
}

# Main execution
main() {
    # Load environment first
    load_env
    
    # Parse command
    case "${1:-mine}" in
        mine)
            check_balance || exit 1
            mine_diesel "${2:-$DEFAULT_FEE_RATE}"
            echo
            check_diesel_balance
            ;;
        monitor)
            check_balance || exit 1
            monitor_and_mine "${2:-$DEFAULT_FEE_RATE}" "${3:-30}"
            ;;
        balance)
            check_balance
            check_diesel_balance
            ;;
        help|--help|-h)
            show_usage
            ;;
        *)
            echo -e "${RED}Unknown command: $1${NC}"
            show_usage
            exit 1
            ;;
    esac
}

# Run main function with all arguments
main "$@"