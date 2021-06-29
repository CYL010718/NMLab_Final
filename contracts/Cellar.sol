pragma solidity >=0.4.21 <0.7.0;

import "./SafeMath.sol";
import "./Castle.sol";

contract CellarFactory is CastleFactory {
    
    using SafeMath for uint;

    //Account accountInstance;
    constructor(address _account_address) public {
        accountInstance = Account(_account_address);
    }
    
    mapping (address => uint) OwnerSaveWood;
    mapping (address => uint) OwnerSaveIron;
    mapping (address => uint) OwnerSaveFood;
    mapping (address => uint) OwnerSaveCoin;
    mapping (address => uint) OwnerSaveStone;
    uint SaveResourceAbility = 100;
    
    function _createCellar(uint _x, uint _y) public {
        _createBuilding(msg.sender, "Cellar", _x, _y);
    }

    function _saveResource(address _owner) internal {
        uint[] memory cellars = getSpecificBuildingByOwner(_owner, "Cellar");
        for (uint i = 0; i < cellars.length; i++) {
            uint saveAmount = buildings[cellars[i]].level * SaveResourceAbility;
            if (accountInstance.getStoneOwnerCount(_owner) <= saveAmount) {
                OwnerSaveStone[_owner] = OwnerSaveStone[_owner].add(accountInstance.getStoneOwnerCount(_owner));
                accountInstance.setStoneOwnerCount(_owner, 0);
            }
            else{
                accountInstance.setStoneOwnerCount(_owner, accountInstance.getStoneOwnerCount(_owner).sub(saveAmount));
                OwnerSaveStone[_owner] = OwnerSaveStone[_owner].add(saveAmount);
            }
            if (accountInstance.getIronOwnerCount(_owner) <= saveAmount) {
                OwnerSaveIron[_owner] = OwnerSaveIron[_owner].add(accountInstance.getIronOwnerCount(_owner));
                accountInstance.setIronOwnerCount(_owner, 0);
            }
            else{
                accountInstance.setIronOwnerCount(_owner, accountInstance.getIronOwnerCount(_owner).sub(saveAmount));
                OwnerSaveIron[_owner] = OwnerSaveIron[_owner].add(saveAmount);
            }
            if (accountInstance.getFoodOwnerCount(_owner) <= saveAmount) {
                OwnerSaveFood[_owner] = OwnerSaveFood[_owner].add(accountInstance.getFoodOwnerCount(_owner));
                accountInstance.setFoodOwnerCount(_owner, 0);
            }
            else{
                accountInstance.setFoodOwnerCount(_owner, accountInstance.getFoodOwnerCount(_owner).sub(saveAmount));
                OwnerSaveFood[_owner] = OwnerSaveFood[_owner].add(saveAmount);
            }
            if (accountInstance.getCoinOwnerCount(_owner) <= saveAmount) {
                OwnerSaveCoin[_owner] = OwnerSaveCoin[_owner].add(accountInstance.getCoinOwnerCount(_owner));
                accountInstance.setCoinOwnerCount(_owner, 0);
            }
            else{
                accountInstance.setCoinOwnerCount(_owner, accountInstance.getCoinOwnerCount(_owner).sub(saveAmount));
                OwnerSaveCoin[_owner] = OwnerSaveCoin[_owner].add(saveAmount);
            }
            if (accountInstance.getWoodOwnerCount(_owner) <= saveAmount) {
                OwnerSaveWood[_owner] = OwnerSaveWood[_owner].add(accountInstance.getWoodOwnerCount(_owner));
                accountInstance.setWoodOwnerCount(_owner, 0);
            }
            else{
                accountInstance.setWoodOwnerCount(_owner, accountInstance.getWoodOwnerCount(_owner).sub(saveAmount));
                OwnerSaveWood[_owner] = OwnerSaveWood[_owner].add(saveAmount);
            }
        }           
    }

    function _takeResource(address _owner) internal {
        accountInstance.setStoneOwnerCount(_owner, accountInstance.getStoneOwnerCount(_owner).add(OwnerSaveStone[_owner]));
        OwnerSaveStone[_owner] = 0;
        accountInstance.setIronOwnerCount(_owner, accountInstance.getIronOwnerCount(_owner).sub(OwnerSaveIron[_owner]));
        OwnerSaveIron[_owner] = 0;
        accountInstance.setFoodOwnerCount(_owner, accountInstance.getFoodOwnerCount(_owner).sub(OwnerSaveFood[_owner]));
        OwnerSaveFood[_owner] = 0;
        accountInstance.setCoinOwnerCount(_owner, accountInstance.getCoinOwnerCount(_owner).sub(OwnerSaveCoin[_owner]));
        OwnerSaveCoin[_owner] = 0;
        accountInstance.setWoodOwnerCount(_owner, accountInstance.getWoodOwnerCount(_owner).sub(OwnerSaveWood[_owner]));
        OwnerSaveWood[_owner] = 0;        
    }
}