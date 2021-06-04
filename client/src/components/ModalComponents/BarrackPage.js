import React, { useState, useEffect } from 'react';
import { Button, Modal, Grid, Icon, Segment, Header, Input, Progress, Image } from 'semantic-ui-react';
import soldierpng from '../../images/soldier_noback.png';

const BarrackPage = ({ page, level, upgrading, contract, cellState, updateCellState }) => {
    const [ soldierProduceAmount, setSoldierProduceAmount ] = useState(0);
    const [ cannonProduceAmount, setCannonProduceAmount ] = useState(0);
    const [ protectorProduceAmount, setProtectorProduceAmount ] = useState(0);
    const [ spyProduceAmount, setSpyProduceAmount ] = useState(0);
    const [ soldierProducing, setSoldierProducing ] = useState(false);
    const [ cannonProducing, setCannonProducing ] = useState(false);
    const [ protectorProducing, setProtectorProducing ] = useState(false);
    const [ spyProducing, setSpyProducing ] = useState(false);
    const [ soldierProduceProgress, setSoldierProduceProgress ] = useState(0);
    const [ cannonProduceProgress, setCannonProduceProgress ] = useState(0);
    const [ protectorProduceProgress, setProtectorProduceProgress ] = useState(0);
    const [ spyProduceProgress, setSpyProduceProgress ] = useState(0);

    const startCreateSoldier = async () => {
        await contract.methods.startCreateSoldier(produceAmount).send({from: account});
        const getCreateTime = await contract.methods.getCreateSoldierTime().call({from: account});
        const nowStartPeriod = parseInt( getCreateTime[0] );
        const createTimeNeed = parseInt( getCreateTime[1] );
        console.log("createSoldier: ", nowStartPeriod, createTimeNeed);
        if(createTimeNeed == 0) {
            alert("Not enough resource!");
            return;
        }
        const newState = { ...cellState, soldierProduce: [ nowStartPeriod, createTimeNeed ]};
        updateCellState(idx, newState);
        // const remainTime = parseInt( await contract.methods.)
    }
        
    const confirmCreateSoldier = async () => {
        await contract.methods.updateCreateSoldier(account).send({from: account});
        const getCreateTime = await contract.methods.getCreateSoldierTime().call({from: account});
        const nowStartPeriod = parseInt( getCreateTime[0] );
        const createTimeNeed = parseInt( getCreateTime[1] );
        if(createTimeNeed != 0) {
            alert("confirm failed");
            return;
        }
        const newState = { ...cellState, soldierProduce: false };
        updateCellState(idx, newState);
    }

    const startCreateCannon = async () => {
        await contract.methods.startCreateCannon(produceAmount).send({from: account});
        const getCreateTime = await contract.methods.getCreateCannonTime().call({from: account});
        const nowStartPeriod = parseInt( getCreateTime[0] );
        const createTimeNeed = parseInt( getCreateTime[1] );
        console.log("createCannon: ", nowStartPeriod, createTimeNeed);
        if(createTimeNeed == 0) {
            alert("Not enough resource!");
            return;
        }
        const newState = { ...cellState, cannonProduce: [ nowStartPeriod, createTimeNeed ]};
        updateCellState(idx, newState);
        // const remainTime = parseInt( await contract.methods.)
    }
        
    const confirmCreateCannon = async () => {
        await contract.methods.updateCreateCannon(account).send({from: account});
        const getCreateTime = await contract.methods.getCreateCannonTime().call({from: account});
        const nowStartPeriod = parseInt( getCreateTime[0] );
        const createTimeNeed = parseInt( getCreateTime[1] );
        if(createTimeNeed != 0) {
            alert("confirm failed");
            return;
        }
        const newState = { ...cellState, cannonProduce: false };
        updateCellState(idx, newState);
    }

    const startCreateProtector = async () => {
        await contract.methods.startCreateProtector(produceAmount).send({from: account});
        const getCreateTime = await contract.methods.getCreateProtectorTime().call({from: account});
        const nowStartPeriod = parseInt( getCreateTime[0] );
        const createTimeNeed = parseInt( getCreateTime[1] );
        console.log("createProtector: ", nowStartPeriod, createTimeNeed);
        if(createTimeNeed == 0) {
            alert("Not enough resource!");
            return;
        }
        const newState = { ...cellState, protectorProduce: [ nowStartPeriod, createTimeNeed ]};
        updateCellState(idx, newState);
        // const remainTime = parseInt( await contract.methods.)
    }
        
    const confirmCreateProtector = async () => {
        await contract.methods.updateCreateProtector(account).send({from: account});
        const getCreateTime = await contract.methods.getCreateProtectorTime().call({from: account});
        const nowStartPeriod = parseInt( getCreateTime[0] );
        const createTimeNeed = parseInt( getCreateTime[1] );
        if(createTimeNeed != 0) {
            alert("confirm failed");
            return;
        }
        const newState = { ...cellState, protectorProduce: false };
        updateCellState(idx, newState);
    }

    const startCreateSpy = async () => {
        await contract.methods.startCreateSpy(produceAmount).send({from: account});
        const getCreateTime = await contract.methods.getCreateSpyTime().call({from: account});
        const nowStartPeriod = parseInt( getCreateTime[0] );
        const createTimeNeed = parseInt( getCreateTime[1] );
        console.log("createSpy: ", nowStartPeriod, createTimeNeed);
        if(createTimeNeed == 0) {
            alert("Not enough resource!");
            return;
        }
        const newState = { ...cellState, spyProduce: [ nowStartPeriod, createTimeNeed ]};
        updateCellState(idx, newState);
        // const remainTime = parseInt( await contract.methods.)
    }
        
    const confirmCreateSpy = async () => {
        await contract.methods.updateCreateSpy(account).send({from: account});
        const getCreateTime = await contract.methods.getCreateSpyTime().call({from: account});
        const nowStartPeriod = parseInt( getCreateTime[0] );
        const createTimeNeed = parseInt( getCreateTime[1] );
        if(createTimeNeed != 0) {
            alert("confirm failed");
            return;
        }
        const newState = { ...cellState, spyProduce: false };
        updateCellState(idx, newState);
    }

    useEffect(() => {
        if(buildingContract && barrackContract && account) {
          getLevel();
          getAmounts();
        }
        setSoldierProducing(cellState.soldierProduce ? true : false);
        setCannonProducing(cellState.cannonProduce ? true : false);
        setProtectorProducing(cellState.protectorProduce ? true : false);
        setSpyProducing(cellState.spyProduce ? true : false);
        setSoldierProduceProgress(cellState.soldierProduce? cellState.soldierProduce[1]===0 ? 100 : cellState.soldierProduce[0]/cellState.soldierProduce[1]*100>100?100:cellState.soldierProduce[0]/cellState.soldierProduce[1]*100  : 0);
        setCannonProduceProgress(cellState.cannonProduce? cellState.cannonProduce[1]===0 ? 100 : cellState.cannonProduce[0]/cellState.cannonProduce[1]*100>100?100:cellState.cannonProduce[0]/cellState.cannonProduce[1]*100  : 0);
        setProtectorProduceProgress(cellState.protectorProduce? cellState.protectorProduce[1]===0 ? 100 : cellState.protectorProduce[0]/cellState.protectorProduce[1]*100>100?100:cellState.protectorProduce[0]/cellState.protectorProduce[1]*100  : 0);
        setSpyProduceProgress(cellState.spyProduce? cellState.spyProduce[1]===0 ? 100 : cellState.soldierProduce[0]/cellState.spyProduce[1]*100>100?100:cellState.spyProduce[0]/cellState.spyProduce[1]*100  : 0);
    }, [contract, account, cellState])
      
    const handleSoldierInputChange = (e, { value }) => {
        e.preventDefault();
        setSoldierProduceAmount(value);
    }

    const handleCannonInputChange = (e, { value }) => {
        e.preventDefault();
        setCannonProduceAmount(value);
    }

    const handleProtectorInputChange = (e, { value }) => {
        e.preventDefault();
        setProtectorProduceAmount(value);
    }

    const handleSpyInputChange = (e, { value }) => {
        e.preventDefault();
        setSpyProduceAmount(value);
    }

    if(page == 0){
        return <>
        <Grid.Column>
            <Header as='h4'>
                Level
            </Header>
            <Segment textAlign='center' compact color='grey' size='tiny'>
                {level}
            </Segment>
            {
                soldierProducing ?
                <>
                <Header as='h4'>
                Produce soldier progress
                </Header>
                <Progress percent={soldierProduceProgress} indicating />
                <div style={{textAlign: 'center'}}>
                <Button disabled={soldierProduceProgress !== 100} primary onClick={() => confirmCreateSoldier()} >
                    confirm
                </Button>
                </div>
                </>
                :
                <>
                <Header as='h4'>
                Produce Soldier
                </Header>
                <Segment textAlign='center' compact color='grey' size='tiny'>
                <div>soldier amount: {soldierProduceAmount}</div>
                <Input
                    min={0}
                    max={10*level}
                    onChange={handleSoldierInputChange}
                    type='range'
                    value={soldierProduceAmount}
                />
                </Segment>
                <div style={{textAlign: 'center'}}>
                <Button primary disabled={upgrading} onClick={() => startCreateSoldier()} >produce</Button>
                </div>
                </>
            }
        </Grid.Column>
        </>
    } 
    if(page == 1){
        return <>
        <Grid.Column>
            <Header as='h4'>
                Level
            </Header>
            <Segment textAlign='center' compact color='grey' size='tiny'>
                {level}
            </Segment>
            {
                cannonProducing ?
                <>
                <Header as='h4'>
                Produce cannon progress
                </Header>
                <Progress percent={cannonProduceProgress} indicating />
                <div style={{textAlign: 'center'}}>
                <Button disabled={cannonProduceProgress !== 100} primary onClick={() => confirmCreateCannon()} >
                    confirm
                </Button>
                </div>
                </>
                :
                <>
                <Header as='h4'>
                Produce Cannon
                </Header>
                <Segment textAlign='center' compact color='grey' size='tiny'>
                <div>cannon amount: {cannonProduceAmount}</div>
                <Input
                    min={0}
                    max={10*level}
                    onChange={handleCannonInputChange}
                    type='range'
                    value={cannonProduceAmount}
                />
                </Segment>
                <div style={{textAlign: 'center'}}>
                <Button primary disabled={upgrading} onClick={() => startCreateCannon()} >produce</Button>
                </div>
                </>
            }
        </Grid.Column>
        </>
    }
    if(page == 2){
        return <>
        <Grid.Column>
            <Header as='h4'>
                Level
            </Header>
            <Segment textAlign='center' compact color='grey' size='tiny'>
                {level}
            </Segment>
            {
                protectorProducing ?
                <>
                <Header as='h4'>
                Produce protector progress
                </Header>
                <Progress percent={protectorProduceProgress} indicating />
                <div style={{textAlign: 'center'}}>
                <Button disabled={protectorProduceProgress !== 100} primary onClick={() => confirmCreateProtector()} >
                    confirm
                </Button>
                </div>
                </>
                :
                <>
                <Header as='h4'>
                Produce Protector
                </Header>
                <Segment textAlign='center' compact color='grey' size='tiny'>
                <div>protector amount: {protectorProduceAmount}</div>
                <Input
                    min={0}
                    max={10*level}
                    onChange={handleProtectorInputChange}
                    type='range'
                    value={protectorProduceAmount}
                />
                </Segment>
                <div style={{textAlign: 'center'}}>
                <Button primary disabled={upgrading} onClick={() => startCreateProtector()} >produce</Button>
                </div>
                </>
            }
        </Grid.Column>
        </>
    }
    if(page == 3){
        return <>
        <Grid.Column>
            <Header as='h4'>
                Level
            </Header>
            <Segment textAlign='center' compact color='grey' size='tiny'>
                {level}
            </Segment>
            {
                spyProducing ?
                <>
                <Header as='h4'>
                Produce spy progress
                </Header>
                <Progress percent={spyProduceProgress} indicating />
                <div style={{textAlign: 'center'}}>
                <Button disabled={spyProduceProgress !== 100} primary onClick={() => confirmCreateSpy()} >
                    confirm
                </Button>
                </div>
                </>
                :
                <>
                <Header as='h4'>
                Produce Spy
                </Header>
                <Segment textAlign='center' compact color='grey' size='tiny'>
                <div>spy amount: {spyProduceAmount}</div>
                <Input
                    min={0}
                    max={10*level}
                    onChange={handleSpyInputChange}
                    type='range'
                    value={spyProduceAmount}
                />
                </Segment>
                <div style={{textAlign: 'center'}}>
                <Button primary disabled={upgrading} onClick={() => startCreateSpy()} >produce</Button>
                </div>
                </>
            }
        </Grid.Column>
        </>
    } 
  
}

export default BarrackPage;