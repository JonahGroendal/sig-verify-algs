pragma solidity  ^0.4.24;

import "./Algorithm.sol";
import "asn1-decode/contracts/Asn1Decode.sol";
import "@ensdomains/dnssec-oracle/contracts/BytesUtils.sol";
import "@ensdomains/dnssec-oracle/contracts/algorithms/RSAVerify.sol";

contract RsaSha256Algorithm is Algorithm {
  using Asn1Decode for bytes;
  using BytesUtils for bytes;

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
    bytes32 oid;
    bytes memory modulus;
    bytes memory exponent;
    bytes memory encodedModulus;
    bytes memory encodedExponent;
    bytes memory bitstring;
    uint node;

    node = key.root();
    node = key.firstChildOf(node);
    // OID must be 1.2.840.113549.1.1.1 (rsaEncryption)
    oid = keccak256(key.bytesAt(key.firstChildOf(node)));
    require( oid == 0x3be606946d6f343b24d5ecdbd7e3370a5303ed54845f50f466a35f3bbeb46a45 );

    node = key.nextSiblingOf(node);
    /* // Decode bitstring
    bitstring = key.bytesAt(node);
    for (uint j=0; j<bitstring.length-1; j++) {
      bitstring[j] = bitstring[j+1];
    } */
    bitstring = key.bitstringAt(node);
    node = bitstring.root();
    node = bitstring.firstChildOf(node);
    encodedModulus = bitstring.bytesAt(node);
    // modulus must be positive
    require( encodedModulus[0] & 0x80 == 0 );
    // remove leading zero byte from der encoding of modulus if present
    if (encodedModulus[0] == 0) {
      modulus = encodedModulus.substring(1, encodedModulus.length-1);
      /* modulus = new bytes(encodedModulus.length - 1);
      for (uint index=0; index<modulus.length; index++) {
        modulus[index] = encodedModulus[index+1];
      } */
    } else {
       modulus = encodedModulus;
    }
    node = bitstring.nextSiblingOf(node);
    encodedExponent = bitstring.bytesAt(node);
    // exponent must be positive
    require( encodedExponent[0] & 0x80 == 0 );
    // remove leading zero byte from der encoding of exponent if present
    if (encodedExponent[0] == 0) {
      exponent = encodedExponent.substring(1, encodedExponent.length-1);
      /* exponent = new bytes(encodedExponent.length - 1);
      for (index=0; index<exponent.length; index++) {
        exponent[index] = encodedExponent[index+1];
      } */
    } else {
       exponent = encodedExponent;
    }

    return (modulus, exponent);
  }
}
