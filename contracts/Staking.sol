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


    struct Staker{
        uint amountStaked;
        address staker;
        uint startTime;
        bool staked;
        uint lastStakedTime;
        uint compoundStake;
        uint withdrawalAmount;
    }


    event StakeEvent(uint _amount, address _staker);
    event withdrawEvent(uint _amount, address _withdrawer);



    mapping(address => Staker) stakers;

    function checkStake() public view returns(Staker memory) {
        return stakers[msg.sender];
    }

    function checkStakeByAddress(address _staker) public view returns(Staker memory) {
        return stakers[_staker];
    }

    function stake(uint _amount) public returns(uint _total, uint _new) {
        uint amountNow = _amount / 1e18;
        // set an id that numbers count;
        // require(boredApe.balanceOf(msg.sender) > 1 , "Staking restricted to boredApe Owners");
        // transfer from msg.sender to address this
        // for withdraw, transfer from address this to msg.sender
        // require the stake token balance of msg.sender is greater than amount

        require(amountNow > 0, "Cannot stake less than zero");
        Staker storage stakerObject = stakers[msg.sender];
         
        if(stakerObject.staked) {
            stakeBalances[msg.sender] += amountNow;
            transfer(address(this), amountNow);
            stakerObject.amountStaked += amountNow;
            stakerObject.lastStakedTime = block.timestamp;
            // (uint _time, uint reward, uint _newOne) = calculateYield(stakerObject.compoundStake);
            (,, uint reward) = yield(stakerObject.compoundStake, stakerObject.lastStakedTime);
              _total = stakerObject.compoundStake + reward;
            (,,_new) = calculateReyield(_total, stakerObject.startTime);
            stakerObject.withdrawalAmount = _new + _total;
           
            // do a mapping  that compound amount each time they stake and calculate the yield
            // compunding works with previous total(amount + interest ) + new amount;
        }
            uint newStake = _total + amountNow;
            stakeBalances[msg.sender] = newStake;
            transfer(address(this), newStake);
            stakerObject.amountStaked = newStake;
            stakerObject.startTime  = block.timestamp;
            stakerObject.compoundStake  = newStake;
            stakerObject.staker  = msg.sender;
            stakerObject.staked = true;
            // calculateYield(_amount);

    }



    function withdrawStake() public {
        Staker storage stakerObject = stakers[msg.sender];
        // require(stakerObject.staked, "Not a staker");
        if(block.timestamp - stakerObject.startTime < 300 seconds) {
            _transfer(address(this), msg.sender, stakerObject.amountStaked);
            // _balances[address(this)] -= stakerObject.amountStaked;

        } else {            
                _transfer(address(this), msg.sender, stakerObject.withdrawalAmount);
                 emit  withdrawEvent(stakerObject.withdrawalAmount,msg.sender);

                    stakerObject.amountStaked = 0;
                    stakerObject.staked = false;
                    stakerObject.startTime = 0;
                    stakerObject.lastStakedTime = 0;
                    stakerObject.compoundStake = 0; 
                    stakerObject.withdrawalAmount = 0;
        }

    }

    function checkStakeBalance() public view returns(uint) {
        return stakeBalances[msg.sender];
    }

     function _getInterest(uint _amount) internal pure returns (uint) {
       return   ((_amount * 10) / 100) * 10000;
    }

    function _useInterest(uint _amount) internal pure returns (uint) {
        uint interest = (_getInterestPersec(_amount) / 10000000);
        return interest;
    }

     function calculateYield(uint _amount) internal view  returns(uint _a, uint _b, uint _c) {
         if(block.timestamp - stakers[msg.sender].startTime > 300 seconds) {
            _a = uint(block.timestamp - stakers[msg.sender].startTime);
                _b = _useInterest(_amount);
                _c =  _a * _b;
          
         }
    }

     function calculateReyield(uint _amount, uint _time) internal view returns(uint _a, uint _b, uint _c) {
            _a = uint(block.timestamp - _time);
                _b = _useInterest(_amount);
                // withdrawNow[msg.sender] = _a * _b;
                _c =  _a * _b;
          
    }

    function yield(uint _amount, uint _lastStaked) internal view returns(uint _a, uint _b, uint _c) {
            _a = uint(block.timestamp - _lastStaked);
                _b = _useInterest(_amount);
                _c = _a * _b;
    }

    function _getInterestPersec(uint _amount) internal pure returns (uint) {
       return   ((_amount * 10 / (30) / 86400 ) / 100) * 10000000;
    }



}
