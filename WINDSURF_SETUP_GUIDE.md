# Windsurf AI Setup Guide for DIESEL Miner

This guide will help you use Windsurf's AI assistant to automatically configure the DIESEL miner script.

## Why Use Windsurf?

- **Free to start**: No credit card required for trial
- **AI understands the code**: It can read all files and understand requirements
- **Automated setup**: The AI can run commands and create files for you
- **Error fixing**: Get instant help with any issues
- **Safe for beginners**: The AI explains everything it does

## Getting Started

### Step 1: Get Windsurf

1. Visit https://windsurf.com/pricing
2. Click "Start Free Trial"
3. Download for your operating system (Mac, Windows, or Linux)
4. Install and open Windsurf
5. Sign in with your account

### Step 2: Open the Project

1. In Windsurf, click "Open Folder"
2. Navigate to where you cloned/downloaded this repository
3. Select the folder containing `diesel-miner-template.sh`
4. The project will open with all files visible in the sidebar

### Step 3: Use AI Assistant

Press `Cmd+L` (Mac) or `Ctrl+L` (Windows/Linux) to open the AI chat.

## Copy-Paste Prompts for Setup

Use these prompts in order. Copy and paste them into the Windsurf AI chat:

### 🚀 Prompt 1: Initial Setup
```
I need to set up the DIESEL miner script from scratch. Please:

1. First, read the SETUP_CHECKLIST.md file to understand all requirements
2. Check if Node.js is installed by running `node --version` in the terminal
3. Create a step-by-step plan for setting up oyl-local CLI
4. Show me the commands to clone and install oyl-sdk
5. Help me create the oyl-local alias in my shell profile

Please run the commands in the terminal and show me the output.
```

### 🔑 Prompt 2: Create New Wallet
```
Now I need to create a NEW Bitcoin wallet for DIESEL mining (not my main wallet). Please:

1. Use oyl-local to generate a new mnemonic seed phrase
2. Show me the generated seed phrase (I will save it securely)
3. Display the Bitcoin addresses that will be generated from this seed
4. Explain which address is for fees (bc1q...) and which receives DIESEL (bc1p...)
5. Create a .env file with my new mnemonic

Important: Remind me to save the seed phrase securely and that this should be a NEW wallet only for testing.
```

### 🔧 Prompt 3: Configure Sandshrew
```
I need to get a Sandshrew API key for blockchain queries. Please:

1. Explain what Sandshrew is and why we need it
2. Tell me to visit http://sandshrew.io to create a free account and get a project ID
3. Once I have the ID, help me add it to the .env file
4. Verify the .env file has both MNEMONIC and SANDSHREW_PROJECT_ID
5. Make the diesel-miner-template.sh script executable

Show me the final .env structure (without revealing my actual seed phrase).
```

### ✅ Prompt 4: Test Everything
```
Let's test that everything is working. Please:

1. Run ./diesel-miner-template.sh balance to check the wallet
2. Explain any errors if they occur
3. Show me my wallet addresses for funding
4. Calculate how much BTC I need for testing (minimum amount)
5. Explain how to send a small amount of BTC to my new wallet

If there are any errors, help me troubleshoot them.
```

### 🔄 Prompt 5: First Mining Test
```
My wallet now has some test BTC. Let's do a test mining transaction. Please:

1. Check my balance again with ./diesel-miner-template.sh balance
2. Explain the current mempool fees by checking https://mempool.space
3. Recommend a fee rate for testing (start low, like 2 sat/vB)
4. Show me how to run a single mining transaction
5. Explain what will happen and what to expect

Run: ./diesel-miner-template.sh mine 2
```

### 🔍 Prompt 6: Monitor Mode
```
Now let's set up continuous mining. Please:

1. Explain how the monitor mode works
2. Show me how to run the miner in monitor mode
3. Explain how to run it in the background
4. Show me how to check the logs
5. Explain how to stop the miner when needed

Also show me how to check my DIESEL balance after transactions confirm.
```

## Troubleshooting Prompts

If you encounter issues, use these prompts:

### For oyl-local errors:
```
I'm getting an error with oyl-local: [paste error here]

Please:
1. Analyze this error message
2. Check if oyl-local is properly installed
3. Verify the alias is set correctly
4. Provide a solution with exact commands
```

### For balance issues:
```
The balance check is showing 0 or giving an error: [paste output here]

Please:
1. Verify my .env file is configured correctly
2. Check if the wallet addresses are being derived properly
3. Test the oyl-local connection to Sandshrew
4. Diagnose and fix the issue
```

### For transaction failures:
```
My mining transaction failed with: [paste error here]

Please:
1. Check if I have sufficient balance
2. Verify there are no pending transactions
3. Check current mempool congestion
4. Suggest a solution or different fee rate
```

## Important Reminders for AI

When working with the AI, remember to:

1. **Never share your real main wallet seed phrase**
2. **Only use a NEW wallet created for this purpose**
3. **Only fund with small test amounts you can afford to lose**
4. **Review commands before the AI runs them**
5. **Save your seed phrase securely offline**

## Tips for Best Results

1. **Be specific about errors**: Copy and paste exact error messages
2. **Let AI run commands**: Windsurf can execute terminal commands directly
3. **Ask for explanations**: Request explanations of what each step does
4. **Check file changes**: Review any files the AI creates or modifies
5. **Use the terminal**: Windsurf has an integrated terminal for all commands

## Advanced Prompts

Once you're comfortable, you can ask the AI for help with:

- Optimizing fee strategies based on mempool conditions
- Setting up automated mining schedules
- Analyzing transaction history in the logs
- Creating monitoring dashboards
- Implementing additional safety checks

## Example Success Flow

1. **Install oyl-local** ✓
2. **Generate new wallet** ✓
3. **Configure .env file** ✓
4. **Get Sandshrew API key** ✓
5. **Check balance (shows 0)** ✓
6. **Fund with 0.0001 BTC** ✓
7. **Check balance (shows funds)** ✓
8. **Run test transaction** ✓
9. **Monitor for new blocks** ✓
10. **Check DIESEL balance** ✓

## Need More Help?

If the AI needs more context, you can tell it to:
```
Please read all the files in this project, especially:
- SETUP_CHECKLIST.md
- README.md
- diesel-miner-template.sh
- .env.example

Then help me with: [your specific question]
```

## Security Note

Windsurf's AI runs locally in your IDE and doesn't send your sensitive data to external servers. However, always:
- Use a NEW wallet for testing
- Never share your seed phrase in chat logs
- Only fund with test amounts
- Keep your .env file private

Happy mining! 🚀