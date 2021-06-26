pragma solidity >=0.4.21 <0.7.0;

import "./Account.sol";

contract Cannon {

    using SafeMath for uint;
    
    Account accountInstance;
    constructor(address _account_address) public {
        accountInstance = Account(_account_address);
    }

    mapping (address => uint) public numOfCannon;

    mapping (address => uint) public levelOfCannon;

    mapping (address => uint) public ownerStartCreateTime;
    mapping (address => uint) public ownerCreateCannonTime;
    mapping (address => uint) public ownerStartUpgradeTime;
    mapping (address => uint) public ownerUpgradeCannonTime;
    uint public createCannonTime = 10;
    uint public UpgradeCannonTime = 10;

    uint public cannonHealth = 100;
    uint public cannonPower = 100;
    uint public cannonFrequency = 1;
    uint public cannonArmour = 0;
    uint public cannonCapacity = 200;
    uint public cannonSpeed = 10;
    

    function setCannonLevel(address _owner, uint value) public {
        levelOfCannon[_owner] = value;
        _updateCannonPower(_owner);
    }

    function setStartCreateTime(address _owner, uint value) public {
        ownerStartCreateTime[_owner] = value;
    }

    function setCreateCannonTime(address _owner, uint value) public {
        ownerCreateCannonTime[_owner] = value;
    }

    function setStartUpgradeTime(address _owner, uint value) public {
        ownerStartUpgradeTime[_owner] = value;
    }

    function setUpgradeCannonTime(address _owner, uint value) public {
        ownerUpgradeCannonTime[_owner] = value;
    }

    function setNumOfCannon(address _owner, uint value) public {
        numOfCannon[_owner] = value;
        _updateCannonPower(_owner);
    }

    // function getCannonStartCreateTime(address _owner) public view return(uint) {
    //     return ownerStartCreateTime[_owner];
    // }


    function _updateCannonPower(address _owner) public {
        accountInstance.setUserCannonPower(_owner, numOfCannon[_owner] * levelOfCannon[_owner] * cannonPower);
        // accountInstance.setUserHealth(_owner, numOfCannon[_owner] * levelOfCannon[_owner] * cannonHealth);
    }

    function _createCannon(address _owner, uint number) public returns(bool) {
        uint foodCost = (25* levelOfCannon[_owner] - 5) * number;
        uint ironCost = (25* levelOfCannon[_owner] - 5) * number;
        uint coinCost = (25* levelOfCannon[_owner] - 5) * number;
        
       
        return accountInstance.cost(_owner, foodCost, uint(0), ironCost, uint(0), coinCost);
    }
    
    function _UpgradeCannon(address _owner) public returns(bool){
        uint foodCost = 500* levelOfCannon[_owner] - 125;
        uint ironCost = 500* levelOfCannon[_owner] - 125;
        uint coinCost = 500* levelOfCannon[_owner] - 125;
        levelOfCannon[_owner] += 1;

        return accountInstance.cost(_owner, foodCost, uint(0), ironCost, uint(0), coinCost);
    }

    function getCannonAmount(address _owner) public view returns(uint) {
        return numOfCannon[_owner];
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

        numOfCannon[winner] = (accountInstance.getUserPower(winner) - winnerPowerLose) / levelOfCannon[winner];

        numOfCannon[loser] = numOfCannon[loser] * 4 / 5;

        _updateCannonPower(winner);
        _updateCannonPower(loser);
    }

    function attack(uint _ownerId, uint _attackedCastleId) public {
        require(msg.sender == accountInstance.convertCastleToOwner(_ownerId));
        address myCastle = accountInstance.convertCastleToOwner(_ownerId);
        address attackedCastle = accountInstance.convertCastleToOwner(_attackedCastleId);
        _fight(myCastle, attackedCastle);
    }


    // return 0 if failed (maybe already creating or not enough resource) otherwise return createtime
    function startCreateCannon(uint number) public returns(uint) {
        address _owner = msg.sender;
        if(ownerStartCreateTime[_owner] != 0) return uint(0); // check if there is already creating Cannons
        bool enoughResource;
        uint lvOfCannon;
        enoughResource = _createCannon(_owner, number);
        lvOfCannon =  levelOfCannon[_owner];
        if(enoughResource == false) return uint(0);
        _updateCannonPower(_owner);
        setStartCreateTime(_owner, uint(now));
        setCreateCannonTime(_owner, createCannonTime * lvOfCannon * number);
        return ownerCreateCannonTime[_owner];
    }

    function getCreateCannonTime() public view returns(uint, uint, uint) {
        return ( ownerStartCreateTime[msg.sender], uint(now) - ownerStartCreateTime[msg.sender], ownerCreateCannonTime[msg.sender] ) ;
    }

    // // return 0 if success else return remaining time
    function updateCreateCannon(address _owner) public returns(uint) {
        if (ownerStartCreateTime[_owner] == 0) return 0;
        if (uint(now) >= ownerStartCreateTime[_owner].add(ownerCreateCannonTime[_owner])) {
            uint num;
            num = ownerCreateCannonTime[_owner].div(  levelOfCannon[_owner].mul(createCannonTime));
            setNumOfCannon(_owner, numOfCannon[_owner] + (num));
            setStartCreateTime(_owner, 0);
            setCreateCannonTime(_owner, 0);
            _updateCannonPower(_owner);
            return 0;
        }
        else {
            uint remainingTime = (ownerStartCreateTime[_owner] + ownerCreateCannonTime[_owner]).sub(uint(now));
            return remainingTime;
        }
    }
}