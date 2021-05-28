pragma solidity >=0.4.21 <0.7.0;

import "./SafeMath.sol";
import "./Account.sol";

contract BuildingFactory is Account {
    
    using SafeMath for uint;
    
    struct Building {
        string name;
        uint placeX;
        uint placeY;
        uint level;
    }

    uint buildTimeNeed = 10;
    Building[] public buildings;
    uint buildResourceNeed = 100;

    mapping (uint => address) public buildingToOwner;
    mapping (address => uint) ownerStartBuildTime;
    mapping (address => uint) ownerBuildingId; //the building that is building
    mapping (address => uint) castleLevel;

    mapping (address => uint) ownerFarmCount;
    mapping (address => uint) ownerMineCount;
    mapping (address => uint) ownerManorCount;
    mapping (address => uint) ownerQuarryCount;
    mapping (address => uint) ownerSawmillCount;
    mapping (address => uint) ownerCellarCount;
    mapping (address => uint) ownerBarrackCount;


    function _createBuilding(address _creator, string memory _name, uint _x, uint _y) internal returns(uint){
        if(buildings.length == 0) {
            buildings.push(Building("first_building!", 0, 0, 1000));
            buildingToOwner[0] = address(0);
        }
        uint id = buildings.push(Building(_name, _x, _y, 1)).sub(1);
        _cost(_creator, 0, buildResourceNeed, buildResourceNeed, buildResourceNeed, buildResourceNeed);
        buildingToOwner[id] = _creator;
        if (keccak256(bytes(_name)) == keccak256(bytes("Farm"))) {
            ownerFarmCount[_creator] = ownerFarmCount[_creator].add(1);
        }
        else if (keccak256(bytes(_name)) == keccak256(bytes("Mine"))) {
            ownerMineCount[_creator] = ownerMineCount[_creator].add(1);
        }
        else if (keccak256(bytes(_name)) == keccak256(bytes("Manor"))) {
            ownerManorCount[_creator] = ownerManorCount[_creator].add(1);
        }
        else if (keccak256(bytes(_name)) == keccak256(bytes("Quarry"))) {
            ownerQuarryCount[_creator] = ownerQuarryCount[_creator].add(1);
        }
        else if (keccak256(bytes(_name)) == keccak256(bytes("Sawmill"))) {
            ownerSawmillCount[_creator] = ownerSawmillCount[_creator].add(1);
        }
        else if (keccak256(bytes(_name)) == keccak256(bytes("Cellar"))) {
            ownerCellarCount[_creator] = ownerCellarCount[_creator].add(1);
        }
        else if (keccak256(bytes(_name)) == keccak256(bytes("Barrack"))) {
            ownerBarrackCount[_creator] = ownerBarrackCount[_creator].add(1);
        }
        return id;
    }

    function startBuild(address _owner, uint _x, uint _y) public returns(uint){
        uint buildingID;
        (buildingID,) = getBuildingByOwner(_owner, _x, _y);
        if(buildingID == 0) return 0;
        if (keccak256(bytes(buildings[buildingID].name)) != keccak256(bytes("Castle"))) {
            // require(castleLevel[_owner] >= buildings[buildingID].level.add(1));
        }
        if(ownerStartBuildTime[_owner] != 0)  return 0;
        ownerBuildingId[_owner] = buildingID;
        ownerStartBuildTime[_owner] = now;
        uint buildingResourceNeed = buildings[buildingID].level * buildResourceNeed;
        _cost(_owner, 0, buildingResourceNeed, buildingResourceNeed, buildingResourceNeed, buildingResourceNeed);
        return buildings[buildingID].level * buildTimeNeed;
    }

    function getRemainingTime(address _owner) public view returns(uint) {
        uint buildingID = ownerBuildingId[_owner];
        if (ownerStartBuildTime[_owner] != 0 && now >= ownerStartBuildTime[_owner] + buildings[buildingID].level * buildTimeNeed) {
            return 0;
        }
        else {
            uint remainingTime = ownerStartBuildTime[_owner] + buildings[buildingID].level * buildTimeNeed - now;
            return remainingTime;
        }
    }

    function getUpgradingId(address _owner) public view returns(uint) {
        return ownerBuildingId[_owner];
    }
    
    function updateBuild(address _owner) public returns(uint){
        uint buildingID = ownerBuildingId[_owner];
        if (ownerStartBuildTime[_owner] != 0 && now >= ownerStartBuildTime[_owner] + buildings[buildingID].level * buildTimeNeed) {
            buildings[buildingID].level = buildings[buildingID].level.add(1);
            ownerStartBuildTime[_owner] = 0;
            ownerBuildingId[_owner] = 0;
            return 0;
        }
        else {
            uint remainingTime = ownerStartBuildTime[_owner] + buildings[buildingID].level * buildTimeNeed - now;
            return remainingTime;
        }
    }

    function getBuildingById(uint idx) public view returns(bool, string memory, uint) {
        if(idx >= buildings.length) {
            return (false, "invalid building id", 0);
        }
        else {
            return (true, buildings[idx].name, buildings[idx].level);
        }
    }

    function getBuildingsLen() public view returns(uint) {
        return buildings.length;
    }

    function getBuildingByOwner(address _owner, uint _placeX, uint _placeY) public view returns(uint, string memory) {
        uint i = 0;
        for (i; i < buildings.length; i++) {
            if (buildingToOwner[i] == _owner) {
                if (buildings[i].placeX == _placeX && buildings[i].placeY == _placeY) {
                    return (i, buildings[i].name);
                }
            }
        }
        return (0, "None");
    }

    function getBuildingsByOwner(address _owner) public view returns(uint[] memory) {
        uint[] memory result = new uint[](ownerFarmCount[_owner] + ownerMineCount[_owner] + ownerManorCount[_owner] + ownerQuarryCount[_owner] + ownerSawmillCount[_owner] + ownerCellarCount[_owner] + ownerBarrackCount[_owner]);
        uint counter = 0;
        for (uint i = 0; i < buildings.length; i++) {
            if (buildingToOwner[i] == _owner) {
                result[counter] = i;
                counter = counter.add(1);
            }
        }
        return result;
    }

    function getSpecificBuildingByOwner(address _owner, string memory _name) public view returns(uint[] memory) {
        uint buildingsLength = 0;
        if (keccak256(bytes(_name)) == keccak256(bytes("Farm"))) {
           buildingsLength = ownerFarmCount[_owner];
        }
        else if (keccak256(bytes(_name)) == keccak256(bytes("Mine"))) {
            buildingsLength = ownerMineCount[_owner];
        }
        else if (keccak256(bytes(_name)) == keccak256(bytes("Manor"))) {
            buildingsLength = ownerManorCount[_owner];
        }
        else if (keccak256(bytes(_name)) == keccak256(bytes("Quarry"))) {
            buildingsLength = ownerQuarryCount[_owner];
        }
        else if (keccak256(bytes(_name)) == keccak256(bytes("Sawmill"))) {
            buildingsLength = ownerSawmillCount[_owner];
        }
        else if (keccak256(bytes(_name)) == keccak256(bytes("Cellar"))) {
            buildingsLength = ownerCellarCount[_owner];
        }
        else if (keccak256(bytes(_name)) == keccak256(bytes("Barrack"))) {
            buildingsLength = ownerBarrackCount[_owner];
        }
        uint[] memory result = new uint[](buildingsLength);
        // result.push(0);
        uint counter = 0;
        for (uint i = 0; i < buildings.length; i++) {
            if (buildingToOwner[i] == _owner && keccak256(bytes(buildings[i].name)) == keccak256(bytes(_name))) {
                result[counter] = i;
                counter = counter.add(1);
            }
        }
        return result;
    }
    
}