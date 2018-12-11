var RsaSha256Algorithm = artifacts.require("RsaSha256Algorithm");
var cert = require('./cert');

contract('RsaSha256Algorithm', (accounts) => {
  // Test addCertificate()
  it("should verify a valid signature", async () => {
    let instance = await RsaSha256Algorithm.deployed();
    let result = await instance.verify(cert.signersPubKey, cert.tbsCertificate, cert.signature);

    let gas = await instance.verify.estimateGas(cert.signersPubKey, cert.tbsCertificate, cert.signature);
    console.log("      gas: verify(): " + gas);

    assert.isTrue(result, "Validation returned false");
  })
  it("should fail to verify an invalid signature", async () => {
    let instance = await RsaSha256Algorithm.deployed();
    let result = await instance.verify(cert.signersPubKey, cert.tbsCertificate.substring(0, 70), cert.signature);

    let gas = await instance.verify.estimateGas(cert.signersPubKey, cert.tbsCertificate, cert.signature);
    console.log("      gas: verify(): " + gas);

    assert.isFalse(result, "Validation returned true");
  })
})
