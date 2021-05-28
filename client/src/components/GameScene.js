import React, { useEffect, useState, useContext} from 'react';
import { Map, Battle, Navbar } from './index';
import { ContractContext } from '../App'
import { Grid, Button, Image } from 'semantic-ui-react';
import castlepng from '../images/castle.png';


const GameScene = () => {
  const [ newUser, setNewUser ] = useState(true);
  const [ reload, setReload ] = useState(false);
  const state = useContext(ContractContext);

  useEffect(() => {
    const { contract, accounts } = state;
    const load = async () => {
      const checkUser = await contract.methods.checkUserAddress().call({from:accounts[0]});
      setNewUser(!checkUser)
    }
    if(contract !== null && accounts.length > 0) {
      load();
    }
  }, [state])
  
  const initializeKingdom = async () => {
    const { contract, accounts } = state;
    if(contract == null || accounts.length < 1) {
      alert("contract error!");
      return;
    }
    const create = await contract.methods.createCastle(650, 300).send({from: accounts[0]});
    console.log(create);
    setNewUser(false);
  }

  const makeReload = () => {
    setReload(!reload);
  }
  

  return newUser ?
    <>
    <br/>
    <br/>
    <br/>
    <Image src={castlepng} size="medium" />
    <br/>
    <Button primary size="massive" onClick={() => initializeKingdom()}>
      Initialize your kingdom!
    </Button>
    </>
    :
    <>
      <Navbar makeReload={makeReload} />
      <Grid celled style={{margin: "0"}}>
        <Grid.Row>
          <Grid.Column width={3}>
            <Battle />
          </Grid.Column>
          <Grid.Column width={13}>
            <Map reload={reload} />
          </Grid.Column>
        </Grid.Row>
      </Grid>
    </>
}

export default GameScene;
