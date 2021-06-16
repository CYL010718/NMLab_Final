pragma solidity >=0.4.21 <0.7.0;

import "./Account.sol";

contract Wall {

    Account accountInstance;
    constructor(address _account_address) public {
        accountInstance = Account(_account_address);
    }

    mapping (address => uint) public numOfWall;

    mapping (address => uint) public levelOfWall;

    mapping (address => uint) public ownerStartCreateTime;
    mapping (address => uint) public ownerCreateWallTime;
    mapping (address => uint) public ownerStartUpgradeTime;
    mapping (address => uint) public ownerUpgradeWallTime;
    uint public createWallTime = 10;
    // uint public UpgradeWallTime = 10;

    uint public WallHealth = 3;
    uint public WallPower = 3;
    uint public WallFrequency = 2;
    

    function setWallLevel(address _owner, uint value) public {
        levelOfWall[_owner] = value;
    }

    function setStartCreateTime(address _owner, uint value) public {
        ownerStartCreateTime[_owner] = value;
    }

    function setCreateWallTime(address _owner, uint value) public {
        ownerCreateWallTime[_owner] = value;
    }

    // function setStartUpgradeTime(address _owner, uint value) public {
    //     ownerStartUpgradeTime[_owner] = value;
    // }

    // function setUpgradeWallTime(address _owner, uint value) public {
    //     ownerUpgradeWallTime[_owner] = value;
    // }

    function setNumOfWall(address _owner, uint value) public {
        numOfWall[_owner] = value;
    }

    // function getWallStartCreateTime(address _owner) public view return(uint) {
    //     return ownerStartCreateTime[_owner];
    // }


    // function _updateWallPower(address _owner) public {
        // accountInstance.setUserPower(_owner, numOfWall[_owner] * levelOfWall[_owner] * WallPower);
        // accountInstance.setUserHealth(_owner, numOfWall[_owner] * levelOfWall[_owner] * WallHealth);

    // }

    function _createWall(address _owner, uint number) public returns(bool) {
        uint foodCost = (25* levelOfWall[_owner] - 5) * number;
        uint ironCost = (25* levelOfWall[_owner] - 5) * number;
        uint coinCost = (25* levelOfWall[_owner] - 5) * number;

        return accountInstance.cost(_owner, foodCost, uint(0), ironCost, uint(0), coinCost);
    }
    
    // function _UpgradeWall(address _owner) public returns(bool){
    //     uint foodCost = 500* levelOfWall[_owner] - 125;
    //     uint ironCost = 500* levelOfWall[_owner] - 125;
    //     uint coinCost = 500* levelOfWall[_owner] - 125;
    //     levelOfWall[_owner] += 1;

    //     return accountInstance.cost(_owner, foodCost, uint(0), ironCost, uint(0), coinCost);
    // }

    function getWallAmount(address _owner) public view returns(uint) {
        return numOfWall[_owner];
    }
}