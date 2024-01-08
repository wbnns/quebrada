
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract QuebradaLottery {
    address public owner;
    uint256 public ticketPrice = 0.00001 ether;
    uint256[] public mainNumbers;
    uint256 public luckyNumber;
    address[] public players;
    mapping(uint256 => address) public ticketOwners;
    uint256 public drawDay;
    uint256 public drawHour = 12;

    // Events
    event TicketPurchased(address indexed buyer, uint256[] mainNumbers, uint256 luckyNumber);
    event NumbersDrawn(uint256[] mainNumbers, uint256 luckyNumber);
    event PrizeAwarded(address indexed winner, uint256 prizeAmount);

    constructor() {
        owner = msg.sender;
        drawDay = setInitialDrawDay();
    }

    function buyTicket(uint256[] memory _mainNumbers, uint256 _luckyNumber) public payable {
        require(msg.value == ticketPrice, "Incorrect ticket price");
        require(_mainNumbers.length == 5, "Must choose 5 main numbers");
        for(uint i = 0; i < _mainNumbers.length; i++) {
            require(_mainNumbers[i] > 0 && _mainNumbers[i] <= 69, "Main numbers must be between 1 and 69");
        }
        require(_luckyNumber > 0 && _luckyNumber <= 26, "Lucky number must be between 1 and 26");

        players.push(msg.sender);
        ticketOwners[ticketID] = msg.sender;
        emit TicketPurchased(msg.sender, _mainNumbers, _luckyNumber);
    }

    function random() private view returns (uint256) {
        return uint256(keccak256(abi.encodePacked(block.difficulty, block.timestamp, players.length)));
    }

    function drawNumbers() public {
        require(msg.sender == owner, "Only the owner can draw numbers");
        require(isDrawDay(), "It's not a draw day");

        // Resetting previous draw numbers
        delete mainNumbers;
        delete luckyNumber;

        // Drawing main numbers
        for (uint256 i = 0; i < 5; i++) {
            mainNumbers.push(drawUniqueNumber(1, 69));
        }

        // Drawing the Lucky number
        luckyNumber = random() % 26 + 1;

        emit NumbersDrawn(mainNumbers, luckyNumber);

        // Prize distribution logic will go here
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
        uint256 dayOfWeek = (block.timestamp / 86400 + 4) % 7; // 0 = Thursday, so +4 to adjust to Monday = 0
        return (dayOfWeek == 0 || dayOfWeek == 2 || dayOfWeek == 5); // 0 = Monday, 2 = Wednesday, 5 = Saturday
    }

    function setInitialDrawDay() private view returns (uint256) {
        // Logic to determine the next draw day (Monday, Wednesday, or Saturday)
    }

    function distributePrizes() public {
        require(msg.sender == owner, "Only the owner can distribute prizes");
        require(numbersDrawn, "Numbers have not been drawn yet");

        uint256 totalPrizePool = address(this).balance;
        uint256 prizeForTier;

        // Example prize distribution logic
        // This should be refined based on your specific prize tiers and rules

        for(uint256 i = 0; i < players.length; i++) {
            uint256 matchedNumbers = countMatchedNumbers(players[i]);
            if(matchedNumbers == 6) { // Example condition
                prizeForTier = totalPrizePool * 30 / 100; // 30% for jackpot
                payable(players[i]).transfer(prizeForTier);
                emit PrizeAwarded(players[i], prizeForTier);
            }
            // Additional conditions for other prize tiers
        }

        resetLottery();
    }

    function countMatchedNumbers(address player) private view returns (uint256) {
        // Logic to count how many numbers a player has matched
        // Returns the number of matched numbers
    }

    function resetLottery() private {
        // Logic to reset the lottery for the next draw
        delete players;
        delete ticketOwners;
    }
}
