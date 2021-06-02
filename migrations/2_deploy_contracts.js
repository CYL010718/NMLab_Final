var Soldier = artifacts.require("./Soldier.sol")
var Spy = artifacts.require("./Spy.sol")
var Account = artifacts.require("./Account.sol")
var BuildingFactory = artifacts.require("./BuildingFactory.sol")
// var Produce = artifacts.require("./Produce.sol")
// var Barrack = artifacts.require("./Barrack.sol")
// var Laboratory = artifacts.require("./Laboratory.sol")
var FarmFactory = artifacts.require("./FarmFactory.sol")
var Sawmill = artifacts.require("./Sawmill.sol")
var Mine = artifacts.require("./Mine.sol")



module.exports = function(deployer) {
  deployer.deploy(Account).then(function() {
    return deployer.deploy(Soldier, Account.address).then(function() {
      return deployer.deploy(Spy, Account.address).then(function() {
        return deployer.deploy(BuildingFactory, Account.address).then(function() {
          return deployer.deploy(FarmFactory, Account.address, BuildingFactory.address).then(function() {
            return deployer.deploy(Sawmill, Account.address, BuildingFactory.address).then(function() {
              return deployer.deploy(Mine, Account.address, BuildingFactory.address).then(function() {
                return deployer.deploy(Manor, Account.address, BuildingFactory.address)
              });
            });
          });
        });
      });
    });
  });
};