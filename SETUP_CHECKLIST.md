# DIESEL Miner Setup Checklist

This checklist will help you configure the DIESEL miner script for your environment.

## Prerequisites

- [ ] Node.js installed (for oyl-local CLI)
- [ ] Basic command line knowledge
- [ ] Small amount of Bitcoin for testing (only what you're prepared to lose)

## Recommended: Use Windsurf AI IDE for Easy Setup

Windsurf is an AI-powered IDE that can help you configure this script automatically. It's free to start and makes the setup process much easier.

### Getting Started with Windsurf

1. **Sign up for free trial**:
   - Visit https://windsurf.com/pricing
   - Click "Start Free Trial" (no credit card required)
   - You get free AI credits to help with setup

2. **Download and install**:
   - Download Windsurf for your operating system
   - Install and open the application
   - Sign in with your account

3. **Open this project**:
   - Click "Open Folder" in Windsurf
   - Navigate to your diesel-miner directory
   - Open the folder containing this SETUP_CHECKLIST.md

### Using Windsurf AI to Configure the Script

Once you have the project open in Windsurf, use the AI assistant (Cmd+L or Ctrl+L) with these prompts:

#### Prompt 1: Initial Setup
```
I need help setting up the DIESEL miner script. Please:
1. Read through SETUP_CHECKLIST.md
2. Help me install oyl-local CLI by creating the necessary commands
3. Generate a new Bitcoin wallet mnemonic for me using oyl-local
4. Create the .env file with the generated mnemonic
```

#### Prompt 2: Configuration
```
Now please:
1. Update the diesel-miner-template.sh script with any necessary configurations
2. Help me get a Sandshrew API key (guide me to the right website)
3. Add the Sandshrew project ID to my .env file
4. Make the script executable with chmod +x
```

#### Prompt 3: Testing
```
Help me test the setup:
1. Run the balance check command
2. Explain what addresses were generated
3. Show me how to fund the wallet with a small test amount
4. Run a test mining command with minimum fees
```

#### Prompt 4: Troubleshooting (if needed)
```
I'm getting [describe error]. Please:
1. Analyze the error message
2. Check my .env configuration
3. Verify oyl-local is installed correctly
4. Suggest a fix
```

### Windsurf AI Tips

- **Be specific**: Tell the AI exactly what error you're seeing
- **Use the terminal**: Windsurf has an integrated terminal - ask the AI to run commands there
- **Check changes**: Review what the AI suggests before applying
- **Ask for explanations**: Request explanations of what each command does

### Why Windsurf Helps

- **Understands context**: The AI can read all your files and understand the setup requirements
- **Runs commands**: It can execute terminal commands for you
- **Fixes errors**: It can diagnose and fix common setup issues
- **Explains everything**: Get explanations of what's happening at each step

Continue with the manual setup below, or use Windsurf AI to help you through each step:

## Step 1: Install oyl-local CLI

- [ ] Clone the oyl-sdk repository:
  ```bash
  git clone https://github.com/Oyl-Wallet/oyl-sdk.git
  cd oyl-sdk
  npm install
  ```

- [ ] Create an alias for easier access:
  ```bash
  alias oyl-local='/path/to/oyl-sdk/bin/oyl.js'
  ```

- [ ] Learn more about oyl-sdk:
  - Documentation: https://alkanes-docs.vercel.app/docs/developers/quickstart
  - Understand how to interact with Alkanes protocol

- [ ] Add the alias to your shell profile (~/.bashrc or ~/.zshrc):
  ```bash
  echo "alias oyl-local='/path/to/oyl-sdk/bin/oyl.js'" >> ~/.zshrc
  source ~/.zshrc
  ```

## Step 2: Create a NEW Wallet for Mining

⚠️ **IMPORTANT: Create a NEW wallet specifically for DIESEL mining. Only fund it with what you're prepared to lose!**

- [ ] Generate a new mnemonic seed phrase using oyl-local:
  ```bash
  oyl-local account generateMnemonic
  ```

- [ ] **SAVE YOUR SEED PHRASE SECURELY** - Write it down on paper
- [ ] **NEVER USE YOUR MAIN WALLET** - This is experimental software
- [ ] Verify the wallet addresses:
  ```bash
  oyl-local account mnemonicToAccount "your new seed phrase here" -p bitcoin
  ```
- [ ] Note your addresses:
  - Native SegWit (bc1q...): For paying fees
  - Taproot (bc1p...): Will receive DIESEL

## Step 3: Get a Sandshrew Project ID

- [ ] Visit http://sandshrew.io
- [ ] Create a free account
- [ ] Create a new project
- [ ] Copy your project ID (32-character hexadecimal string)

## Step 4: Create .env File

- [ ] Create a `.env` file in the same directory as the script:
  ```bash
  touch .env
  ```

- [ ] Add your NEW wallet configuration (NOT your main wallet):
  ```bash
  MNEMONIC="your NEW twelve word seed phrase from step 2"
  SANDSHREW_PROJECT_ID="your_sandshrew_project_id_here"
  ```

## Step 4: Update Script Configuration (Optional)

If you're using the template script, update these values:

- [ ] Line 39: Replace `YOUR_SANDSHREW_PROJECT_ID_HERE` with your actual project ID
- [ ] Line 69: (Optional) Add a fallback Bitcoin address if needed
- [ ] Line 126: (Optional) Add your taproot address if needed

## Step 5: Make Script Executable

- [ ] Set execute permissions:
  ```bash
  chmod +x diesel-miner-template.sh
  ```

## Step 6: Verify Setup

- [ ] Check your balance:
  ```bash
  ./diesel-miner-template.sh balance
  ```

- [ ] Verify you see:
  - Your Bitcoin balance
  - Your wallet addresses
  - Any existing DIESEL balance

## Step 7: Fund Your NEW Mining Wallet

⚠️ **ONLY SEND WHAT YOU'RE PREPARED TO LOSE**

- [ ] Send a SMALL amount of Bitcoin to your NEW wallet address (shown in balance check)
- [ ] Recommended: 0.0001 BTC for initial testing
- [ ] Maximum: Only what you can afford to lose
- [ ] Wait for confirmation
- [ ] **DO NOT use your main wallet or life savings**

## Configuration Values to Fill In

### Required:
1. **MNEMONIC**: Your NEW 12-word Bitcoin wallet seed phrase (from Step 2)
   - Format: "word1 word2 word3 ... word12"
   - Keep this SECRET and SECURE
   - MUST be a NEW wallet, not your main wallet

2. **SANDSHREW_PROJECT_ID**: Your API key for blockchain queries
   - Get from Sandshrew service
   - Format: 32-character hexadecimal string

### Optional:
3. **Fallback Addresses**: If automatic derivation fails
   - Native SegWit address (bc1q...)
   - Taproot address (bc1p...)

4. **Fee Settings**: Adjust based on network conditions
   - DEFAULT_FEE_RATE (line 17): Default is 10 sat/vB
   - MEMPOOL_CHECK_INTERVAL (line 21): Default is 30 seconds

## Important Security Notes

⚠️ **USE A NEW WALLET - Never use your main Bitcoin wallet**
⚠️ **ONLY FUND WITH WHAT YOU'RE PREPARED TO LOSE**
⚠️ **NEVER share your MNEMONIC seed phrase**
⚠️ **Keep your .env file private and secure**
⚠️ **Do not commit .env to version control**
⚠️ **This is experimental software - expect the unexpected**
⚠️ **Start with minimal amounts (0.0001 BTC)**

## Wallet Address Types

Your wallet will have two addresses:
1. **Native SegWit (bc1q...)**: Used for paying transaction fees
2. **Taproot (bc1p...)**: Receives DIESEL tokens

Both are derived from your mnemonic seed phrase.

## Testing Your Setup

### Understanding Fee Rates (sat/vB)
The number after `mine` or `monitor` is the fee rate in satoshis per virtual byte (sat/vB):
- **2 sat/vB**: Minimum fee, slowest confirmation, least DIESEL
- **10 sat/vB**: Standard fee, moderate speed, balanced DIESEL
- **20+ sat/vB**: Priority fee, fast confirmation, maximum DIESEL

### Single Mining Transaction
```bash
./diesel-miner-template.sh mine 2    # Use 2 sat/vB fee rate
./diesel-miner-template.sh mine 10   # Use 10 sat/vB fee rate
```

### Continuous Mining (Monitor Mode)
```bash
yes | ./diesel-miner-template.sh monitor 2    # Monitor with 2 sat/vB
yes | ./diesel-miner-template.sh monitor 10   # Monitor with 10 sat/vB
```

### Check Balances
```bash
./diesel-miner-template.sh balance
```

## Troubleshooting

### "oyl-local not found"
- Verify the oyl-sdk installation path
- Check that the alias is set correctly
- Try using the full path to oyl.js

### "Insufficient balance"
- Check you have at least 0.00005 BTC
- Wait for pending transactions to confirm
- Use the script's mempool-aware features

### "Invalid Sandshrew project ID"
- Verify your project ID is correct
- Check it's properly set in .env file
- Ensure no extra spaces or quotes

### "Transaction failed"
- Check network congestion
- Increase fee rate if needed
- Verify wallet has sufficient funds

## Support Resources

- Alkanes Protocol Documentation
- Bitcoin Mempool: https://mempool.space
- oyl-sdk GitHub: https://github.com/Oyl-Wallet/oyl-sdk

## Ready to Mine?

Once all items are checked:
1. ✅ Run balance check
2. ✅ Try a single mining transaction
3. ✅ Monitor the transaction on mempool.space
4. ✅ Check DIESEL balance after confirmation

Good luck mining DIESEL! 🚀