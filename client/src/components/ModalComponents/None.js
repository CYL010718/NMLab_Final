import React from 'react';
import {  Modal, Grid } from 'semantic-ui-react';
import { Page } from './index'

const None = ({ upgradingIdx, idx, x, y, produceContract, buildingContract, barrackContract, labContract, account, updateCellState, page }) => {
  //const [ page, setPage ] = useState(0);

  const build = async (buildType) => {
    if(!buildingContract || !barrackContract && !account) {
      alert("please wait a minute and try again");
      return;
    }
    if(upgradingIdx !== 0) {
      console.log(upgradingIdx);
      alert("something upgrading!");
      return;
    }
    let newBuildingId;
    // const {  } = contractB.methods;
    switch (buildType) {
      case "Sawmill":
        newBuildingId = await produceContract.methods.createBuilding(account, "Sawmill", x, y).send({from: account});
        break;
      case "Farm":
        newBuildingId = await produceContract.methods.createBuilding(account, "Farm", x, y).send({from: account});
        break;
      case "Mine":
        newBuildingId = await produceContract.methods.createBuilding(account, "Mine", x, y).send({from: account});
        break;
      case "Quarry":
        newBuildingId = await produceContract.methods.createBuilding(account, "Quarry", x, y).send({from: account});
        break;
      case "Manor":
        newBuildingId = await produceContract.methods.createBuilding(account, "Manor", x, y).send({from: account});
        break;
      case "Barrack":
        /*
        const haveBuilding = await contract.methods.getSpecificBuildingByOwner(account, "Barrack").call({from:account});
        if(haveBuilding.length > 0) {
          alert("Already have Barrack!");
          break;
        }
        */
        newBuildingId = await barrackContract.methods.createBarrack(x, y).send({from: account});
        break;
      case "Laboratory":
        const haveBarrack = await buildingContract.methods.getSpecificBuildingByOwner(account, "Barrack").call({from:account});
        if(haveBarrack.length === 0){
          alert("Does not have a barrack! Build barrack before laboratory!")
          break;
        }
        newBuildingId = await labContract.methods.createLaboratory(x, y).send({from: account});
        break;
      default:
        console.alert("invalid buildingType");
        break;
    }
    const building = await buildingContract.methods.getBuildingByOwner(account, x, y).call({from: account});
    const loadIndex = parseInt(building[0]);
    const loadType = building[1];
    const newState = { type: loadType, index:loadIndex, others: null }
    updateCellState(idx, newState);
    const buildingLen = await buildingContract.methods.getBuildingsLen().call({from: account});
    console.log(buildingLen);
  }

  return <>
    <Modal.Content image>
      <Grid columns='equal' divided inverted padded>
        <Grid.Row>
          <Page page={page} build={build}/>
        </Grid.Row>
      </Grid>
    </Modal.Content>
  </>
}

export default None;