//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "hardhat/console.sol";
import  "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";


contract Staking {

    IERC20 dearTokenInstance;
    struct Staker{
        uint amountStaked;
        uint96 startTime;
        bool staked;
        uint reward;
    }

    event StakeEvent(uint _amount, address _staker);
    event withdrawEvent(uint _amount, address _withdrawer);

    mapping(address => Staker) stakers;
    uint constant maxTime = 3 days;

    
    constructor(address _dearAddr) {
        dearTokenInstance = IERC20(_dearAddr);
    }

    function stakeNow(uint _amount) public  {
        require(_amount > 0, "Cannot stake less than zero");
        Staker storage stakerObject = stakers[msg.sender];
        emit StakeEvent(_amount, msg.sender);

        if(stakerObject.staked == true) {
            uint daySpent = block.timestamp - stakerObject.startTime;
            dearTokenInstance.transferFrom(msg.sender, address(this), _amount);
            if(daySpent >  maxTime) {
                // calculate yield
                (,, uint _reward) = calculateYield(_amount, msg.sender);
                stakerObject.reward += _reward;
                 stakerObject.amountStaked += _reward;
                stakerObject.amountStaked += _amount;
                stakerObject.startTime = uint96(block.timestamp);
            } else {
                stakerObject.reward = 0;
                stakerObject.amountStaked += _amount;
                stakerObject.startTime = uint96(block.timestamp); 
            }

         } else {
            dearTokenInstance.transferFrom(msg.sender, address(this), _amount);
            stakerObject.amountStaked = _amount;
            stakerObject.startTime  = uint96(block.timestamp);
            stakerObject.staked = true;
        }

    }



    function withdrawStake(uint _amount) public {
        Staker storage stakerObject = stakers[msg.sender];
        uint256 daySpent = block.timestamp - stakerObject.startTime;

        if(daySpent > maxTime){
            (,, uint256 _yield) =  calculateYield(stakerObject.amountStaked, msg.sender);
            uint256 totalAmount =  stakerObject.amountStaked + _yield;
            // require(_amount <= totalAmount, "Insufficient fund");
            stakerObject.amountStaked = totalAmount - _amount;
            stakerObject.reward -= _amount;
            dearTokenInstance.transfer(msg.sender, _amount);
            stakerObject.startTime = uint96(block.timestamp);
        } else {
            require(stakerObject.amountStaked >= _amount, "Insufficient fund");
            stakerObject.amountStaked = stakerObject.amountStaked - _amount;
            stakerObject.startTime = uint96(block.timestamp);
        }
        dearTokenInstance.transfer(msg.sender, _amount);
        stakerObject.startTime = uint96(block.timestamp);
        // stakerObject.amount > 0 ? stakerObject.staked = true : stakerObject.staked = false;
        emit withdrawEvent(stakerObject.amountStaked, msg.sender);

    }

    function withdrawReward(uint _amount) public {
        Staker storage stakerObject = stakers[msg.sender];
        uint256 daySpent = block.timestamp - stakerObject.startTime;

        if(daySpent > maxTime){
            (,, uint256 _yield) =  calculateYield(stakerObject.amountStaked, msg.sender);
            require(_amount <= stakerObject.reward, "Insufficient fund");
            stakerObject.amountStaked -= _yield;
            stakerObject.reward -= _amount;
        } else {
            stakerObject.reward = 0;
        }
        dearTokenInstance.transfer(msg.sender, _amount);
    }

    function checkStakeBalance() public view returns(uint) {
        Staker storage stakerObject = stakers[msg.sender];
        return stakerObject.amountStaked;
    }

    function checkStake() public view returns(Staker memory) {
        return stakers[msg.sender];
    }

    function checkStakeByAddress(address _staker) public view returns(Staker memory) {
        return stakers[_staker];
    }

    function calculateYield(uint _amount, address _user) public view  returns(uint _a, uint _b, uint _c) {
            _a = uint(block.timestamp - stakers[_user].startTime);
               (_b) = _getInterestPersec(_amount);

                uint b =   _a * _b;
                _c = b  / 100000000000000;
        }

    function _getInterestPersec(uint _amount) public pure returns (uint _f) {
        // uint amountWei = _amount * 1e18;
        uint a = (10 * 10000000);
        uint b = a / 100;
        uint c = b / 30;
        uint d = (c * 10000000);
        uint e = d / 86400;
       _f = e * _amount;
    }





}
