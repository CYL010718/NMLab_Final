pragma solidity >=0.4.21 <0.7.0;

import "./SafeMath.sol";

contract Account {
    using SafeMath for uint;

    mapping (address => uint) public stoneOwnerCount;
    mapping (address => uint) public ironOwnerCount;
    mapping (address => uint) public foodOwnerCount;
    mapping (address => uint) public coinOwnerCount;
    mapping (address => uint) public woodOwnerCount;
    mapping (address => uint) public power;
    mapping (address => uint) public health;
    mapping (address => uint) public spyPower;
    mapping (address => uint) public cannonPower;
    mapping (address => uint) public soldierPower;
    mapping (address => uint) public protectorPower;
    mapping (address => uint) public wallPower;

    uint public kingdomAmount;

    mapping (uint => address) public castleToOwner;
    mapping (address => uint) public ownerCastleCount;

    mapping (address => bool) public ownerIsAttacked;
    mapping (address => address) public ownerAttackerAddress;
    mapping (address => uint) public ownerAttackStartTime;
    mapping (address => uint) public ownerAttackTotalTime;



    uint IdDigits = 16;
    uint IdModulus = 10 ** IdDigits;

    function setAttackedInfo(address _attacked, bool _isAttack, address _attacker, uint _attackstarttime, uint _attacktotaltime) public {
        ownerIsAttacked[_attacked] = _isAttack;
        ownerAttackerAddress[_attacked] = _attacker;
        ownerAttackStartTime[_attacked] = _attackstarttime;
        ownerAttackTotalTime[_attacked] = _attacktotaltime;
    }

    function getMarchTime(address _owner) public view returns(uint, uint, uint) {
        return ( ownerAttackStartTime[_owner], uint(now) - ownerAttackStartTime[_owner], ownerAttackTotalTime[_owner] ) ;
    }

    function getAttackerInfo(address _owner) public returns(bool,address) {
        return (ownerIsAttacked[_owner], ownerAttackerAddress[_owner]);
    }

    // // return 0 if success else return remaining time
    function updateMarch(address _owner) public returns(uint) {
        if (ownerAttackStartTime[_owner] == 0) return 0;
        if (uint(now) >= ownerAttackStartTime[_owner].add(ownerAttackTotalTime[_owner])) {
            // uint num;
            // num = ownerTotalMarchTime[_owner].div(  MarchInstance.levelOfMarch(_owner).mul(MarchInstance.createMarchTime()) );
            // MarchInstance.setNumOfMarch(_owner, MarchInstance.numOfMarch(_owner) + (num));
            ownerIsAttacked[_owner] = false;
            ownerAttackerAddress[_owner] = _owner;
            ownerAttackStartTime[_owner] = 0;
            ownerAttackTotalTime[_owner] = 0;
            return 0;
        }
        else {
            uint remainingTime = (ownerAttackStartTime[_owner] + ownerAttackTotalTime[_owner]).sub(uint(now));
            return remainingTime;
        }
    }

    function checkUserAddress() public view returns(bool) {
        if(ownerCastleCount[msg.sender] > 0) return true;
        return false;
    }

    function getStoneOwnerCount(address _owner) public view returns(uint) {
        return stoneOwnerCount[_owner];
    }

    function setStoneOwnerCount(address _owner, uint value) public {
        stoneOwnerCount[_owner] = value;
    }

    function getIronOwnerCount(address _owner) public view returns(uint) {
        return ironOwnerCount[_owner];
    }

    function setIronOwnerCount(address _owner, uint value) public {
        ironOwnerCount[_owner] = value;
    }

    function getFoodOwnerCount(address _owner) public view returns(uint) {
        return foodOwnerCount[_owner];
    }

    function setFoodOwnerCount(address _owner, uint value) public {
        foodOwnerCount[_owner] = value;
    }

    function getCoinOwnerCount(address _owner) public view returns(uint) {
        return coinOwnerCount[_owner];
    }

    function setCoinOwnerCount(address _owner, uint value) public {
        coinOwnerCount[_owner] = value;
    }

    function getWoodOwnerCount(address _owner) public view returns(uint) {
        return woodOwnerCount[_owner];
    }

    function setWoodOwnerCount(address _owner, uint value) public {
        woodOwnerCount[_owner] = value;
    }


    function getMyIdx() public view returns(uint) {
        for (uint i=0; i<kingdomAmount; ++i) {
            if(castleToOwner[i] == msg.sender) {
                return i;
            }
        }
        return kingdomAmount;
    }

    function getUserPowerById(uint idx) public returns(uint) {
        if(idx < kingdomAmount) {
            address idx = castleToOwner[idx];
            power[idx] = soldierPower[idx] + wallPower[idx] + protectorPower[idx] + cannonPower[idx];
            return power[idx];
        }
        return 0;
    }

    function getUserPower(address idx) public returns(uint) {
        power[idx] = soldierPower[idx] + wallPower[idx] + protectorPower[idx] + cannonPower[idx];
        return power[idx];
    }

    function setUserPower(address idx, uint value) public {
        power[idx] = value;
    }



    function setUserSoldierPower(address idx, uint value) public {
        power[idx] = value;
    }



    function setUserProtectorPower(address idx, uint value) public {
        power[idx] = value;
    }



    function setUserCannonPower(address idx, uint value) public {
        power[idx] = value;
    }



    function setUserWallPower(address idx, uint value) public {
        power[idx] = value;
    }


    function getUserHealth(address idx) public view returns(uint) {
        return health[idx];
    }

    function setUserHealth(address idx, uint value) public {
        health[idx] = value;
    }

    function getUserSpyPower(address idx) public view returns(uint) {
        return spyPower[idx];
    }

    function setUserSpyPower(address idx, uint value) public {
        spyPower[idx] = value;
    }

    function getKingdomAmount() public view returns(uint) {
        return kingdomAmount;
    }

    function convertCastleToOwner(uint id) public view returns(address) {
        return castleToOwner[id];
    }

    // for web to create castle
    function initializeKingdom(address _owner) public {
        require(ownerCastleCount[_owner] == 0);
        castleToOwner[kingdomAmount] = _owner;
        kingdomAmount++;
        ownerCastleCount[_owner]++;
        foodOwnerCount[_owner] = 10000;
        woodOwnerCount[_owner] = 10000;
        stoneOwnerCount[_owner] = 10000;
        ironOwnerCount[_owner] = 10000;
        coinOwnerCount[_owner] = 10000;
        power[_owner] = 0;
        health[_owner] = 0;
        spyPower[_owner] = 0;
        ownerIsAttacked[_owner] = false;
        ownerAttackStartTime[_owner] = 0;
        ownerAttackTotalTime[_owner] = 0;
    }

    function cost(address _owner, uint food, uint wood, uint iron, uint stone, uint coin) public returns (bool){
        if(foodOwnerCount[_owner]>=food && woodOwnerCount[_owner]>=wood && ironOwnerCount[_owner]>=iron && stoneOwnerCount[_owner]>=stone && coinOwnerCount[_owner]>=coin){
            foodOwnerCount[_owner] = foodOwnerCount[_owner].sub(food);
            woodOwnerCount[_owner] = woodOwnerCount[_owner].sub(wood);
            ironOwnerCount[_owner] = ironOwnerCount[_owner].sub(iron);
            stoneOwnerCount[_owner] = stoneOwnerCount[_owner].sub(stone);
            coinOwnerCount[_owner] = coinOwnerCount[_owner].sub(coin);
            return true;
        }
        return false;
    }

    function getFoodAmount() public view returns(uint) {
        return foodOwnerCount[msg.sender];
    }

    function getIronAmount() public view returns(uint) {
        return ironOwnerCount[msg.sender];
    }

    function getStoneAmount() public view returns(uint) {
        return stoneOwnerCount[msg.sender];
    }

    function getCoinAmount() public view returns(uint) {
        return coinOwnerCount[msg.sender];
    }

    function getWoodAmount() public view returns(uint) {
        return woodOwnerCount[msg.sender];
    }
}