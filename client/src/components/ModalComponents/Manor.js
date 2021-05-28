import React, { useState, useEffect } from 'react';
import { Button, Modal, Grid, Icon, Segment, Header, Progress, Image } from 'semantic-ui-react';
import coinpng from '../../images/coin_noback.png';

const PRODUCTION_RATE = 10;

const Manor = ({ idx, x, y, cellState, contract, account, updateCellState }) => {
  const [ level, setLevel ] = useState(1);
  const [ upgrading, setUpgrading ] = useState(false);
  const [ upgradeProgress, setUpgradeProgress ] = useState(0);

  const getLevel = async() => {
    const building = await contract.methods.getBuildingById(cellState.index).call({from: account});
    const exist = building[0];
    const lv = building[2];
    if(exist) {
      console.log(`level: ${lv}`);
      setLevel(lv);
    }
  }

  const startUpgrade = async () => {
    if(!contract || !account) return;
    const upgradingId = parseInt( await contract.methods.getUpgradingId(account).call({from: account}) );
    if(upgradingId !== 0 && upgradingId !== cellState.index) {
      alert("something else are upgrading now!");
      return;
    }
    await contract.methods.startBuild(account, x, y).send({from: account});
    const remainTime = parseInt( await contract.methods.getRemainingTime(account).call({from: account}) );
    console.log("upgrade remainTime: ", remainTime);
    const newState = { ...cellState, upgrade: [0, remainTime] };
    updateCellState(idx, newState);
  }

  const confirmUpgrade = async () => {
    await contract.methods.updateBuild(account).send({from: account});
    const newState = { ...cellState, upgrade: false };
    updateCellState(idx, newState);
  }

  useEffect(() => {
    if(contract && account) {
      getLevel()
    }
    setUpgrading(cellState.upgrade?true:false);
    setUpgradeProgress(cellState.upgrade? cellState.upgrade[1]===0 ? 100 : cellState.upgrade[0]/cellState.upgrade[1]*100>100?100:cellState.upgrade[0]/cellState.upgrade[1]*100  : 0);
  }, [contract, account, cellState])

  return <>
    <Modal.Content image>
      <Grid columns='equal' divided padded>
        <Grid.Row stretched>
          <Grid.Column>
              <Header as='h4'>
                Level
              </Header>
              <Segment textAlign='center' compact color='yellow' size='tiny'>
                {level}
              </Segment>
              <Header as='h4'>
                Production rate
              </Header>
              <Segment textAlign='center' compact color='yellow' size='tiny'>
                {level*PRODUCTION_RATE}
              </Segment>
          </Grid.Column>
          <Grid.Column>
            <Header icon>
              Manor
              <br/>
              <Image size='massive' src={coinpng} />
            </Header>
            <Segment padded color='yellow'>
              <p>produce coin</p>
            </Segment>
            {
              upgrading?
              <>
              <Header as='h4'>
                Upgrade progress
              </Header>
              <Progress percent={upgradeProgress} indicating />
              <div style={{textAlign: 'center'}}>
                <Button primary disabled={upgradeProgress !== 100} onClick={() => confirmUpgrade()} >comfirm upgrade</Button>
              </div>
              </>
              :
              <div style={{textAlign: 'center'}}>
                <Button primary onClick={() => startUpgrade()} >start upgrade</Button>
              </div>
            }
          </Grid.Column>
        </Grid.Row>
      </Grid>
    </Modal.Content>
  </>
}

export default Manor;