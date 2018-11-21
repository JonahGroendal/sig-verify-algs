pragma solidity ^0.4.24;

interface Algorithm {
    /**
    * @dev Verifies a signature.
    * @param data The data that's is signed.
    * @param sig The signature.
    * @param key The signers pub key
    * @return True iff the signature is valid.
    */
    function verify(bytes key, bytes data, bytes sig) external view returns (bool);
}
