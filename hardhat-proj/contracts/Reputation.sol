// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;


//A simple contract to store and manage user reputation scores
contract Reputation {
    address public owner;
    mapping(address => uint256) public scores;

    event ScoreUpdated(address indexed user, uint256 newScore);

    constructor() {
        owner = msg.sender; 
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Reputation: Caller is not the owner");
        _;
    }

    /**
     * Updates a user's score based on their actions in the main contract
     *  The address of the user whose score is to be updated
     *  The amount to change the score by (can be positive or negative)
     */
    function updateScore(address user, int256 change) external onlyOwner {
        uint256 currentScore = scores[user];
        uint256 newScore;
        if (change > 0) {
            newScore = currentScore + uint256(change);
        } else {
            uint256 reduction = uint256(-change);
            if (currentScore >= reduction) {
                newScore = currentScore - reduction;
            } else {
                newScore = 0; 
            }
        }
        scores[user] = newScore;
        emit ScoreUpdated(user, newScore);
    }

    function transferOwnership(address newOwner) external onlyOwner {
        require(newOwner != address(0), "Reputation: New owner is the zero address");
        owner = newOwner;
    }
}