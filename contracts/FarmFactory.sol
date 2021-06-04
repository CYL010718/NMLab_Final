pragma solidity >=0.4.21 <0.7.0;

import "./SafeMath.sol";
import "./BuildingFactory.sol";

contract FarmFactory {

    using SafeMath for uint;

    Account accountInstance;
    BuildingFactory buildingInstance;
    constructor(address _account_address, address _building_address) public {
        accountInstance = Account(_account_address);
        buildingInstance = BuildingFactory(_building_address);
    }
    
    mapping (address => uint) public ownerFoodProduceTime;
    uint produceFoodAbility = 1;

    function createFarm(uint _x, uint _y) public {
        buildingInstance._createBuilding(msg.sender, "Farm", _x, _y);
        _updateProduceFood(msg.sender);
    }


    function _updateProduceFood(address _owner) public {
        uint[] memory farms = buildingInstance.getSpecificBuildingByOwner(_owner, "Farm");
        if (ownerFoodProduceTime[_owner] == 0 || farms.length == 0) {
            ownerFoodProduceTime[_owner] = now;
            return;
        }
        uint periodCounts = (now - ownerFoodProduceTime[_owner]).div(10 seconds);
        uint produceAbilitySum = 0;
        for (uint i=0; i<farms.length; i++) {
            produceAbilitySum += buildingInstance.getBuildingLevel(farms[i]) * produceFoodAbility;
        }
        accountInstance.setFoodOwnerCount(_owner, accountInstance.getFoodOwnerCount(_owner) + periodCounts * produceAbilitySum);
        ownerFoodProduceTime[_owner] += 10 * periodCounts;
    }

}