import React, { useState, useEffect } from 'react';
import { Menu, Button } from 'semantic-ui-react';
import { BattleMenuItem } from './index';

const BattleMenu = ({ myIdx, userAmount, back}) => {
  const [ selectedIdx, setSelectedIdx ] = useState(-1);
  const [ battleList, setBattleList ] = useState([]);

  useEffect(() => {
    const newBattleList = [];
    for (let i=0; i<userAmount; ++i) {
      if(i != myIdx) {
        newBattleList.push(i);
      }
    }
    setBattleList([ ...newBattleList]);
  }, [myIdx, userAmount]);

  const select = (idx) => {
    setSelectedIdx(idx);
  }

  return <>
    <Menu vertical fluid>
      {
        battleList.map((idx) => {
          return <BattleMenuItem key={idx} myIdx={myIdx} userIdx={idx} active={selectedIdx === idx} />
        })
      }
    </Menu>
    <Button color='red' content="back" fluid onClick={() => back()} />
  </>
}

export default BattleMenu;