pragma solidity >=0.4.21 <0.7.0;

import "./SafeMath.sol";
import "./BuildingFactory.sol";

contract QuarryFactory is BuildingFactory {
    
    using SafeMath for uint;

    //Account accountInstance;
    constructor(address _account_address) public {
        accountInstance = Account(_account_address);
    }
    
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