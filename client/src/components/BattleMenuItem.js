import React, { useState, useContext, useEffect } from 'react';
import { ContractContext } from '../App';
import { Menu, Icon, Modal, Button } from 'semantic-ui-react';
import { BattleModal } from './index';

const BattleMenuItem = ({ userIdx, myIdx, active }) => {
  const state = useContext(ContractContext);
  const { contract, accounts } = state;
  const [ myPower, setMyPower ] = useState(-1);
  const [ userPower, setUserPower ] = useState(-1);
  const [ open, setOpen ] = useState(false);

  useEffect(() => {
    const { contract, accounts } = state;
    if(!contract || accounts.length < 1) return;
    const getUP = async () => {
      // const pow = await contract.methods.getUserPower(userIdx).call({from:accounts[0]});
      const myPow = await contract.methods.getUserPower(myIdx).call({from:accounts[0]});
      // console.log(pow);
      // setUserPower(pow);
      setMyPower(myPow);
    }
    getUP();
  }, [state])


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
      <BattleModal myIdx={myIdx} userIdx={userIdx} myPower={myPower} userPower={userPower} setMyPower={setMyPower} setUserPower={setUserPower} contract={contract} account={accounts[0]} />
      <Modal.Actions>
        <Button onClick={() => setOpen(false)} color='red'>
          <Icon name='close' /> close
        </Button>
      </Modal.Actions>
    </Modal>
  </>
}

export default BattleMenuItem;