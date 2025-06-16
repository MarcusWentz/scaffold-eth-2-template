// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

contract YourContract {
    mapping(address => uint256) public playerMarblesOnTable;
    mapping(address => uint256) public playerUserWins;
    mapping(address => uint256) public playerComputerWins;
    uint256 public topUserWins;
    address public topUserAddress;

    function newGame() public {
        if (playerMarblesOnTable[msg.sender] == 0) {
            playerMarblesOnTable[msg.sender] = 12;
        }
    }

    function turn(uint256 removeMarblesAmount) public {
        require(playerMarblesOnTable[msg.sender] > 0, "No more marbles on table, start a new game");

        // First turn validation
        if (playerMarblesOnTable[msg.sender] == 12) {
            require(removeMarblesAmount <= 3, "You can only take 0 to 3 marbles on the first turn");
        }
        
        // Subsequent turns validation
        if (playerMarblesOnTable[msg.sender] < 12) {
            require(removeMarblesAmount <= 3 && removeMarblesAmount > 0, "You can only take 1 to 3 marbles after the first turn");
        }
        
        // Player's turn
        playerMarblesOnTable[msg.sender] -= removeMarblesAmount;
        
        // Check if player won
        if (playerMarblesOnTable[msg.sender] == 0) {
            playerUserWins[msg.sender] += 1;
            // Update top user if current user has more wins
            if (playerUserWins[msg.sender] > topUserWins) {
                topUserWins = playerUserWins[msg.sender];
                topUserAddress = msg.sender;
            }
            return;
        }

        // Computer's turn
        uint256 _marblesOnTable = playerMarblesOnTable[msg.sender];
        
        if (_marblesOnTable == 4 || _marblesOnTable == 8 || _marblesOnTable == 12) {
            playerMarblesOnTable[msg.sender] -= 1;
        }
        
        if (_marblesOnTable < 4) {
            playerMarblesOnTable[msg.sender] -= _marblesOnTable;
        }
        
        if (_marblesOnTable > 4 && _marblesOnTable != 8 && _marblesOnTable != 12) {
            playerMarblesOnTable[msg.sender] -= _marblesOnTable % 4;
        }

        // Check if computer won
        if (playerMarblesOnTable[msg.sender] == 0) {
            playerComputerWins[msg.sender] += 1;
        }
    }
}