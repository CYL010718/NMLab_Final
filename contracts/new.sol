contract Barrack {
    string battleLog = "戰鬥開始\n" ; 
    //for string concat
    function concatenate(string memory a, string memory b) public returns(string memory) {
        return string(abi.encodePacked(a, b));
    }
    //this two function do exactly same thing , second was created inoreder to cope with stack too deep problem.can be merge Later.  
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
    //deal with stack too depp
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
}