const BatchTransfer = artifacts.require("BatchTransfer");

module.exports = function(deployer) {
  deployer.deploy(BatchTransfer);
};
