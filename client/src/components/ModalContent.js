import React, { useContext } from "react";
import { ContractContext } from "../App";
import { Modal } from 'semantic-ui-react';
import "../styles/Map.css";
import { None, Farm, Sawmill, Mine, Manor, Quarry, Barrack } from './ModalComponents/index';

const ModalContent = ({ upgradingIdx, idx, x, y, cellState, index, updateCellState }) => {
  const state = useContext(ContractContext);
  if(!cellState) return <></>
  const { type } = cellState;

  if(type === "None") {
    return <>
      <Modal.Header>Create Buiding</Modal.Header>
      {state.accounts && state.contract ? <None upgradingIdx={upgradingIdx} idx={idx} cellState={cellState} x={x} y={y} contract={state.contract} account={state.accounts[0]} updateCellState={updateCellState} /> : null}
    </>
  }
  if(type === "Farm") {
    return <>
      <Modal.Header>Farm</Modal.Header>
      {state.accounts && state.contract ? <Farm idx={idx} cellState={cellState} x={x} y={y} contract={state.contract} account={state.accounts[0]} updateCellState={updateCellState} /> : null}
    </>
  }
  if(type === "Sawmill") {
    return <>
      <Modal.Header>Sawmill</Modal.Header>
      {state.accounts && state.contract ? <Sawmill idx={idx} cellState={cellState} x={x} y={y} contract={state.contract} account={state.accounts[0]} updateCellState={updateCellState} /> : null}
    </>
  }
  if(type === "Mine") {
    return <>
      <Modal.Header>Mine</Modal.Header>
      {state.accounts && state.contract ? <Mine idx={idx} cellState={cellState} x={x} y={y} contract={state.contract} account={state.accounts[0]} updateCellState={updateCellState} /> : null}
    </>
  }
  if(type === "Manor") {
    return <>
      <Modal.Header>Manor</Modal.Header>
      {state.accounts && state.contract ? <Manor idx={idx} cellState={cellState} x={x} y={y} contract={state.contract} account={state.accounts[0]} updateCellState={updateCellState} /> : null}
    </>
  }
  if(type === "Quarry") {
    return <>
      <Modal.Header>Manor</Modal.Header>
      {state.accounts && state.contract ? <Quarry idx={idx} cellState={cellState} x={x} y={y} contract={state.contract} account={state.accounts[0]} updateCellState={updateCellState} /> : null}
    </>
  }
  if(type === "Barrack") {
    return <>
      <Modal.Header>Manor</Modal.Header>
      {state.accounts && state.contract ? <Barrack idx={idx} cellState={cellState} x={x} y={y} contract={state.contract} account={state.accounts[0]} updateCellState={updateCellState} /> : null}
    </>
  }

  return <></>
  
}

export default ModalContent;