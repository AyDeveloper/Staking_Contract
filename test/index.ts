/* eslint-disable node/no-missing-import */
/* eslint-disable prettier/prettier */
/* eslint-disable no-unused-vars */
import { expect } from "chai";
import { ethers } from "hardhat";
import { Staking } from "../typechain";

describe("Staking Contract", function () {
  let ghostContractAddr: Staking;
  beforeEach( async function() {
    const [,signer] = await ethers.getSigners()
    const signer1 = await ethers.getSigner(signer.address);

    const GhostContractAddr = await ethers.getContractFactory("Staking");
    ghostContractAddr = await GhostContractAddr.connect(signer1).deploy("GHoST", "Ghst", "100000000000000000000000", signer.address);
    ghostContractAddr.deployed();
  });

  it("has a balance of the token", async function () {
    const [,signer] = await ethers.getSigners()
    const signer1 = await ethers.getSigner(signer.address);
    const bal = await ghostContractAddr.balanceOf(signer.address);
    const transferToContract = await ghostContractAddr.connect(signer1).transfer(ghostContractAddr.address, "9000000000000000000000");
    const balContract = await ghostContractAddr.balanceOf(ghostContractAddr.address);
    console.log(`This user bal ${bal}, and contract addr ${balContract}`);
  });
  it("should stake", async function () {
    const [,signer] = await ethers.getSigners()
    const signer1 = await ethers.getSigner(signer.address);
    const stake = await ghostContractAddr.connect(signer1).stake("100000000000000000000");
    const balContract = await ghostContractAddr.balanceOf(ghostContractAddr.address);
    console.log(`This contract addr now has ${balContract}`);
    expect(balContract.toString()).to.equal("100000000000000000000");
  });
  it("Withdraw stake b4 30 secs", async function () {
    const [,signer] = await ethers.getSigners()
    const signer1 = await ethers.getSigner(signer.address);
    const balContract = await ghostContractAddr.balanceOf(ghostContractAddr.address);
    console.log(`contract bal b4 stake ${balContract}`); 
    const userBal1 = await ghostContractAddr.balanceOf(signer.address);  
    console.log(`user bal before ${userBal1}`);
    const stake = await ghostContractAddr.connect(signer1).stake("100000000000000000000");
    const balContract1 = await ghostContractAddr.balanceOf(ghostContractAddr.address);
    const userBalAfterStake = await ghostContractAddr.balanceOf(signer.address);
    console.log(`user balance after stake ${userBalAfterStake}`);
    console.log(`This contract addr now has ${balContract1}`);
    const withdrawNow = await ghostContractAddr.connect(signer1).withdrawStake();
      await withdrawNow.wait();
    const contractBal = await ghostContractAddr.balanceOf(ghostContractAddr.address);
    const userBal = await ghostContractAddr.balanceOf(signer.address);
    console.log(`user balance now is ${userBal}`);
    console.log(`contract balance after withdraw ${contractBal}`);
    expect(balContract.toString()).to.equal("0");
    expect("100000000000000000000000").to.equal( userBal.toString());
  });

  
});
