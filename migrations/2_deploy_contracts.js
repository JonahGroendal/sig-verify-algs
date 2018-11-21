var RsaSha256Algorithm = artifacts.require("RsaSha256Algorithm");
var Asn1Decode = artifacts.require("asn1-decode/Asn1Decode");
var NodePtr = artifacts.require("asn1-decode/NodePtr");
var RSAVerify = artifacts.require("@ensdomains/dnssec-oracle/RSAVerify");
var BytesUtils = artifacts.require("@ensdomains/dnssec-oracle/BytesUtils");
var Buffer = artifacts.require("@ensdomains/buffer/Buffer");

module.exports = function(deployer, network) {
  deployer.deploy(Buffer);
  deployer.deploy(BytesUtils);
  deployer.deploy(RSAVerify);
  deployer.deploy(NodePtr);
  deployer.link(NodePtr, Asn1Decode);
  deployer.deploy(Asn1Decode);
  deployer.link(Asn1Decode, RsaSha256Algorithm);
  deployer.deploy(RsaSha256Algorithm);
};
