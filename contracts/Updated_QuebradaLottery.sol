
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract QuebradaLottery {
    address public owner;
    uint256 public ticketPrice = 0.00001 ether;
    uint256[] public mainNumbers;
    uint256 public powerballNumber;
    address[] public players;
    mapping(uint256 => address) public ticketOwners;
    uint256 public drawDay;
    uint256 public drawHour = 12;
    uint256 private ticketID = 0;  // Declaration of the ticketID variable
    bool public numbersDrawn = false;  // Declaration of the numbersDrawn variable

    // Events
    event TicketPurchased(address indexed buyer, uint256[] mainNumbers, uint256 powerballNumber);
    event NumbersDrawn(uint256[] mainNumbers, uint256 powerballNumber);
    event PrizeAwarded(address indexed winner, uint256 prizeAmount);

    constructor() {
        owner = msg.sender;
        drawDay = setInitialDrawDay();
    }

    function buyTicket(uint256[] memory _mainNumbers, uint256 _powerballNumber) public payable {
        require(msg.value == ticketPrice, "Incorrect ticket price");
        require(_mainNumbers.length == 5, "Must choose 5 main numbers");
        for(uint i = 0; i < _mainNumbers.length; i++) {
            require(_mainNumbers[i] > 0 && _mainNumbers[i] <= 69, "Main numbers must be between 1 and 69");
        }
        require(_powerballNumber > 0 && _powerballNumber <= 26, "Powerball number must be between 1 and 26");

        players.push(msg.sender);
        ticketOwners[ticketID] = msg.sender;
        ticketID++; // Increment the ticketID for the next ticket purchase
        emit TicketPurchased(msg.sender, _mainNumbers, _powerballNumber);
    }

    function random() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function drawNumbers() public {
        require(msg.sender == owner, "Only the owner can draw numbers");
        require(isDrawDay(), "It's not a draw day");

        delete mainNumbers;
        delete powerballNumber;

        for (uint256 i = 0; i < 5; i++) {
            mainNumbers.push(drawUniqueNumber(1, 69));
        }

        powerballNumber = random() % 26 + 1;

        numbersDrawn = true;  // Set numbersDrawn to true after drawing
        emit NumbersDrawn(mainNumbers, powerballNumber);
    }

    function drawUniqueNumber(uint256 min, uint256 max) private returns (uint256) {
        uint256 number;
        bool numberExists;
        do {
            number = random() % max + min;
            numberExists = checkNumberExists(number);
        } while (numberExists);
        return number;
    }

    function checkNumberExists(uint256 number) private view returns (bool) {
        for (uint256 i = 0; i < mainNumbers.length; i++) {
            if (mainNumbers[i] == number) {
                return true;
            }
        }
        return false;
    }

    function isDrawDay() private view returns (bool) {
        uint256 dayOfWeek = (block.timestamp / 86400 + 4) % 7;
        return (dayOfWeek == 0 || dayOfWeek == 2 || dayOfWeek == 5);
    }

    function setInitialDrawDay() private view returns (uint256) {
        // Logic to determine the next draw day (Monday, Wednesday, or Saturday)
    }

    function distributePrizes() public {
        require(msg.sender == owner, "Only the owner can distribute prizes");
        require(numbersDrawn, "Numbers have not been drawn yet");

        uint256 totalPrizePool = address(this).balance;
        uint256 prizeForTier;

        for(uint256 i = 0; i < players.length; i++) {
            uint256 matchedNumbers = countMatchedNumbers(players[i]);
            if(matchedNumbers == 6) {
                prizeForTier = totalPrizePool * 30 / 100;
                payable(players[i]).transfer(prizeForTier);
                emit PrizeAwarded(players[i], prizeForTier);
            }
            // Additional conditions for other prize tiers
        }

        resetLottery();
    }

    function countMatchedNumbers(address player) private view returns (uint256) {
        // Logic to count how many numbers a player has matched
    }

    function resetLottery() private {
        delete players;
        delete ticketOwners;
        numbersDrawn = false;  // Reset numbersDrawn for the next draw
    }
}
