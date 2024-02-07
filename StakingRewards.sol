// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "./TokenContract.sol";

contract Rewards is ERC20 {
    POSToken public posToken;

    // Total staked tokens
    uint256 public totalStaked;

    // Mapping of staker address to their earned rewards
    mapping(address => uint256) public earnedRewards;

    // Mapping of staker address to their last reward update timestamp
    mapping(address => uint256) public lastRewardUpdate;

    constructor(address posTokenAddress) ERC20("MoneyTrees", "MTM") {
        posToken = POSToken(posTokenAddress);
    }

    function updateRewards() public {
        uint256 currentTime = block.timestamp;
        
        // Update rewards for all stakers since their last update
        for (uint256 i = 0; i < posToken.stakerLength(); i++) {
            address staker = posToken.stakers(i);
            uint256 lastUpdateTime = lastRewardUpdate[staker];
            uint256 timeElapsed = currentTime - lastUpdateTime;

            // Calculate earned rewards since last update (adjust formula as needed)
            uint256 stakedAmount = posToken.balanceOf(staker);
            uint256 reward = (stakedAmount * timeElapsed * interestRate) / SECONDS_PER_YEAR;
            earnedRewards[staker] += reward;

            // Update last reward update timestamp
            lastRewardUpdate[staker] = currentTime;
        }
    }

    function claimRewards() public {
        require(earnedRewards[msg.sender] > 0, "No rewards to claim");

        // Transfer earned rewards to staker
        uint256 amount = earnedRewards[msg.sender];
        earnedRewards[msg.sender] = 0; // Reset earned rewards
        _transfer(address(this), msg.sender, amount);
    }

    // Constants representing seconds in a year and initial interest rate
    uint256 constant SECONDS_PER_YEAR = 31536000;
    uint256 public interestRate = 10;

    // Events for reward updates and claims
    event RewardUpdated(address staker, uint256 amount);
    event RewardClaimed(address staker, uint256 amount);
}
