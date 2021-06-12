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
    Wall WallInstance;
    Account AccountInstance;
    constructor(address _building_address, address _soldier_address, address _spy_instance, address _cannon_instance, address _protector_instance, address _wall_instance, address _account_instance) public {
        buildingInstance = BuildingFactory(_building_address);
        soldierInstance = Soldier(_soldier_address);
        SpyInstance = Spy(_spy_instance);
        ProtectorInstance = Protector(_protector_instance);
        CannonInstance = Cannon(_cannon_instance);
        WallInstance = Wall(_wall_instance);
        AccountInstance = Account(_account_instance);
    }

    function createBarrack(uint _x, uint _y) public {
        buildingInstance._createBuilding(msg.sender, "Barrack", _x, _y);
        soldierInstance.setSoldierLevel(msg.sender, 1);
        SpyInstance.setSpyLevel(msg.sender, 1);
        ProtectorInstance.setProtectorLevel(msg.sender, 1);
        CannonInstance.setCannonLevel(msg.sender, 1);
    }

    function getSoldierAmount(address _owner) public view returns(uint) {
        return soldierInstance.getSoldierAmount(_owner);
    }

    // return 0 if failed (maybe already creating or not enough resource) otherwise return createtime
    function startCreateSoldier(uint number) public returns(uint) {
        address _owner = msg.sender;
        if(soldierInstance.ownerStartCreateTime(_owner) != 0) return uint(0); // check if there is already creating soldiers
        bool enoughResource;
        uint lvOfSoldier;
        enoughResource = soldierInstance._createSoldier(_owner, number);
        lvOfSoldier =  soldierInstance.levelOfSoldier(_owner);
        if(enoughResource == false) return uint(0);
        soldierInstance.setStartCreateTime(_owner, uint(now));
        soldierInstance.setCreateSoldierTime(_owner, soldierInstance.createSoldierTime() * lvOfSoldier * number);
        return soldierInstance.ownerCreateSoldierTime(_owner);
    }

    function getCreateSoldierTime() public view returns(uint, uint) {
        return ( now - soldierInstance.ownerStartCreateTime(msg.sender), soldierInstance.ownerCreateSoldierTime(msg.sender) ) ;
    }

    // // return 0 if success else return remaining time
    function updateCreateSoldier(address _owner) public returns(uint) {
        if (soldierInstance.ownerStartCreateTime(_owner) == 0) return 0;
        if (now >= soldierInstance.ownerStartCreateTime(_owner).add(soldierInstance.ownerCreateSoldierTime(_owner))) {
            uint num;
            num = soldierInstance.ownerCreateSoldierTime(_owner).div(  soldierInstance.levelOfSoldier(_owner).mul(soldierInstance.createSoldierTime()) );
            soldierInstance.setNumOfSoldier(_owner, soldierInstance.numOfSoldier(_owner) + (num));
            soldierInstance.setStartCreateTime(_owner, 0);
            soldierInstance.setCreateSoldierTime(_owner, 0);
            soldierInstance._updatePower(_owner);
            return 0;
        }
        else {
            uint remainingTime = (soldierInstance.ownerStartCreateTime(_owner) + soldierInstance.ownerCreateSoldierTime(_owner)).sub(now);
            return remainingTime;
        }
    }

    function getSpyAmount(address _owner) public view returns(uint) {
        return SpyInstance.getSpyAmount(_owner);
    }

    // return 0 if failed (maybe already creating or not enough resource) otherwise return createtime
    function startCreateSpy(uint number) public returns(uint) {
        address _owner = msg.sender;
        if(SpyInstance.ownerStartCreateTime(_owner) != 0) return uint(0); // check if there is already creating spys
        bool enoughResource;
        uint lvOfSpy;
        enoughResource = SpyInstance._createSpy(_owner, number);
        lvOfSpy =  SpyInstance.levelOfSpy(_owner);
        if(enoughResource == false) return uint(0);
        SpyInstance.setStartCreateTime(_owner, uint(now));
        SpyInstance.setCreateSpyTime(_owner, SpyInstance.createSpyTime() * lvOfSpy * number);
        return SpyInstance.ownerCreateSpyTime(_owner);
    }

    function getCreateSpyTime() public view returns(uint, uint) {
        return ( now - SpyInstance.ownerStartCreateTime(msg.sender), SpyInstance.ownerCreateSpyTime(msg.sender) ) ;
    }

    // // return 0 if success else return remaining time
    function updateCreateSpy(address _owner) public returns(uint) {
        if (SpyInstance.ownerStartCreateTime(_owner) == 0) return 0;
        if (now >= SpyInstance.ownerStartCreateTime(_owner).add(SpyInstance.ownerCreateSpyTime(_owner))) {
            uint num;
            num = SpyInstance.ownerCreateSpyTime(_owner).div(  SpyInstance.levelOfSpy(_owner).mul(SpyInstance.createSpyTime()) );
            SpyInstance.setNumOfSpy(_owner, SpyInstance.numOfSpy(_owner) + (num));
            SpyInstance.setStartCreateTime(_owner, 0);
            SpyInstance.setCreateSpyTime(_owner, 0);
            SpyInstance._updateSpyPower(_owner);
            return 0;
        }
        else {
            uint remainingTime = (SpyInstance.ownerStartCreateTime(_owner) + SpyInstance.ownerCreateSpyTime(_owner)).sub(now);
            return remainingTime;
        }
    }

    function getCannonAmount(address _owner) public view returns(uint) {
        return CannonInstance.getCannonAmount(_owner);
    }

    // return 0 if failed (maybe already creating or not enough resource) otherwise return createtime
    function startCreateCannon(uint number) public returns(uint) {
        address _owner = msg.sender;
        if(CannonInstance.ownerStartCreateTime(_owner) != 0) return uint(0); // check if there is already creating Cannons
        bool enoughResource;
        uint lvOfCannon;
        enoughResource = CannonInstance._createCannon(_owner, number);
        lvOfCannon =  CannonInstance.levelOfCannon(_owner);
        if(enoughResource == false) return uint(0);
        CannonInstance.setStartCreateTime(_owner, uint(now));
        CannonInstance.setCreateCannonTime(_owner, CannonInstance.createCannonTime() * lvOfCannon * number);
        return CannonInstance.ownerCreateCannonTime(_owner);
    }

    function getCreateCannonTime() public view returns(uint, uint) {
        return ( now - CannonInstance.ownerStartCreateTime(msg.sender), CannonInstance.ownerCreateCannonTime(msg.sender) ) ;
    }

    // // return 0 if success else return remaining time
    function updateCreateCannon(address _owner) public returns(uint) {
        if (CannonInstance.ownerStartCreateTime(_owner) == 0) return 0;
        if (now >= CannonInstance.ownerStartCreateTime(_owner).add(CannonInstance.ownerCreateCannonTime(_owner))) {
            uint num;
            num = CannonInstance.ownerCreateCannonTime(_owner).div(  CannonInstance.levelOfCannon(_owner).mul(CannonInstance.createCannonTime()) );
            CannonInstance.setNumOfCannon(_owner, CannonInstance.numOfCannon(_owner) + (num));
            CannonInstance.setStartCreateTime(_owner, 0);
            CannonInstance.setCreateCannonTime(_owner, 0);
            CannonInstance._updateCannonPower(_owner);
            return 0;
        }
        else {
            uint remainingTime = (CannonInstance.ownerStartCreateTime(_owner) + CannonInstance.ownerCreateCannonTime(_owner)).sub(now);
            return remainingTime;
        }
    }

    function getProtectorAmount(address _owner) public view returns(uint) {
        return ProtectorInstance.getProtectorAmount(_owner);
    }

    // return 0 if failed (maybe already creating or not enough resource) otherwise return createtime
    function startCreateProtector(uint number) public returns(uint) {
        address _owner = msg.sender;
        if(ProtectorInstance.ownerStartCreateTime(_owner) != 0) return uint(0); // check if there is already creating Protectors
        bool enoughResource;
        uint lvOfProtector;
        enoughResource = ProtectorInstance._createProtector(_owner, number);
        lvOfProtector =  ProtectorInstance.levelOfProtector(_owner);
        if(enoughResource == false) return uint(0);
        ProtectorInstance.setStartCreateTime(_owner, uint(now));
        ProtectorInstance.setCreateProtectorTime(_owner, ProtectorInstance.createProtectorTime() * lvOfProtector * number);
        return ProtectorInstance.ownerCreateProtectorTime(_owner);
    }

    function getCreateProtectorTime() public view returns(uint, uint) {
        return ( now - ProtectorInstance.ownerStartCreateTime(msg.sender), ProtectorInstance.ownerCreateProtectorTime(msg.sender) ) ;
    }

    // // return 0 if success else return remaining time
    // function updateCreateProtector(address _owner) public returns(uint) {
    //     if (ProtectorInstance.ownerStartCreateTime(_owner) == 0) return 0;
    //     if (now >= ProtectorInstance.ownerStartCreateTime(_owner).add(ProtectorInstance.ownerCreateProtectorTime(_owner))) {
    //         uint num;
    //         num = ProtectorInstance.ownerCreateProtectorTime(_owner).div(  ProtectorInstance.levelOfProtector(_owner).mul(ProtectorInstance.createProtectorTime()) );
    //         ProtectorInstance.setNumOfProtector(_owner, ProtectorInstance.numOfProtector(_owner) + (num));
    //         ProtectorInstance.setStartCreateTime(_owner, 0);
    //         ProtectorInstance.setCreateProtectorTime(_owner, 0);
    //         ProtectorInstance._updateProtectorPower(_owner);
    //         return 0;
    //     }
    //     else {
    //         uint remainingTime = (ProtectorInstance.ownerStartCreateTime(_owner) + ProtectorInstance.ownerCreateProtectorTime(_owner)).sub(now);
    //         return remainingTime;
    //     }
    // }

    // // return 0 if failed (maybe already creating or not enough resource) otherwise return createtime
    // function startCreateWall(uint number) public returns(uint) {
    //     address _owner = msg.sender;
    //     if(WallInstance.ownerStartCreateTime(_owner) != 0) return uint(0); // check if there is already creating Walls
    //     bool enoughResource;
    //     uint lvOfWall;
    //     enoughResource = WallInstance._createWall(_owner, number);
    //     lvOfWall =  WallInstance.levelOfWall(_owner);
    //     if(enoughResource == false) return uint(0);
    //     WallInstance.setStartCreateTime(_owner, uint(now));
    //     WallInstance.setCreateWallTime(_owner, WallInstance.createWallTime() * lvOfWall * number);
    //     return WallInstance.ownerCreateWallTime(_owner);
    // }

    // function getCreateWallTime() public view returns(uint, uint) {
    //     return ( now - WallInstance.ownerStartCreateTime(msg.sender), WallInstance.ownerCreateWallTime(msg.sender) ) ;
    // }

    // // // return 0 if success else return remaining time
    // function updateCreateWall(address _owner) public returns(uint) {
    //     if (WallInstance.ownerStartCreateTime(_owner) == 0) return 0;
    //     if (now >= WallInstance.ownerStartCreateTime(_owner).add(WallInstance.ownerCreateWallTime(_owner))) {
    //         uint num;
    //         num = WallInstance.ownerCreateWallTime(_owner).div(  WallInstance.levelOfWall(_owner).mul(WallInstance.createWallTime()) );
    //         WallInstance.setNumOfWall(_owner, WallInstance.numOfWall(_owner) + (num));
    //         WallInstance.setStartCreateTime(_owner, 0);
    //         WallInstance.setCreateWallTime(_owner, 0);
    //         // WallInstance._updateWallPower(_owner);
    //         return 0;
    //     }
    //     else {
    //         uint remainingTime = (WallInstance.ownerStartCreateTime(_owner) + WallInstance.ownerCreateWallTime(_owner)).sub(now);
    //         return remainingTime;
    //     }
    // }



    function attack(uint _ownerId, uint _attackedCastleId) public {
        // soldierInstance.attack(_ownerId, _attackedCastleId);
    }

    function startMarch(uint _attackedCastleId) public returns(uint) {
        address _owner = msg.sender;
        address attackedAddress = AccountInstance.castleToOwner(_attackedCastleId);
        Account attackedInstance = Account(attackedAddress);
        
        if(ownerStartMarchTime[_owner] != 0) return uint(0); // check if there is already Marching
        bool enoughResource;
        enoughResource = enoughResource = AccountInstance.cost(_owner, 100, uint(0), 100, uint(0), 100);
        if(enoughResource == false) return uint(0);
        ownerStartMarchTime[_owner] = uint(now);
        ownerTotalMarchTime[_owner] = 10;
        attackedInstance.setAttackedInfo(true, _owner, ownerStartMarchTime[_owner], ownerTotalMarchTime[_owner]);
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