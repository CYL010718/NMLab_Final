pragma solidity >=0.4.21 <0.7.0;

import "./SafeMath.sol";
import "./BuildingFactory.sol";
import "./Soldier.sol";

contract Barrack is BuildingFactory, Soldier {
    
    using SafeMath for uint;
    using SafeMath for uint;

    function createBarrack(uint _x, uint _y) public {
        _createBuilding(msg.sender, "Barrack", _x, _y);
        levelOfSoldier[msg.sender] = 1;
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
        ownerStartCreateTime[_owner] = uint(now);
        ownerCreateSoldierTime[_owner] = createSoldierTime * lvOfSoldier * number;
        return ownerCreateSoldierTime[_owner];
    }

    function getCreateSoldierTime() public view returns(uint, uint) {
        return ( now - ownerStartCreateTime[msg.sender], ownerCreateSoldierTime[msg.sender] ) ;
    }

    // // return 0 if success else return remaining time
    function updateCreateSoldier(address _owner) public returns(uint) {
        if (ownerStartCreateTime[_owner] == 0) return 0;
        if (now >= ownerStartCreateTime[_owner].add(ownerCreateSoldierTime[_owner])) {
            uint num;
            num = ownerCreateSoldierTime[_owner].div(  levelOfSoldier[_owner].mul(createSoldierTime) );
            numOfSoldier[_owner] = numOfSoldier[_owner] + (num);
            ownerStartCreateTime[_owner] = 0;
            ownerCreateSoldierTime[_owner] = 0;
            _updatePower(_owner);
            return 0;
        }
        else {
            uint remainingTime = (ownerStartCreateTime[_owner] + ownerCreateSoldierTime[_owner]).sub(now);
            return remainingTime;
        }
    }

}