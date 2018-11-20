pragma solidity  ^0.4.25;

import "./Algorithm.sol";
import "./BytesUtil.sol";
import "@ensdomains/dnssec-oracle/contracts/algorithms/RSAVerify.sol";

contract RSA is Algorithm {
  using BytesUtil for bytes;

  function verify(bytes32 hash, bytes s, bytes e, bytes m) external view returns (bool) {
    bool ok;
    bytes memory result;

    (ok, result) = RSAVerify.rsarecover(m, e, s);

    return ok && hash == result.readBytes32(result.length - 32);
  }
}
