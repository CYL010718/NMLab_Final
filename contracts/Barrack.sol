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
    string battleLog = "戰鬥開始\n" ; 

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

    function concatenate(string memory a, string memory b) public returns(string memory) {
        return string(abi.encodePacked(a, b));
    }

    function getSoldierAmount(address _owner) public view returns(uint) {
        return soldierInstance.getSoldierAmount(_owner);
    }
    

    // // return 0 if failed (maybe already creating or not enough resource) otherwise return createtime
    // function startCreateSoldier(uint number) public returns(uint) {
    //     address _owner = msg.sender;
    //     if(soldierInstance.ownerStartCreateTime(_owner) != 0) return uint(0); // check if there is already creating soldiers
    //     bool enoughResource;
    //     uint lvOfSoldier;
    //     enoughResource = soldierInstance._createSoldier(_owner, number);
    //     lvOfSoldier =  soldierInstance.levelOfSoldier(_owner);
    //     if(enoughResource == false) return uint(0);
    //     soldierInstance.setStartCreateTime(_owner, uint(now));
    //     soldierInstance.setCreateSoldierTime(_owner, soldierInstance.createSoldierTime() * lvOfSoldier * number);
    //     return soldierInstance.ownerCreateSoldierTime(_owner);
    // }

    // function getCreateSoldierTime() public view returns(uint, uint) {
    //     return ( now - soldierInstance.ownerStartCreateTime(msg.sender), soldierInstance.ownerCreateSoldierTime(msg.sender) ) ;
    // }

    // // // return 0 if success else return remaining time
    // function updateCreateSoldier(address _owner) public returns(uint) {
    //     if (soldierInstance.ownerStartCreateTime(_owner) == 0) return 0;
    //     if (now >= soldierInstance.ownerStartCreateTime(_owner).add(soldierInstance.ownerCreateSoldierTime(_owner))) {
    //         uint num;
    //         num = soldierInstance.ownerCreateSoldierTime(_owner).div(  soldierInstance.levelOfSoldier(_owner).mul(soldierInstance.createSoldierTime()) );
    //         soldierInstance.setNumOfSoldier(_owner, soldierInstance.numOfSoldier(_owner) + (num));
    //         soldierInstance.setStartCreateTime(_owner, 0);
    //         soldierInstance.setCreateSoldierTime(_owner, 0);
    //         soldierInstance._updatePower(_owner);
    //         return 0;
    //     }
    //     else {
    //         uint remainingTime = (soldierInstance.ownerStartCreateTime(_owner) + soldierInstance.ownerCreateSoldierTime(_owner)).sub(now);
    //         return remainingTime;
    //     }
    // }
    

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
        ownerTotalMarchTime[_owner] = 20;
        AccountInstance.setAttackedInfo(attackedAddress, true, _owner, ownerStartMarchTime[_owner], ownerTotalMarchTime[_owner]);
        return ownerTotalMarchTime[_owner];
    }

    function getMarchTime() public view returns(uint, uint, uint) {
        return ( ownerStartMarchTime[msg.sender], uint(now) - ownerStartMarchTime[msg.sender], ownerTotalMarchTime[msg.sender] ) ;
    }

    // // return 0 if success else return remaining time
    function updateMarch(address _owner) public returns(uint) {
        if (ownerStartMarchTime[_owner] == 0) return 0;
        if (uint(now) >= ownerStartMarchTime[_owner].add(ownerTotalMarchTime[_owner])) {
            // uint num;
            // num = ownerTotalMarchTime[_owner].div(  MarchInstance.levelOfMarch(_owner).mul(MarchInstance.createMarchTime()) );
            // MarchInstance.setNumOfMarch(_owner, MarchInstance.numOfMarch(_owner) + (num));
            ownerStartMarchTime[_owner] = 0;
            ownerTotalMarchTime[_owner] = 0;
            return 0;
        }
        else {
            uint remainingTime = (ownerStartMarchTime[_owner] + ownerTotalMarchTime[_owner]).sub(uint(now));
            return remainingTime;
        }
    }
    function is_annihilated(uint a , uint b , uint c) public returns(bool){
        if(a+b+c==0)
            return true ; 
        else 
            return false ; 
    }
    function annihilated(address id)public returns(bool){
        if(soldierInstance.getSoldierAmount(id)+ProtectorInstance.getProtectorAmount(id)+CannonInstance.getCannonAmount(id)==0){
            return true;
        }else
            return false ; 
    }
    struct battle_info{
        uint attackerLevel   ;   
        uint attackerDamage ; 
        uint attackerFrequency  ;
        uint defenderLevel  ; 
        uint defenderHealth ; 
        uint defenderArmour ; 
        uint effectiveDamage  ;  
        uint requireCulling  ; 
        uint requireKill   ; 
    }
    //fuction battle_army() 一次僅計算單一兩種兵種互打的狀況，回傳剩餘雙方士兵以及受傷士兵血量
    //attack_id : 進攻者的id
    //defend_id : 防守者id
    //attacker/defender_flag  分別用來標示攻擊與被攻擊的兵種 
    //    守護者:0 神槍手:1 火砲:2
    //attack_q :本次進攻的士兵數量，進攻後減少但不影響總兵力
    //defender_q:防守的兵種數量，被進攻後根據損失的數量改變總兵力
    //injure:用來計算受傷判定
    function battle_army(address attack_id , address defend_id , uint attacker_flag , uint defender_flag, uint attacker_q, uint defender_q, uint injure ) public returns(uint,uint,uint){
        battle_info memory info ; 
        info.attackerLevel = 0 ; 
        info.defenderLevel = 0 ; 

        if(attacker_flag == 0){
            info.attackerDamage = 40 + 4 * info.attackerLevel ; 
            info.attackerFrequency = 1 ; 
        }else if (attacker_flag == 1 ){
            info.attackerDamage = 30 + 3 * info.attackerLevel ; 
            info.attackerFrequency = 2 ; 
        }else if(attacker_flag ==2){
            info.attackerDamage = 100 + 10 * info.attackerLevel ; 
            info.attackerFrequency = 1 ;
        }
        if(defender_flag == 0){
            info.defenderHealth = 80 + 8 * info.defenderLevel ; 
            info.defenderArmour = 20 + 2 * info.defenderLevel ; 
        }else if (defender_flag == 1 ){
            info.defenderHealth = 50 + 5 * info.defenderLevel ; 
            info.defenderArmour = 10 + 1 * info.defenderLevel ; 
        }else if(defender_flag ==2){
            info.defenderHealth = 100 + 10 * info.defenderLevel ; 
            info.defenderArmour = 0 + 3 * info.defenderLevel ; 
        }
        //無效傷害
        if(info.defenderArmour >= info.attackerDamage){
            battleLog = concatenate(battleLog,"\n指定兵種護甲過高，進攻者無法造成有效傷害") ; 
            return (0,defender_q,injure) ; 
        }else{
            info.effectiveDamage = (info.attackerDamage - info.defenderArmour) * info.attackerFrequency ; 
        //  有效傷害
        //  優先撲殺受傷單位
            if(injure != info.defenderHealth ){
                //這兩行可以用ceiling直接變成一行
                if(injure % info.effectiveDamage == 0 )
                    info.requireCulling = injure / info.effectiveDamage ; 
                else    
                    info.requireCulling = injure / info.effectiveDamage + 1; 

                //可撲殺
                if(attacker_q >= info.requireCulling){
                    battleLog = concatenate(battleLog,"\n受傷單位受到擊殺") ; 
                    attacker_q -= info.requireCulling ;
                    injure = info.defenderHealth ; 
                    defender_q -= 1 ; 
                //不足以撲殺
                }else{
                    injure -= attacker_q * info.effectiveDamage ; 
                    //todo  \n{not_yet_attack}個單位進行攻擊，使受傷單位剩餘{ownSoldierRemain}生命
                    battleLog = concatenate(battleLog,"\n進攻方全體進行攻擊，使受傷單位剩餘xx生命\n進攻結束") ; 
                    attacker_q = 0  ;
                    return(0,defender_q,injure);
                }
            }
            //進行一般進攻判定
            if(attacker_q == 0){
                battleLog = concatenate(battleLog,"\n進攻結束") ;
                return (0,defender_q,injure) ; 
            }else{
                if(info.defenderHealth % info.effectiveDamage == 0 )
                    info.requireKill = info.defenderHealth / info.effectiveDamage ; 
                else    
                    info.requireKill = info.defenderHealth / info.effectiveDamage + 1; 
                //擊殺判定
                if( attacker_q / info.requireKill != 0 ){
                    //全殺
                    if(attacker_q / info.requireKill >= defender_q){
                        battleLog = concatenate(battleLog,"\n防守方全滅") ;
                        attacker_q -= info.requireKill * defender_q ; 
                        defender_q = 0 ; 
                        return (attacker_q , 0 , info.defenderHealth) ; 
                    }else{
                        battleLog = concatenate(battleLog,"\n消滅防守方xx名單位") ;
                        defender_q -= attacker_q / info.requireKill  ; 
                        attacker_q %=  info.requireKill  ;
                    }
                    if(attacker_q == 0){
                        battleLog = concatenate(battleLog,"\n進攻結束") ;
                        return (0,defender_q,info.defenderHealth) ;
                    }
                }    
                //受傷判定
                injure -= attacker_q * info.effectiveDamage ;
                battleLog = concatenate(battleLog,"\n防守單位受傷，剩餘xx生命") ; 
                battleLog = concatenate(battleLog,"\n進攻結束") ;
                attacker_q = 0 ; 
                return (attacker_q,defender_q,injure) ; 
                }
                
            }


            
    }
