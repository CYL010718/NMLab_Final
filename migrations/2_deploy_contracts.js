var BulidingFactory = artifacts.require("./BuildingFactory.sol")
var Account = artifacts.require("./Account.sol")

module.exports = function(deployer) {
  deployer.deploy(Account).then(function() {
    return deployer.deploy(BulidingFactory, Account.address);
  });
};