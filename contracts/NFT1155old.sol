// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;

import "@openzeppelin/contracts@v4.9.0/token/ERC1155/ERC1155.sol";
contract ERC1155Kven is ERC1155 {
    mapping(address => bool) public isController;
    address public owner; 
    constructor() payable ERC1155("") {
        owner = msg.sender;
    }

    modifier onlyController() {
        require(isController[msg.sender] == true, "not controller");
        _;
    }
    modifier onlyOwner() {
        require(msg.sender == owner, "not owner");
        _;
    }
    function setController(address _controller) public onlyOwner {
        isController[_controller] = true;
    }

    function mint(address to, bytes32 id,uint256 value ) public onlyController {
        require(to != address(0), "ERC1155: mint to the zero address");
        _mint(to,uint256(id),value,'');
    }
}   
