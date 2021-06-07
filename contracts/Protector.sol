pragma solidity >=0.4.21 <0.7.0;

import "./Account.sol";

contract Protector {

    Account accountInstance;
    constructor(address _account_address) public {
        accountInstance = Account(_account_address);
    }

    mapping (address => uint) public numOfProtector;

    mapping (address => uint) public levelOfProtector;

    mapping (address => uint) public ownerStartCreateTime;
    mapping (address => uint) public ownerCreateProtectorTime;
    mapping (address => uint) public ownerStartLevelUpTime;
    uint public createProtectorTime = 10;
    uint public levelUpProtectorTime = 10;

    uint public protectorHealth = 3;
    uint public protectorPower = 3;
    uint public protectorFrequency = 2;
    uint public protectorArmour = 1;
    uint public protectorCapacity = 200;
    uint public protectorSpeed = 3;
    

    function setProtectorLevel(address _owner, uint value) public {
        levelOfProtector[_owner] = value;
    }

    function setStartCreateTime(address _owner, uint value) public {
        ownerStartCreateTime[_owner] = value;
    }

    function setCreateProtectorTime(address _owner, uint value) public {
        ownerCreateProtectorTime[_owner] = value;
    }

    function setNumOfProtector(address _owner, uint value) public {
        numOfProtector[_owner] = value;
    }

    // function getProtectorStartCreateTime(address _owner) public view return(uint) {
    //     return ownerStartCreateTime[_owner];
    // }


    function _updateProtectorPower(address _owner) public {
        accountInstance.setUserPower(_owner, numOfProtector[_owner] * levelOfProtector[_owner] * protectorPower);
        accountInstance.setUserHealth(_owner, numOfProtector[_owner] * levelOfProtector[_owner] * protectorHealth);

    }

    function _createProtector(address _owner, uint number) public returns(bool) {
        uint foodCost = (25* levelOfProtector[_owner] - 5) * number;
        uint ironCost = (25* levelOfProtector[_owner] - 5) * number;
        uint coinCost = (25* levelOfProtector[_owner] - 5) * number;

        return accountInstance.cost(_owner, foodCost, uint(0), ironCost, uint(0), coinCost);
    }
    
    function _upgradeProtector(address _owner) internal returns(bool){
        uint foodCost = 500* levelOfProtector[_owner] - 125;
        uint ironCost = 500* levelOfProtector[_owner] - 125;
        uint coinCost = 500* levelOfProtector[_owner] - 125;

        return accountInstance.cost(_owner, foodCost, uint(0), ironCost, uint(0), coinCost);
    }

    function getProtectorAmount(address _owner) public view returns(uint) {
        return numOfProtector[_owner];
    }

    function _fight(address myCastle, address attackedCastle) internal{
        address winner;
        address loser;

        if (accountInstance.getUserPower(myCastle) > accountInstance.getUserPower(attackedCastle)){
            winner = myCastle;
            loser = attackedCastle;
        }
        else {
            winner = attackedCastle;
            loser = myCastle;
        }
        
        accountInstance.setFoodOwnerCount(winner, accountInstance.getFoodOwnerCount(winner) + (accountInstance.getFoodOwnerCount(loser) * 4/5));
        // woodOwnerCount[winner] = woodOwnerCount[winner] + (woodOwnerCount[loser] * 4/5);
        // ironOwnerCount[winner] = ironOwnerCount[winner] + (ironOwnerCount[loser] * 4/5);
        // stoneOwnerCount[winner] = stoneOwnerCount[winner] + (stoneOwnerCount[loser] * 4/5);
        accountInstance.setCoinOwnerCount(winner, accountInstance.getCoinOwnerCount(winner) + (accountInstance.getCoinOwnerCount(loser) * 4/5));
        accountInstance.setCoinOwnerCount(loser, accountInstance.getCoinOwnerCount(loser) - (accountInstance.getCoinOwnerCount(loser) * 4/5));
        accountInstance.setFoodOwnerCount(loser, accountInstance.getFoodOwnerCount(loser) - (accountInstance.getFoodOwnerCount(loser) * 4/5));

        // foodOwnerCount[loser] = foodOwnerCount[loser] - (foodOwnerCount[loser] * 4/5);
        // woodOwnerCount[loser] = woodOwnerCount[loser] - (woodOwnerCount[loser] * 4/5);
        // ironOwnerCount[loser] = ironOwnerCount[loser] - (ironOwnerCount[loser] * 4/5);
        // stoneOwnerCount[loser] = stoneOwnerCount[loser] - (stoneOwnerCount[loser] * 4/5);
        // coinOwnerCount[loser] = coinOwnerCount[loser] - (coinOwnerCount[loser] * 4/5);

        uint winnerPowerLose = accountInstance.getUserPower(loser)/2;

        numOfProtector[winner] = (accountInstance.getUserPower(winner) - winnerPowerLose) / levelOfProtector[winner];

        numOfProtector[loser] = numOfProtector[loser] * 4 / 5;

        _updateProtectorPower(winner);
        _updateProtectorPower(loser);
    }

    function attack(uint _ownerId, uint _attackedCastleId) public {
        require(msg.sender == accountInstance.convertCastleToOwner(_ownerId));
        address myCastle = accountInstance.convertCastleToOwner(_ownerId);
        address attackedCastle = accountInstance.convertCastleToOwner(_attackedCastleId);
        _fight(myCastle, attackedCastle);
    }
}