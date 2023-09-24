async function main() {
  // Mint 1 NFTs by sending 0.0001 ether
  txn = await contract.mintNFTs(1, { value: utils.parseEther("0.0001") });
  await txn.wait();

  // Get all token IDs of the owner
  let tokens = await contract.tokensOfOwner(owner.address);
  console.log("Owner has tokens: ", tokens);
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
