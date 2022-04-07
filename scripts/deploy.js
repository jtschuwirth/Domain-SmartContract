const main = async () => {
    const domainContractFactory = await hre.ethers.getContractFactory('Domains');
    const domainContract = await domainContractFactory.deploy("ptg");
    await domainContract.deployed();
  
    console.log("Contract deployed to:", domainContract.address);
  
    // CHANGE THIS DOMAIN TO SOMETHING ELSE! I don't want to see OpenSea full of bananas lol
    let txn = await domainContract.register("neca",  {value: hre.ethers.utils.parseEther('0.3')});
    await txn.wait();
    console.log("Minted domain neca.ptg");
  
    txn = await domainContract.setRecord("neca", "first domain deployed");
    await txn.wait();
    console.log("Set record for neca-ptg");
  
    const address = await domainContract.getAddress("neca");
    console.log("Owner of domain neca:", address);
  
    const balance = await hre.ethers.provider.getBalance(domainContract.address);
    console.log("Contract balance:", hre.ethers.utils.formatEther(balance));
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