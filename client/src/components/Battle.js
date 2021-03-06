import React, { useState, useContext } from 'react'
import { ContractContext } from "../App";
import { Button } from 'semantic-ui-react';
import { BattleMenu } from './index';

const Battle = () => {
  const [ scene, setScene ] = useState(false);
  const [ totalUser, setTotalUser ] = useState(0);
  const [ myIdx, setMyIdx ] = useState(-1);
 // const [ battleState, setBattleState ] = useState({ storageValue: 0, web3: null, accounts: null, contract: null });
  const state = useContext(ContractContext);

  const battleScene = async () => {
    const { accountContract, accounts } = state;
    if (!accountContract || accounts.length === 0) {
      alert("No contract or lack of account");
      return;
    }
    const myId = await accountContract.methods.getMyIdx().call({from:accounts[0]});
    const kingdomLength = await accountContract.methods.getKingdomAmount().call({from: accounts[0]});
    if(myId === kingdomLength) {
      alert("something went wrong!");
    }
    setTotalUser(kingdomLength);
    setMyIdx(myId);
    // const newAddressList = await contract.methods.getUserAddress().call({from: accounts[0]});
    // console.log(newAddressList);
    // setAddressList(newAddressList)
    setScene(true);
  }

  const back = () => {
    setScene(false);
  }


  return scene ? 
    <BattleMenu myIdx={myIdx} userAmount={totalUser} back={back}/>
    :
    <Button primary fluid content="Battle" onClick={()=>battleScene()}/>
}

export default Battle;