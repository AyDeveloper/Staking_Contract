/* eslint-disable prettier/prettier */
import { ethers } from "hardhat";
import { Signer } from "ethers";

async function main() {
  const boredApeOwner = "0xcee749f1cfc66cd3fb57cefde8a9c5999fbe7b8f";
  const owner = "0x9ae1e982Fc9A9D799e611843CB9154410f11Fe35";

  const boredApeOwnerSigner: Signer = await ethers.getSigner(boredApeOwner);
  const ownerSigner: Signer = await ethers.getSigner(owner);

   // @ts-ignore
   await hre.network.provider.request({
    method: "hardhat_impersonateAccount",
    params: [owner],
  });

    // @ts-ignore
    await hre.network.provider.request({
      method: "hardhat_impersonateAccount",
      params: [boredApeOwner],
    });

  // @ts-ignore
  await network.provider.send("hardhat_setBalance", [
    owner,
    "0x2000000000000000000000000000000000000",
  ])

  // We get the contract to deploy
  // const Staking = await ethers.getContractFactory("Staking");
  // const staking = await Staking.connect(ownerSigner).deploy("Bape", "BAPE", 1000000000000, owner);

  // await staking.deployed();
  // console.log('address', staking.address);
  
  // console.log(await staking.balanceOf(owner));
  // await staking.connect(ownerSigner).transfer(boredApeOwner, "1000000")
  // console.log(`balance b4 is`, await staking.balanceOf(boredApeOwner));

  // const txstake = await staking.connect(boredApeOwnerSigner).stake("10,000");
  //  console.log(txstake);

  
 

const staking = await ethers.getContractAt('Staking', "0x06d74519CB7C0AFFBf645A43fafD3ae8C38DB4e7");
const witTx = await staking.connect(boredApeOwnerSigner).withdrawStake(); 
console.log(witTx);

const afterStake = await staking.stakeBalances(boredApeOwner);
console.log(`balance after is ${afterStake}`);

// 1000000

}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
