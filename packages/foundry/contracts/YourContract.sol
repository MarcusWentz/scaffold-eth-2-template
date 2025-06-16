// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract YourContract {
    mapping(address => uint256) public marblesOnTable;
    mapping(address => uint256) public playerWins;
    mapping(address => uint256) public computerWins;

    function newGame() public {
        if (marblesOnTable[msg.sender] == 0) {
            marblesOnTable[msg.sender] = 12;
        }
    }

    function turn(uint256 marblesAmount) public {
        require(marblesOnTable[msg.sender] > 0, "No more marbles on table, start a new game");

        // Validate marblesAmount
        // First turn
        if (marblesOnTable[msg.sender] == 12) {
            require(marblesAmount <= 3, "You can only take 0 to 3 marbles on the first turn");
        }
        // After first turn
        else if (marblesOnTable[msg.sender] < 12) {
            require(marblesAmount <= 3 && marblesAmount > 0, "You can only take 1 to 3 marbles after the first turn");
        }
        else { revert("Unexpected"); }
        
        // Player's turn
        marblesOnTable[msg.sender] -= marblesAmount;
        
        // Add win count if player wins
        if (marblesOnTable[msg.sender] == 0) {
            playerWins[msg.sender] += 1;
        }
        // Computer's turn if player have not win
        else {
            uint256 _marblesOnTable = marblesOnTable[msg.sender];
            if (_marblesOnTable == 4 || _marblesOnTable == 8 || _marblesOnTable == 12) {
                marblesOnTable[msg.sender] -= 1;
            } else if (marblesOnTable[msg.sender] < 4) {
                marblesOnTable[msg.sender] -= marblesOnTable[msg.sender];
            } else {
                marblesOnTable[msg.sender] -= marblesOnTable[msg.sender] % 4;
            }

            // Add win count if computer wins
            if (marblesOnTable[msg.sender] == 0) {
                computerWins[msg.sender] += 1;
            }
        }
    }
}