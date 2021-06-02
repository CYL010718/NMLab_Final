pragma solidity >=0.4.21 <0.7.0;

import "./SafeMath.sol";
import "./Quarry.sol";
import "./Mine.sol";
import "./FarmFactory.sol";
import "./Manor.sol";
import "./Sawmill.sol";
import "./BuildingFactory.sol";

contract Produce {
    FarmFactory farmInstance;
    Manor manorInstance;
    Sawmill sawmillInstance;
    Mine mineInstance;
    Quarry quarryInstance;
    BuildingFactory buildingInstance;
    constructor(address _farm_address, address _manor_address, address _sawmill_instance, address _mine_instance, address _quarry_instance, address _building_address) public {
        farmInstance = FarmFactory(_farm_address);
        manorInstance = Manor(_manor_address);
        sawmillInstance = Sawmill(_sawmill_instance);
        quarryInstance = Quarry(_quarry_instance);
        mineInstance = Mine(_mine_instance);
        buildingInstance = BuildingFactory(_building_address);
    }





    function updateProduce(address _owner) public {
        manorInstance._updateProduceCoin(_owner);
        mineInstance._updateProduceIron(_owner);
        farmInstance._updateProduceFood(_owner);
        quarryInstance._updateProduceStone(_owner);
        sawmillInstance._updateProduceWood(_owner);
    }

    function createBuilding(address _owner, string memory _name, uint _x, uint _y) public {
        buildingInstance._createBuilding(_owner, _name, _x, _y);
        if (keccak256(bytes(_name)) == keccak256(bytes("Farm"))) {
            farmInstance._updateProduceFood(_owner);
        }
        else if (keccak256(bytes(_name)) == keccak256(bytes("Mine"))) {
            mineInstance._updateProduceIron(_owner);
        }
        else if (keccak256(bytes(_name)) == keccak256(bytes("Manor"))) {
            manorInstance._updateProduceCoin(_owner);
        }
        else if (keccak256(bytes(_name)) == keccak256(bytes("Quarry"))) {
            quarryInstance._updateProduceStone(_owner);
        }
        else if (keccak256(bytes(_name)) == keccak256(bytes("Sawmill"))) {
            sawmillInstance._updateProduceWood(_owner);
        }
    }

}