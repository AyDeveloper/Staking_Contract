//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import  "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";


contract Staking is ERC20 {

    mapping(address => uint256) public stakeBalances;

    constructor(string memory name_, string memory symbol_, uint totalsupply_, address _owner) ERC20(name_, symbol_) {
        _balances[_owner] += totalsupply_;
    }

    address boredApeAddr = 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D;
    IERC721 boredApe = IERC721(boredApeAddr);
    uint public timeStarts;
    function stake(uint _amount) public {
        require(boredApe.balanceOf(msg.sender) >= 1 , "Staking restricted to boredApe Owners");
        timeStarts = block.timestamp;
        stakeBalances[msg.sender] += _amount;
        // calculateRewards(_amount);
    }
  

    function withdrawStake() public {
        require(stakeBalances[msg.sender] > 0, "didnt stake");
        require(block.timestamp > timeStarts, "Cannot withdraw yet");
        uint amount = stakeBalances[msg.sender];
       if((block.timestamp - timeStarts) == 30 seconds) {
           // get rewards for 3 days
           uint interest = (_getInterestADay(amount) / 10000);
           uint interestFor3days = (interest * 3);
           uint profit = amount + interestFor3days;
           stakeBalances[msg.sender] = profit;
           console.log(interest , interestFor3days);
       }

       if(block.timestamp - timeStarts == 300 seconds) {
           // get reward for 30days
           uint interest = (_getInterestADay(amount)) / 10000;
           uint interestFor30days = (interest * 30) ;
           stakeBalances[msg.sender] += interestFor30days;
           console.log(interest , interestFor30days);
       }

        // stakeBalances[msg.sender] = amount;
       if(block.timestamp - timeStarts > 3 days &&  block.timestamp - timeStarts < 30 days) {
           uint timeNow = block.timestamp - timeStarts;
            uint dayNow = timeNow / 86400;
       }       
    }

    function checkStakeBalance() public view returns(uint) {
        return stakeBalances[msg.sender];
    }

     function _getInterest(uint _amount) public pure returns (uint) {
       return   ((_amount * 10) / 100) * 10000;
    }

    
    function _getInterestADay(uint _amount) public pure returns (uint) {
       return   ((_amount * 10 / 30) / 100) * 10000;
    }


}
