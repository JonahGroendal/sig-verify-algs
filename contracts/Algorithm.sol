pragma solidity ^0.5.2;

interface Algorithm {
    /**
    * @dev Verifies a signature.
    * @param data The data that's is signed.
    * @param sig The signature.
    * @param key The signers pub key
    * @return True iff the signature is valid.
    */
    function verify(bytes calldata key, bytes calldata data, bytes calldata sig) external view returns (bool);
}
