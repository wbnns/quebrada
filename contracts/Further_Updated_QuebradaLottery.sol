
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract QuebradaLottery {
    address public owner;
    uint256 public ticketPrice = 0.00001 ether;
    uint256[] public mainNumbers;
    uint256 public powerballNumber;
    address[] public players;
    uint256 private currentRound = 0;
    mapping(uint256 => mapping(uint256 => address)) public ticketOwners; // Round to ticket ID to owner
    uint256 public drawDay;
    uint256 public drawHour = 12;
    uint256 private ticketID = 0;
    bool public numbersDrawn = false;

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
        ticketOwners[currentRound][ticketID] = msg.sender;
        ticketID++;
        emit TicketPurchased(msg.sender, _mainNumbers, _powerballNumber);
    }

    // ... [rest of the contract functions]

    function resetLottery() private {
        delete players;
        currentRound++; // Move to the next round
        numbersDrawn = false;
    }

    // ... [rest of the contract]
}
