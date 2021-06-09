import React, {useState, useContext} from 'react';
import { ContractContext } from '../App';
import {
  Button,
  Divider,
  Grid,
  Header,
  Icon,
  Segment,
  Modal,
} from 'semantic-ui-react'


const BattleModal = ({ myIdx, userIdx, myPower, userPower, setMyPower, setUserPower }) => {
  const state = useContext(ContractContext);
  const {accountContract, barrackContract, accounts} = state;
  const [battled, setBattled] = useState(false);
  const [spyed, setSpyed] = useState(false);
  const [battleLog, setBattleLog] = useState("戰鬥報告\n<<第1回合>>\n\n-----------\n由進攻方9名神射手進攻\n---------");
  //const [battleResult, setBattleResult] = useState(false) 
  const [spyResult, setSpyResult] = useState(false); // True = win

  const goBattle = async () => {
    await barrackContract.methods.attack(myIdx, userIdx).send({from: accounts[0]});
    // const log = await barrackContract.methods.getBattleLog().call({from: accounts[0]});
    // const myNewPower = await accountContract.methods.getUserPowerById(myIdx).call({from: accounts[0]});
    // const userNewPower = await accountContract.methods.getUserPowerById(userIdx).call({from: accounts[0]});
    setBattled(true);
    // setBattleLog(log);
    // setMyPower(myNewPower);
    // setUserPower(userNewPower);
  }

  const sendSpy = async () => {
    const spyResult = await barrackContract.methods.sendSpy(myIdx, userIdx).call({from: accounts[0]});

    console.log("hello123")
    
    setSpyed(true);
    if(spyResult){
      const myNewPower = await accountContract.methods.getUserPowerById(myIdx).call({from: accounts[0]});
      const userNewPower = await accountContract.methods.getUserPowerById(userIdx).call({from: accounts[0]});
      setSpyResult(true);
      setMyPower(myNewPower);
      setUserPower(userNewPower);
    }
  }

  return <>
  {!battled ?
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
      <Button animated='fade' color='red' fluid inverted attached='bottom' onClick={() => goBattle()}>
        <Button.Content visible>Battle</Button.Content>
        <Button.Content hidden>
          <Icon name='fire' />
        </Button.Content>
      </Button>
       
      {
        !spyed ?
        <Button animated='fade' color='red' fluid inverted attached='bottom' onClick={() => sendSpy()}>
          <Button.Content visible>Send Spy</Button.Content>
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
        <Grid.Row stretched>
          <Grid.Column>
            {battleLog}
          </Grid.Column>
        </Grid.Row>
      </Grid>
    </Modal.Content>}
  </>
}

export default BattleModal;