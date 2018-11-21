pragma solidity ^0.4.24;

library BytesUtil {
  function readBytes32(bytes memory self, uint idx) internal pure returns (bytes32 ret) {
    require(idx + 32 <= self.length);
    assembly {
      ret := mload(add(add(self, 32), idx))
    }
  }
}
