// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.0;

import "./Ownable.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/utils/introspection/IERC165.sol";
import "./Time.sol";

contract TokenSwap is Ownable, TimeManager{
    
    struct User {
        uint256 id;
        address addr;
        uint256 tokenId;
    } 
    
    uint256 userCount;

    // Maps address to whether or not that address has authorised the token swap
    mapping(address => bool) authorise;

    // Maps a token id to another token id (pairing up token ids) to prepare for token swap
    mapping(uint256 => uint256) tokenPair; 

    // Maps an address to user id
    mapping(address => uint256) public addrToUserId;

    // Maps user id to a user
    mapping(uint256 => User) public idToUser;

    // List of users 
    User[] internal users;
    
    modifier validateAddress(address _addr) {
        require(_addr != address(0), "Invalid address");
        _;
    }

    modifier isAuthorised(address _addr) {
       require(authorise[_addr] == true, "Invalid: Address not authorised");
       _;
    }  

    function getContractOwner() public view returns(address){
        return getOwner();
    }

    function readString() public view returns(string memory) {
        return "Hiresh Bremanand";
    }

    function returnNumber() public view returns(uint256){
        return 10;
    }

    //Two token id's from the same contract address are paired up 
    function setPair(address _tokenAddr, uint256 _tokenId1, uint256 _tokenId2) public {
        tokenPair[_tokenId1] = _tokenId2;
    }
    
    //Msg.sender will authorise their token swap
    function authoriseSwap(address _tokenAddr, uint256 _tokenId) public {
        authorise[msg.sender] = true;
        _addToStorage(userCount, msg.sender, _tokenId);
        IERC721 contractAddr = IERC721(_tokenAddr);
        contractAddr.approve(address(this), _tokenId);
    }

    function swapTokens(address _tokenAddr, uint256 _tokenId1, uint256 _tokenId2) public 
        validateAddress(_tokenAddr)
        isAuthorised(_getOwner(_tokenAddr, _tokenId1))
        isAuthorised(_getOwner(_tokenAddr, _tokenId2)) {
        // Swap tokens (interact with their contracts)
        require(tokenPair[_tokenId1] == _tokenId2 || tokenPair[_tokenId2] == _tokenId1, "Invalid: specified token ids are not a pair.");

        //Interact with contract
        _swapToken(_tokenAddr, _tokenId1, _tokenId2);
    }

    // Signs up person for the token swap
    function _addToStorage(uint256 userCount, address _addr, uint256 _tokenId) internal {
        userCount+=1;
        users.push(User(userCount, _addr, _tokenId));
        idToUser[userCount] = User(userCount, _addr, _tokenId);
        addrToUserId[_addr] = userCount; 
    }

    // Gets the owner of a token id 
    function _getOwner(address _tokenAddr, uint256 _tokenId) internal view returns(address){
        IERC721 contractAddr = IERC721(_tokenAddr);
        return contractAddr.ownerOf(_tokenId);
    }

    function _swapToken(address _tokenAddr, uint256 _tokenId1, uint256 _tokenId2) internal {
        IERC721 contractAddr = IERC721(_tokenAddr);
        contractAddr.safeTransferFrom(_getOwner(_tokenAddr, _tokenId1), _getOwner(_tokenAddr, _tokenId2), _tokenId1);
        contractAddr.safeTransferFrom(_getOwner(_tokenAddr, _tokenId2), _getOwner(_tokenAddr, _tokenId1), _tokenId2);
    }
 
}

