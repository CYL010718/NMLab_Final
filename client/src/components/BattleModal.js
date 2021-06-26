import React, {useState, useEffect, useContext} from 'react';
import { ContractContext } from '../App';
import {
  Button,
  Divider,
  Grid,
  Header,
  Icon,
  Segment,
  Modal,
  Progress
} from 'semantic-ui-react'


const BattleModal = ({ myIdx, userIdx, myPower, userPower, setMyPower, setUserPower, spyedList, setSpyedList }) => {
  const state = useContext(ContractContext);
  const {accountContract, barrackContract, accounts} = state;
  const [initialized, setInitialize] = useState(false);
  const [battled, setBattled] = useState(false);
  const [spyed, setSpyed] = useState(false);
  const [marching, setMarching] = useState(false);
  const [marchProgress, setMarchProgress] = useState(0);
  const [marchPeriod, setMarchPeriod] = useState(0);
  const [marchTimeNeed, setMarchTimeNeed] = useState(0);
  
  const [battleLog, setBattleLog] = useState([]);  
  //const [battleResult, setBattleResult] = useState(false) 
  const [spyResult, setSpyResult] = useState(false); // True = win

  console.log(battleLog);
  const march = async() => {
    await barrackContract.methods.startMarch(userIdx).send({from: accounts[0]});
    const getMarchTime = await barrackContract.methods.getMarchTime().call({from: accounts[0]});
    const nowStartPeriod = parseInt( getMarchTime[1] );
    const marchingTimeNeed = parseInt( getMarchTime[2] );
    //console.log("createSoldier: ", nowStartPeriod, createTimeNeed);
    if(marchingTimeNeed === 0) {
        alert("Not enough resource!");
        return;
    }
    setMarching(true);
    setMarchPeriod(nowStartPeriod);
    setMarchTimeNeed(marchingTimeNeed)
  }

  const sliceBattleLog = async (log) => {
    let logAry = [];
    while(log.search("\n") !== -1){
      await logAry.push(log.slice(0, log.search("\n")));
      log = log.slice(log.search("\n") + 1);
    }
    logAry.push(log);
    console.log(logAry);
    return logAry
  }
  const goBattle = async () => {
    console.log("Battle");
    await barrackContract.methods.attack(myIdx, userIdx).send({from: accounts[0]});
    //await barrackContract.methods.updateMarch(accounts[0]).send({from: accounts[0]});
    const log = await barrackContract.methods.getBattleLog().call({from: accounts[0]});
    const myNewPower = await accountContract.methods.getUserPowerById(myIdx).call({from: accounts[0]});
    const userNewPower = await accountContract.methods.getUserPowerById(userIdx).call({from: accounts[0]});
    setBattled(true);
    setMarching(false);
    setMarchPeriod(0);
    setMarchTimeNeed(0);
    const returnLog = await sliceBattleLog(log);
    setBattleLog(returnLog);
    //battleLog.push(returnLog);
    console.log(battleLog);
    //setBattleLog(log);
    setMyPower(myNewPower);
    setUserPower(userNewPower);
  }

  const sendSpy = async () => {
    console.log(accounts);
    console.log(barrackContract);
    const spyResult = await barrackContract.methods.sendSpy(myIdx, userIdx).call({from: accounts[0]});

    setSpyed(true);
    if(spyResult){
      const myNewPower = await accountContract.methods.getUserPowerById(myIdx).call({from: accounts[0]});
      const userNewPower = await accountContract.methods.getUserPowerById(userIdx).call({from: accounts[0]});
      setSpyResult(true);
      setSpyedList([...spyedList.slice(0, userIdx), true, ...spyedList.slice(userIdx + 1)]);
      console.log(spyedList)
      console.log([...spyedList.slice(0, userIdx), true, ...spyedList.slice(userIdx + 1)]);
      setMyPower(myNewPower);
      setUserPower(userNewPower);
    }
  }
  const updateMarch = () => {
    console.log("updating march")
    if(!marching){
      console.log("???")
      return 
    }
    if(marchPeriod < marchTimeNeed){
        setMarchPeriod(marchPeriod + 3);
    }
    else {
      console.log("goBattle")
      //goBattle();
    }
  }

  useEffect(() => {
    const init = async () => {

      const getMarchTime = await barrackContract.methods.getMarchTime().call({from: accounts[0]});
      const startMarchTime = parseInt( getMarchTime[0] );
      const totalMarchTimeNeed = parseInt( getMarchTime[2] );
      console.log(getMarchTime);
      console.log(parseInt(Date.now() / 1000));
      if(totalMarchTimeNeed > 0) {
        await setMarching(true);
        await setMarchPeriod(parseInt(Date.now() / 1000) - startMarchTime);
        await setMarchTimeNeed(totalMarchTimeNeed);
        return true;
      }
      await setMarchPeriod(parseInt(Date.now() / 1000) - startMarchTime);
      await setMarchTimeNeed(totalMarchTimeNeed);
      return false;
    }
    
    const update = async () => {
      if(!initialized) {
        const marchingValue = await init();
        if(marchingValue) {
          await setMarching(true);
          console.log("marching?", marching)
          setMarchProgress(marching ? marchTimeNeed === 0 ? 100 : marchPeriod/marchTimeNeed*100 > 100 ? 
            100:marchPeriod/ marchTimeNeed*100 : 0);
          handle = setTimeout(() => {
            updateMarch();
          }, 3000);
        }
        await setInitialize(true);
        return
      }
      else{
        setMarchProgress(marching ? marchTimeNeed === 0 ? 100 : marchPeriod/marchTimeNeed*100 > 100 ? 
          100:marchPeriod/ marchTimeNeed*100: 0);
        console.log("marching?", marching)
        if(marching) {
          handle = setTimeout(() => {
            updateMarch();
          }, 3000);
        }
      }

      
    }

    var handle;
    update();

    return () => {
      clearTimeout(handle);
    }
  }, [state, marchPeriod, marchTimeNeed])
/*
  const outputLog = battleLog.map((log, idx) => {
    //console.log(log);
    return <div key = {idx}> {log} </div>
  });
  console.log(outputLog);
  */
  return <>
  { battled ? 
    <Modal.Content>
      <Grid columns='equal' divided padded>
        <Grid.Row stretch = "true">
          <Grid.Column textAlign = "center">
            <div>
              {
                battleLog.map((log, idx) => {
                  return <p key = {idx}> {log} </p>
                })
                
              }
            </div>
          </Grid.Column>
        </Grid.Row>
      </Grid>
    </Modal.Content>
    :
    !marching ?
    <Modal.Content>
      <Segment placeholder>
        <Grid columns={2} stackable textAlign='center'>
          <Divider vertical>VS</Divider>
          <Grid.Row verticalAlign='middle'>
            <Grid.Column>
              <Header icon>
                <Icon name='user' />
                You
              </Header>

              <div>
                {
                  ["Power: ",
                    myPower === -1 ?
                    <Icon key="loading" loading name='spinner' />
                    :
                    `${myPower}`
                  ]
                }
              </div>
            </Grid.Column>

            <Grid.Column>
              <Header icon>
                <Icon name='user secret' />
                Enemy
              </Header>
              <div>
              <div>
                {
                  ["Power: ",
                    userPower === -1 ?
                    <Icon key="loading" loading name='spinner' />
                    :
                    `${userPower}`
                  ]
                }
              </div>
              </div>
            </Grid.Column>
          </Grid.Row>
        </Grid>
      </Segment>
      <Button animated='fade' color='red' fluid inverted attached='bottom' onClick={() => march()}>
        <Button.Content visible>Attack</Button.Content>
        <Button.Content hidden>
          <Icon name='fire' />
        </Button.Content>
      </Button>
       
      {
        !spyed ?
        <Button animated='fade' color='red' fluid inverted attached='bottom' onClick={() => sendSpy()}>
          <Button.Content visible >Send Spy</Button.Content>
          <Button.Content hidden>
            <Icon name='fire' />
          </Button.Content>
        </Button>
        :
        spyResult?
        <Button positive fluid>
          spy success!
        </Button>
        :
        <Button negative fluid>
          spy failed!
        </Button>
      }
    </Modal.Content>
    :
    <Modal.Content>
      <Grid columns='equal' divided padded>
        <Grid.Row stretch = "true">
          <Grid.Column>
            <Header as='h4' textAlign='center'>
              March progress
            </Header>
            <Progress progress='percent'  percent={marchProgress} indicating/>
            <div style={{textAlign: 'center'}}>
              <Button disabled={marchProgress !== 100} primary onClick={() => goBattle()} >
                  Attack!
              </Button>
            </div>
          </Grid.Column>
        </Grid.Row>
      </Grid>
    </Modal.Content>
    
    }
  </>
}

export default BattleModal;


/*
 battleLog.map((log, idx) => {
                return <div key = {idx}> {log} </div>
              })
*/
