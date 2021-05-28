pragma solidity >=0.4.21 <0.7.0;

import "./SafeMath.sol";
import "./Castle.sol";

contract ManorFactory is CastleFactory {
    
    using SafeMath for uint;
    
    mapping (address => uint) public ownerCoinProduceTime;
    uint produceCoinAbility = 1;

    function createManor(uint _x, uint _y) public {
        _createBuilding(msg.sender, "Manor", _x, _y);
        _updateProduceCoin(msg.sender);
    }


    function _updateProduceCoin(address _owner) internal {
        uint[] memory manors = getSpecificBuildingByOwner(_owner, "Manor");
        if (ownerCoinProduceTime[_owner] == 0 || manors.length == 0) {
            ownerCoinProduceTime[_owner] = now;
            return;
        }
        uint periodCounts = (now - ownerCoinProduceTime[_owner]).div(10 seconds);
        uint produceAbilitySum = 0;
        for (uint i=0; i<manors.length; i++) {
            produceAbilitySum += buildings[manors[i]].level * produceCoinAbility;
        }
        coinOwnerCount[_owner] += periodCounts * produceAbilitySum;
        ownerCoinProduceTime[_owner] += 10 * periodCounts;
    }
}