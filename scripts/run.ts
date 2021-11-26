import { ethers } from "hardhat";

const main = async () => {
  const nftContractFactory = await ethers.getContractFactory("MyEpicNFT");
  const nftContract = await nftContractFactory.deploy();
  await nftContract.deployed();
  console.log("Contract deployed to:", nftContract.address);

  // Call the fucntion to mint an NFT.
  const nftMintTxn = await nftContract.makeAnEpicNFT();
  await nftMintTxn.wait();

  const nft2MintTxn = await nftContract.makeAnEpicNFT();
  await nft2MintTxn.wait();
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (err: any) {
    console.log(err);
    process.exit(1);
  }
};

runMain();
