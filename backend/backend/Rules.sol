// SPDX-License-Identifier: Apache-2.0 (see LICENSE)

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity ^0.8.8;

/// @title Rules Contract, here we can define allowedTokens, timeouts for withdrawals,...

contract Rules is Ownable {
  event AllowedToken(address indexed token_);
  event RemovedToken(address indexed token_);

  modifier onlyOwner() {
    require(msg.sender == owner);
    _;
  }

  mapping(address => bool) public allowedTokens;
  address[] allowedTokensList;
  address allowedNFTCollection; //can be allowedNFTCollections in a future

  constructor() {
    _initTokens();

    allowedNFTCollection = 0x495f947276749Ce646f68AC8c248420045cb7b5e; //TODO: after nft deployment OpenSea
  }

  function setNewToken(address token_) public onlyOwner {
    allowedTokens[token_] = true;
    emit AllowedToken(token_);
  }

  function removeToken(address token_) public onlyOwner {
    allowedTokens[token_] = false;
    emit RemovedToken(token_);
  }

  function isTokenAllowed(address _token) public view returns (bool) {
    return allowedTokens[_token];
  }

  function getAllowedNFTCollection() public view returns (address) {
    return allowedNFTCollection;
  }

  /*function isNftCollectionAllowed(
    address _nftCollection
  ) public view returns (bool) {
    return allowedNFTCollections[_nftCollection];
  }*/

  function setTimeoutForWithdrawal() public {}

  function getAllowedTokenList() public view returns (address[] memory) {
    return allowedTokensList;
  }

  function _initTokens() internal {
    IERC20 cusd = IERC20(0x765DE816845861e75A25fCA122bb6898B8B1282a); //cusd IN CELO
    IERC20 weth = IERC20(0x66803FB87aBd4aaC3cbB3fAd7C3aa01f6F3FB207); //WETH IN CELO
    IERC20 wbtc = IERC20(0xd71Ffd0940c920786eC4DbB5A12306669b5b81EF); //WBTC IN CELO
    allowedTokens[cusd] = true;
    allowedTokens[weth] = true;
    allowedTokens[wbtc] = true;
    allowedTokensList.push(address(cusd));
    allowedTokensList.push(address(weth));
    allowedTokensList.push(address(wbtc));
  }
}

// 0x765DE816845861e75A25fCA122bb6898B8B1282a, 0xd71Ffd0940c920786eC4DbB5A12306669b5b81EF,1
