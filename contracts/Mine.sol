pragma solidity >=0.4.21 <0.7.0;

import "./SafeMath.sol";
import "./Castle.sol";

contract MineFactory is CastleFactory {
    
    using SafeMath for uint;
    
    mapping (address => uint) public ownerIronProduceTime;
    uint produceIronAbility = 1;

    function createMine(uint _x, uint _y) public {
        _createBuilding(msg.sender, "Mine", _x, _y);
        _updateProduceIron(msg.sender);
    }


    function _updateProduceIron(address _owner) internal {
        uint[] memory mines = getSpecificBuildingByOwner(_owner, "Mine");
        if (ownerIronProduceTime[_owner] == 0 || mines.length == 0) {
            ownerIronProduceTime[_owner] = now;
            return;
        }
        uint periodCounts = (now - ownerIronProduceTime[_owner]).div(10 seconds);
        uint produceAbilitySum = 0;
        for (uint i=0; i<mines.length; i++) {
            produceAbilitySum += buildings[mines[i]].level * produceIronAbility;
        }
        ironOwnerCount[_owner] += periodCounts * produceAbilitySum;
        ownerIronProduceTime[_owner] += 10 * periodCounts;
    }
}