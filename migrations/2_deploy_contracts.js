var Soldier = artifacts.require("./Soldier.sol")
var Barrack = artifacts.require("./Barrack.sol")
var Account = artifacts.require("./Account.sol")
var Produce = artifacts.require("./Produce.sol")
var BuildingFactory = artifacts.require("./BuildingFactory.sol")

module.exports = function(deployer) {
  //deployer.deploy(Barrack);
  //deployer.deploy(Produce);
  
  deployer.deploy(Account).then(function() {
    return deployer.deploy(Soldier, Account.address).then(function() {
      return deployer.deploy(BuildingFactory, Account.address).then(function() {
        return deployer.deploy(Barrack, Account.address)
      });
    });
  });
  
};