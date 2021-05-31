import React, { useState } from 'react';
import { Button, Modal, Grid, Icon, Segment, Header, Menu, Pagination } from 'semantic-ui-react';
import { Page, BarrackPage, LabPage } from './index'

const None = ({ upgradingIdx, idx, x, y, contract, account, updateCellState }) => {
  const [ page, setPage ] = useState(0);

  const build = async (buildType) => {
    if(!contract || !account) {
      alert("please wait a minute and try again");
      return;
    }
    if(upgradingIdx !== 0) {
      console.log(upgradingIdx);
      alert("something upgrading!");
      return;
    }
    let newBuildingId;
    const { createSawmill, createFarm, createMine, createQuarry, createManor, createLaboratory } = contract.methods;
    // const {  } = contractB.methods;
    switch (buildType) {
      case "Sawmill":
        newBuildingId = await createSawmill(x, y).send({from: account});
        break;
      case "Farm":
        newBuildingId = await createFarm(x, y).send({from: account});
        break;
      case "Mine":
        newBuildingId = await createMine(x, y).send({from: account});
        break;
      case "Quarry":
        newBuildingId = await createQuarry(x, y).send({from: account});
        break;
      case "Manor":
        newBuildingId = await createManor(x, y).send({from: account});
        break;
      default:
        console.alert("invalid buildingType");
        break;
    }
    const building = await contract.methods.getBuildingByOwner(account, x, y).call({from: account});
    const loadIndex = parseInt(building[0]);
    const loadType = building[1];
    const newState = { type: loadType, index:loadIndex, others: null }
    updateCellState(idx, newState);
    //const buildingLen = await contract.methods.getBuildingsLen().call({from: account});
    //console.log(buildingLen);
  }

  return <>
    <Modal.Content image>
      <Grid columns='equal' divided inverted padded>
        <Grid.Row centered>
          <Menu pointing secondary>
            <Menu.Item
              name='Resource'
              active={page === 0}
              onClick={()=>setPage(0)}
            />
          </Menu>
        </Grid.Row>
        <Grid.Row>
          <Page build={build}/>
        </Grid.Row>
      </Grid>
    </Modal.Content>
  </>
}

const BarrackNone = ({ upgradingIdx, idx, x, y, contract, account, updateCellState }) => {
  
  const build = async (buildType) => {
    if(!contract || !account) {
      alert("please wait a minute and try again");
      return;
    }
    if(upgradingIdx !== 0) {
      console.log(upgradingIdx);
      alert("something upgrading!");
      return;
    }
    let newBuildingId;
    const { createBarrack } = contract.methods;
    // const {  } = contractB.methods;
    if(buildType === "Barrack"){
        const haveBuilding = await contract.methods.getSpecificBuildingByOwner(account, "Barrack").call({from:account});
        if(haveBuilding.length > 0) {
          alert("Already have Barrack!");
        }
        newBuildingId = await createBarrack(x, y).send({from: account});
    }
    else{
        console.alert("invalid buildingType");
    }   

    const building = await contract.methods.getBuildingByOwner(account, x, y).call({from: account});
    const loadIndex = parseInt(building[0]);
    const loadType = building[1];
    const newState = { type: loadType, index:loadIndex, others: null }
    updateCellState(idx, newState);
    //const buildingLen = await contract.methods.getBuildingsLen().call({from: account});
    //console.log(buildingLen);
  }

  return <>
    <Modal.Content image>
      <Grid columns='equal' divided inverted padded>
        <Grid.Row centered>
          <Menu pointing secondary>
            <Menu.Item name='Barrack'/>
          </Menu>
        </Grid.Row>
        <Grid.Row>
          <BarrackPage build={build}/>
        </Grid.Row>
      </Grid>
    </Modal.Content>
  </>
}

const LabNone = ({ upgradingIdx, idx, x, y, contract, account, updateCellState }) => {
  const build = async (buildType) => {
    if(!contract || !account) {
      alert("please wait a minute and try again");
      return;
    }
    if(upgradingIdx !== 0) {
      console.log(upgradingIdx);
      alert("something upgrading!");
      return;
    }
    let newBuildingId;
    const { createLaboratory } = contract.methods;
    // const {  } = contractB.methods;
    if(buildType === "Laboratory"){
        const haveBuilding = await contract.methods.getSpecificBuildingByOwner(account, "Laboratory").call({from:account});
        if(haveBuilding.length > 0) {
          alert("Already have Lab!");
        }
        newBuildingId = await createLaboratory(x, y).send({from: account});
    }
    else{
        console.alert("invalid buildingType");
    }   

    const building = await contract.methods.getBuildingByOwner(account, x, y).call({from: account});
    const loadIndex = parseInt(building[0]);
    const loadType = building[1];
    const newState = { type: loadType, index:loadIndex, others: null }
    updateCellState(idx, newState);
    //const buildingLen = await contract.methods.getBuildingsLen().call({from: account});
    //console.log(buildingLen);
  }

  return <>
    <Modal.Content image>
      <Grid columns='equal' divided inverted padded>
        <Grid.Row centered>
          <Menu pointing secondary>
            <Menu.Item name='Laboratory'/>
          </Menu>
        </Grid.Row>
        <Grid.Row>
          <LabPage build={build}/>
        </Grid.Row>
      </Grid>
    </Modal.Content>
  </>
}


export {None, BarrackNone, LabNone};