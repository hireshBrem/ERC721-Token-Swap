// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract Ownable{
    address public owner;

    event OwnerChanged(
        address _previousOwner,
        address _newOwner,
        uint256 time
    );

    modifier onlyOwner() {
        require(owner == msg.sender, "Invalid only owner can access this function");
        _;
    }

    constructor(){
        owner = msg.sender;
    }

    function getOwner() public view returns(address){
        return owner;
    }

    function changeOwner(address _addr) public virtual onlyOwner{
        owner = _addr;
        emit OwnerChanged(msg.sender, _addr, block.timestamp);
    }
}