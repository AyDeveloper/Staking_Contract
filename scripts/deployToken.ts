/* eslint-disable prettier/prettier */
import { ethers } from "hardhat";
import { Signer } from "ethers";

async function main() {
    const ownerAddr = "0x9ae1e982Fc9A9D799e611843CB9154410f11Fe35";
    const signer1 = await ethers.getSigner(ownerAddr);
  //   We get the contract to deploy
   // @ts-ignore
   await hre.network.provider.request({
    method: "hardhat_impersonateAccount",
    params: [ownerAddr],
  });
    
  // @ts-ignore
  await network.provider.send("hardhat_setBalance", [
    ownerAddr,
    "0x2000000000000000000000000000000000000",
  ])

  // const DearToken = await ethers.getContractFactory("Dear");
  // const dearToken = await DearToken.connect(signer1).deploy("Dear", "DEAR", "1000000000000000000000000000000000000000");
  
  // await dearToken.deployed();

  // console.log(`deployed token address`, dearToken.address);

  const instance = await ethers.getContractAt("IERC20","0x0403402d232f96FaeB67224C1eA68D715fFD8133")

//   const bal = await instance.balanceOf(ownerAddr);

  await instance.connect(signer1).approve("0x40a42Baf86Fc821f972Ad2aC878729063CeEF403", "10000");
  const allowed = await instance.allowance(ownerAddr,"0x40a42Baf86Fc821f972Ad2aC878729063CeEF403");
//   console.log(`contract balance is ${bal}`);
  console.log(`claimer balance is ${allowed}`);

  await instance.connect(signer1).transfer("0x40a42Baf86Fc821f972Ad2aC878729063CeEF403", "100000000000000000000")
    const bal = await instance.balanceOf("0x40a42Baf86Fc821f972Ad2aC878729063CeEF403");
    console.log(`bal of contract ${bal}`);
    

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
