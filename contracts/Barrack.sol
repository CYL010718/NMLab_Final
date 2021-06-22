pragma solidity >=0.4.21 <0.7.0;

import "./SafeMath.sol";
import "./BuildingFactory.sol";
import "./Soldier.sol";
import "./Spy.sol";
import "./Cannon.sol";
import "./Protector.sol";
import "./Wall.sol";

contract Barrack {

    using SafeMath for uint;

    mapping (address => uint) public ownerStartMarchTime;
    mapping (address => uint) public ownerTotalMarchTime;

    BuildingFactory buildingInstance;
    Soldier soldierInstance;
    Protector ProtectorInstance;
    Cannon CannonInstance;
    Spy SpyInstance;
    Account AccountInstance;
    Wall WallInstance;
    constructor(address _building_address, address _soldier_address, address _spy_instance, address _cannon_instance, address _protector_instance, address _wall_instance, address _account_instance) public {
        buildingInstance = BuildingFactory(_building_address);
        soldierInstance = Soldier(_soldier_address);
        SpyInstance = Spy(_spy_instance);
        ProtectorInstance = Protector(_protector_instance);
        CannonInstance = Cannon(_cannon_instance);
        AccountInstance = Account(_account_instance);
        WallInstance = Wall(_wall_instance);
    }

    function createBarrack(uint _x, uint _y) public {
        buildingInstance._createBuilding(msg.sender, "Barrack", _x, _y);
        soldierInstance.setSoldierLevel(msg.sender, 1);
        SpyInstance.setSpyLevel(msg.sender, 1);
        ProtectorInstance.setProtectorLevel(msg.sender, 1);
        CannonInstance.setCannonLevel(msg.sender, 1);
        WallInstance.setWallLevel(msg.sender, 1);
    }


    // // return 0 if failed (maybe already creating or not enough resource) otherwise return createtime
    
    function attack(uint _ownerId, uint _attackedCastleId) public {
        // soldierInstance.attack(_ownerId, _attackedCastleId);
    }

    function startMarch(uint _attackedCastleId) public returns(uint) {
        address _owner = msg.sender;
        address attackedAddress = AccountInstance.castleToOwner(_attackedCastleId);

        
        if(ownerStartMarchTime[_owner] != 0) return uint(0); // check if there is already Marching
        bool enoughResource;
        enoughResource = enoughResource = AccountInstance.cost(_owner, 100, uint(0), 100, uint(0), 100);
        if(enoughResource == false) return uint(0);
        ownerStartMarchTime[_owner] = uint(now);
        ownerTotalMarchTime[_owner] = 10;
        AccountInstance.setAttackedInfo(attackedAddress, true, _owner, ownerStartMarchTime[_owner], ownerTotalMarchTime[_owner]);
        return ownerTotalMarchTime[_owner];
    }

    function getMarchTime() public view returns(uint, uint) {
        return ( now - ownerStartMarchTime[msg.sender], ownerTotalMarchTime[msg.sender] ) ;
    }

    // // return 0 if success else return remaining time
    function updateMarch(address _owner) public returns(uint) {
        if (ownerStartMarchTime[_owner] == 0) return 0;
        if (now >= ownerStartMarchTime[_owner].add(ownerTotalMarchTime[_owner])) {
            // uint num;
            // num = ownerTotalMarchTime[_owner].div(  MarchInstance.levelOfMarch(_owner).mul(MarchInstance.createMarchTime()) );
            // MarchInstance.setNumOfMarch(_owner, MarchInstance.numOfMarch(_owner) + (num));
            ownerStartMarchTime[_owner] = 0;
            ownerTotalMarchTime[_owner] = 0;
            return 0;
        }
        else {
            uint remainingTime = (ownerStartMarchTime[_owner] + ownerTotalMarchTime[_owner]).sub(now);
            return remainingTime;
        }
    }

    function sendSpy(uint _ownerId, uint _attackedCastleId) public view returns(bool) {
        //returns TRUE if spy of myCastle > attackedCastle
        
        return SpyInstance.sendSpy(_ownerId, _attackedCastleId);
    }

}