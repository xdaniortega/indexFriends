// SPDX-License-Identifier: Apache-2.0 (see LICENSE)

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

pragma solidity ^0.8.8;

/// @title Rules Contract, here we can define allowedTokens, timeouts for withdrawals,...

contract Rules is Ownable {
  event AllowedToken(address indexed token_);
  event RemovedToken(address indexed token_);

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
    /*IERC20 usdc = IERC20(0x07865c6e87b9f70255377e024ace6630c1eaa37f); //USDC IN ETH CELO
    IERC20 wbtc = IERC20(0xC04B0d3107736C32e19F1c62b2aF67BE61d63a05); //WBTC IN ETH CELO
    IERC20 weth = IERC20(0xB4FBF271143F4FBf7B91A5ded31805e42b2208d6); //WETH IN ETH CELO*/
    allowedTokens[0x765DE816845861e75A25fCA122bb6898B8B1282a] = true;
    allowedTokens[0xd71Ffd0940c920786eC4DbB5A12306669b5b81EF] = true;
    allowedTokens[0x66803FB87aBd4aaC3cbB3fAd7C3aa01f6F3FB207] = true;
    allowedTokensList.push(address(0x765DE816845861e75A25fCA122bb6898B8B1282a));
    allowedTokensList.push(address(0xd71Ffd0940c920786eC4DbB5A12306669b5b81EF));
    allowedTokensList.push(address(0x66803FB87aBd4aaC3cbB3fAd7C3aa01f6F3FB207));
  }
}
