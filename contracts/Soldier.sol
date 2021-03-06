pragma solidity >=0.4.21 <0.7.0;

import "./Account.sol";

contract Soldier {
    
    using SafeMath for uint;

    Account accountInstance;
    constructor(address _account_address) public {
        accountInstance = Account(_account_address);
    }

    mapping (address => uint) public numOfSoldier;

    mapping (address => uint) public levelOfSoldier;

    mapping (address => uint) public ownerStartCreateTime;
    mapping (address => uint) public ownerCreateSoldierTime;
    mapping (address => uint) public ownerStartUpgradeTime;
    mapping (address => uint) public ownerUpgradeSoldierTime;
    uint public createSoldierTime = 10;
    uint public UpgradeSoldierTime = 10;
    uint public soldierHealth = 50;
    uint public soldierPower = 30;
    uint public soldierFrequency = 2;
    uint public soldierArmour = 10;
    uint public soldierCapacity = 200;
    uint public soldierSpeed = 30;
    
    //for battle function to get other's information
   
    //
    function setSoldierLevel(address _owner, uint value) public {
        levelOfSoldier[_owner] = value;
        _updatePower(_owner);
    }

    function setStartCreateTime(address _owner, uint value) public {
        ownerStartCreateTime[_owner] = value;
    }

    function setCreateSoldierTime(address _owner, uint value) public {
        ownerCreateSoldierTime[_owner] = value;
    }

    function setStartUpgradeTime(address _owner, uint value) public {
        ownerStartUpgradeTime[_owner] = value;
    }

    function setUpgradeSoldierTime(address _owner, uint value) public {
        ownerUpgradeSoldierTime[_owner] = value;
    }

    function setNumOfSoldier(address _owner, uint value) public {
        numOfSoldier[_owner] = value;
        _updatePower(_owner);
    }

    // function getSoldierStartCreateTime(address _owner) public view return(uint) {
    //     return ownerStartCreateTime[_owner];
    // }


    function _updatePower(address _owner) public {
        accountInstance.setUserSoldierPower(_owner, numOfSoldier[_owner] * levelOfSoldier[_owner] * soldierPower);
    }

    function _createSoldier(address _owner, uint number) public returns(bool) {
        uint foodCost = (25* levelOfSoldier[_owner] - 5) * number;
        uint ironCost = (25* levelOfSoldier[_owner] - 5) * number;
        uint coinCost = (25* levelOfSoldier[_owner] - 5) * number;

        return accountInstance.cost(_owner, foodCost, uint(0), ironCost, uint(0), coinCost);
    }
    
    function _UpgradeSoldier(address _owner) public returns(bool){
        uint foodCost = 500* levelOfSoldier[_owner] - 125;
        uint ironCost = 500* levelOfSoldier[_owner] - 125;
        uint coinCost = 500* levelOfSoldier[_owner] - 125;
        levelOfSoldier[_owner] += 1;

        return accountInstance.cost(_owner, foodCost, uint(0), ironCost, uint(0), coinCost);
    }

    function getSoldierAmount(address _owner) public view returns(uint) {
        return numOfSoldier[_owner];
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

        numOfSoldier[winner] = (accountInstance.getUserPower(winner) - winnerPowerLose) / levelOfSoldier[winner];

        numOfSoldier[loser] = numOfSoldier[loser] * 4 / 5;

        _updatePower(winner);
        _updatePower(loser);
    }

    function attack(uint _ownerId, uint _attackedCastleId) public {
        require(msg.sender == accountInstance.convertCastleToOwner(_ownerId));
        address myCastle = accountInstance.convertCastleToOwner(_ownerId);
        address attackedCastle = accountInstance.convertCastleToOwner(_attackedCastleId);
        _fight(myCastle, attackedCastle);
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
        _updatePower(_owner);
        setStartCreateTime(_owner, uint(now));
        setCreateSoldierTime(_owner, createSoldierTime * lvOfSoldier * number);
        return ownerCreateSoldierTime[_owner];
    }

    function getCreateSoldierTime() public view returns(uint, uint, uint) {
        return ( ownerStartCreateTime[msg.sender], uint(now) - ownerStartCreateTime[msg.sender], ownerCreateSoldierTime[msg.sender] ) ;
    }

    // // return 0 if success else return remaining time
    function updateCreateSoldier(address _owner) public returns(uint) {
        if (ownerStartCreateTime[_owner] == 0) return 0;
        if (uint(now) >= ownerStartCreateTime[_owner].add(ownerCreateSoldierTime[_owner])) {
            uint num;
            num = ownerCreateSoldierTime[_owner].div( levelOfSoldier[_owner].mul(createSoldierTime) );
            setNumOfSoldier(_owner, numOfSoldier[_owner] + (num));
            setStartCreateTime(_owner, 0);
            setCreateSoldierTime(_owner, 0);
            _updatePower(_owner);
            return 0;
        }
        else {
            uint remainingTime = (ownerStartCreateTime[_owner] + ownerCreateSoldierTime[_owner]).sub(uint(now));
            return remainingTime;
        }
    }

}