// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
import "../interfaces/ICode.sol";

contract Mining{
    constructor() payable {}

    function isCloudMining(address user) public pure  returns(bool){
        return true;
    }
    function addCode(Code memory code) public pure returns (bool){
        return true;
    }
}
