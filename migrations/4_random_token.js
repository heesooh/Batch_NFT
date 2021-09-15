const RandomToken = artifacts.require("RandomToken");

module.exports = function(deployer) {
  deployer.deploy(RandomToken);
};
