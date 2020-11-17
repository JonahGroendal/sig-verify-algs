var RsaSha256Algorithm = artifacts.require("RsaSha256Algorithm");

module.exports = function(deployer, network) {
  deployer.deploy(RsaSha256Algorithm);
};
