pragma solidity >=0.4.21 <0.7.0;

import "./SafeMath.sol";
import "./BuildingFactory.sol";

contract ManorFactory {
    
    using SafeMath for uint;

    Account accountInstance;
    BuildingFactory buildingInstance;
    constructor(address _account_address, address _building_address) public {
        accountInstance = Account(_account_address);
        buildingInstance = BuildingFactory(_building_address);
    }
    
    mapping (address => uint) public ownerCoinProduceTime;
    uint produceCoinAbility = 1;

    function createManor(uint _x, uint _y) public {
        buildingInstance._createBuilding(msg.sender, "Manor", _x, _y);
        _updateProduceCoin(msg.sender);
    }


    function _updateProduceCoin(address _owner) internal {
        uint[] memory manors = buildingInstance.getSpecificBuildingByOwner(_owner, "Manor");
        if (ownerCoinProduceTime[_owner] == 0 || manors.length == 0) {
            ownerCoinProduceTime[_owner] = now;
            return;
        }
        uint periodCounts = (now - ownerCoinProduceTime[_owner]).div(10 seconds);
        uint produceAbilitySum = 0;
        for (uint i=0; i<manors.length; i++) {
            produceAbilitySum += buildingInstance.getBuildingLevel(manors[i]) * produceCoinAbility;
        }
        accountInstance.setCoinOwnerCount(_owner,  accountInstance.getCoinOwnerCount(_owner) + periodCounts * produceAbilitySum);
        ownerCoinProduceTime[_owner] += 10 * periodCounts;
    }
}