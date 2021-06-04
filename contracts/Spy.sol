pragma solidity >=0.4.21 <0.7.0;

import "./Account.sol";

contract Spy {

    Account accountInstance;
    constructor(address _account_address) public {
        accountInstance = Account(_account_address);
    }

    mapping (address => uint) public numOfSpy;

    mapping (address => uint) public levelOfSpy;

    mapping (address => uint) public ownerStartCreateTime;
    mapping (address => uint) public ownerCreateSpyTime;
    mapping (address => uint) public ownerStartLevelUpTime;
    uint public createSpyTime = 10;
    uint public levelUpSpyTime = 10;
    
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
    
    function _upgradeSpy(address _owner) public returns(bool){
        uint foodCost = 500* levelOfSpy[_owner] - 125;
        uint ironCost = 500* levelOfSpy[_owner] - 125;
        uint coinCost = 500* levelOfSpy[_owner] - 125;

        return accountInstance.cost(_owner, foodCost, uint(0), ironCost, uint(0), coinCost);
    }

    function getSpyAmount(address _owner) public view returns(uint) {
        return numOfSpy[_owner];
    }

    function _spy(address myCastle, address attackedCastle) public returns(bool) {
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

    function sendSpy(uint _ownerId, uint _attackedCastleId) public returns(bool) {
        require(msg.sender == accountInstance.convertCastleToOwner(_ownerId));
        address myCastle = accountInstance.convertCastleToOwner(_ownerId);
        address attackedCastle = accountInstance.convertCastleToOwner(_attackedCastleId);

        //returns TRUE if spy of myCastle > attackedCastle
        return _spy(myCastle, attackedCastle);
    }
}