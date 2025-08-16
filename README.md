# DIESEL Miner - Alkanes Protocol

A mempool-aware Bitcoin script for mining DIESEL tokens on the Alkanes protocol. This miner includes advanced features like transaction tracking and automatic UTXO management to prevent common errors.

## Features

- 🚀 **Automatic DIESEL Mining**: Mines DIESEL tokens on new Bitcoin blocks
- 🔍 **Mempool Awareness**: Waits for pending transactions to prevent UTXO locking
- 💰 **Balance Tracking**: Monitor both BTC and DIESEL balances
- ⚡ **Proportional Rewards**: Optimized for the new proportional DIESEL distribution system
- 🛡️ **Error Prevention**: Robust error handling and transaction validation
- 📊 **Transaction History**: Logs all mining attempts for tracking

## 📚 Essential Resources

> **🔥 NEW TO ALKANES?** Start with the comprehensive [Alkanes SDK Documentation](https://alkanes-docs.vercel.app/docs/developers/sdk/) - your complete guide to building on the Alkanes protocol!

## How It Works

DIESEL is a token on the Alkanes protocol that can be mined by submitting special Bitcoin transactions. After the upcoming protocol change, DIESEL rewards will be distributed proportionally based on transaction fees paid, eliminating the need to race for the first transaction in each block.

### Mining Process
1. Script detects new Bitcoin blocks
2. Submits a transaction with contract data `"2,0,77"`
3. Pays Bitcoin transaction fee
4. Receives DIESEL proportional to fee paid

## Quick Start

### Prerequisites
- Node.js installed
- oyl-local CLI installed
- Small amount of BTC you're prepared to lose (minimum 0.00005 BTC)

⚠️ **IMPORTANT: Create a NEW wallet for mining - never use your main wallet!**

### Easiest Setup Method: Use Windsurf AI IDE

For the simplest setup experience, we recommend using Windsurf's AI-powered IDE:

1. **Get Windsurf** (free trial): https://windsurf.com/pricing
2. **Open this project** in Windsurf
3. **Use the AI assistant** (Cmd+L) to help configure everything automatically
4. **Follow the prompts** in SETUP_CHECKLIST.md

The AI will help you install dependencies, create wallets, and configure the script.

### Manual Installation

1. Clone this repository:
```bash
git clone https://github.com/UnexpectedIteminbagginarea/Orbinaut_Diesel_Miner_V1.git
cd diesel-miner
```

2. Install oyl-local CLI:
```bash
git clone https://github.com/Oyl-Wallet/oyl-sdk.git
cd oyl-sdk
npm install
alias oyl-local="$(pwd)/bin/oyl.js"
```

3. Create a NEW wallet for mining:
```bash
# Generate new seed phrase - SAVE THIS SECURELY!
oyl-local account generateMnemonic

# Verify your new addresses
oyl-local account mnemonicToAccount "your new seed phrase" -p bitcoin
```

4. Get your Sandshrew API key:
   - Visit http://sandshrew.io
   - Create a free account
   - Create a new project and copy the project ID

5. Create `.env` file with your NEW wallet:
```bash
cat > .env << EOF
MNEMONIC="your NEW twelve word seed phrase from step 3"
SANDSHREW_PROJECT_ID="your_project_id_from_sandshrew"
EOF
```

6. Make script executable:
```bash
chmod +x diesel-miner-template.sh
```

7. Fund your NEW wallet (ONLY what you're prepared to lose):
```bash
# Get your address from balance check
./diesel-miner-template.sh balance
# Send a small amount (0.0001 BTC) to the displayed address
```

8. Check your setup:
```bash
./diesel-miner-template.sh balance
```

## Usage

### Setting the Fee Rate (sat/vB)
The fee rate is specified as a number after the command. This determines:
- How much you pay in Bitcoin transaction fees
- Your proportional share of DIESEL rewards (higher fee = more DIESEL)

### Mine Once
```bash
./diesel-miner-template.sh mine 10  # Mine with 10 sat/vB fee
./diesel-miner-template.sh mine 2   # Mine with 2 sat/vB (minimum)
./diesel-miner-template.sh mine 20  # Mine with 20 sat/vB (priority)
```

### Continuous Mining
```bash
yes | ./diesel-miner-template.sh monitor 10  # Auto-mine with 10 sat/vB
yes | ./diesel-miner-template.sh monitor 2   # Auto-mine with 2 sat/vB (economy)
yes | ./diesel-miner-template.sh monitor 15  # Auto-mine with 15 sat/vB (balanced)
```

### Check Balances
```bash
./diesel-miner-template.sh balance
```

### Run in Background
```bash
nohup yes | ./diesel-miner-template.sh monitor 10 > diesel.log 2>&1 &
```

## Configuration

See [SETUP_CHECKLIST.md](SETUP_CHECKLIST.md) for detailed configuration instructions.

### Key Settings
- **Fee Rate**: Determines your DIESEL reward share (higher fee = more DIESEL)
- **Check Interval**: How often to check for new blocks (default: 30 seconds)
- **Mempool Timeout**: How long to wait for pending transactions (default: 30 seconds)

## Fee Strategy

After the protocol change:
- **2 sat/vB**: Minimum fee, minimal DIESEL
- **10 sat/vB**: Standard, balanced cost/reward
- **20+ sat/vB**: Priority, maximum DIESEL share

## Repository Files

- `diesel-miner-template.sh` - Main mining script
- `SETUP_CHECKLIST.md` - Step-by-step setup guide
- `WINDSURF_SETUP_GUIDE.md` - AI-assisted setup instructions
- `README.md` - This documentation
- `.env.example` - Template for environment configuration
- `.gitignore` - Protects sensitive files from being committed

## Safety Features

### Mempool Tracking
The script tracks your pending transactions and waits for confirmation before submitting new ones, preventing "insufficient balance" errors.

### Balance Verification
Checks wallet balance before each transaction to ensure sufficient funds.

### Transaction Logging
All mining attempts are logged with timestamps and transaction IDs for tracking.

## Troubleshooting

### Common Issues

**"Insufficient balance"**
- Ensure you have at least 0.00005 BTC
- Wait for pending transactions to confirm
- Check address has received funds

**"oyl-local not found"**
- Verify oyl-sdk installation
- Check alias is set correctly
- Use full path if needed

**"Transaction failed"**
- Check mempool congestion
- Increase fee rate
- Verify environment configuration

## Security

⚠️ **CRITICAL SECURITY WARNINGS:**
- **CREATE A NEW WALLET** - Never use your main Bitcoin wallet
- **ONLY FUND WITH WHAT YOU'RE PREPARED TO LOSE**
- **NEVER** share your mnemonic seed phrase
- **NEVER** commit `.env` to version control
- Keep your Sandshrew API key private
- This is experimental software - expect bugs and potential loss
- Start with minimal amounts (0.0001 BTC max for testing)

## Protocol Information

### DIESEL Contract
- Contract ID: `2,0`
- Mint Opcode: `77`
- Transaction Data: `"2,0,77"`

### Address Types
- **Native SegWit (bc1q...)**: Pays transaction fees
- **Taproot (bc1p...)**: Receives DIESEL tokens

### Learn More About Alkanes
- **Developer Quickstart**: https://alkanes-docs.vercel.app/docs/developers/quickstart
- **Understanding the protocol**: Learn how Alkanes tokens work on Bitcoin
- **oyl-sdk documentation**: Complete CLI and SDK reference

## Contributing

Contributions are welcome! Please:
1. Fork the repository
2. Create a feature branch
3. Submit a pull request

## Resources

- [Alkanes Protocol Documentation](https://alkanes-docs.vercel.app/docs/developers/quickstart)
- [Sandshrew API](http://sandshrew.io) - Get your free API key here
- [Bitcoin Mempool](https://mempool.space)
- [oyl-sdk](https://github.com/Oyl-Wallet/oyl-sdk)

## License

MIT License - See LICENSE file for details

## Disclaimer

This software interacts with the Bitcoin mainnet and uses real funds. Use at your own risk. Always verify transactions and start with small amounts for testing.

## Support

For issues or questions:
- Open an issue on GitHub
- Check transaction status on mempool.space
- Review the SETUP_CHECKLIST.md for configuration help

---

**Note**: This is experimental software for the Alkanes protocol. The proportional DIESEL distribution system may not be active yet. Monitor official Alkanes channels for updates.