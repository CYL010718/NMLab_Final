pragma solidity >=0.4.21 <0.7.0;

import "./SafeMath.sol";
import "./BuildingFactory.sol";
import "./Soldier.sol";

contract Barrack is BuildingFactory, Soldier {
    
    using SafeMath for uint;
    using SafeMath for uint;

    function createBarrack(uint _x, uint _y) public {
        _createBuilding(msg.sender, "Barrack", _x, _y);
        levelOfSoldier[msg.sender] = 1;
    }

    // return 0 if failed (maybe already creating or not enough resource) otherwise return createtime
    function startCreateSoldier(uint number) public returns(uint) {
        address _owner = msg.sender;
        if(ownerStartCreateTime[_owner] != 0) return uint(0); // check if there is already creating soldiers
        bool enoughResource;
        uint lvOfSoldier;
        enoughResource = _createSoldier(_owner, number);
        lvOfSoldier =  levelOfSoldier[_owner];
        if(enoughResource == false) return uint(0);
        ownerStartCreateTime[_owner] = uint(now);
        ownerCreateSoldierTime[_owner] = createSoldierTime * lvOfSoldier * number;
        return ownerCreateSoldierTime[_owner];
    }

    function getCreateSoldierTime() public view returns(uint, uint) {
        return ( now - ownerStartCreateTime[msg.sender], ownerCreateSoldierTime[msg.sender] ) ;
    }

    // // return 0 if success else return remaining time
    function updateCreateSoldier(address _owner) public returns(uint) {
        if (ownerStartCreateTime[_owner] == 0) return 0;
        if (now >= ownerStartCreateTime[_owner].add(ownerCreateSoldierTime[_owner])) {
            uint num;
            num = ownerCreateSoldierTime[_owner].div(  levelOfSoldier[_owner].mul(createSoldierTime) );
            numOfSoldier[_owner] = numOfSoldier[_owner] + (num);
            ownerStartCreateTime[_owner] = 0;
            ownerCreateSoldierTime[_owner] = 0;
            _updatePower(_owner);
            return 0;
        }
        else {
            uint remainingTime = (ownerStartCreateTime[_owner] + ownerCreateSoldierTime[_owner]).sub(now);
            return remainingTime;
        }
    }

    // // return 0 if failed (maybe already creating or not enough resource) otherwise return leveluptime
    // function startLevelUpSoldier(string memory _name) public returns(uint) {
    //     address _owner = msg.sender;
    //     if (ownerStartLevelUpTime[_owner] != 0) return uint(0);// check if there is already leveling up soldiers
    //     bool enoughResource;
    //     uint levelOfSoldier;
    //     uint numOfSoldier;
    //     if (keccak256(bytes(_name)) == keccak256(bytes("Cavalry"))) {
    //         enoughResource = _upgradeCavalry(_owner);
    //         _name = "Cavalry";
    //         levelOfSoldier = levelOfCavalry[_owner];
    //         numOfSoldier = numOfCavalry[_owner];
    //     }
    //     // else if (keccak256(bytes(_name)) == keccak256(bytes("Pikemen"))) {
    //     //     enoughResource = _upgradePikemen(_owner);
    //     //     _name = "Pikemen";
    //     //     levelOfSoldier = levelOfPikemen[_owner];
    //     //     numOfSoldier = numOfPikemen[_owner];
    //     // }
    //     // else if (keccak256(bytes(_name)) == keccak256(bytes("Infantry"))) {
    //     //     enoughResource = _upgradeInfantry(_owner);
    //     //     _name = "Infantry";
    //     //     levelOfSoldier = levelOfInfantry[_owner];
    //     //     numOfSoldier = numOfInfantry[_owner];
    //     // }
    //     // else if (keccak256(bytes(_name)) == keccak256(bytes("Archer"))) {
    //     //     enoughResource = _upgradeArcher(_owner);
    //     //     _name = "Archer";
    //     //     levelOfSoldier = levelOfArcher[_owner];
    //     //     numOfSoldier = numOfArcher[_owner];
    //     // }
    //     if(enoughResource == false) return uint(0);
    //     ownerStartLevelUpTime[_owner] = now;
    //     return levelUpSoldierTime * numOfSoldier * uint(levelOfSoldier);
    // }

    // function updateLevelUpSoldier(string memory _name, address _owner) public returns(uint) {
    //     if (ownerStartLevelUpTime[_owner] == 0) return 0;
    //     uint levelOfSoldier;
    //     uint numOfSoldier;
    //     if (keccak256(bytes(_name)) == keccak256(bytes("Cavalry"))) {
    //         levelOfSoldier = levelOfCavalry[_owner];
    //         numOfSoldier = numOfCavalry[_owner];
    //     }
    //     // else if (keccak256(bytes(_name)) == keccak256(bytes("Pikemen"))) {
    //     //     levelOfSoldier = levelOfPikemen[_owner];
    //     //     numOfSoldier = numOfPikemen[_owner];
    //     // }
    //     // else if (keccak256(bytes(_name)) == keccak256(bytes("Infantry"))) {
    //     //     levelOfSoldier = levelOfInfantry[_owner];
    //     //     numOfSoldier = numOfInfantry[_owner];
    //     // }
    //     // else if (keccak256(bytes(_name)) == keccak256(bytes("Archer"))) {
    //     //     levelOfSoldier = levelOfArcher[_owner];
    //     //     numOfSoldier = numOfArcher[_owner];
    //     // }
    //     if (now >= ownerStartLevelUpTime[_owner].add(levelUpSoldierTime * numOfSoldier * uint(levelOfSoldier))) {
    //         if (keccak256(bytes(_name)) == keccak256(bytes("Cavalry"))) {
    //             levelOfCavalry[_owner]++;
    //         }
    //         else if (keccak256(bytes(_name)) == keccak256(bytes("Pikemen"))) {
    //             levelOfPikemen[_owner]++;
    //         }
    //         else if (keccak256(bytes(_name)) == keccak256(bytes("Infantry"))) {
    //             levelOfInfantry[_owner]++;
    //         }
    //         else if (keccak256(bytes(_name)) == keccak256(bytes("Archer"))) {
    //             levelOfArcher[_owner]++;
    //         }
    //         ownerStartLevelUpTime[_owner] = 0;
    //         _updatePower(_owner);
    //         return 0;
    //     }
    //     else {
    //         uint remainingTime = levelUpSoldierTime * numOfSoldier * uint(levelOfSoldier) + ownerStartLevelUpTime[_owner] - now;
    //         return remainingTime;
    //     }
    // }
}