var Soldier = artifacts.require("./Soldier.sol")
var Spy = artifacts.require("./Spy.sol")
var Account = artifacts.require("./Account.sol")
var BuildingFactory = artifacts.require("./BuildingFactory.sol")
var CastleFactory = artifacts.require("./CastleFactory.sol")
// var FarmFactory = artifacts.require("./Farm.sol")
var Produce = artifacts.require("./Produce.sol")

module.exports = function(deployer) {
  
  deployer.deploy(Account).then(function() {
    return deployer.deploy(Soldier, Account.address).then(function() {
      return deployer.deploy(Spy, Account.address).then(function() {
        return deployer.deploy(BuildingFactory, Account.address).then(function() {
          return deployer.deploy(CastleFactory, Account.address)
        });
      });
    });
  });
  
};