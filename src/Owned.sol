pragma solidity ^0.5.9;

contract Owned {
  address public owner;
  constructor() public {
    owner = msg.sender;
  }
}
