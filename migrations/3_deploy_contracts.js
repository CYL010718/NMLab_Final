var LabFactory = artifacts.require("./Laboratory.sol")

module.exports = function(deployer) {
  deployer.deploy(LabFactory);
};