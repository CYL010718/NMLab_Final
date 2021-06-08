pragma solidity >=0.4.21 <0.7.0;

import "./SafeMath.sol";
import "./BuildingFactory.sol";
import "./Soldier.sol";
import "./Spy.sol";
import "./Cannon.sol";
import "./Protector.sol";

contract Laboratory {
    
    using SafeMath for uint;
    
    // Account accountInstance;
    BuildingFactory buildingInstance;
    Soldier soldierInstance;
    Protector ProtectorInstance;
    Cannon CannonInstance;
    Spy SpyInstance;
    constructor(address _building_address, address _soldier_address, address _spy_instance, address _cannon_instance, address _protector_instance) public {
        buildingInstance = BuildingFactory(_building_address);
        soldierInstance = Soldier(_soldier_address);
        SpyInstance = Spy(_spy_instance);
        ProtectorInstance = Protector(_protector_instance);
        CannonInstance = Cannon(_cannon_instance);
    }
    
    mapping (address => uint) public ownerLabProduceTime;


    function createLaboratory(uint _x, uint _y) public {
        buildingInstance._createBuilding(msg.sender, "Laboratory", _x, _y);
        _updateLaboratory(msg.sender);
    }

    function _updateLaboratory(address _owner) public {
        uint[] memory labs = buildingInstance.getSpecificBuildingByOwner(_owner, "Laboratory");
        if (ownerLabProduceTime[_owner] == 0 || labs.length == 0) {
            ownerLabProduceTime[_owner] = now;
            return;
        }
        uint periodCounts = (now - ownerLabProduceTime[_owner]).div(10 seconds);
        // uint produceAbilitySum = 0;
        // for (uint i=0; i<farms.length; i++) {
        //     produceAbilitySum += buildingInstance.getBuildingLevel(labs[i]) * produceLabAbility;
        // }
        // accountInstance.setLabOwnerCount(_owner, accountInstance.getFoodOwnerCount(_owner) + periodCounts * produceAbilitySum);
        ownerLabProduceTime[_owner] += 10 * periodCounts;
    }

        function startUpgradeSoldier() public returns(uint) {
        address _owner = msg.sender;
        if(soldierInstance.ownerStartUpgradeTime(_owner) != 0) return uint(0); // check if there is already creating soldiers
        bool enoughResource;
        uint lvOfSoldier;
        enoughResource = soldierInstance._UpgradeSoldier(_owner);
        lvOfSoldier =  soldierInstance.levelOfSoldier(_owner);
        if(enoughResource == false) return uint(0);
        soldierInstance.setStartUpgradeTime(_owner, uint(now));
        soldierInstance.setUpgradeSoldierTime(_owner, soldierInstance.UpgradeSoldierTime() * lvOfSoldier);
        return soldierInstance.ownerUpgradeSoldierTime(_owner);
    }

    function getUpgradeSoldierTime() public view returns(uint, uint) {
        return ( now - soldierInstance.ownerStartUpgradeTime(msg.sender), soldierInstance.ownerUpgradeSoldierTime(msg.sender) ) ;
    }

    // // return 0 if success else return remaining time
    function updateUpgradeSoldier(address _owner) public returns(uint) {
        if (soldierInstance.ownerStartUpgradeTime(_owner) == 0) return 0;
        if (now >= soldierInstance.ownerStartUpgradeTime(_owner).add(soldierInstance.ownerUpgradeSoldierTime(_owner))) {
            uint num;
            num = soldierInstance.ownerUpgradeSoldierTime(_owner).div(  soldierInstance.levelOfSoldier(_owner).mul(soldierInstance.UpgradeSoldierTime()) );
            soldierInstance.setNumOfSoldier(_owner, soldierInstance.numOfSoldier(_owner) + (num));
            soldierInstance.setStartUpgradeTime(_owner, 0);
            soldierInstance.setUpgradeSoldierTime(_owner, 0);
            soldierInstance._updatePower(_owner);
            return 0;
        }
        else {
            uint remainingTime = (soldierInstance.ownerStartUpgradeTime(_owner) + soldierInstance.ownerUpgradeSoldierTime(_owner)).sub(now);
            return remainingTime;
        }
    }

    function startUpgradeProtector() public returns(uint) {
        address _owner = msg.sender;
        if(ProtectorInstance.ownerStartUpgradeTime(_owner) != 0) return uint(0); // check if there is already creating Protectors
        bool enoughResource;
        uint lvOfProtector;
        enoughResource = ProtectorInstance._UpgradeProtector(_owner);
        lvOfProtector =  ProtectorInstance.levelOfProtector(_owner);
        if(enoughResource == false) return uint(0);
        ProtectorInstance.setStartUpgradeTime(_owner, uint(now));
        ProtectorInstance.setUpgradeProtectorTime(_owner, ProtectorInstance.UpgradeProtectorTime() * lvOfProtector);
        return ProtectorInstance.ownerUpgradeProtectorTime(_owner);
    }

    function getUpgradeProtectorTime() public view returns(uint, uint) {
        return ( now - ProtectorInstance.ownerStartUpgradeTime(msg.sender), ProtectorInstance.ownerUpgradeProtectorTime(msg.sender) ) ;
    }

    // // return 0 if success else return remaining time
    function updateUpgradeProtector(address _owner) public returns(uint) {
        if (ProtectorInstance.ownerStartUpgradeTime(_owner) == 0) return 0;
        if (now >= ProtectorInstance.ownerStartUpgradeTime(_owner).add(ProtectorInstance.ownerUpgradeProtectorTime(_owner))) {
            uint num;
            num = ProtectorInstance.ownerUpgradeProtectorTime(_owner).div(  ProtectorInstance.levelOfProtector(_owner).mul(ProtectorInstance.UpgradeProtectorTime()) );
            ProtectorInstance.setNumOfProtector(_owner, ProtectorInstance.numOfProtector(_owner) + (num));
            ProtectorInstance.setStartUpgradeTime(_owner, 0);
            ProtectorInstance.setUpgradeProtectorTime(_owner, 0);
            ProtectorInstance._updateProtectorPower(_owner);
            return 0;
        }
        else {
            uint remainingTime = (ProtectorInstance.ownerStartUpgradeTime(_owner) + ProtectorInstance.ownerUpgradeProtectorTime(_owner)).sub(now);
            return remainingTime;
        }
    }

    function startUpgradeCannon() public returns(uint) {
        address _owner = msg.sender;
        if(CannonInstance.ownerStartUpgradeTime(_owner) != 0) return uint(0); // check if there is already creating Cannons
        bool enoughResource;
        uint lvOfCannon;
        enoughResource = CannonInstance._UpgradeCannon(_owner);
        lvOfCannon =  CannonInstance.levelOfCannon(_owner);
        if(enoughResource == false) return uint(0);
        CannonInstance.setStartUpgradeTime(_owner, uint(now));
        CannonInstance.setUpgradeCannonTime(_owner, CannonInstance.UpgradeCannonTime() * lvOfCannon);
        return CannonInstance.ownerUpgradeCannonTime(_owner);
    }

    function getUpgradeCannonTime() public view returns(uint, uint) {
        return ( now - CannonInstance.ownerStartUpgradeTime(msg.sender), CannonInstance.ownerUpgradeCannonTime(msg.sender) ) ;
    }

    // // return 0 if success else return remaining time
    function updateUpgradeCannon(address _owner) public returns(uint) {
        if (CannonInstance.ownerStartUpgradeTime(_owner) == 0) return 0;
        if (now >= CannonInstance.ownerStartUpgradeTime(_owner).add(CannonInstance.ownerUpgradeCannonTime(_owner))) {
            uint num;
            num = CannonInstance.ownerUpgradeCannonTime(_owner).div(  CannonInstance.levelOfCannon(_owner).mul(CannonInstance.UpgradeCannonTime()) );
            CannonInstance.setNumOfCannon(_owner, CannonInstance.numOfCannon(_owner) + (num));
            CannonInstance.setStartUpgradeTime(_owner, 0);
            CannonInstance.setUpgradeCannonTime(_owner, 0);
            CannonInstance._updateCannonPower(_owner);
            return 0;
        }
        else {
            uint remainingTime = (CannonInstance.ownerStartUpgradeTime(_owner) + CannonInstance.ownerUpgradeCannonTime(_owner)).sub(now);
            return remainingTime;
        }
    }

    function startUpgradeSpy() public returns(uint) {
        address _owner = msg.sender;
        if(SpyInstance.ownerStartUpgradeTime(_owner) != 0) return uint(0); // check if there is already creating Spys
        bool enoughResource;
        uint lvOfSpy;
        enoughResource = SpyInstance._UpgradeSpy(_owner);
        lvOfSpy =  SpyInstance.levelOfSpy(_owner);
        if(enoughResource == false) return uint(0);
        SpyInstance.setStartUpgradeTime(_owner, uint(now));
        SpyInstance.setUpgradeSpyTime(_owner, SpyInstance.UpgradeSpyTime() * lvOfSpy);
        return SpyInstance.ownerUpgradeSpyTime(_owner);
    }

    function getUpgradeSpyTime() public view returns(uint, uint) {
        return ( now - SpyInstance.ownerStartUpgradeTime(msg.sender), SpyInstance.ownerUpgradeSpyTime(msg.sender) ) ;
    }

    // // return 0 if success else return remaining time
    function updateUpgradeSpy(address _owner) public returns(uint) {
        if (SpyInstance.ownerStartUpgradeTime(_owner) == 0) return 0;
        if (now >= SpyInstance.ownerStartUpgradeTime(_owner).add(SpyInstance.ownerUpgradeSpyTime(_owner))) {
            uint num;
            num = SpyInstance.ownerUpgradeSpyTime(_owner).div(  SpyInstance.levelOfSpy(_owner).mul(SpyInstance.UpgradeSpyTime()) );
            SpyInstance.setNumOfSpy(_owner, SpyInstance.numOfSpy(_owner) + (num));
            SpyInstance.setStartUpgradeTime(_owner, 0);
            SpyInstance.setUpgradeSpyTime(_owner, 0);
            SpyInstance._updateSpyPower(_owner);
            return 0;
        }
        else {
            uint remainingTime = (SpyInstance.ownerStartUpgradeTime(_owner) + SpyInstance.ownerUpgradeSpyTime(_owner)).sub(now);
            return remainingTime;
        }
    }

    function getSoldierLevel(address _owner) public view return(uint) {
        return SoldierInstance.levelOfSoldier(_owner);
    }

    function getProtectorLevel(address _owner) public view return(uint) {
        return ProtectorInstance.levelOfProtector(_owner);
    }

    function getCannonLevel(address _owner) public view return(uint) {
        return CannonInstance.levelOfCannon(_owner);
    }

    function getSpyLevel(address _owner) public view return(uint) {
        return SpyInstance.levelOfSpy(_owner);
    }
}