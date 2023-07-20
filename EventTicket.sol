//SPDX-License-Identifier: Unlicense
pragma solidity >=0.5.0 <0.9.0;


contract EventContract {

    //creating a struct to store the required data type
 struct Event{
   address organizer;
   string name;
   uint date; 
   uint price;
   uint ticketCount;  
   uint ticketRemain;
 }

//to get the users details
 mapping(uint=>Event) public events;

 //to get the tickets 
 mapping(address=>mapping(uint=>uint)) public tickets;
 uint public nextId;
 

//to create a event
 function createEvent(string memory name,uint date,uint price,uint ticketCount) external{
   //event date should not be in past
   require(date>block.timestamp,"You can organize event for future date");
   //to create a event with ticket size more then 0
   require(ticketCount>0,"You can organize event only if you create more than 0 tickets");
   //use to store the event from 0 index
   events[nextId] = Event(msg.sender,name,date,price,ticketCount,ticketCount);
   nextId++;
 }


 function buyTicket(uint id,uint quantity) external payable{
   require(events[id].date!=0,"Event does not exist");
   require(events[id].date>block.timestamp,"Event has already occured");
   Event storage _event = events[id];
   require(msg.value==(_event.price*quantity),"Ethere is not enough");
   require(_event.ticketRemain>=quantity,"Not enough tickets");
   _event.ticketRemain-=quantity;
   //ticket recieved by the user
   tickets[msg.sender][id]+=quantity;


 }

//function to transfer the tickets 
 function transferTicket(uint id,uint quantity,address to) external{
   require(events[id].date!=0,"Event does not exist");
   require(events[id].date>block.timestamp,"Event has already occured");
   require(tickets[msg.sender][id]>=quantity,"You do not have enough tickets");
   tickets[msg.sender][id]-=quantity;
   tickets[to][id]+=quantity;
 }
}
