import React, { useState, useEffect, useContext } from 'react';
import { Button, Grid, Segment, Header, Input, Progress } from 'semantic-ui-react';
import { ContractContext } from '../../App';
//import soldierpng from '../../images/soldier_noback.png';

const BarrackPage = ({ page, idx, level, upgrading, account, cellState, updateCellState }) => {
    const state = useContext(ContractContext);
    const {soldierContract, cannonContract, protectorContract, spyContract, wallContract} = state;
    const [ soldierProduceAmount, setSoldierProduceAmount ] = useState(0);
    const [ cannonProduceAmount, setCannonProduceAmount ] = useState(0);
    const [ protectorProduceAmount, setProtectorProduceAmount ] = useState(0);
    const [ spyProduceAmount, setSpyProduceAmount ] = useState(0);
    const [ wallProduceAmount, setWallProduceAmount ] = useState(0);
    const [ soldierProducing, setSoldierProducing ] = useState(false);
    const [ cannonProducing, setCannonProducing ] = useState(false);
    const [ protectorProducing, setProtectorProducing ] = useState(false);
    const [ spyProducing, setSpyProducing ] = useState(false);
    const [ wallProducing, setWallProducing ] = useState(false);
    const [ soldierProduceProgress, setSoldierProduceProgress ] = useState(0);
    const [ cannonProduceProgress, setCannonProduceProgress ] = useState(0);
    const [ protectorProduceProgress, setProtectorProduceProgress ] = useState(0);
    const [ spyProduceProgress, setSpyProduceProgress ] = useState(0);
    const [ wallProduceProgress, setWallProduceProgress ] = useState(0);

    const startCreateSoldier = async () => {
        await soldierContract.methods.startCreateSoldier(soldierProduceAmount).send({from: account});
        const getCreateTime = await soldierContract.methods.getCreateSoldierTime().call({from: account});
        const nowStartPeriod = parseInt( getCreateTime[1] );
        const createTimeNeed = parseInt( getCreateTime[2] );
        console.log("createSoldier: ", nowStartPeriod, createTimeNeed);
        if(createTimeNeed === 0) {
            alert("Not enough resource!");
            return;
        }
        const newState = { ...cellState, soldierProduce: [ nowStartPeriod, createTimeNeed ]};
        setSoldierProducing(true);
        updateCellState(idx, newState);
        // const remainTime = parseInt( await contract.methods.)
    }
        
    const confirmCreateSoldier = async () => {
        await soldierContract.methods.updateCreateSoldier(account).send({from: account});
        const getCreateTime = await soldierContract.methods.getCreateSoldierTime().call({from: account});
        //const nowStartPeriod = parseInt( getCreateTime[1] );
        const createTimeNeed = parseInt( getCreateTime[2] );
        console.log(getCreateTime);
        if(createTimeNeed !== 0) {
            alert("confirm failed");
            return;
        }
        const newState = { ...cellState, soldierProduce: false };
        setSoldierProducing(false);
        updateCellState(idx, newState);
    }

    const startCreateCannon = async () => {
        await cannonContract.methods.startCreateCannon(cannonProduceAmount).send({from: account});
        const getCreateTime = await cannonContract.methods.getCreateCannonTime().call({from: account});
        const nowStartPeriod = parseInt( getCreateTime[1] );
        const createTimeNeed = parseInt( getCreateTime[2] );
        console.log(getCreateTime);
        if(createTimeNeed === 0) {
            alert("Not enough resource!");
            return;
        }
        const newState = { ...cellState, cannonProduce: [ nowStartPeriod, createTimeNeed ]};
        setCannonProducing(true);
        updateCellState(idx, newState);
        // const remainTime = parseInt( await contract.methods.)
    }
        
    const confirmCreateCannon = async () => {
        await cannonContract.methods.updateCreateCannon(account).send({from: account});
        const getCreateTime = await cannonContract.methods.getCreateCannonTime().call({from: account});
        //const nowStartPeriod = parseInt( getCreateTime[1] );
        const createTimeNeed = parseInt( getCreateTime[2] );
        console.log(getCreateTime);
        if(createTimeNeed !== 0) {
            alert("confirm failed");
            return;
        }
        const newState = { ...cellState, cannonProduce: false };
        setCannonProducing(false);
        updateCellState(idx, newState);
    }

    const startCreateProtector = async () => {
        await protectorContract.methods.startCreateProtector(protectorProduceAmount).send({from: account});
        const getCreateTime = await protectorContract.methods.getCreateProtectorTime().call({from: account});
        const nowStartPeriod = parseInt( getCreateTime[1] );
        const createTimeNeed = parseInt( getCreateTime[2] );
        console.log("createProtector: ", nowStartPeriod, createTimeNeed);
        if(createTimeNeed === 0) {
            alert("Not enough resource!");
            return;
        }
        const newState = { ...cellState, protectorProduce: [ nowStartPeriod, createTimeNeed ]};
        setProtectorProducing(true);
        updateCellState(idx, newState);
        // const remainTime = parseInt( await contract.methods.)
    }
        
    const confirmCreateProtector = async () => {
        await protectorContract.methods.updateCreateProtector(account).send({from: account});
        const getCreateTime = await protectorContract.methods.getCreateProtectorTime().call({from: account});
        const nowStartPeriod = parseInt( getCreateTime[1] );
        const createTimeNeed = parseInt( getCreateTime[2] );
        console.log("Confirm: ", nowStartPeriod, createTimeNeed);
        if(createTimeNeed !== 0) {
            alert("confirm failed");
            return;
        }
        const newState = { ...cellState, protectorProduce: false };
        setProtectorProducing(false);
        updateCellState(idx, newState);
    }

    const startCreateSpy = async () => {
        await spyContract.methods.startCreateSpy(spyProduceAmount).send({from: account});
        const getCreateTime = await spyContract.methods.getCreateSpyTime().call({from: account});
        const nowStartPeriod = parseInt( getCreateTime[1] );
        const createTimeNeed = parseInt( getCreateTime[2] );
        console.log("createSpy: ", nowStartPeriod, createTimeNeed);
        if(createTimeNeed === 0) {
            alert("Not enough resource!");
            return;
        }
        const newState = { ...cellState, spyProduce: [ nowStartPeriod, createTimeNeed ]};
        setSpyProducing(true);
        updateCellState(idx, newState);
        // const remainTime = parseInt( await contract.methods.)
    }
        
    const confirmCreateSpy = async () => {
        await spyContract.methods.updateCreateSpy(account).send({from: account});
        const getCreateTime = await spyContract.methods.getCreateSpyTime().call({from: account});
        //const nowStartPeriod = parseInt( getCreateTime[1] );
        const createTimeNeed = parseInt( getCreateTime[2] );
        if(createTimeNeed !== 0) {
            alert("confirm failed");
            return;
        }
        const newState = { ...cellState, spyProduce: false };
        setSpyProducing(false);
        updateCellState(idx, newState);
    }

    const startCreateWall = async () => {
        await wallContract.methods.startCreateWall(wallProduceAmount).send({from: account});
        const getCreateTime = await wallContract.methods.getCreateWallTime().call({from: account});
        const nowStartPeriod = parseInt( getCreateTime[1] );
        const createTimeNeed = parseInt( getCreateTime[2] );
        //console.log("createSpy: ", nowStartPeriod, createTimeNeed);
        if(createTimeNeed === 0) {
            alert("Not enough resource!");
            return;
        }
        const newState = { ...cellState, wallProduce: [ nowStartPeriod, createTimeNeed ]};
        setWallProducing(true);
        updateCellState(idx, newState);
        // const remainTime = parseInt( await contract.methods.)
    }
        
    const confirmCreateWall = async () => {
        await wallContract.methods.updateCreateWall(account).send({from: account});
        const getCreateTime = await wallContract.methods.getCreateWallTime().call({from: account});
        //const nowStartPeriod = parseInt( getCreateTime[1] );
        const createTimeNeed = parseInt( getCreateTime[2] );
        if(createTimeNeed !== 0) {
            alert("confirm failed");
            return;
        }
        const newState = { ...cellState, wallProduce: false };
        setWallProducing(false);
        updateCellState(idx, newState);
    }
    

    const updateSoldierProduce = () => {
        if(!cellState.soldierProduce){
            
            return cellState.soldierProduce;
        }
        const [ a,b ] = cellState.soldierProduce;
        if(a < b){
            console.log("Hii");
            return [a + 3, b];
        } 
        else{
            console.log(a,b);
            return [a,b];
        }  
    }

    const updateCannonProduce = () => {
        if(!cellState.cannonProduce){
            return cellState.cannonProduce;
        }
        const [ a,b ] = cellState.cannonProduce;
        if(a < b){
            return [a + 3, b];
        } 
        else{
            return [a,b];
        } 
    }

    const updateProtectorProduce = () => {
        if(!cellState.protectorProduce){
            return cellState.protectorProduce;
        }
        const [ a,b ] = cellState.protectorProduce;
        console.log(a,b);
        if(a < b){
            console.log("Hii")
            return [a + 3, b];
        } 
        else{
            console.log("Hiii")
            return [a,b];
        } 
    }

    const updateSpyProduce = () => {
        console.log(cellState.spyProduce);
        if(cellState.spyProduce === false || cellState.spyProduce === undefined){
            console.log(1);
            return cellState.spyProduce;
        }
        const [ a,b ] = cellState.spyProduce;
        if(a < b){
            console.log(2);
            return [a + 3, b];
        }
        else{
            console.log(3);
            console.log(a,b);
            return [a,b];
        } 
    }

    const updateWallProduce = () => {
        console.log(cellState.wallProduce);
        if(cellState.wallProduce === false || cellState.wallProduce === undefined){
            console.log(1);
            return cellState.wallProduce;
        }
        const [ a,b ] = cellState.wallProduce;
        if(a < b){
            console.log(2);
            return [a + 3, b];
        }
        else{
            console.log(3);
            console.log(a,b);
            return [a,b];
        } 
    }
    const updateProduce = async () => {
    
        const soldierState = await updateSoldierProduce();
        const cannonState = await updateCannonProduce();
        const protectorState = await updateProtectorProduce();
        const spyState = await updateSpyProduce();
        const wallState = await updateWallProduce();
        
        
        const newState = {...cellState, soldierProduce: soldierState, cannonProduce: cannonState, protectorProduce: protectorState, spyProduce: spyState, wallProduce: wallState};
        updateCellState(idx, newState);
    }

    useEffect(() => {
        setSoldierProducing(cellState.soldierProduce ? true : false);
        setCannonProducing(cellState.cannonProduce ? true : false);
        setProtectorProducing(cellState.protectorProduce ? true : false);
        setSpyProducing(cellState.spyProduce ? true : false);
        setWallProducing(cellState.wallProduce ? true : false);
        setSoldierProduceProgress(cellState.soldierProduce? cellState.soldierProduce[1]===0 ? 100 : cellState.soldierProduce[0]/cellState.soldierProduce[1]*100>100?100:cellState.soldierProduce[0]/cellState.soldierProduce[1]*100  : 0);
        setCannonProduceProgress(cellState.cannonProduce? cellState.cannonProduce[1]===0 ? 100 : cellState.cannonProduce[0]/cellState.cannonProduce[1]*100>100?100:cellState.cannonProduce[0]/cellState.cannonProduce[1]*100  : 0);
        setProtectorProduceProgress(cellState.protectorProduce? cellState.protectorProduce[1]===0 ? 100 : cellState.protectorProduce[0]/cellState.protectorProduce[1]*100>100?100:cellState.protectorProduce[0]/cellState.protectorProduce[1]*100  : 0);
        setSpyProduceProgress(cellState.spyProduce? cellState.spyProduce[1]===0 ? 100 : cellState.spyProduce[0]/cellState.spyProduce[1]*100>100?100:cellState.spyProduce[0]/cellState.spyProduce[1]*100  : 0);
        setWallProduceProgress(cellState.wallProduce? cellState.wallProduce[1]===0 ? 100 : cellState.wallProduce[0]/cellState.wallProduce[1]*100>100?100:cellState.wallProduce[0]/cellState.wallProduce[1]*100  : 0);
        

        console.log(cellState.spyProduce);
        var handle;
        if(cellState.soldierProduce || cellState.protectorProduce || cellState.cannonProduce || cellState.spyProduce || cellState.wallProduce){
            console.log(handle);
            handle = setTimeout(() => {
                updateProduce();
            }, 3000);
        }
        else{
            console.log("WTF");
        }
        return () => {
            clearTimeout(handle);
        }

    }, [account, cellState])
      
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

    const handleWallInputChange = (e, { value }) => {
        e.preventDefault();
        setWallProduceAmount(value);
    }

    if(page === 0){
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
                <Progress progress='percent'   percent={soldierProduceProgress} indicating/>
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
    if(page === 1){
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
                <Progress  progress='percent'  percent={cannonProduceProgress} indicating/>
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
    if(page === 2){
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
                <Progress progress='percent'  percent={protectorProduceProgress} indicating/>
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
    if(page === 3){
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
                <Progress progress='percent'  percent={spyProduceProgress} indicating/>
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
    if(page === 4){
        return <>
        <Grid.Column>
            <Header as='h4'>
                Level
            </Header>
            <Segment textAlign='center' compact color='grey' size='tiny'>
                {level}
            </Segment>
            {
                wallProducing ?
                <>
                <Header as='h4'>
                Produce wall progress
                </Header>
                <Progress progress='percent'  percent={wallProduceProgress} indicating/>
                <div style={{textAlign: 'center'}}>
                <Button disabled={wallProduceProgress !== 100} primary onClick={() => confirmCreateWall()} >
                    confirm
                </Button>
                </div>
                </>
                :
                <>
                <Header as='h4'>
                Produce Wall
                </Header>
                <Segment textAlign='center' compact color='grey' size='tiny'>
                <div>wall amount: {wallProduceAmount}</div>
                <Input
                    min={0}
                    max={10*level}
                    onChange={handleWallInputChange}
                    type='range'
                    value={wallProduceAmount}
                />
                </Segment>
                <div style={{textAlign: 'center'}}>
                <Button primary disabled={upgrading} onClick={() => startCreateWall()} >produce</Button>
                </div>
                </>
            }
        </Grid.Column>
        </>
    }
  
}

export default BarrackPage;