pragma solidity >=0.4.21 <0.7.0;

import "./SafeMath.sol";
import "./BuildingFactory.sol";

contract Quarry {
    
    using SafeMath for uint;

    Account accountInstance;
    BuildingFactory buildingInstance;
    constructor(address _account_address, address _building_address) public {
        accountInstance = Account(_account_address);
        buildingInstance = BuildingFactory(_building_address);
    }
    
    mapping (address => uint) public ownerStoneProduceTime;
    uint produceStoneAbility = 1;


    function createQuarry(uint _x, uint _y) public {
        buildingInstance._createBuilding(msg.sender, "Quarry", _x, _y);
        _updateProduceStone(msg.sender);
    }

    
    function _updateProduceStone(address _owner) public {
        uint[] memory quarries = buildingInstance.getSpecificBuildingByOwner(_owner, "Quarry");
        if (ownerStoneProduceTime[_owner] == 0 || quarries.length == 0) {
            ownerStoneProduceTime[_owner] = now;
            return;
        }
        uint periodCounts = (now - ownerStoneProduceTime[_owner]).div(10 seconds);
        uint produceAbilitySum = 0;
        for (uint i=0; i<quarries.length; i++) {
            produceAbilitySum += buildingInstance.getBuildingLevel(quarries[i]) * produceStoneAbility;
        }
        accountInstance.setStoneOwnerCount(_owner, accountInstance.getStoneOwnerCount(_owner) + periodCounts * produceAbilitySum);
        ownerStoneProduceTime[_owner] += 10 * periodCounts;
        // while (now > ownerStoneProduceTime[_owner].add(10 seconds)) { //too slow
        //     for (uint i = 0; i < quarries.length; i++) {
        //         stoneOwnerCount[_owner] = stoneOwnerCount[_owner].add(buildings[quarries[i]].level * produceStoneAbility ); //cost too much
        //     }
        //     ownerStoneProduceTime[_owner] = ownerStoneProduceTime[_owner].add(10 seconds);
        // }
    }
}