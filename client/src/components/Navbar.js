import React, { useEffect, useState, useContext } from "react";
import { ContractContext } from "../App";
import { Menu, Icon, Button, Image, Modal, Progress, Header } from 'semantic-ui-react';
import "../styles/Navbar.css";
import woodpng from '../images/wood_noback.png';
import ironpng from '../images/iron_noback.png';
import stonepng from '../images/stone_noback.png';
import coinpng from '../images/coin_noback.png';
import foodpng from '../images/food_noback.png';


const Navbar = ({ makeReload }) => { 
  const state = useContext(ContractContext);
  const { accountContract, produceContract, barrackContract, accounts } = state;
  const [ initialized, setInitialized ] = useState(false);
  const [ beingAttacked, setBeingAttacked ] = useState(false);
  const [ attacker, setAttacker ] = useState("");
  const [ showCountdown, setShowCountdown ] = useState(false);
  const [ marchPeriod, setMarchPeriod ] = useState(0);
  const [ marchTimeNeed, setMarchTimeNeed ] = useState(0);
  const [ countdownProgress, setCountdownProgress ] = useState(100);
  const [ resources, setResources ] = useState({
    wood: "--",
    food: "--",
    iron: "--",
    stone: "--",
    coin: "--"
  });
  const [ updateTimes, setUpdateTimes ] = useState(0);

  const updateCountdown = async() => {
    if(!beingAttacked){
      console.log("???")
      return 
    }
    if(marchPeriod < marchTimeNeed){
        setMarchPeriod(marchPeriod + 3);
    }
    else{
      await accountContract.methods.updateMarch(accounts[0]).send({from: accounts[0]});
      setBeingAttacked(false);
      setMarchPeriod(0);
      setMarchTimeNeed(0);
    }
  }

  const updateResource = async () => {
    const result = await produceContract.methods.updateProduce(accounts[0]).send({from: accounts[0]});
    console.log(result);
    const wood = await accountContract.methods.getWoodAmount().call({from: accounts[0]});
    const food = await accountContract.methods.getFoodAmount().call({from: accounts[0]});
    const iron = await accountContract.methods.getIronAmount().call({from: accounts[0]});
    const stone = await accountContract.methods.getStoneAmount().call({from: accounts[0]});
    const coin = await accountContract.methods.getCoinAmount().call({from: accounts[0]});
    setResources({ wood, food, iron, stone, coin });
    makeReload();
  }

  useEffect(() => {
    if(!produceContract || accounts.length < 1) return;
    
    const getResource = async () => {
      const wood = await accountContract.methods.getWoodAmount().call({from: accounts[0]});
      const food = await accountContract.methods.getFoodAmount().call({from: accounts[0]});
      const iron = await accountContract.methods.getIronAmount().call({from: accounts[0]});
      const stone = await accountContract.methods.getStoneAmount().call({from: accounts[0]});
      const coin = await accountContract.methods.getCoinAmount().call({from: accounts[0]});
      setResources({ wood, food, iron, stone, coin });
    }
    const init = async () => {
      getResource();

      const getMarchTime = await accountContract.methods.getMarchTime(accounts[0]).call({from: accounts[0]}); //Modify
      const nowStartPeriod = parseInt( getMarchTime[0] );
      const marchingTimeNeed = parseInt( getMarchTime[1] );
      const attackerInfo = await accountContract.methods.getAttackerInfo(accounts[0]).call({from: accounts[0]});
      const isAttacked = attackerInfo[0];
      const attackerAddress = attackerInfo[0];
      
      setMarchPeriod(nowStartPeriod);
      setMarchTimeNeed(marchingTimeNeed);
      if(marchingTimeNeed !== 0) setBeingAttacked(true);
      setAttacker(attackerAddress);
      setInitialized(true);
    }

    if(barrackContract && accounts.length > 0) {
      if(!initialized) {
        init();
      }
    }
    /*
    if(updateTimes === 0) {
      getResource();
      return;
    };
    */
    setCountdownProgress(100 - (beingAttacked ? 100 - marchTimeNeed === 0 ? 100 : marchPeriod/marchTimeNeed*100 > 100 ? 
      100:marchPeriod/ marchTimeNeed*100: 0));
    
    var handle;
    if(beingAttacked) {
      handle = setTimeout(() => {
        updateCountdown();
      }, 3000);
    }
    makeReload();
    return () => {
      clearTimeout(handle);
    }
    //updateResource();  
  }, [state, marchPeriod, marchTimeNeed]);

  return (
    <div className="navbar">
      <Menu secondary className="welcome-menu" >
        <Menu.Menu position='right'>
          {beingAttacked ?
            <>
              <Button icon = 'warning sign' color = 'red' floated = 'left' onClick = {() => setShowCountdown(true)}>
                  View attacker information
              </Button>
              <Modal open = {showCountdown}>
                 <Modal.Content>
                    <Header> Attack by {attacker} </Header>
                    <Progress  progress='percent'  percent={countdownProgress} indicating>
                        Attack countdown
                    </Progress>
                    <Modal.Actions>
                      <Button onClick = {() => setShowCountdown(false)} color = 'red'>
                        <Icon name='close' /> close
                      </Button>
                    </Modal.Actions>
                 </Modal.Content>
              </Modal>
            </>
            :
            <></>
          }
          <Button.Group floated='right'>
            <Button animated='fade' circular onClick={() => updateResource()} inverted color='teal'>
              <Button.Content hidden>Refresh</Button.Content>
              <Button.Content visible  >
                <Icon name='sync' />
              </Button.Content>
            </Button>
            {/* <Button circular icon='sync' onClick={() => setUpdateTimes(updateTimes+1)} inverted color='blue'/> */}
            {/* <Button active color='blue' inverted size='mini' icon="tree" style={{ color: 'green' }} > */}
            <Button active color='blue' inverted size='mini' style={{ color: 'SaddleBrown' }}>
              <Image src={woodpng} size='mini' spaced />
              {resources.wood}
            </Button>
            <Button active color='blue' inverted size='mini' style={{ color: 'Khaki' }}>
              <Image src={foodpng} size='mini' spaced />
              {resources.food}
            </Button>
            <Button active color='blue' inverted size='mini' style={{ color: 'black' }}>
              <Image src={ironpng} size='mini' spaced />
              {resources.iron}
            </Button>
            <Button active color='blue' inverted size='mini' style={{ color: 'Olive' }}>
              <Image src={coinpng} size='mini' spaced />
              {resources.coin}
            </Button>
            <Button active color='blue' inverted size='mini' style={{ color: 'gray' }}>
              <Image src={stonepng} size='mini' spaced />
              {resources.stone}
            </Button>
          </Button.Group>
          {/* <Menu.Item
            name='wood'
            style={{ color: 'green' }}
          >
            <Icon size='mini' name="tree"  />
            {resources.wood}
          </Menu.Item>
          <Menu.Item
            name='food'
            style={{ color: 'gainsboro' }}
          >
            <Icon name="food" />
            {resources.food}
          </Menu.Item>
          <Menu.Item
            name='iron'
            style={{ color: 'black' }}
          >
            <Icon name="lock" />
            {resources.iron}
          </Menu.Item>
          <Menu.Item
            name='stone'
            style={{ color: 'gray' }}
          >
            <Icon name="hand rock" />
            {resources.stone}
          </Menu.Item>
          <Menu.Item
            name='coin'
            style={{ color: "gold" }}
          >
            <Icon name="bitcoin" />
            {resources.coin}
          </Menu.Item> */}
        </Menu.Menu>
      </Menu>
    </div>


  )

}


export default Navbar;