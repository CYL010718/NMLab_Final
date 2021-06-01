pragma solidity >=0.4.21 <0.7.0;

import "./ownable.sol";
import "./SafeMath.sol";
import "./BuildingFactory.sol";

contract Earning is Ownable, BuildingFactory {

    Account accountInstance;
    constructor(address _account_address) public {
        accountInstance = Account(_account_address);
    }
    
    uint speedUpFee = 0.002 ether;
    uint resourceFee = 0.001 ether;
    uint getResourceNum = 100;

    function withdraw() external onlyOwner {
        address payable _owner = address(uint160(owner()));
        _owner.transfer(address(this).balance);
    }

    function setSpeedUpFee(uint _fee) external onlyOwner {
        speedUpFee = _fee;
    }

    function speedupBuilding() external payable returns(uint){
        address _owner = msg.sender;
        require(msg.value == speedUpFee);
        ownerStartBuildTime[_owner] = ownerStartBuildTime[_owner] + buildings[ownerBuildingId[_owner]].level * buildTimeNeed / 2;
        return updateBuild(_owner);
    }

    function setResourceFee(uint _fee) external onlyOwner {
        resourceFee = _fee;
    }

    function getResource(string calldata _name) external payable {
        address _owner = msg.sender;
        require(msg.value == resourceFee);
        if ( keccak256(bytes(_name)) == keccak256(bytes("Stone"))) {
            accountInstance.setStoneOwnerCount(_owner, accountInstance.getStoneOwnerCount(_owner).add(getResourceNum));
        }
        else if (keccak256(bytes(_name)) == keccak256(bytes("Iron"))) {
            accountInstance.setIronOwnerCount(_owner, accountInstance.getIronOwnerCount(_owner).add(getResourceNum));
        }
        else if (keccak256(bytes(_name)) == keccak256(bytes("Food"))) {
            accountInstance.setFoodOwnerCount(_owner, accountInstance.getFoodOwnerCount(_owner).add(getResourceNum));
        }
        else if (keccak256(bytes(_name)) == keccak256(bytes("Coin"))) {
            accountInstance.setCoinOwnerCount(_owner, accountInstance.getCoinOwnerCount(_owner).add(getResourceNum));
        }
        else if (keccak256(bytes(_name)) == keccak256(bytes("Wood"))) {
            accountInstance.setWoodOwnerCount(_owner, accountInstance.getWoodOwnerCount(_owner).add(getResourceNum));
        }
    }
}