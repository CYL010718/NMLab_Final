import React, { useState, useEffect } from 'react';
import { Button, Modal, Grid, Icon, Segment, Header, Input, Progress, Image } from 'semantic-ui-react';
import spypng from '../../images/soldier_noback.png';

const Laboratory = ({ idx, x, y, cellState, contract, account, updateCellState }) => {
  const [ level, setLevel ] = useState(1);
  const [ spyAmount, setSpyAmount ] = useState(0);
  const [ upgrading, setUpgrading ] = useState(false);
  const [ upgradeProgress, setUpgradeProgress ] = useState(0);
  const [ produceAmount, setProduceAmount ] = useState(0);
  const [ producing, setProducing ] = useState(false);
  const [ produceProgress, setProduceProgress ] = useState(0);

  const getLevel = async () => {
    const building = await contract.methods.getBuildingById(cellState.index).call({from: account});
    const exist = building[0];
    const lv = building[2];
    if(exist) {
      console.log(`level: ${lv}`);
      setLevel(lv);
    }
  }

  const getSpyAmount = async () => {
    const getSA = await contract.methods.getSpyAmount(account).call({from: account});
    setSpyAmount(getSA);
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
    const newState = { ...cellState, produce: [ nowStartPeriod, createTimeNeed ]};
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
    const newState = { ...cellState, produce: false };
    updateCellState(idx, newState);
  }

  useEffect(() => {
    if(contract && account) {
      getLevel();
      getSpyAmount();
    }
    setProducing(cellState.produce?true:false);
    setProduceProgress(cellState.produce? cellState.produce[1]===0 ? 100 : cellState.produce[0]/cellState.produce[1]*100>100?100:cellState.produce[0]/cellState.produce[1]*100  : 0)
    setUpgrading(cellState.upgrade?true:false);
    setUpgradeProgress(cellState.upgrade? cellState.upgrade[1]===0 ? 100 : cellState.upgrade[0]/cellState.upgrade[1]*100>100?100:cellState.upgrade[0]/cellState.upgrade[1]*100  : 0);
  }, [contract, account, cellState])

  const handleInputChange = (e, { value }) => {
    e.preventDefault();
    setProduceAmount(value);
  }

  return <>
    <Modal.Content image>
      <Grid columns='equal' divided padded>
        <Grid.Row stretched>
          <Grid.Column>
            <Header as='h4'>
              Level
            </Header>
            <Segment textAlign='center' compact color='grey' size='tiny'>
              {level}
            </Segment>
            {
              producing ?
              <>
              <Header as='h4'>
                Produce spy progress
              </Header>
              <Progress percent={produceProgress} indicating />
              <div style={{textAlign: 'center'}}>
                <Button disabled={produceProgress !== 100} primary onClick={() => confirmCreateSpy()} >
                  confirm spy
                </Button>
              </div>
              </>
              :
              <>
              <Header as='h4'>
                Produce Spy
              </Header>
              <Segment textAlign='center' compact color='grey' size='tiny'>
                <div>spy amount: {produceAmount}</div>
                <Input
                  min={0}
                  max={10*level}
                  onChange={handleInputChange}
                  type='range'
                  value={produceAmount}
                />
              </Segment>
              <div style={{textAlign: 'center'}}>
                <Button primary disabled={upgrading} onClick={() => startCreateSpy()} >produce</Button>
              </div>
              </>
            }
          </Grid.Column>
          <Grid.Column>
            <Header icon>
              Laboratory
              <br/>
              <Image size='massive' src={spypng} />
            </Header>
            <Segment padded color='black'>
              <p>Produce Spy  </p>
              <p>Spy amount: {spyAmount}</p>
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
                <Button primary disabled={producing} onClick={() => startUpgrade()} >start upgrade</Button>
              </div>
            }
          </Grid.Column>
        </Grid.Row>
      </Grid>
    </Modal.Content>
  </>

}

export default Laboratory;