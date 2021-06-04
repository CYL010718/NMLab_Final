pragma solidity >=0.4.21 <0.7.0;

import "./SafeMath.sol";
import "./BuildingFactory.sol";

contract Sawmill {
    
    using SafeMath for uint;
    
    Account accountInstance;
    BuildingFactory buildingInstance;
    constructor(address _account_address, address _building_address) public {
        accountInstance = Account(_account_address);
        buildingInstance = BuildingFactory(_building_address);
    }


    mapping (address => uint) public ownerWoodProduceTime;
    uint produceWoodAbility = 1;

    function createSawmill(uint _x, uint _y) public {
        buildingInstance._createBuilding(msg.sender, "Sawmill", _x, _y);
        _updateProduceWood(msg.sender);
    }


    function _updateProduceWood(address _owner) public {
        uint[] memory sawmills = buildingInstance.getSpecificBuildingByOwner(_owner, "Sawmill");
        if (ownerWoodProduceTime[_owner] == 0 || sawmills.length == 0) {
            ownerWoodProduceTime[_owner] = now;
            return;
        }
        uint periodCounts = (now - ownerWoodProduceTime[_owner]).div(10 seconds);
        uint produceAbilitySum = 0;
        for (uint i=0; i<sawmills.length; i++) {
            produceAbilitySum += buildingInstance.getBuildingLevel(sawmills[i]) * produceWoodAbility;
        }
        accountInstance.setWoodOwnerCount(_owner,  accountInstance.getWoodOwnerCount(_owner) + periodCounts * produceAbilitySum);
        ownerWoodProduceTime[_owner] += 10 * periodCounts;
    }
}