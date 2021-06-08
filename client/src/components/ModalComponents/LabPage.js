import React, { useState, useEffect } from 'react';
import { Button, Modal, Grid, Icon, Segment, Header, Input, Progress, Image, GridColumn } from 'semantic-ui-react';
import soldierpng from '../../images/soldier_noback.png';

const LabPage = ({ idx, contract, account, cellState, updateCellState }) => {
    const [ soldierUpgrading, setSoldierUpgrading ] = useState(false);
    const [ cannonUpgrading, setCannonUpgrading ] = useState(false);
    const [ protectorUpgrading, setProtectorUpgrading ] = useState(false);
    const [ spyUpgrading, setSpyUpgrading ] = useState(false);
    const [ soldierUpgradeProgress, setSoldierUpgradeProgress ] = useState(0);
    const [ cannonUpgradeProgress, setCannonUpgradeProgress ] = useState(0);
    const [ protectorUpgradeProgress, setProtectorUpgradeProgress ] = useState(0);
    const [ spyUpgradeProgress, setSpyUpgradeProgress ] = useState(0);
    const [ soldierLevel, setSoldierLevel ] = useState(1);
    const [ cannonLevel, setCannonLevel ] = useState(1);
    const [ protectorLevel, setProtectorLevel ] = useState(1);
    const [ spyLevel, setSpyLevel ] = useState(1);

    const getLevels = async () => {
        const levelOfSoldier = await contract.methods.getSoldierLevel().call({from: account});
        const levelOfCannon = await contract.methods.getCannonLevel().call({from:account});
        const levelOfProtector = await contract.methods.getProtectorLevel().call({from: account});
        const levelOfSpy = await contract.methods.getSpyLevel().call({from:account});

        setSoldierLevel(levelOfSoldier);
        setCannonLevel(levelOfCannon);
        setProtectorLevel(levelOfProtector);
        setSpyLevel(levelOfSpy);
    }

    const startUpgradeSoldier = async () => {
        await contract.methods.startUpgradeSoldier().send({from: account});
        const getUpgradeTime = await contract.methods.getUpgradeSoldierTime().call({from: account});
        const nowStartPeriod = parseInt( getUpgradeTime[0] );
        const UpgradeTimeNeed = parseInt( getUpgradeTime[1] );
        console.log("upgradeSoldier: ", nowStartPeriod, UpgradeTimeNeed);
        if(UpgradeTimeNeed == 0) {
            alert("Not enough resource!");
            return;
        }
        const newState = { ...cellState, soldier: [ nowStartPeriod, UpgradeTimeNeed ]};
        setSoldierUpgrading(true);
        updateCellState(idx, newState);
        // const remainTime = parseInt( await contract.methods.)
    }
        
    const confirmUpgradeSoldier = async () => {
        await contract.methods.updateUpgradeSoldier(account).send({from: account});
        const getUpgradeTime = await contract.methods.getUpgradeSoldierTime().call({from: account});
        const nowStartPeriod = parseInt( getUpgradeTime[0] );
        const UpgradeTimeNeed = parseInt( getUpgradeTime[1] );
        if(UpgradeTimeNeed != 0) {
            alert("confirm failed");
            return;
        }
        const newState = { ...cellState, soldierUpgrade: false };
        setSoldierUpgrading(false);
        updateCellState(idx, newState);
    }

    const startUpgradeCannon = async () => {
        await contract.methods.startUpgradeCannon().send({from: account});
        const getUpgradeTime = await contract.methods.getUpgradeCannonTime().call({from: account});
        const nowStartPeriod = parseInt( getUpgradeTime[0] );
        const UpgradeTimeNeed = parseInt( getUpgradeTime[1] );
        console.log("UpgradeCannon: ", nowStartPeriod, UpgradeTimeNeed);
        if(UpgradeTimeNeed == 0) {
            alert("Not enough resource!");
            return;
        }
        const newState = { ...cellState, cannonUpgrade: [ nowStartPeriod, UpgradeTimeNeed ]};
        setCannonUpgrading(true);
        updateCellState(idx, newState);
        // const remainTime = parseInt( await contract.methods.)
    }
        
    const confirmUpgradeCannon = async () => {
        await contract.methods.updateUpgradeCannon(account).send({from: account});
        const getUpgradeTime = await contract.methods.getUpgradeCannonTime().call({from: account});
        const nowStartPeriod = parseInt( getUpgradeTime[0] );
        const UpgradeTimeNeed = parseInt( getUpgradeTime[1] );
        if(UpgradeTimeNeed != 0) {
            alert("confirm failed");
            return;
        }
        const newState = { ...cellState, cannonUpgrade: false };
        setCannonUpgrading(false);
        updateCellState(idx, newState);
    }

    const startUpgradeProtector = async () => {
        await contract.methods.startUpgradeProtector().send({from: account});
        const getUpgradeTime = await contract.methods.getUpgradeProtectorTime().call({from: account});
        const nowStartPeriod = parseInt( getUpgradeTime[0] );
        const UpgradeTimeNeed = parseInt( getUpgradeTime[1] );
        console.log("UpgradeProtector: ", nowStartPeriod, UpgradeTimeNeed);
        if(UpgradeTimeNeed == 0) {
            alert("Not enough resource!");
            return;
        }
        const newState = { ...cellState, protectorUpgrade: [ nowStartPeriod, UpgradeTimeNeed ]};
        setProtectorUpgrading(true);
        updateCellState(idx, newState);
        // const remainTime = parseInt( await contract.methods.)
    }
        
    const confirmUpgradeProtector = async () => {
        await contract.methods.updateUpgradeProtector(account).send({from: account});
        const getUpgradeTime = await contract.methods.getUpgradeProtectorTime().call({from: account});
        const nowStartPeriod = parseInt( getUpgradeTime[0] );
        const UpgradeTimeNeed = parseInt( getUpgradeTime[1] );
        console.log("Confirm: ", nowStartPeriod, UpgradeTimeNeed);
        if(UpgradeTimeNeed != 0) {
            alert("confirm failed");
            return;
        }
        const newState = { ...cellState, protectorUpgrade: false };
        setProtectorUpgrading(false);
        updateCellState(idx, newState);
    }

    const startUpgradeSpy = async () => {
        await contract.methods.startUpgradeSpy().send({from: account});
        const getUpgradeTime = await contract.methods.getUpgradeSpyTime().call({from: account});
        const nowStartPeriod = parseInt( getUpgradeTime[0] );
        const UpgradeTimeNeed = parseInt( getUpgradeTime[1] );
        console.log("UpgradeSpy: ", nowStartPeriod, UpgradeTimeNeed);
        if(UpgradeTimeNeed == 0) {
            alert("Not enough resource!");
            return;
        }
        const newState = { ...cellState, spyUpgrade: [ nowStartPeriod, UpgradeTimeNeed ]};
        setSpyUpgrading(true);
        updateCellState(idx, newState);
        // const remainTime = parseInt( await contract.methods.)
    }
        
    const confirmUpgradeSpy = async () => {
        await contract.methods.updateUpgradeSpy(account).send({from: account});
        const getUpgradeTime = await contract.methods.getUpgradeSpyTime().call({from: account});
        const nowStartPeriod = parseInt( getUpgradeTime[0] );
        const UpgradeTimeNeed = parseInt( getUpgradeTime[1] );
        if(UpgradeTimeNeed != 0) {
            alert("confirm failed");
            return;
        }
        const newState = { ...cellState, spyUpgrade: false };
        setSpyUpgrading(false);
        updateCellState(idx, newState);
    }
    

    const updateSoldierUpgrade = () => {
        if(!cellState.soldierUpgrade){
            
            return cellState.soldierUpgrade;
        }
        const [ a,b ] = cellState.soldierUpgrade;
        if(a < b){
            console.log("Hii");
            return [a + 3, b];
            const newState = { ...cellState, soldierUpgrade: [a + 3, b]};
            updateCellState(idx, newState);
        } 
        else{
            console.log(a,b);
            return [a,b];
        }  
    }

    const updateCannonUpgrade = () => {
        if(!cellState.cannonUpgrade){
            return cellState.cannonUpgrade;
        }
        const [ a,b ] = cellState.cannonUpgrade;
        if(a < b){
            return [a + 3, b];
            const newState = { ...cellState, cannonUpgrade: [a + 3, b]};
            updateCellState(idx, newState);
        } 
        else{
            return [a,b];
        } 
    }

    const updateProtectorUpgrade = () => {
        if(!cellState.protectorUpgrade){
            return cellState.protectorUpgrade;
        }
        const [ a,b ] = cellState.protectorUpgrade;
        console.log(a,b);
        if(a < b){
            console.log("Hii")
            return [a + 3, b];
            const newState = { ...cellState, protectorUpgrade: [a + 3, b]};
            updateCellState(idx, newState);
        } 
        else{
            console.log("Hiii")
            return [a,b];
        } 
    }

    const updateSpyUpgrade = () => {
        console.log(cellState.spyUpgrade);
        if(cellState.spyUpgrade === false || cellState.spyUpgrade === undefined){
            console.log(1);
            return cellState.spyUpgrade;
        }
        const [ a,b ] = cellState.spyUpgrade;
        if(a < b){
            console.log(2);
            return [a + 3, b];
            const newState = { ...cellState, spyUpgrade: [a + 3, b]};
            updateCellState(idx, newState);
        }
        else{
            console.log(3);
            console.log(a,b);
            return [a,b];
        } 
    }
    const updateUpgrade = async () => {
    
        const soldierState = await updateSoldierUpgrade();
        const cannonState = await updateCannonUpgrade();
        const protectorState = await updateProtectorUpgrade();
        const spyState = await updateSpyUpgrade();
        
        
        const newState = {...cellState, soldierUpgrade: soldierState, cannonUpgrade: cannonState, protectorUpgrade: protectorState, spyUpgrade: spyState};
        updateCellState(idx, newState);
    }

    useEffect(() => {
        setSoldierUpgrading(cellState.soldierUpgrade ? true : false);
        setCannonUpgrading(cellState.cannonUpgrade ? true : false);
        setProtectorUpgrading(cellState.protectorUpgrade ? true : false);
        setSpyUpgrading(cellState.spyUpgrade ? true : false);
        setSoldierUpgradeProgress(cellState.soldierUpgrade? cellState.soldierUpgrade[1]===0 ? 100 : cellState.soldierUpgrade[0]/cellState.soldierUpgrade[1]*100>100?100:cellState.soldierUpgrade[0]/cellState.soldierUpgrade[1]*100  : 0);
        setCannonUpgradeProgress(cellState.cannonUpgrade? cellState.cannonUpgrade[1]===0 ? 100 : cellState.cannonUpgrade[0]/cellState.cannonUpgrade[1]*100>100?100:cellState.cannonUpgrade[0]/cellState.cannonUpgrade[1]*100  : 0);
        setProtectorUpgradeProgress(cellState.protectorUpgrade? cellState.protectorUpgrade[1]===0 ? 100 : cellState.protectorUpgrade[0]/cellState.protectorUpgrade[1]*100>100?100:cellState.protectorUpgrade[0]/cellState.protectorUpgrade[1]*100  : 0);
        setSpyUpgradeProgress(cellState.spyUpgrade? cellState.spyUpgrade[1]===0 ? 100 : cellState.spyUpgrade[0]/cellState.spyUpgrade[1]*100>100?100:cellState.spyUpgrade[0]/cellState.spyUpgrade[1]*100  : 0);
        
        getLevels();

        console.log(cellState.spyUpgrade);
        var handle;
        if(cellState.soldierUpgrade || cellState.protectorUpgrade || cellState.cannonUpgrade || cellState.spyUpgrade){
            //console.log(cellState.spyUpgrade);
            //console.log(handle);
            handle = setTimeout(() => {
                console.log(cellState.spyUpgrade);
                updateUpgrade();
            }, 3000);
        }
        else{
            console.log("WTF");
        }
        return () => {
            clearTimeout(handle);
        }

    }, [contract, account, cellState])
      

    
    return <>
        <Grid.Column>
            {
                soldierUpgrading ?
                <>
                <Header as='h4'>
                Upgrade Progress
                </Header>
                <Progress percent={soldierUpgradeProgress} indicating />
                <div style={{textAlign: 'center'}}>
                <Button disabled={soldierUpgradeProgress !== 100} primary onClick={() => confirmUpgradeSoldier()} >
                    confirm
                </Button>
                </div>
                </>
                :
                <>
                <div style={{textAlign: 'center'}}>
                    <Header as='h4'>
                        Soldier Technology Level: {soldierLevel 
                    </Header>
                    <Button primary disabled={upgrading} onClick={() => startUpgradeSoldier()} >Upgrade</Button>
                </div>
                </>
            }
       
            {
                cannonUpgrading ?
                <>
                <Header as='h4'>
                Upgrade Progress
                </Header>
                <Progress percent={cannonUpgradeProgress} indicating />
                <div style={{textAlign: 'center'}}>
                <Button disabled={cannonUpgradeProgress !== 100} primary onClick={() => confirmUpgradeCannon()} >
                    confirm
                </Button>
                </div>
                </>
                :
                <>
                <div style={{textAlign: 'center'}}>
                    <Header as='h4'>
                        Cannon Technology Level: {cannonLevel}
                    </Header>
                    <Button primary disabled={upgrading} onClick={() => startUpgradeCannon()} >Upgrade</Button>
                </div>
                </>
            }
         
            {
                protectorUpgrading ?
                <>
                <Header as='h4'>
                Upgrade Progress
                </Header>
                <Progress percent={protectorUpgradeProgress} indicating />
                <div style={{textAlign: 'center'}}>
                <Button disabled={protectorUpgradeProgress !== 100} primary onClick={() => confirmUpgradeProtector()} >
                    confirm
                </Button>
                </div>
                </>
                :
                <>
                <div style={{textAlign: 'center'}}>
                    <Header as='h4'>
                        Protector Technology Level: {protectorLevel}
                    </Header>
                    <Button primary disabled={upgrading} onClick={() => startUpgradeProtector()} >Upgrade</Button>
                </div>
                </>
            }
        
            {
                spyUpgrading ?
                <>
                <Header as='h4'>
                Upgrade Progress
                </Header>
                <Progress percent={spyUpgradeProgress} indicating />
                <div style={{textAlign: 'center'}}>
                <Button disabled={spyUpgradeProgress !== 100} primary onClick={() => confirmUpgradeSpy()} >
                    confirm
                </Button>
                </div>
                </>
                :
                <>
                <div style={{textAlign: 'center'}}>
                    <Header as='h4'>
                        Spy Technology Level: {spyLevel}
                    </Header>
                    <Button primary disabled={upgrading} onClick={() => startUpgradeSpy()} >Upgrade</Button>
                </div>
                </>
            }
        </Grid.Column>
    </>
    
  
}

export default LabPage;