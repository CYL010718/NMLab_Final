pragma solidity >=0.4.21 <0.7.0;

import "./SafeMath.sol";

contract Account {
    using SafeMath for uint;

    mapping (address => uint) public stoneOwnerCount;
    mapping (address => uint) public ironOwnerCount;
    mapping (address => uint) public foodOwnerCount;
    mapping (address => uint) public coinOwnerCount;
    mapping (address => uint) public woodOwnerCount;
    mapping (address => uint) public power;
    uint public kingdomAmount;

    mapping (uint => address) public castleToOwner;
    mapping (address => uint) public ownerCastleCount;

    uint IdDigits = 16;
    uint IdModulus = 10 ** IdDigits;

    function checkUserAddress() public view returns(bool) {
        if(ownerCastleCount[msg.sender] > 0) return true;
        return false;
    }

    function getMyIdx() public view returns(uint) {
        for (uint i=0; i<kingdomAmount; ++i) {
            if(castleToOwner[i] == msg.sender) {
                return i;
            }
        }
        return kingdomAmount;
    }

    function getUserPower(uint idx) public view returns(uint) {
        if(idx < kingdomAmount) {
            return power[castleToOwner[idx]];
        }
        return 0;
    }

    function getKingdomAmount() public view returns(uint) {
        return kingdomAmount;
    }

    // for web to create castle
    function _initializeKingdom(address _owner) internal {
        require(ownerCastleCount[_owner] == 0);
        castleToOwner[kingdomAmount] = _owner;
        kingdomAmount++;
        ownerCastleCount[_owner]++;
        foodOwnerCount[_owner] = 10000;
        woodOwnerCount[_owner] = 10000;
        stoneOwnerCount[_owner] = 10000;
        ironOwnerCount[_owner] = 10000;
        coinOwnerCount[_owner] = 10000;
        power[_owner] = 0;
    }

    function _cost(address _owner, uint food, uint wood, uint iron, uint stone, uint coin) internal returns (bool){
        if(foodOwnerCount[_owner]>=food && woodOwnerCount[_owner]>=wood && ironOwnerCount[_owner]>=iron && stoneOwnerCount[_owner]>=stone && coinOwnerCount[_owner]>=coin){
            foodOwnerCount[_owner] = foodOwnerCount[_owner].sub(food);
            woodOwnerCount[_owner] = woodOwnerCount[_owner].sub(wood);
            ironOwnerCount[_owner] = ironOwnerCount[_owner].sub(iron);
            stoneOwnerCount[_owner] = stoneOwnerCount[_owner].sub(stone);
            coinOwnerCount[_owner] = coinOwnerCount[_owner].sub(coin);
            return true;
        }
        return false;
    }

    function getFoodAmount() public view returns(uint) {
        return foodOwnerCount[msg.sender];
    }

    function getIronAmount() public view returns(uint) {
        return ironOwnerCount[msg.sender];
    }

    function getStoneAmount() public view returns(uint) {
        return stoneOwnerCount[msg.sender];
    }

    function getCoinAmount() public view returns(uint) {
        return coinOwnerCount[msg.sender];
    }

    function getWoodAmount() public view returns(uint) {
        return woodOwnerCount[msg.sender];
    }
}