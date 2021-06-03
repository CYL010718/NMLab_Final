pragma solidity >=0.4.21 <0.7.0;

import "./SafeMath.sol";
import "./BuildingFactory.sol";

contract MineFactory {
    
    using SafeMath for uint;

    Account accountInstance;
    BuildingFactory buildingInstance;
    constructor(address _account_address, address _building_address) public {
        accountInstance = Account(_account_address);
        buildingInstance = BuildingFactory(_building_address);
    }
    
    mapping (address => uint) public ownerIronProduceTime;
    uint produceIronAbility = 1;

    function createMine(uint _x, uint _y) public {
        buildingInstance._createBuilding(msg.sender, "Mine", _x, _y);
        _updateProduceIron(msg.sender);
    }


    function _updateProduceIron(address _owner) internal {
        uint[] memory mines = buildingInstance.getSpecificBuildingByOwner(_owner, "Mine");
        if (ownerIronProduceTime[_owner] == 0 || mines.length == 0) {
            ownerIronProduceTime[_owner] = now;
            return;
        }
        uint periodCounts = (now - ownerIronProduceTime[_owner]).div(10 seconds);
        uint produceAbilitySum = 0;
        for (uint i=0; i<mines.length; i++) {
            produceAbilitySum += buildingInstance.getBuildingLevel(mines[i]) * produceIronAbility;
        }
        accountInstance.setIronOwnerCount(_owner, accountInstance.getIronOwnerCount(_owner) + periodCounts * produceAbilitySum);
        ownerIronProduceTime[_owner] += 10 * periodCounts;
    }
}