// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

contract TimeManager{
    
    function createDeadline(uint256 _addTime) public virtual view returns(uint256) {
        uint256 currentTime = block.timestamp;
        return currentTime += _addTime;
    }
    
}
