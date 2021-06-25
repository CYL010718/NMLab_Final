pragma solidity >=0.4.21 <0.7.0;

import "./Account.sol";

contract Protector {

    using SafeMath for uint;
    
    Account accountInstance;
    constructor(address _account_address) public {
        accountInstance = Account(_account_address);
    }

    mapping (address => uint) public numOfProtector;

    mapping (address => uint) public levelOfProtector;

    mapping (address => uint) public ownerStartCreateTime;
    mapping (address => uint) public ownerCreateProtectorTime;
    mapping (address => uint) public ownerStartUpgradeTime;
    mapping (address => uint) public ownerUpgradeProtectorTime;
    uint public createProtectorTime = 10;
    uint public UpgradeProtectorTime = 10;

    uint public protectorHealth = 80;
    uint public protectorPower = 40;
    uint public protectorFrequency = 1;
    uint public protectorArmour = 20;
    uint public protectorCapacity = 200;
    uint public protectorSpeed = 20;
    

    function setProtectorLevel(address _owner, uint value) public {
        levelOfProtector[_owner] = value;
    }

    function setStartCreateTime(address _owner, uint value) public {
        ownerStartCreateTime[_owner] = value;
    }

    function setCreateProtectorTime(address _owner, uint value) public {
        ownerCreateProtectorTime[_owner] = value;
    }

    function setStartUpgradeTime(address _owner, uint value) public {
        ownerStartUpgradeTime[_owner] = value;
    }

    function setUpgradeProtectorTime(address _owner, uint value) public {
        ownerUpgradeProtectorTime[_owner] = value;
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
    
    function _UpgradeProtector(address _owner) public returns(bool){
        uint foodCost = 500* levelOfProtector[_owner] - 125;
        uint ironCost = 500* levelOfProtector[_owner] - 125;
        uint coinCost = 500* levelOfProtector[_owner] - 125;
        levelOfProtector[_owner] += 1;
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


    // return 0 if failed (maybe already creating or not enough resource) otherwise return createtime
    function startCreateProtector(uint number) public returns(uint) {
        address _owner = msg.sender;
        if(ownerStartCreateTime[_owner] != 0) return uint(0); // check if there is already creating Protectors
        bool enoughResource;
        uint lvOfProtector;
        enoughResource = _createProtector(_owner, number);
        lvOfProtector =  levelOfProtector[_owner];
        if(enoughResource == false) return uint(0);
        setStartCreateTime(_owner, uint(now));
        setCreateProtectorTime(_owner, createProtectorTime * lvOfProtector * number);
        return ownerCreateProtectorTime[_owner];
    }

    function getCreateProtectorTime() public view returns(uint, uint, uint) {
        return ( ownerStartCreateTime[msg.sender], uint(now) - ownerStartCreateTime[msg.sender], ownerCreateProtectorTime[msg.sender] ) ;
    }

    // // return 0 if success else return remaining time
    function updateCreateProtector(address _owner) public returns(uint) {
         if (ownerStartCreateTime[_owner] == 0) return 0;
         if (uint(now) >= ownerStartCreateTime[_owner].add(ownerCreateProtectorTime[_owner])) {
             uint num;
             num = ownerCreateProtectorTime[_owner].div(  levelOfProtector[_owner].mul(createProtectorTime) );
             setNumOfProtector(_owner, numOfProtector[_owner] + (num));
             setStartCreateTime(_owner, 0);
             setCreateProtectorTime(_owner, 0);
             _updateProtectorPower(_owner);
             return 0;
         }
         else {
             uint remainingTime = (ownerStartCreateTime[_owner] + ownerCreateProtectorTime[_owner]).sub(uint(now));
             return remainingTime;
         }
     }
}