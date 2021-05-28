pragma solidity >=0.4.21 <0.7.0;

import "./SafeMath.sol";
import "./Castle.sol";

contract CellarFactory is CastleFactory {
    
    using SafeMath for uint;
    
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
            if (stoneOwnerCount[_owner] <= saveAmount) {
                OwnerSaveStone[_owner] = OwnerSaveStone[_owner].add(stoneOwnerCount[_owner]);
                stoneOwnerCount[_owner] = 0;
            }
            else{
                stoneOwnerCount[_owner] = stoneOwnerCount[_owner].sub(saveAmount);
                OwnerSaveStone[_owner] = OwnerSaveStone[_owner].add(saveAmount);
            }
            if (ironOwnerCount[_owner] <= saveAmount) {
                OwnerSaveIron[_owner] = OwnerSaveIron[_owner].add(ironOwnerCount[_owner]);
                ironOwnerCount[_owner] = 0;
            }
            else{
                ironOwnerCount[_owner] = ironOwnerCount[_owner].sub(saveAmount);
                OwnerSaveIron[_owner] = OwnerSaveIron[_owner].add(saveAmount);
            }
            if (foodOwnerCount[_owner] <= saveAmount) {
                OwnerSaveFood[_owner] = OwnerSaveFood[_owner].add(foodOwnerCount[_owner]);
                foodOwnerCount[_owner] = 0;
            }
            else{
                foodOwnerCount[_owner] = foodOwnerCount[_owner].sub(saveAmount);
                OwnerSaveFood[_owner] = OwnerSaveFood[_owner].add(saveAmount);
            }
            if (coinOwnerCount[_owner] <= saveAmount) {
                OwnerSaveCoin[_owner] = OwnerSaveCoin[_owner].add(coinOwnerCount[_owner]);
                coinOwnerCount[_owner] = 0;
            }
            else{
                coinOwnerCount[_owner] = coinOwnerCount[_owner].sub(saveAmount);
                OwnerSaveCoin[_owner] = OwnerSaveCoin[_owner].add(saveAmount);
            }
            if (woodOwnerCount[_owner] <= saveAmount) {
                OwnerSaveWood[_owner] = OwnerSaveWood[_owner].add(woodOwnerCount[_owner]);
                woodOwnerCount[_owner] = 0;
            }
            else{
                woodOwnerCount[_owner] = woodOwnerCount[_owner].sub(saveAmount);
                OwnerSaveWood[_owner] = OwnerSaveWood[_owner].add(saveAmount);
            }
        }           
    }

    function _takeResource(address _owner) internal {
        stoneOwnerCount[_owner] = stoneOwnerCount[_owner].add(OwnerSaveStone[_owner]);
        OwnerSaveStone[_owner] = 0;
        ironOwnerCount[_owner] = ironOwnerCount[_owner].sub(OwnerSaveIron[_owner]);
        OwnerSaveIron[_owner] = 0;
        foodOwnerCount[_owner] = foodOwnerCount[_owner].sub(OwnerSaveFood[_owner]);
        OwnerSaveFood[_owner] = 0;
        coinOwnerCount[_owner] = coinOwnerCount[_owner].sub(OwnerSaveCoin[_owner]);
        OwnerSaveCoin[_owner] = 0;
        woodOwnerCount[_owner] = woodOwnerCount[_owner].sub(OwnerSaveWood[_owner]);
        OwnerSaveWood[_owner] = 0;        
    }
}