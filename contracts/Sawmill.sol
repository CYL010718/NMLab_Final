pragma solidity >=0.4.21 <0.7.0;

import "./SafeMath.sol";
import "./BuildingFactory.sol";

contract SawmillFactory is BuildingFactory {
    
    using SafeMath for uint;
    
    Account accountInstance;
    constructor(address _account_address) public {
        accountInstance = Account(_account_address);
    }


    mapping (address => uint) public ownerWoodProduceTime;
    uint produceWoodAbility = 1;

    function createSawmill(uint _x, uint _y) public {
        _createBuilding(msg.sender, "Sawmill", _x, _y);
        _updateProduceWood(msg.sender);
    }


    function _updateProduceWood(address _owner) internal {
        uint[] memory sawmills = getSpecificBuildingByOwner(_owner, "Sawmill");
        if (ownerWoodProduceTime[_owner] == 0 || sawmills.length == 0) {
            ownerWoodProduceTime[_owner] = now;
            return;
        }
        uint periodCounts = (now - ownerWoodProduceTime[_owner]).div(10 seconds);
        uint produceAbilitySum = 0;
        for (uint i=0; i<sawmills.length; i++) {
            produceAbilitySum += buildings[sawmills[i]].level * produceWoodAbility;
        }
        accountInstance.setWoodOwnerCount(_owner,  accountInstance.getWoodOwnerCount(_owner) + periodCounts * produceAbilitySum);
        ownerWoodProduceTime[_owner] += 10 * periodCounts;
    }
}