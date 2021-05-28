import React, { useEffect, useState, useContext } from "react";
import { ContractContext } from "../App";
import { Menu, Icon, Button, Image } from 'semantic-ui-react';
import "../styles/Navbar.css";
import woodpng from '../images/wood_noback.png';
import ironpng from '../images/iron_noback.png';
import stonepng from '../images/stone_noback.png';
import coinpng from '../images/coin_noback.png';
import foodpng from '../images/food_noback.png';


const Navbar = ({ makeReload }) => { 
  const state = useContext(ContractContext);
  const [ resources, setResources ] = useState({
    wood: "--",
    food: "--",
    iron: "--",
    stone: "--",
    coin: "--"
  });
  const [ updateTimes, setUpdateTimes ] = useState(0);

  useEffect(() => {
    const { contract, accounts } = state;
    if(!contract || accounts.length < 1) return;
    const updateResource = async () => {
      const result = await contract.methods.updateProduce(accounts[0]).send({from: accounts[0]});
      console.log(result);
      const wood = await contract.methods.getWoodAmount().call({from: accounts[0]});
      const food = await contract.methods.getFoodAmount().call({from: accounts[0]});
      const iron = await contract.methods.getIronAmount().call({from: accounts[0]});
      const stone = await contract.methods.getStoneAmount().call({from: accounts[0]});
      const coin = await contract.methods.getCoinAmount().call({from: accounts[0]});
      setResources({ wood, food, iron, stone, coin });
    }
    const getResource = async () => {
      const wood = await contract.methods.getWoodAmount().call({from: accounts[0]});
      const food = await contract.methods.getFoodAmount().call({from: accounts[0]});
      const iron = await contract.methods.getIronAmount().call({from: accounts[0]});
      const stone = await contract.methods.getStoneAmount().call({from: accounts[0]});
      const coin = await contract.methods.getCoinAmount().call({from: accounts[0]});
      setResources({ wood, food, iron, stone, coin });
    }
    if(updateTimes === 0) {
      getResource();
      return;
    };
    updateResource();
    makeReload();
  }, [updateTimes, state]);

  return (
    <div className="navbar">
      <Menu secondary className="welcome-menu" >
        <Menu.Menu position='right'>
          <Button.Group floated='right'>
            <Button animated='fade' circular onClick={() => setUpdateTimes(updateTimes+1)} inverted color='teal'>
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