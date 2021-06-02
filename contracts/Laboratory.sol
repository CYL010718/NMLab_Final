pragma solidity >=0.4.21 <0.7.0;

import "./SafeMath.sol";
import "./BuildingFactory.sol";
import "./Spy.sol";

contract Laboratory is BuildingFactory, Spy {
    
    using SafeMath for uint;
    using SafeMath for uint;

    
    function createLaboratory(uint _x, uint _y) public {
        _createBuilding(msg.sender, "Laboratory", _x, _y);
        levelOfSpy[msg.sender] = 1;
    }

    // return 0 if failed (maybe already creating or not enough resource) otherwise return createtime
    function startCreateSpy(uint number) public returns(uint) {
        address _owner = msg.sender;
        if(ownerStartCreateTime[_owner] != 0) return uint(0); // check if there is already creating Spys
        bool enoughResource;
        uint lvOfSpy;
        enoughResource = _createSpy(_owner, number);
        lvOfSpy =  levelOfSpy[_owner];
        if(enoughResource == false) return uint(0);
        ownerStartCreateTime[_owner] = uint(now);
        ownerCreateSpyTime[_owner] = createSpyTime * lvOfSpy * number;
        return ownerCreateSpyTime[_owner];
    }

    function getCreateSpyTime() public view returns(uint, uint) {
        return ( now - ownerStartCreateTime[msg.sender], ownerCreateSpyTime[msg.sender] ) ;
    }

    // // return 0 if success else return remaining time
    function updateCreateSpy(address _owner) public returns(uint) {
        if (ownerStartCreateTime[_owner] == 0) return 0;
        if (now >= ownerStartCreateTime[_owner].add(ownerCreateSpyTime[_owner])) {
            uint num;
            num = ownerCreateSpyTime[_owner].div(  levelOfSpy[_owner].mul(createSpyTime) );
            numOfSpy[_owner] = numOfSpy[_owner] + (num);
            ownerStartCreateTime[_owner] = 0;
            ownerCreateSpyTime[_owner] = 0;
            _updateSpyPower(_owner);
            return 0;
        }
        else {
            uint remainingTime = (ownerStartCreateTime[_owner] + ownerCreateSpyTime[_owner]).sub(now);
            return remainingTime;
        }
    }
}