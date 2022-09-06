// SPDX-License-Identifier: MIT
// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
contract HotelRoom {
    event Occupy (address Theaddress , uint thevalue);
    enum status {
        vacant, 
        occupeid
        }
    status public currentStatus;
    address payable public owner;

    constructor (){
        owner= payable (msg.sender);
        currentStatus=status.vacant;
    }
    modifier onlyVacant {
         require(currentStatus==status.vacant, "Sorry no room availale");//status Check
         _;
    }
    modifier cost(uint _amount) {
        //check price
        require (msg.value==_amount, "not enough money");
        _;

    }
    function book ()public payable onlyVacant cost(2 ether) {

        currentStatus= status.occupeid;
        owner.transfer (msg.value);
        (bool sent , bytes memory data)=owner.call{value:msg.value}("");
        require(true);
        emit Occupy(msg.sender,msg.value);
    }
}