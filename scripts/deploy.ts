/* eslint-disable prettier/prettier */
import { ethers } from "hardhat";
import { Signer } from "ethers";

async function main() {
  // const boredApeOwner = "0xcee749f1cfc66cd3fb57cefde8a9c5999fbe7b8f";
  const owner = "0x9ae1e982Fc9A9D799e611843CB9154410f11Fe35";

  // const boredApeOwnerSigner: Signer = await ethers.getSigner(boredApeOwner);
  const ownerSigner: Signer = await ethers.getSigner(owner);

   // @ts-ignore
   await hre.network.provider.request({
    method: "hardhat_impersonateAccount",
    params: [owner],
  });

  // @ts-ignore
  await network.provider.send("hardhat_setBalance", [
    owner,
    "0x2000000000000000000000000000000000000",
  ])

  // We get the contract to deploy
  // const Staking = await ethers.getContractFactory("Staking");
  // const staking = await Staking.deploy("0x0C669838b390DF27CEEdc9Af53da6371590e4Fc4");

  // await staking.deployed();
  // console.log('address', staking.address);
  

const staking = await ethers.getContractAt('Staking', "0x74Cf9087AD26D541930BaC724B7ab21bA8F00a27");
await staking.connect(ownerSigner).stakeNow("100"); 

// @ts-ignore
await network.provider.send("evm_increaseTime", [2592000]);
// @ts-ignore
await network.provider.send("evm_mine");


await staking.connect(ownerSigner).withdrawStake('10');
console.log(await staking.connect(ownerSigner).checkStakeBalance());
console.log(await staking.connect(ownerSigner).calculateYield("100", owner));
// console.log(await staking.connect(ownerSigner).checkStake());





}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
