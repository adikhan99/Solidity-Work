// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;
 contract Auction {
     address payable public beneficiary;
     uint public auctionedEndTime;
     address public HighestBidder;
     uint public HighestBid;
     bool ended = false;
     mapping(address => uint) public pendingReturns;
     event HighestBidIncrease (address bidder, uint amount);
     event AuctionEnded (address winner, uint amount);
     constructor (uint _biddingTime,address payable _beneficiary){
         beneficiary = _beneficiary;
         auctionedEndTime = block.timestamp + _biddingTime;

     }
     function bid () public payable{
         if (block.timestamp > auctionedEndTime){
             revert ("The auction has already ended");
         }
         if (msg.value <= HighestBid){
             revert ("There is already higher or equal bid");
         }
         if (HighestBid != 0){
             pendingReturns[HighestBidder] += HighestBid;
         }
         HighestBidder = msg.sender;
         HighestBid = msg.value;
         emit HighestBidIncrease(msg.sender, msg.value);
       
     }
     function withdraw () public returns (bool){
         uint amount =pendingReturns[msg.sender];
         if ( amount > 0){
             pendingReturns[msg.sender]= 0;
            if(! payable (msg.sender).send(amount)){
                pendingReturns[msg.sender]= amount;
                return false;
            }
         }

         return true;


     }
     function auctionEnd()public{
         if (block.timestamp < auctionedEndTime){
             revert("The auction has not ended yet");
         }
         if (ended){
             revert ("The auction has ended");
         }
         ended= true;
         emit AuctionEnded(HighestBidder, HighestBid);
         beneficiary.transfer(HighestBid);
         //**address** will recieve **value** here
     }

 }