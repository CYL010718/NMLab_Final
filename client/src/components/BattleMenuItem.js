import React, { useState, useContext, useEffect } from 'react';
import { ContractContext } from '../App';
import { Menu, Icon, Modal, Button } from 'semantic-ui-react';
import { BattleModal } from './index';

const BattleMenuItem = ({ userIdx, myIdx, active, spyedList, setSpyedList }) => {
  const state = useContext(ContractContext);
  //const { contract, accounts } = state;
  const [ myPower, setMyPower ] = useState(-1);
  const [ userPower, setUserPower ] = useState(-1);
  const [ open, setOpen ] = useState(false);

  useEffect(() => {
    console.log(spyedList)
    const { accountContract, accounts } = state;
    console.log(myIdx);
    if(!accountContract || accounts.length < 1) return;
    const getUP = async () => {
      const pow = await accountContract.methods.getUserPowerById(userIdx).call({from:accounts[0]});
      const myPow = await accountContract.methods.getUserPowerById(myIdx).call({from:accounts[0]});
      // console.log(pow);
      // setUserPower(pow);
      setMyPower(myPow);
      if(spyedList[userIdx] === true) setUserPower(pow);
    }
    getUP();
  }, [state, spyedList])


  return <>
    <Menu.Item
      active={active}
      onClick={() => {setOpen(true);}}
    >
      <Menu.Header>{`Player${userIdx}`}</Menu.Header>

      <Menu.Menu>
        <Menu.Item>
          {
            ["power: ",
              userPower === -1 ?
              <Icon key="loading" loading name='spinner' />
              :
              `${userPower}`
            ]
          }
        </Menu.Item>
      </Menu.Menu>
    </Menu.Item>

    <Modal
      dimmer='inverted'
      onClose={() => setOpen(false)}
      onOpen={() => setOpen(true)}
      open={open}
    >
      <BattleModal myIdx={myIdx} userIdx={userIdx} myPower={myPower} userPower={userPower} setMyPower={setMyPower} setUserPower={setUserPower}  spyedList = {spyedList} setSpyedList = {setSpyedList}/>
      <Modal.Actions>
        <Button onClick={() => setOpen(false)} color='red'>
          <Icon name='close' /> close
        </Button>
      </Modal.Actions>
    </Modal>
  </>
}

export default BattleMenuItem;