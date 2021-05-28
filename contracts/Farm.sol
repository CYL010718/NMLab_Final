pragma solidity >=0.4.21 <0.7.0;

import "./SafeMath.sol";
import "./Castle.sol";

contract FarmFactory is CastleFactory {
    
    using SafeMath for uint;
    
    mapping (address => uint) public ownerFoodProduceTime;
    uint produceFoodAbility = 1;

    function createFarm(uint _x, uint _y) public {
        _createBuilding(msg.sender, "Farm", _x, _y);
        _updateProduceFood(msg.sender);
    }


    function _updateProduceFood(address _owner) internal {
        uint[] memory farms = getSpecificBuildingByOwner(_owner, "Farm");
        if (ownerFoodProduceTime[_owner] == 0 || farms.length == 0) {
            ownerFoodProduceTime[_owner] = now;
            return;
        }
        uint periodCounts = (now - ownerFoodProduceTime[_owner]).div(10 seconds);
        uint produceAbilitySum = 0;
        for (uint i=0; i<farms.length; i++) {
            produceAbilitySum += buildings[farms[i]].level * produceFoodAbility;
        }
        foodOwnerCount[_owner] += periodCounts * produceAbilitySum;
        ownerFoodProduceTime[_owner] += 10 * periodCounts;
    }

}