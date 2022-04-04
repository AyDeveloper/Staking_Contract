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

  const instance = await ethers.getContractAt("IERC20","0x0C669838b390DF27CEEdc9Af53da6371590e4Fc4")

  const bal = await instance.balanceOf(ownerAddr);

  await instance.connect(signer1).approve("0x74Cf9087AD26D541930BaC724B7ab21bA8F00a27", "10000");
  const allowed = await instance.allowance(ownerAddr,"0x74Cf9087AD26D541930BaC724B7ab21bA8F00a27");
//   console.log(`contract balance is ${bal}`);
  console.log(`contract allowance is ${allowed}`);

  await instance.connect(signer1).transfer("0x74Cf9087AD26D541930BaC724B7ab21bA8F00a27", "100000000000000000000")
    const bal1 = await instance.balanceOf("0x74Cf9087AD26D541930BaC724B7ab21bA8F00a27");
    const bal2 = await instance.balanceOf(ownerAddr);
    console.log(`bal of owner ${bal2} and bal of th contract ${bal1}`);
    

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
