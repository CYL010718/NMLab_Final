pragma solidity >=0.4.21 <0.7.0;

import "./Account.sol";

contract Spy {

    using SafeMath for uint;

    Account accountInstance;
    constructor(address _account_address) public {
        accountInstance = Account(_account_address);
    }

    mapping (address => uint) public numOfSpy;

    mapping (address => uint) public levelOfSpy;

    mapping (address => uint) public ownerStartCreateTime;
    mapping (address => uint) public ownerCreateSpyTime;
    mapping (address => uint) public ownerStartUpgradeTime;
    mapping (address => uint) public ownerUpgradeSpyTime;
    uint public createSpyTime = 10;
    uint public UpgradeSpyTime = 10;
    
    uint public spyHealth = 1;
    uint public spyPower = 1;
    uint public spyFrequency = 1;
    uint public spyArmour = 1;
    uint public spyCapacity = 1;
    uint public spySpeed = 1;
    

    function setSpyLevel(address _owner, uint value) public {
        levelOfSpy[_owner] = value;
    }

    function setStartCreateTime(address _owner, uint value) public {
        ownerStartCreateTime[_owner] = value;
    }

    function setCreateSpyTime(address _owner, uint value) public {
        ownerCreateSpyTime[_owner] = value;
    }

    function setStartUpgradeTime(address _owner, uint value) public {
        ownerStartUpgradeTime[_owner] = value;
    }

    function setUpgradeSpyTime(address _owner, uint value) public {
        ownerUpgradeSpyTime[_owner] = value;
    }

    function setNumOfSpy(address _owner, uint value) public {
        numOfSpy[_owner] = value;
    }


    function _updateSpyPower(address _owner) public {
        // power[_owner] = numOfSpy[_owner] * levelOfSpy[_owner];
        accountInstance.setUserSpyPower(_owner, numOfSpy[_owner] * levelOfSpy[_owner]);
    }

    function _createSpy(address _owner, uint number) public returns(bool) {
        uint foodCost = (25* levelOfSpy[_owner] - 5) * number;
        uint ironCost = (25* levelOfSpy[_owner] - 5) * number;
        uint coinCost = (25* levelOfSpy[_owner] - 5) * number;

        return accountInstance.cost(_owner, foodCost, uint(0), ironCost, uint(0), coinCost);
    }
    
    function _UpgradeSpy(address _owner) public returns(bool){
        uint foodCost = 500* levelOfSpy[_owner] - 125;
        uint ironCost = 500* levelOfSpy[_owner] - 125;
        uint coinCost = 500* levelOfSpy[_owner] - 125;
        levelOfSpy[_owner] += 1;
        return accountInstance.cost(_owner, foodCost, uint(0), ironCost, uint(0), coinCost);
    }

    function getSpyAmount(address _owner) public view returns(uint) {
        return numOfSpy[_owner];
    }

    function _spy(address myCastle, address attackedCastle) public view returns(bool) {
        address winner;
        address loser;
        bool win;
        //bool win = -1;

        if (accountInstance.getUserSpyPower(myCastle) > accountInstance.getUserSpyPower(attackedCastle)){
            winner = myCastle;
            loser = attackedCastle;
            win = true;
        }
        else {
            winner = attackedCastle;
            loser = myCastle;
            win = false;
        }
        return win;
    }

    function sendSpy(uint _ownerId, uint _attackedCastleId) public view returns(bool) {
        //require(msg.sender == accountInstance.convertCastleToOwner(_ownerId));
        address myCastle = accountInstance.convertCastleToOwner(_ownerId);
        address attackedCastle = accountInstance.convertCastleToOwner(_attackedCastleId);

        //returns TRUE if spy of myCastle > attackedCastle
        return _spy(myCastle, attackedCastle);
    }


    // return 0 if failed (maybe already creating or not enough resource) otherwise return createtime
    function startCreateSpy(uint number) public returns(uint) {
        address _owner = msg.sender;
        if(ownerStartCreateTime[_owner] != 0) return uint(0); // check if there is already creating spys
        bool enoughResource;
        uint lvOfSpy;
        enoughResource = _createSpy(_owner, number);
        lvOfSpy =  levelOfSpy[_owner];
        if(enoughResource == false) return uint(0);
        setStartCreateTime(_owner, uint(now));
        setCreateSpyTime(_owner, createSpyTime * lvOfSpy * number);
        return ownerCreateSpyTime[_owner];
    }

    function getCreateSpyTime() public view returns(uint, uint, uint) {
        return ( ownerStartCreateTime[msg.sender], uint(now) - ownerStartCreateTime[msg.sender], ownerCreateSpyTime[msg.sender] ) ;
    }

    // // return 0 if success else return remaining time
    function updateCreateSpy(address _owner) public returns(uint) {
        if (ownerStartCreateTime[_owner] == 0) return 0;
        if (uint(now) >= ownerStartCreateTime[_owner].add(ownerCreateSpyTime[_owner])) {
            uint num;
            num = ownerCreateSpyTime[_owner].div(  levelOfSpy[_owner].mul(createSpyTime) );
            setNumOfSpy(_owner, numOfSpy[_owner] + (num));
            setStartCreateTime(_owner, 0);
            setCreateSpyTime(_owner, 0);
            _updateSpyPower(_owner);
            return 0;
        }
        else {
            uint remainingTime = (ownerStartCreateTime[_owner] + ownerCreateSpyTime[_owner]).sub(uint(now));
            return remainingTime;
        }
    }
}