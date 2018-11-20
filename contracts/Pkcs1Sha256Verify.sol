pragma solidity  ^0.4.19;

import "@ensdomains/dnssec-oracle/contracts/algorithms/RSAVerify.sol";

library Pkcs1Sha256Verify {

  function readBytes32(bytes memory self, uint idx) internal pure returns (bytes32 ret) {
    require(idx + 32 <= self.length);
    assembly {
      ret := mload(add(add(self, 32), idx))
    }
  }

  function verify(bytes32 hash, bytes s, bytes e, bytes m) public returns (bool) {
    bool ok;
    bytes memory result;

    (ok, result) = RSAVerify.rsarecover(m, e, s);

    return ok && hash == readBytes32(result, result.length - 32);
  }
}
