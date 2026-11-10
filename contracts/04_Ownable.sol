// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Ownable {
    address public owner;

    event OwnershipTransferred(
        address indexed previousOwner,
        address indexed newOwner
    );

    constructor() {
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Not the owner");
        _;
    }

    function transferOwnership(address newOwner) public onlyOwner {
        require(newOwner != address(0), "New owner is zero address");

        address previousOwner = owner;
        owner = newOwner;

        emit OwnershipTransferred(previousOwner, newOwner);
    }
}

contract ProtectedVault is Ownable {
    uint256 private treasure;

    function deposit() public payable {
        require(msg.value > 0, "Deposit must be greater than zero");

        treasure += msg.value;
    }

    function withdraw(address to, uint256 amt) public onlyOwner {
        require(amt <= address(this).balance, "Insufficient balance");

        treasure -= amt;

        (bool success, ) = payable(to).call{value: amt}("");
        require(success, "Transfer failed");
    }

    function contractBalance() public view returns (uint256) {
        return address(this).balance;
    }
}