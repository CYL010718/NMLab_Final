import React from 'react';
import {
  Button,
  Divider,
  Grid,
  Header,
  Icon,
  Segment,
  Modal,
} from 'semantic-ui-react'


const BattleModal = ({ myIdx, userIdx, myPower, userPower, setMyPower, setUserPower, contract, account }) => {

  const goBattle = async () => {
    await contract.methods.attack(myIdx, userIdx).send({from: account});
    const myNewPower = await contract.methods.getUserPower(myIdx).call({from: account});
    const userNewPower = await contract.methods.getUserPower(userIdx).call({from: account});
    setMyPower(myNewPower);
    setUserPower(userNewPower);
  }

  return <>
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
      
    </Modal.Content>
  </>
}

export default BattleModal;