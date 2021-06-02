var Soldier = artifacts.require("./Soldier.sol")
var Barrack = artifacts.require("./Barrack.sol")
var Account = artifacts.require("./Account.sol")

module.exports = function(deployer) {
  
  deployer.deploy(Account).then(function() {
    return deployer.deploy(Soldier, Account.address);
  });
  
};