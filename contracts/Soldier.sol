pragma solidity >=0.4.21 <0.7.0;

import "./Account.sol";

contract Soldier is Account {
    mapping (address => uint) public numOfSoldier;

    mapping (address => uint) public levelOfSoldier;

    mapping (address => uint) public ownerStartCreateTime;
    mapping (address => uint) public ownerCreateSoldierTime;
    mapping (address => uint) public ownerStartLevelUpTime;
    uint public createSoldierTime = 10;
    uint public levelUpSoldierTime = 10;


    function _updatePower(address _owner) internal {
        power[_owner] = numOfSoldier[_owner] * levelOfSoldier[_owner];
    }

    function _createSoldier(address _owner, uint number) internal returns(bool) {
        uint foodCost = (25* levelOfSoldier[_owner] - 5) * number;
        uint ironCost = (25* levelOfSoldier[_owner] - 5) * number;
        uint coinCost = (25* levelOfSoldier[_owner] - 5) * number;

        return _cost(_owner, foodCost, uint(0), ironCost, uint(0), coinCost);
    }
    
    function _upgradeSoldier(address _owner) internal returns(bool){
        uint foodCost = 500* levelOfSoldier[_owner] - 125;
        uint ironCost = 500* levelOfSoldier[_owner] - 125;
        uint coinCost = 500* levelOfSoldier[_owner] - 125;

        return _cost(_owner, foodCost, uint(0), ironCost, uint(0), coinCost);
    }

    function getSoldierAmount(address _owner) public view returns(uint) {
        return numOfSoldier[_owner];
    }

    function _fight(address myCastle, address attackedCastle) internal{
        address winner;
        address loser;

        if (power[myCastle] > power[attackedCastle]){
            winner = myCastle;
            loser = attackedCastle;
        }
        else {
            winner = attackedCastle;
            loser = myCastle;
        }
        
        foodOwnerCount[winner] = foodOwnerCount[winner] + (foodOwnerCount[loser] * 4/5);
        // woodOwnerCount[winner] = woodOwnerCount[winner] + (woodOwnerCount[loser] * 4/5);
        // ironOwnerCount[winner] = ironOwnerCount[winner] + (ironOwnerCount[loser] * 4/5);
        // stoneOwnerCount[winner] = stoneOwnerCount[winner] + (stoneOwnerCount[loser] * 4/5);
        coinOwnerCount[winner] = coinOwnerCount[winner] + (coinOwnerCount[loser] * 4/5);
        foodOwnerCount[loser] = foodOwnerCount[loser] - (foodOwnerCount[loser] * 4/5);
        // woodOwnerCount[loser] = woodOwnerCount[loser] - (woodOwnerCount[loser] * 4/5);
        // ironOwnerCount[loser] = ironOwnerCount[loser] - (ironOwnerCount[loser] * 4/5);
        // stoneOwnerCount[loser] = stoneOwnerCount[loser] - (stoneOwnerCount[loser] * 4/5);
        coinOwnerCount[loser] = coinOwnerCount[loser] - (coinOwnerCount[loser] * 4/5);

        uint winnerPowerLose = power[loser] / 2;

        numOfSoldier[winner] = (power[winner] - winnerPowerLose) / levelOfSoldier[winner];

        numOfSoldier[loser] = numOfSoldier[loser] * 4 / 5;

        _updatePower(winner);
        _updatePower(loser);
    }

    function attack(uint _ownerId, uint _attackedCastleId) public {
        require(msg.sender == castleToOwner[_ownerId]);
        address myCastle = castleToOwner[_ownerId];
        address attackedCastle = castleToOwner[_attackedCastleId];
        _fight(myCastle, attackedCastle);
    }
}