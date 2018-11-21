pragma solidity  ^0.4.24;

import "./Algorithm.sol";
import "./BytesUtil.sol";
import "asn1-decode/contracts/Asn1Decode.sol";
import "@ensdomains/dnssec-oracle/contracts/algorithms/RSAVerify.sol";

contract RsaSha256Algorithm is Algorithm {
  using Asn1Decode for uint;
  using BytesUtil for bytes;

  function verify(bytes key, bytes data, bytes sig)
  external
  view
  returns (bool)
  {
    bool ok;
    bytes memory result;
    bytes memory m;
    bytes memory e;

    (m, e) = extractKeyComponents(key);

    (ok, result) = RSAVerify.rsarecover(m, e, sig);

    return ok && sha256(data) == result.readBytes32(result.length - 32);
  }

  /**
   * @dev Extracts modulus and exponent (respectively) from a DER-encoded RSA public key
   * @param key A DER-encoded RSA public key
   */
  function extractKeyComponents(bytes memory key)
  private
  pure
  returns (bytes, bytes)
  {
    bytes memory modulus;
    bytes memory exponent;
    bytes memory encodedModulus;
    bytes memory encodedExponent;
    bytes memory encodedBytes;
    uint node;

    node = Asn1Decode.root(key);
    node = node.firstChild(key);
    node = node.next(key);
    // Decode bitstring
    encodedBytes = node.getValue(key);
    for (uint j=0; j<encodedBytes.length-1; j++) {
      encodedBytes[j] = encodedBytes[j+1];
    }
    node = Asn1Decode.root(encodedBytes);
    node = node.firstChild(encodedBytes);
    encodedModulus = node.getValue(encodedBytes);
    // modulus must be positive
    require( encodedModulus[0] & 0x80 == 0 );
    // remove leading zero byte from der encoding of modulus if present
    if (encodedModulus[0] == 0) {
       modulus = new bytes(encodedModulus.length - 1);
       for (uint index=0; index<modulus.length; index++) {
           modulus[index] = encodedModulus[index+1];
       }
    } else {
       modulus = encodedModulus;
    }
    node = node.next(encodedBytes);
    encodedExponent = node.getValue(encodedBytes);
    // exponent must be positive
    require( encodedExponent[0] & 0x80 == 0 );
    // remove leading zero byte from der encoding of exponent if present
    if (encodedExponent[0] == 0) {
       exponent = new bytes(encodedExponent.length - 1);
       for (index=0; index<exponent.length; index++) {
           exponent[index] = encodedExponent[index+1];
       }
    } else {
       exponent = encodedExponent;
    }

    return (modulus, exponent);
  }
}
