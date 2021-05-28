pragma solidity >=0.4.21 <0.7.0;

import "./SafeMath.sol";
import "./Castle.sol";

contract QuarryFactory is CastleFactory {
    
    using SafeMath for uint;
    
    mapping (address => uint) public ownerStoneProduceTime;
    uint produceStoneAbility = 1;


    function createQuarry(uint _x, uint _y) public {
        _createBuilding(msg.sender, "Quarry", _x, _y);
        _updateProduceStone(msg.sender);
    }

    
    function _updateProduceStone(address _owner) internal {
        uint[] memory quarries = getSpecificBuildingByOwner(_owner, "Quarry");
        if (ownerStoneProduceTime[_owner] == 0 || quarries.length == 0) {
            ownerStoneProduceTime[_owner] = now;
            return;
        }
        uint periodCounts = (now - ownerStoneProduceTime[_owner]).div(10 seconds);
        uint produceAbilitySum = 0;
        for (uint i=0; i<quarries.length; i++) {
            produceAbilitySum += buildings[quarries[i]].level * produceStoneAbility;
        }
        stoneOwnerCount[_owner] += periodCounts * produceAbilitySum;
        ownerStoneProduceTime[_owner] += 10 * periodCounts;
        // while (now > ownerStoneProduceTime[_owner].add(10 seconds)) { //too slow
        //     for (uint i = 0; i < quarries.length; i++) {
        //         stoneOwnerCount[_owner] = stoneOwnerCount[_owner].add(buildings[quarries[i]].level * produceStoneAbility ); //cost too much
        //     }
        //     ownerStoneProduceTime[_owner] = ownerStoneProduceTime[_owner].add(10 seconds);
        // }
    }
}