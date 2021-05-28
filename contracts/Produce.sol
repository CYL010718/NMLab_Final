pragma solidity >=0.4.21 <0.7.0;

import "./SafeMath.sol";
import "./Quarry.sol";
import "./Mine.sol";
import "./Farm.sol";
import "./Manor.sol";
import "./Sawmill.sol";
import "./Soldier.sol";
import "./Barrack.sol";

contract Produce is QuarryFactory, MineFactory, FarmFactory, ManorFactory, SawmillFactory, Barrack {

    function updateProduce(address _owner) public {
        _updateProduceCoin(_owner);
        _updateProduceIron(_owner);
        _updateProduceFood(_owner);
        _updateProduceStone(_owner);
        _updateProduceWood(_owner);
    }

}