/*
    function battle_army(address attack_id , address defend_id , uint attacker_flag , uint defender_flag, uint attacker_q, uint defender_q, uint injure ) public returns(uint,uint,uint){
        battle_info memory info ; 
        info.attackerLevel = 0 ; 
        info.defenderLevel = 0 ; 

        /*
        uint attackerLevel = 0  ;   
        uint attackerDamage ; 
        uint attackerFrequency  ;
        uint defenderLevel = 0 ; 
        uint defenderHealth ; 
        uint defenderArmour ; 
        uint defenderInjure  ; 
        uint effectiveDamage = 0 ;  
        uint requireCulling = 0 ; 
        uint requireKill = 0 ; 
        

        // 註解部分需要修改，除蟲後改回來
        // 初始化，偽多形性
        if(attacker_flag == 0){
            //attackerLevel = ProtectorInstance.levelOfProtector(attack_id) ;
            info.attackerDamage = 40 + 4 * info.attackerLevel ; 
            info.attackerFrequency = 1 ; 
        }else if (attacker_flag == 1 ){
            //attackerLevel = soldierInstance.levelOfSoldier(attack_id) ; 
            info.attackerDamage = 30 + 3 * info.attackerLevel ; 
            info.attackerFrequency = 2 ; 
        }else if(attacker_flag ==2){
            //attackerLevel = CannonInstance.levelOfCannon(attack_id) ; 
            info.attackerDamage = 100 + 10 * info.attackerLevel ; 
            info.attackerFrequency = 1 ;
        }
        if(defender_flag == 0){
            //defenderLevel = ProtectorInstance.levelOfProtector(defend_id) ;
            info.defenderHealth = 80 + 8 * info.defenderLevel ; 
            info.defenderArmour = 20 + 2 * info.defenderLevel ; 
        }else if (defender_flag == 1 ){
            //defenderLevel = soldierInstance.levelOfSoldier(defend_id) ; 
            info.defenderHealth = 50 + 5 * info.defenderLevel ; 
            info.defenderArmour = 10 + 1 * info.defenderLevel ; 
        }else if(defender_flag ==2){
            //defendderLevel = CannonInstance.levelOfCannon(defend_id) ; 
            info.defenderHealth = 100 + 10 * info.defenderLevel ; 
            info.defenderArmour = 0 + 3 * info.defenderLevel ; 
        }
        //無效傷害
        if(info.defenderArmour >= info.attackerDamage){
            battleLog = concatenate(battleLog,"\n指定兵種護甲過高，進攻者無法造成有效傷害") ; 
            return (0,defender_q,info.defenderInjure) ; 
        }else{
            info.effectiveDamage = (info.attackerDamage - info.defenderArmour) * info.attackerFrequency ; 
        //  有效傷害
        //  優先撲殺受傷單位
            if(info.defenderInjure != info.defenderHealth ){
                //這兩行可以用ceiling直接變成一行
                if(info.defenderInjure % info.effectiveDamage == 0 )
                    info.requireCulling = info.defenderInjure / info.effectiveDamage ; 
                else    
                    info.requireCulling = info.defenderInjure / info.effectiveDamage + 1; 

                //可撲殺
                if(attacker_q >= info.requireCulling){
                    battleLog = concatenate(battleLog,"\n受傷單位受到擊殺") ; 
                    attacker_q -= info.requireCulling ;
                    info.defenderInjure = info.defenderHealth ; 
                    defender_q -= 1 ; 
                //不足以撲殺
                }else{
                    info.defenderInjure -= attacker_q * info.effectiveDamage ; 
                    //todo  \n{not_yet_attack}個單位進行攻擊，使受傷單位剩餘{ownSoldierRemain}生命
                    battleLog = concatenate(battleLog,"\n進攻方全體進行攻擊，使受傷單位剩xx生命") ; 
                    attacker_q = 0  ;
                }
            }
            //進行一般進攻判定
            if(attacker_q == 0){
                battleLog = concatenate(battleLog,"\n進攻結束") ;
                return (0,defender_q,info.defenderInjure) ; 
            }else{
                if(info.defenderHealth % info.effectiveDamage == 0 )
                    info.requireKill = info.defenderHealth / info.effectiveDamage ; 
                else    
                    info.requireKill = info.defenderHealth / info.effectiveDamage + 1; 
                //擊殺判定
                if( attacker_q / info.requireKill != 0 ){
                    //全殺
                    if(attacker_q / info.requireKill >= defender_q){
                        battleLog = concatenate(battleLog,"\n防守方全滅") ;
                        attacker_q -= info.requireKill * defender_q ; 
                        defender_q = 0 ; 
                        return (attacker_q , 0 , info.defenderHealth) ; 
                    }else{
                        battleLog = concatenate(battleLog,"\n消滅防守方xx名單位") ;
                        defender_q -= attacker_q / info.requireKill  ; 
                        attacker_q %=  info.requireKill  ;
                    }
                    if(attacker_q == 0){
                        return (0,defender_q,info.defenderHealth) ; 
                        battleLog = concatenate(battleLog,"\n進攻結束") ;
                        //battlelog += 進攻結束
                    }else{
                        //受傷判定
                        info.defenderInjure -= attacker_q * info.effectiveDamage ;
                        battleLog = concatenate(battleLog,"\n防守單位受傷，剩餘xx生命") ; 
                        battleLog = concatenate(battleLog,"\n進攻結束") ;
                        attacker_q = 0 ; 
                        return (attacker_q,defender_q,info.defenderInjure) ; 
                    }
                }
            }


            
        }
    }*/





    function attack(address _ownerId, address _attackedCastleId) public returns(uint){
        //soldierInstance.attack(_ownerId, _attackedCastleId);
        //uint ownSoldierQuantity = soldierInstance.getSoldierAmount(_ownerId);
        uint dummyQuantityAttacker ; 
        uint dummyQuantityDefender ; 
        uint ownSoldierInjure = 50 + soldierInstance.levelOfSoldier(_ownerId) * 5  ; 
        //uint ownProtectorQuantity = ProtectorInstance.getProtectorAmount(_ownerId);  
        uint ownProtectorInjure = 80 + ProtectorInstance.levelOfProtector(_ownerId) * 8  ;
        //uint ownCannonQuantity = CannonInstance.getCannonAmount(_ownerId);  
        uint ownCannonInjure = 100 + CannonInstance.levelOfCannon(_ownerId) * 10 ;
        //uint rivalSoldierQuantity = soldierInstance.getSoldierAmount(_attackedCastleId);
        uint rivalSoldierInjure = 50 + soldierInstance.levelOfSoldier(_attackedCastleId)  * 5 ;
        //uint rivalProtectorQuantity = ProtectorInstance.getProtectorAmount(_attackedCastleId); 
        uint rivalProtectorInjure = 80 + ProtectorInstance.levelOfProtector(_attackedCastleId) * 8  ;
        //uint rivalCannonQuantity = CannonInstance.getCannonAmount(_attackedCastleId);  
        uint rivalCannonInjure = 100 + CannonInstance.levelOfCannon(_attackedCastleId) * 10 ;
        //戰鬥計算用
        uint round = 0 ;  

        if( is_annihilated(CannonInstance.getCannonAmount(_attackedCastleId),soldierInstance.getSoldierAmount(_attackedCastleId),ProtectorInstance.getProtectorAmount(_attackedCastleId)) ){
            battleLog = concatenate(battleLog,"防守方無兵力，進攻方獲勝") ; 
        }
        else{
        //a barricade is set in case of infinite loop can be removed if no bug is found
        //otherwise two army fight until one is totally annihilateed
            
            while(round < 20  ){
                if( annihilated(_ownerId) ){
                    battleLog = concatenate(battleLog,"我方遭到全數殲滅，敵方防守成功") ;
                    return 1; 
                }else if(annihilated(_attackedCastleId)){
                    battleLog = concatenate(battleLog,"敵方守軍遭到全數殲滅，我方進攻獲勝") ;
                    return 1; 
                }
                round += 1 ; 
                //battleLog += 第{round}回合
                //順序上讓防守方守護者先攻->進攻方槍手->防守方槍手->進攻方槍手->防守火砲->工坊火砲

                //防守方protector先攻擊
                dummyQuantityAttacker = ProtectorInstance.getProtectorAmount(_attackedCastleId);
                if( dummyQuantityAttacker != 0  ){
                    battleLog = concatenate(battleLog,"\n敵方守衛者優先攻擊") ; 
                    dummyQuantityDefender = soldierInstance.getSoldierAmount(_ownerId) ; 
                    if( dummyQuantityDefender != 0 ){
                        battleLog = concatenate(battleLog,",攻擊進我方神槍手") ; 
                        (dummyQuantityAttacker,dummyQuantityDefender,ownSoldierInjure) = battle_army(_attackedCastleId,_ownerId,0,1,dummyQuantityAttacker,dummyQuantityDefender,ownSoldierInjure) ; 
                        soldierInstance.setNumOfSoldier(_ownerId,dummyQuantityDefender) ; 
                    }
                    // 第二優先攻擊  
                    dummyQuantityDefender = ProtectorInstance.getProtectorAmount(_ownerId) ; 
                    if( dummyQuantityAttacker != 0 && dummyQuantityDefender != 0){       
                        battleLog = concatenate(battleLog,"\n尚有進攻單位，繼續攻擊我方守衛者") ; 
                        (dummyQuantityAttacker,dummyQuantityDefender,ownProtectorInjure) = battle_army(_attackedCastleId,_ownerId,0,0,dummyQuantityAttacker,dummyQuantityDefender,ownProtectorInjure) ;
                        ProtectorInstance.setNumOfProtector(_ownerId,dummyQuantityDefender) ; 
                    }
                    // 第三優先攻擊
                    dummyQuantityDefender = CannonInstance.getCannonAmount(_ownerId) ; 
                    if( dummyQuantityAttacker != 0 && dummyQuantityDefender != 0){    
                        battleLog = concatenate(battleLog,"\n尚有進攻單位，繼續攻擊我方火砲") ;
                        (dummyQuantityAttacker,dummyQuantityDefender,ownCannonInjure) = battle_army(_attackedCastleId,_ownerId,0,2,dummyQuantityAttacker,dummyQuantityDefender,ownCannonInjure) ;    
                        CannonInstance.setNumOfCannon(_ownerId,dummyQuantityDefender) ; 
                    }
                }
                
                dummyQuantityAttacker = soldierInstance.getSoldierAmount(_ownerId);
                if( dummyQuantityAttacker != 0  ){
                    battleLog = concatenate(battleLog,"\n我方神槍手攻擊") ; 
                    dummyQuantityDefender = soldierInstance.getSoldierAmount(_attackedCastleId) ; 
                    if( dummyQuantityDefender != 0 ){
                        battleLog = concatenate(battleLog,",攻擊敵方神槍手") ; 
                        (dummyQuantityAttacker,dummyQuantityDefender,rivalSoldierInjure) = battle_army(_ownerId,_attackedCastleId,1,1,dummyQuantityAttacker,dummyQuantityDefender,rivalSoldierInjure) ; 
                        soldierInstance.setNumOfSoldier(_attackedCastleId,dummyQuantityDefender) ; 
                    }
                    // 第二優先攻擊  
                    dummyQuantityDefender = ProtectorInstance.getProtectorAmount(_attackedCastleId) ; 
                    if( dummyQuantityAttacker != 0 && dummyQuantityDefender != 0){       
                        battleLog = concatenate(battleLog,"\n尚有進攻單位，繼續攻擊敵方守衛者") ; 
                        (dummyQuantityAttacker,dummyQuantityDefender,rivalProtectorInjure) = battle_army(_ownerId,_attackedCastleId,1,0,dummyQuantityAttacker,dummyQuantityDefender,rivalProtectorInjure) ;
                        ProtectorInstance.setNumOfProtector(_attackedCastleId,dummyQuantityDefender) ; 
                    }
                    // 第三優先攻擊
                    dummyQuantityDefender = CannonInstance.getCannonAmount(_attackedCastleId) ; 
                    if( dummyQuantityAttacker != 0 && dummyQuantityDefender != 0){    
                        battleLog = concatenate(battleLog,"\n尚有進攻單位，繼續攻擊敵方火砲") ;
                        (dummyQuantityAttacker,dummyQuantityDefender,rivalCannonInjure) = battle_army(_ownerId,_attackedCastleId,1,2,dummyQuantityAttacker,dummyQuantityDefender,rivalCannonInjure) ;    
                        CannonInstance.setNumOfCannon(_attackedCastleId,dummyQuantityDefender) ; 
                    }
                }
                /*
                if( rivalSoldierQuantity != 0){

                }
                if( ownProtectorQuantity != 0){

                }
                if( rivalCannonQuantity != 0){

                }
                if( ownCannonQuantity != 0){

                }*/



            }
            

        }
    }

    function sendSpy(uint _ownerId, uint _attackedCastleId) public view returns(bool) {
        //returns TRUE if spy of myCastle > attackedCastle
        
        return SpyInstance.sendSpy(_ownerId, _attackedCastleId);
    }

}