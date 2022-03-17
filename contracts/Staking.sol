//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import  "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";


contract Staking is ERC20 {

      mapping(address => uint256) public stakeBalances;
     
    //   mapping(address => mapping(address => uint256)) private _allowances;

    //     string private _name;
    //     string private _symbol;
    //     uint private  _totalSupply;

    //  constructor(string memory name_, string memory symbol_,  uint totalSupply_) {
    //      _name = name_;
    //      _symbol = symbol_;  
    //      _totalSupply = totalSupply_;
    //      _balances[address(this)] += totalSupply_;
    //  }

    constructor(string memory name_, string memory symbol_, uint totalsupply_, address _owner) ERC20(name_, symbol_) {
        _balances[_owner] += totalsupply_;
    }

    address boredApeAddr = 0xBC4CA0EdA7647A8aB7C2061c2E118A18a936f13D;
    IERC721 boredApe = IERC721(boredApeAddr);
    uint private timeStarts;
    function stake(uint _amount) public {
        require(boredApe.balanceOf(msg.sender) > 0, "Staking restricted to boredApe Owners");
        // send funds to the msg.sender before staking
        timeStarts = block.timestamp;
        // balances
        stakeBalances[msg.sender] += _amount;
        stakeRewards(_amount, timeStarts);
    }
  
    function stakeRewards(uint _amount, uint _timeStart) internal  {
        // if(timeStarts >= timeStarts + 3 days) {
        //     // calculate rewards for 3days
        //     uint bal = stakeBalances[msg.sender];
        //     uint amountPayable = _getInterestAfter3days(_amount) / 10000;
        //    return stakeBalances[msg.sender] = bal + amountPayable;
        // }

        // 1647460094

        if(_timeStart >= _timeStart + 30) {
        //    uint bal = stakeBalances[msg.sender];
           uint amountPayable = (_getInterest(_amount) / 10000);
           stakeBalances[msg.sender] += amountPayable;
           console.log(amountPayable);
        //    return stakeBalances[msg.sender] += amountPayable; 
        }

        // return stakeBalances[msg.sender];
    }

    function withdrawStake( ) public {
        require(stakeBalances[msg.sender] > 0, "didnt stake");
        uint withdrawAmount = stakeBalances[msg.sender];
        _balances[msg.sender] += withdrawAmount;
    }

    function checkStakeBalance() public view returns(uint) {
        return stakeBalances[msg.sender];
    }

     function _getInterest(uint _amount) public pure returns (uint) {
       return   ((_amount * 10) / 100) * 10000;
    }

    
    function _getInterestAfter3days(uint _amount) public pure returns (uint) {
       return   ((_amount * 10 / 30) / 100) * 10000;
    }


}
