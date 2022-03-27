const main = async () => {
    // The first return is the deployer, the second is a random account
    const [owner, randomPerson] = await hre.ethers.getSigners();
    const domainContractFactory = await hre.ethers.getContractFactory('Domains');
    const domainContract = await domainContractFactory.deploy();
    await domainContract.deployed();
    console.log("Contract deployed to:", domainContract.address);
    console.log("Contract deployed by:", owner.address);
  
    let txn = await domainContract.register("Neca");
    await txn.wait();
  
    const domainAddress = await domainContract.getAddress("Neca");
    console.log("Owner of domain Neca:", domainAddress);

    txn = await domainContract.connect(randomPerson).register("Random");
    await txn.wait();

    const domainAddress2 = await domainContract.getAddress("Random");
    console.log("Owner of domain Random:", domainAddress2);
}
  
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