pragma solidity ^0.4.25;

interface Algorithm {
    /**
    * @dev Verifies a signature.
    * @param hash The hash data that's signed.
    * @param s The signature of hash data.
    * @param e The exponent component of signers pub key
    * @param m The modulus component of signers pub key
    * @return True iff the signature is valid.
    */
    function verify(bytes32 hash, bytes s, bytes e, bytes m) external view returns (bool);
}
