const main = async () => {
  // Compile contract and generate required files stored under the `artifacts` directory
  const nftContractFactory = await hre.ethers.getContractFactory("MyEpicNFT");

  // Hardhat creates local Ethereum network just for this contract
  const nftContract = await nftContractFactory.deploy();

  // Wait until contract is mined and deployed to local blockchain
  await nftContract.deployed();

  // `constructor` runs when we actually are fully deployed
  // Contract address is printed on the console
  // This address is how we can find our contract on the blockchain
  console.log("Contract deployed to this address:", nftContract.address);

  // Call public function from contract
  let transaction = await nftContract.makeAnEpicNFT();
  // Wait for it to be mined
  await transaction.wait();

  // Mint another NFT for fun
  transaction = await nftContract.makeAnEpicNFT();
  // Wait for it to be mined
  await transaction.wait();
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
