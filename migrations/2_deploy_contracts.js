var BarrackFactory = artifacts.require("./Barrack.sol")

module.exports = function(deployer) {
  deployer.deploy(BarrackFactory);
};