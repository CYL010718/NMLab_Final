var Produce = artifacts.require("./Produce.sol")
var Account = artifacts.require("./Account.sol")

module.exports = function(deployer) {
    deployer.deploy(Account).then(function() {
        return deployer.deploy(Produce, Account.address);
      });
};