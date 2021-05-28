pragma solidity >=0.4.21 <0.7.0;

import "./SafeMath.sol";
import "./BuildingFactory.sol";

contract CastleFactory is BuildingFactory {

    using SafeMath for uint;
    
    function createCastle(uint _x, uint _y) public {
        _createBuilding(msg.sender, "Castle", _x, _y);
        _initializeKingdom(msg.sender);
        castleLevel[msg.sender] = 1;
    }


    modifier lessThanCastle(address _owner, uint _buildingID) {
        require(buildings[_buildingID].level.add(1) <= castleLevel[_owner]);
        _;
    }
}