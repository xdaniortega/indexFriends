[![EthGlobal NY 2023](https://img.shields.io/badge/EthGlobal-NY%202023-6c5ce7?style=for-the-badge&logo=ethereum)](#)
[![DeFi Project](https://img.shields.io/badge/Category-DeFi%20%26%20NFTs-00cec9?style=for-the-badge&logo=defi)](#)
[![Solidity](https://img.shields.io/badge/Solidity-0.8.20-363636?style=for-the-badge&logo=solidity)](#)
[![Hardhat](https://img.shields.io/badge/Hardhat-Development-FF6B6B?style=for-the-badge&logo=hardhat)](#)
[![Custom Errors](https://img.shields.io/badge/Features-Custom%20Errors-00d4aa?style=for-the-badge)](#)
[![Gas Optimized](https://img.shields.io/badge/Optimization-Gas%20Efficient-ff6b35?style=for-the-badge)](#)

# IndexFriends - DeFi Investment Strategy Platform

**IndexFriends** is a decentralized platform that enables NFT holders to create and manage personalized investment strategies through smart contracts. The platform integrates with DeFi protocols to provide automated portfolio management and rebalancing capabilities.

**🚀 Latest Updates**: Upgraded to Solidity ^0.8.20 with custom errors for improved gas efficiency and better error handling.

---

## 🏗 Smart Contract Architecture

```
┌─────────────────────────────────────────────────────────────────────────────┐
│                              FRONTEND LAYER                                │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────────────┐ │
│  │   React App     │  │   Web3.js       │  │   MetaMask/WalletConnect   │ │
│  │   (User UI)     │◄─┤   Integration   │◄─┤   Wallet Integration       │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
                                        │
                                        ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                           SMART CONTRACT LAYER                             │
│                                                                             │
│  ┌─────────────────────────────────────────────────────────────────────────┐ │
│  │                           CORE CONTRACTS                               │ │
│  │                                                                         │ │
│  │  ┌─────────────────┐    ┌─────────────────┐    ┌─────────────────────┐ │ │
│  │  │  IndexFriends   │    │      Rules      │    │      Vault          │ │
│  │  │     (NFT)       │    │   (Governance)  │    │   (Fund Mgmt)       │ │
│  │  │                 │    │                 │    │                     │ │
│  │  │ • Mint NFTs     │    │ • Token Allow   │    │ • Deposit Funds     │ │
│  │  │ • Metadata      │    │ • NFT Collection│    │ • Withdraw Funds    │ │
│  │  │ • Ownership     │    │ • Validation    │    │ • Strategy Approve  │ │
│  │  └─────────────────┘    └─────────────────┘    └─────────────────────┘ │ │
│  │           │                       │                       │             │ │
│  │           │                       │                       │             │ │
│  │           ▼                       ▼                       ▼             │ │
│  │  ┌─────────────────────────────────────────────────────────────────────┐ │ │
│  │  │                    STRATEGY MANAGEMENT                              │ │ │
│  │  │                                                                     │ │ │
│  │  │  ┌─────────────────┐    ┌─────────────────┐                        │ │ │
│  │  │  │ StrategyFactory │    │    Strategy     │                        │ │ │
│  │  │  │                 │    │                 │                        │ │ │
│  │  │  │ • Deploy        │───▶│ • Token %       │                        │ │ │
│  │  │  │ • Track         │    │ • User Balance  │                        │ │ │
│  │  │  │ • Manage        │    │ • Portfolio     │                        │ │ │
│  │  │  └─────────────────┘    └─────────────────┘                        │ │ │
│  │  └─────────────────────────────────────────────────────────────────────┘ │ │
│  │                                                                         │ │
│  │  ┌─────────────────────────────────────────────────────────────────────┐ │ │
│  │  │                    REBALANCING LAYER                                │ │ │
│  │  │                                                                     │ │ │
│  │  │  ┌─────────────────┐    ┌─────────────────┐                        │ │ │
│  │  │  │ RebalanceRouter │    │ IRebalanceRouter│                        │ │ │
│  │  │  │                 │    │                 │                        │ │ │
│  │  │  │ • Uniswap V3    │    │ • 1inch API     │                        │ │ │
│  │  │  │ • Token Swaps   │    │ • Clipper       │                        │ │ │
│  │  │  │ • Celo Network  │    │ • Cross-chain   │                        │ │ │
│  │  │  └─────────────────┘    └─────────────────┘                        │ │ │
│  └─────────────────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
                                        │
                                        ▼
┌─────────────────────────────────────────────────────────────────────────────┐
│                           BLOCKCHAIN LAYER                                │
│  ┌─────────────────┐  ┌─────────────────┐  ┌─────────────────────────────┐ │
│  │   Celo Network  │  │   Uniswap V3    │  │   Price Oracles &          │ │
│  │   (Mainnet)     │  │   (DEX)         │  │   DeFi Protocols           │ │
│  └─────────────────┘  └─────────────────┘  └─────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────────────────┘
```

---

## 🔧 Smart Contract Technical Specifications

### **Core Contracts**

#### 1. **IndexFriends.sol** - NFT Collection
```solidity
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

contract IndexFriends is ERC721Enumerable, Ownable {
    // Configurable parameters via constructor
    uint public immutable maxSupply;
    uint public immutable price;
    uint public immutable maxPerMint;
    
    // Custom errors for gas efficiency
    error InvalidMaxSupply();
    error InvalidMaxPerMint();
    error InsufficientPayment();
    error NotEnoughNFTsLeft();
}
```

**Key Features:**
- **ERC721Enumerable**: Standard NFT implementation with enumeration
- **Ownable**: Access control for administrative functions
- **Minting**: Public minting with configurable supply limits
- **Metadata**: Dynamic URI management for token metadata
- **Custom Errors**: Gas-efficient error handling
- **Immutable Variables**: Gas-optimized state variables

**State Variables:**
- `maxSupply`: Configurable total NFT supply
- `price`: Configurable minting price
- `maxPerMint`: Configurable NFTs per transaction
- `baseTokenURI`: Base URI for metadata

---

#### 2. **Rules.sol** - Protocol Governance
```solidity
// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

contract Rules is Ownable {
    mapping(address => bool) public allowedTokens;
    address[] allowedTokensList;
    address public allowedNFTCollection;
    
    // Custom errors for validation
    error InvalidMaxAllowedTokens();
    error TokenAlreadyAllowed();
    error MaxTokensLimitReached();
}
```

**Key Features:**
- **Token Management**: Whitelist of allowed tokens for strategies
- **NFT Validation**: Approved NFT collections for strategy creation
- **Access Control**: Owner-only token addition/removal
- **Custom Errors**: Efficient error handling
- **Configurable Limits**: Dynamic token limits

**Supported Tokens (Celo Network):**
- `0x765DE816845861e75A25fCA122bb6898B8B1282a` - cUSD
- `0xd71Ffd0940c920786eC4DbB5A12306669b5b81EF` - cEUR  
- `0x66803FB87aBd4aaC3cbB3fAd7C3aa01f6F3FB207` - cREAL

---

#### 3. **Vault.sol** - Fund Management
```solidity
// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

contract Vault is Ownable, ReentrancyGuard {
    address public immutable vaultToken;
    uint256 public maxDepositAmount;
    uint256 public withdrawalFeeBps;
    
    // Custom errors for security
    error InvalidDepositLimits();
    error WithdrawalFeeTooHigh();
    error InsufficientBalance();
}
```

**Key Features:**
- **Token Management**: Configurable token support
- **Deposit/Withdrawal**: Secure fund handling with reentrancy protection
- **Strategy Integration**: Approves funds for strategy contracts
- **Custom Errors**: Gas-efficient error handling
- **Configurable Parameters**: Dynamic limits and fees

---

### **Strategy Management Contracts**

#### 4. **Strategy.sol** - Individual Strategy
```solidity
// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

contract Strategy is Ownable, ReentrancyGuard {
    mapping(address => uint256) public tokenPercentages;
    mapping(address => uint256) public userBalances;
    uint256 public immutable tokenId;
    Rules public immutable rules;
    
    // Custom errors for access control
    error Unauthorized();
    error InvalidPercentage();
    error RebalanceCooldown();
}
```

**Key Features:**
- **Portfolio Management**: Token allocation percentages
- **User Balances**: Individual user fund tracking
- **NFT Integration**: Links strategies to specific NFTs
- **Rules Validation**: Ensures only allowed tokens
- **Custom Errors**: Efficient error handling
- **Reentrancy Protection**: Security against reentrancy attacks

**Access Control:**
- `onlyNFTOwner`: Only NFT holders can modify strategies
- `onlyProvider`: Company address for administrative functions

---

#### 5. **StrategyFactory.sol** - Strategy Deployment
```solidity
// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

contract StrategyFactory is Ownable, ReentrancyGuard {
    address[] public deployedStrategies;
    Rules public immutable rules;
    IERC721 public immutable nftCollection;
    
    // Custom errors for deployment
    error MaxStrategiesReached();
    error InsufficientFee();
    error InvalidStrategyAddress();
}
```

**Key Features:**
- **Factory Pattern**: Deploys new Strategy contracts
- **Strategy Tracking**: Maintains list of all deployed strategies
- **NFT Validation**: Ensures only valid NFT holders can create strategies
- **Custom Errors**: Efficient error handling
- **Fee Management**: Configurable deployment fees

---

### **Rebalancing Contracts**

#### 6. **RebalanceRouter.sol** - Token Swaps
```solidity
// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

contract RebalanceRouter is Ownable, ReentrancyGuard {
    ISwapRouter public immutable router;
    uint24 public defaultFeeTier;
    uint256 public defaultSlippageBps;
    
    // Custom errors for swaps
    error InvalidRouterAddress();
    error SwapFailed();
    error InsufficientAllowance();
}
```

**Key Features:**
- **Uniswap V3 Integration**: Executes token swaps
- **Celo Network**: Optimized for Celo mainnet
- **Token Approvals**: Handles ERC20 approvals automatically
- **Swap Parameters**: Configurable fees and deadlines
- **Custom Errors**: Gas-efficient error handling
- **Reentrancy Protection**: Security against reentrancy attacks

**Swap Configuration:**
- **Fee Tier**: Configurable (default: 0.5%)
- **Deadline**: Configurable buffer
- **Slippage**: Configurable tolerance

---

#### 7. **IRebalanceRouter1Inch.sol** - Interface
```solidity
// SPDX-License-Identifier: Apache-2.0
pragma solidity ^0.8.20;

interface IRebalanceRouter {
    function swap(uint256 _amountIn, address _tokenIn, address _tokenOut, bytes calldata _swapData) external returns (uint256 amountOut);
    function clipperSwap(IERC20 srcToken, IERC20 dstToken, uint256 amount, uint256 minReturn) external returns (uint256 returnAmount);
}
```

**Key Features:**
- **1inch Integration**: Alternative DEX aggregation
- **Clipper Protocol**: Specialized swap functionality
- **Cross-chain Support**: Multi-network compatibility

---

## 🚀 Latest Improvements (v2.0)

### **Solidity ^0.8.20 Upgrade** ✅
- **Modern Compiler**: Latest Solidity features and optimizations
- **Better Performance**: Improved gas efficiency and execution
- **Enhanced Security**: Latest security patches and best practices
- **Future Compatibility**: Ready for upcoming Solidity features

### **Custom Errors Implementation** ✅
- **Gas Efficiency**: 10-20% gas savings on failed transactions
- **Better Debugging**: Specific error types for easier troubleshooting
- **Cleaner Code**: Eliminated hardcoded error strings
- **Improved UX**: More informative error messages

### **Enhanced Security Features** ✅
- **ReentrancyGuard**: Protection against reentrancy attacks
- **Immutable Variables**: Gas-optimized state variables
- **Custom Error Validation**: Comprehensive input validation
- **Pause Mechanisms**: Emergency pause functionality

### **Configurable Parameters** ✅
- **Constructor Arguments**: No more hardcoded values
- **Owner Controls**: Dynamic parameter updates
- **Flexible Deployment**: Easy configuration for different networks
- **Scalable Architecture**: Adaptable to various use cases

---

## 🔄 Contract Interaction Flow

### **1. Strategy Creation**
```
User (NFT Holder) → StrategyFactory → Deploy Strategy → Rules Validation → Strategy Active
```

### **2. Fund Management**
```
User → Vault → Deposit Funds → Strategy Approval → Portfolio Allocation
```

### **3. Rebalancing Process**
```
Strategy → RebalanceRouter → Uniswap V3 → Token Swap → Portfolio Updated
```

### **4. NFT Integration**
```
IndexFriends NFT → Strategy Ownership → Portfolio Control → Performance Tracking
```

---

## 🚀 Deployment & Configuration

### **Network Configuration**
- **Primary Network**: Celo Mainnet
- **Test Network**: Celo Alfajores Testnet
- **Block Explorer**: [CeloScan](https://celoscan.io/)

### **Contract Addresses**
```javascript
// Celo Mainnet
const CONTRACTS = {
    IndexFriends: "0x...",      // NFT Collection
    Rules: "0x...",             // Protocol Rules
    Vault: "0x...",             // Fund Management
    StrategyFactory: "0x...",   // Strategy Deployment
    RebalanceRouter: "0x...",   // Token Swaps
    UniswapV3: "0x5615CDAb10dc425a742d643d949a7F474C01abc4"
};
```

### **Environment Variables**
```bash
# .env
CELO_RPC_URL=https://forno.celo.org
PRIVATE_KEY=your_private_key
ETHERSCAN_API_KEY=your_api_key
```

---

## 🧪 Testing & Development

### **Local Development**
```bash
# Install dependencies
npm install

# Compile contracts
npx hardhat compile

# Run tests
npx hardhat test

# Deploy to local network
npx hardhat node
npx hardhat run scripts/deploy.js --network localhost
```

### **Test Network Deployment**
```bash
# Deploy to Celo Alfajores
npx hardhat run scripts/deploy.js --network alfajores

# Verify contracts
npx hardhat verify --network alfajores CONTRACT_ADDRESS
```

---

## 🔒 Security Features

### **Access Control**
- **Ownable Pattern**: Administrative functions restricted to owner
- **NFT Ownership**: Strategy modification limited to NFT holders
- **Token Validation**: Only whitelisted tokens allowed

### **Fund Security**
- **Approval System**: Explicit user approval required for all transactions
- **Transfer Validation**: Secure token transfer mechanisms
- **Balance Tracking**: Real-time balance monitoring
- **Reentrancy Protection**: Built-in security against reentrancy attacks

### **Smart Contract Security**
- **Custom Errors**: Gas-efficient error handling
- **Input Validation**: Comprehensive parameter checking
- **Immutable Variables**: Gas-optimized state management
- **Pause Mechanisms**: Emergency stop functionality

---

## 📊 Performance & Gas Optimization

### **Gas Efficiency**
- **Custom Errors**: 10-20% gas savings on failed transactions
- **Immutable Variables**: Reduced storage costs
- **Batch Operations**: Multiple operations in single transaction
- **Storage Optimization**: Efficient data structure usage

### **Scalability Features**
- **Factory Pattern**: Unlimited strategy deployment
- **Modular Design**: Independent contract functionality
- **Configurable Parameters**: Dynamic contract behavior
- **Upgradeable Architecture**: Future contract improvements

---

## 🔮 Future Enhancements

### **Phase 2 Features**
- [ ] **Multi-chain Support**: Ethereum, Polygon, Arbitrum
- [ ] **Advanced Strategies**: Options, Futures, Yield Farming
- [ ] **Governance Token**: DAO governance implementation
- [ ] **Mobile App**: React Native mobile application

### **Phase 3 Features**
- [ ] **AI Integration**: Machine learning portfolio optimization
- [ ] **Social Trading**: Copy trading and leaderboards
- [ ] **Institutional Tools**: Advanced portfolio analytics
- [ ] **Cross-chain Bridges**: Seamless asset movement

---

## 📚 Technical Documentation

### **API Reference**
- **Smart Contract ABI**: Available in `/artifacts/` directory
- **Frontend SDK**: React hooks and utilities
- **Backend API**: RESTful endpoints for data retrieval

### **Integration Guides**
- **DeFi Protocol Integration**: Adding new DEX protocols
- **Token Addition**: Whitelisting new tokens
- **Strategy Development**: Creating custom strategies

### **Custom Errors Reference**
```solidity
// Common error patterns used across contracts
error InvalidAddress();
error InvalidAmount();
error InsufficientBalance();
error Unauthorized();
error InvalidParameters();
error TransferFailed();
```

---

## 🤝 Contributing

### **Development Setup**
1. Fork the repository
2. Create feature branch: `git checkout -b feature/amazing-feature`
3. Commit changes: `git commit -m 'Add amazing feature'`
4. Push to branch: `git push origin feature/amazing-feature`
5. Open Pull Request

### **Code Standards**
- **Solidity**: Follow Solidity Style Guide (^0.8.20)
- **Custom Errors**: Use custom errors instead of require strings
- **JavaScript**: ESLint configuration
- **Testing**: 90%+ test coverage required
- **Documentation**: Comprehensive Natspec comments

---

## 📄 License

This project is licensed under the Apache 2.0 License - see the [LICENSE](LICENSE) file for details.

---

## 📞 Contact & Support

- **Author**: [xdaniortega](https://github.com/xdaniortega)
- **Repository**: [strategicWealth](https://github.com/xdaniortega/strategicWealth)
- **Documentation**: [Technical Docs](docs/)
- **Discord**: [Community Server](https://discord.gg/indexfriends)

---

## 🙏 Acknowledgments

- **OpenZeppelin**: Smart contract security libraries
- **Uniswap**: DEX integration and swap functionality
- **Celo Foundation**: Blockchain infrastructure support
- **EthGlobal**: Hackathon platform and community
