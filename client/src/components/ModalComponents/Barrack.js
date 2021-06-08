import React, { useState, useEffect } from 'react';
import BarrackPage from './BarrackPage'
import { Button, Modal, Grid, Icon, Segment, Header, Input, Progress, Menu, Image } from 'semantic-ui-react';
import soldierpng from '../../images/soldier_noback.png';

const Barrack = ({ idx, x, y, cellState, buildingContract, barrackContract, account, updateCellState }) => {
  const [ page, setPage ] = useState(0);
  const [ level, setLevel ] = useState(1);
  const [ soldierAmount, setSoldierAmount ] = useState(0);
  const [ cannonAmount, setCannonAmount ] = useState(0);
  const [ protectorAmount, setProtectorAmount ] = useState(0);
  const [ spyAmount, setSpyAmount ] = useState(0);
  const [ upgrading, setUpgrading ] = useState(false);
  const [ upgradeProgress, setUpgradeProgress ] = useState(0);
  const [ producing, setProducing ] = useState(false);
  

  const getLevel = async () => {
    const building = await buildingContract.methods.getBuildingById(cellState.index).call({from: account});
    const exist = building[0];
    const lv = building[2];
    if(exist) {
      console.log(`level: ${lv}`);
      setLevel(lv);
    }
  }

  const getAmounts = async () => {
    const soldierNum = await barrackContract.methods.getSoldierAmount(account).call({from: account});
    const cannonNum = await barrackContract.methods.getCannonAmount(account).call({from: account});
    const protectorNum = await barrackContract.methods.getProtectorAmount(account).call({from: account});
    const spyNum = await barrackContract.methods.getSpyAmount(account).call({from: account});
    setSoldierAmount(soldierNum);
    setCannonAmount(cannonNum);
    setProtectorAmount(protectorNum);
    setSpyAmount(spyNum);
  }

  const startUpgrade = async () => {
    if(!buildingContract || !account) return;
    const upgradingId = parseInt( await buildingContract.methods.getUpgradingId(account).call({from: account}) );
    if(upgradingId !== 0 && upgradingId !== cellState.index) {
      alert("something else are upgrading now!");
      return;
    }
    await buildingContract.methods.startBuild(account, x, y).send({from: account});
    const remainTime = parseInt( await buildingContract.methods.getRemainingTime(account).call({from: account}) );
    console.log("upgrade remainTime: ", remainTime);
    const newState = { ...cellState, upgrade: [0, remainTime] };
    updateCellState(idx, newState);
  }

  const confirmUpgrade = async () => {
    await buildingContract.methods.updateBuild(account).send({from: account});
    const newState = { ...cellState, upgrade: false };
    updateCellState(idx, newState);
  }

  useEffect(() => {
    if(buildingContract && barrackContract && account) {
      getLevel();
      getAmounts();
    }
    setProducing((cellState.soldierProduce || cellState.cannonProduce || cellState.protectorProduce || cellState.spyProduce) ?true:false);
    //setProduceProgress(cellState.produce? cellState.produce[1]===0 ? 100 : cellState.produce[0]/cellState.produce[1]*100>100?100:cellState.produce[0]/cellState.produce[1]*100  : 0)
    setUpgrading(cellState.upgrade?true:false);
    setUpgradeProgress(cellState.upgrade? cellState.upgrade[1]===0 ? 100 : cellState.upgrade[0]/cellState.upgrade[1]*100>100?100:cellState.upgrade[0]/cellState.upgrade[1]*100  : 0);
  }, [buildingContract, barrackContract, account, cellState])

  return <>
    <Modal.Content image>
      <Grid columns='equal' divided padded>
        <Grid.Row centered>
          <Menu pointing secondary>
            <Menu.Item
              name='Soldier'
              active={page === 0}
              onClick={()=>setPage(0)}
            />
            <Menu.Item
              name='Cannon'
              active={page === 1}
              onClick={()=>setPage(1)}
            />
            <Menu.Item
              name='Protector'
              active={page === 2}
              onClick={()=>setPage(2)}
            />
            <Menu.Item
              name='Spy'
              active={page === 3}
              onClick={()=>setPage(3)}
            />
          </Menu>
        </Grid.Row>
        <Grid.Row stretched>
          <BarrackPage page = {page} idx = {idx} level = {level} upgrading = {upgrading} contract = {barrackContract} account = {account} cellState = {cellState} updateCellState = {updateCellState}/>
          <Grid.Column>
            <Header icon>
              Barrack
              <br/>
              <Image size='massive' src={soldierpng} />
            </Header>
            <Segment padded color='black'>
              <p>Produce Army  </p>
              <p>Soldier amount: {soldierAmount}</p>
              <p>Cannon amount: {cannonAmount}</p>
              <p>Protector amount: {protectorAmount}</p>
              <p>Spy amount: {spyAmount}</p>
            </Segment>
            {
              upgrading?
              <>
              <Header as='h4'>
                Upgrade progress
              </Header>
              <Progress progress='percent' percent={upgradeProgress} indicating />
              <div style={{textAlign: 'center'}}>
                <Button primary disabled={upgradeProgress !== 100} onClick={() => confirmUpgrade()} >comfirm upgrade</Button>
              </div>
              </>
              :
              <div style={{textAlign: 'center'}}>
                <Button primary disabled={producing} onClick={() => startUpgrade()} >start upgrade</Button>
              </div>
            }
          </Grid.Column>
        </Grid.Row>
      </Grid>
    </Modal.Content>
  </>

}

export default Barrack;