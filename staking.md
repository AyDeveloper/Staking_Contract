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
           uint interestFor30days = (interest * 30);
           uint profit = amount + interestFor30days;
           stakeBalances[msg.sender] = profit;
           console.log(interest , interestFor30days);
       }

        // stakeBalances[msg.sender] = amount;
       if(block.timestamp - timeStarts > 3 days &&  block.timestamp - timeStarts < 30 days) {
           uint timeNow = block.timestamp - timeStarts;
            uint dayNow = timeNow / 86400;
            //  interestof three days + current
            uint interestPerDay = (_getInterestADay(amount) / 10000);
            uint interest3Days = interestPerDay * 3;
            uint additionalInterest = interestPerDay * dayNow;
            uint totalProfit = interest3Days + additionalInterest;
            uint profit = amount + totalProfit;
            stakeBalances[msg.sender] = profit;
       } 