# 🔐 Simple Escrow Smart Contract

This project implements a simple escrow smart contract in Solidity using the [Foundry](https://book.getfoundry.sh/) framework. It supports unit testing, fuzz testing, and emits events for key actions.

---

## 🚀 Overview

The contract enables a payer to deposit funds into escrow, with an arbiter having the authority to approve and release funds to the payee. This pattern is common in decentralized payment systems where trust between parties is minimal.

### ✨ Features
- Only the **arbiter** can approve the transfer.
- Funds are held securely in the contract until approval.
- Emits an **`Approved` event** for on-chain transparency.
- Tested with both **unit tests** and **fuzz tests** using Foundry.

---

## 📂 Project Structure

simple-escrow/
├── lib/ # Dependencies (like forge-std)
├── out/ # Build artifacts
├── script/ # (optional) Deployment scripts
├── src/
│ └── SimpleEscrow.sol # Main contract
├── test/
│ └── SimpleEscrow.t.sol # Unit and fuzz tests
├── foundry.toml # Foundry config file


---

## 🛠️ Setup Instructions

### 1. Prerequisites
Install Foundry (if not installed):

```solidity
curl -L https://foundry.paradigm.xyz | bash
foundryup
```
### 2. Clone the Repo
```solidity
git clone https://github.com/YOUR_USERNAME/simple-escrow.git
cd simple-escrow
```

### 3. Install Dependencies
```solidity 
forge install
```
---

## ⚙️ Build & Test

### Compile the contract
```solidity
forge build
```

### Run all tests (unit + fuzz)
```solidity 
forge test -vvv
```
---

## ✅ Sample Test Output
[PASS] testApproveEmitsEvent()
[PASS] testApproveTransfersFunds()
[PASS] testFuzz_OnlyArbiterCanApprove(address) (runs: 256)
[PASS] testInitialValues()
[PASS] testOnlyArbiterCanApprove()

---

## 📜 Smart Contract: SimpleEscrow.sol
```solidity
event Approved(address indexed arbiter, uint256 amount, address indexed payee);

function approve() external {
    require(msg.sender == arbiter, "Only arbiter can approve");
    require(!isApproved, "Already approved");
    isApproved = true;
    (bool sent, ) = payee.call{value: amount}("");
    require(sent, "Transfer failed");

    emit Approved(msg.sender, amount, payee);
}
```

---

## 🔍 Testing Highlights

- `testInitialValues()` – Checks constructor values.

- `testOnlyArbiterCanApprove()` – Ensures access control.

- `testApproveTransfersFunds()` – Validates payment.

- `testFuzz_OnlyArbiterCanApprove()` – Fuzz test against arbitrary callers.

- `testApproveEmitsEvent()` – Verifies event emission.

---

## 📄 License
MIT License © 2025

---

## 👤 Author
SmartCodez
[GitHub:](https://www.github.com/Natzsmart)
