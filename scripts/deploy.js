const {ethers} = require("hardhat");

async function main(){
    const [deployer, user1, user2] = await ethers.getSigners();
    const deployerAddress = await deployer.getAddress();
    console.log("Deployer address: ", deployerAddress);

    const NFT = await ethers.getContractFactory("MyNFT");
    const nft = await NFT.deploy();
    await nft.waitForDeployment();
    const nftAddress = await nft.getAddress();
    console.log("Contract address: ", nftAddress);

    await nft.setTokenURI(0, process.env.ROSE_BASEURI);
    await nft.setTokenURI(1, process.env.LILY_BASEURI);

    console.log("Showing URI for my nfts.....");
    console.log("URI for ROSE: ", await nft.tokenURI(0));
    console.log("URI for LILY: ", await nft.tokenURI(1));

    console.log("Minting NFTs to users.....");
    //to be continued.........
}
main().catch(console.error);