pragma solidity ^0.5.9;

contract Faucet {

    address payable public owner;
    uint256 sendAmount;

    function getSendAmount() public view returns (uint256) {
        return sendAmount;
    }
    
    constructor() public payable {
        owner = msg.sender;
        sendAmount = 1 ether;
    }

    function getBalance() public view returns (uint) {
        address(this).balance;
    }

    function withdrawWei() public {
        msg.sender.transfer(sendAmount);
    }

    function sendWei(address payable target) public {
        target.transfer(sendAmount);
    }

    function killMe() public returns (bool) {
        require(msg.sender == owner);
        selfdestruct(owner);
        return true;
    }

    function() external payable {}
}
