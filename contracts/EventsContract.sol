// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.24;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";

contract EventsManager {

    uint256 eventCount;
    IERC721 public nftContractAddress;

    struct Event {
        string title;
        uint256 noOfAttendees;
        bool hasEnded;
        uint256 closeTime;
        address organizer;
        bool isOngoing;
        // mapping(address => bool) isRegistered;
    }

    Event[] allEvents;

    // mapping(uint256 => Event) 
    mapping(address => Event[]) organizersEvents;
    mapping(uint256 => Event) events;
    mapping(address => mapping(uint256 => bool)) hasRegistered;
    
    // mapping(address => events) 

    constructor(address _nftContractAddress) {
        nftContractAddress = IERC721(_nftContractAddress);
    }

    function createEvent(string memory _title, uint256 _closeTime) external {
        require(msg.sender != address(0), "address zero found");
        require(_closeTime > 0, "give time in future");

        
        uint256 _eventId = eventCount + 1;
        
        Event storage evnt = events[_eventId];
        evnt.title = _title;
        evnt.closeTime = block.timestamp + (_closeTime * 1 days);
        evnt.hasEnded = evnt.closeTime > block.timestamp;
        evnt.organizer = msg.sender;

        allEvents.push(evnt);
        organizersEvents[msg.sender].push(evnt);
    }

    function getEvents() external view returns (Event[] memory) {
        return allEvents;
    }

    function registerForEvent(uint256 _eventId) external {
        require(msg.sender != address(0), "address zero found");
        require(_eventId > 0, "invalid id");
        
        
        Event storage evnt = events[_eventId];
        require(!evnt.hasEnded, "event has ended");


        // check that user has the NFT
        require(nftContractAddress.balanceOf(msg.sender) >= 0, "access denied. Mint NFT");
        require(!hasRegistered[msg.sender][_eventId], "already registered");

        

        evnt.noOfAttendees += 1;
        hasRegistered[msg.sender][_eventId] = true;

    }


}
