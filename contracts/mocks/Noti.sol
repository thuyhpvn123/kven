pragma solidity 0.8.19;
import "../interfaces/INoti.sol";

contract Notification {

  constructor () payable{}

function AddNoti(
      NotiParams memory params,
      address _to
    ) external returns (bool){
      return true;
    }

  function AddMultipleNoti(
        NotiParams memory params,
        address[] memory _to
    ) external returns (bool){
      return true;
    }
}
