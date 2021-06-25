import React, { useState, useEffect } from 'react';
import { Menu, Button } from 'semantic-ui-react';
import { BattleMenuItem } from './index';

const BattleMenu = ({ myIdx, userAmount, back}) => {
  const [ initialized, setInitialized ] = useState(false)
  const [ selectedIdx, setSelectedIdx ] = useState(-1);
  const [ battleList, setBattleList ] = useState([]);
  const [ spyedList, setSpyedList ] = useState([]);

  useEffect(() => {
    const newBattleList = [];
    const newSpyedList = [];
    for (let i=0; i<userAmount; ++i) {
      if(i != myIdx) {
        newBattleList.push(i);
      }
      newSpyedList.push(false);
    }
    setBattleList([ ...newBattleList]);
    if(!initialized){
      console.log(userAmount);
      setInitialized(true);
      setSpyedList([ ...newSpyedList]);
    }
  }, [myIdx, userAmount]);

  const select = (idx) => {
    setSelectedIdx(idx);
  }

  return <>
    <Menu vertical fluid>
      {
        battleList.map((idx) => {
          return <BattleMenuItem key={idx} myIdx={myIdx} userIdx={idx} active={selectedIdx === idx} spyedList = {spyedList} setSpyedList = {setSpyedList} />
        })
      }
    </Menu>
    <Button color='red' content="back" fluid onClick={() => back()} />
  </>
}

export default BattleMenu;