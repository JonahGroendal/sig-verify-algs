var RSA = artifacts.require("RSA");
var RSAVerify = artifacts.require("@ensdomains/dnssec-oracle/RSAVerify");
var BytesUtils = artifacts.require("@ensdomains/dnssec-oracle/BytesUtils");
var Buffer = artifacts.require("@ensdomains/buffer/Buffer");

module.exports = function(deployer, network) {
  deployer.deploy(Buffer);
  deployer.deploy(BytesUtils);
  deployer.deploy(RSAVerify);
  deployer.deploy(RSA);
};
