import React, { useContext } from "react";
import { ContractContext } from "../App";
import { Modal } from 'semantic-ui-react';
import "../styles/Map.css";
import { None, Farm, Sawmill, Mine, Manor, Quarry, Barrack } from './ModalComponents/index';

const ModalContent = ({ upgradingIdx, idx, x, y, cellState, index, updateCellState, page = {page} }) => {
  const state = useContext(ContractContext);
  if(!cellState) return <></>
  const { type } = cellState;

  if(type === "None") {
    return <>
      <Modal.Header>Create Building</Modal.Header>
      {state.accounts && state.produceContract && state.buildingContract && state.barrackContract ? <None upgradingIdx={upgradingIdx} idx={idx} cellState={cellState} x={x} y={y} produceContract={state.produceContract} buildingContract={state.buildingContract} barrackContract={state.barrackContract} account={state.accounts[0]} updateCellState={updateCellState} page = {page} /> : null}
    </>
  }
  if(type === "Farm") {
    return <>
      <Modal.Header>Farm</Modal.Header>
      {state.accounts && state.buildingContract ? <Farm idx={idx} cellState={cellState} x={x} y={y} contract={state.buildingContract} account={state.accounts[0]} updateCellState={updateCellState} /> : null}
    </>
  }
  if(type === "Sawmill") {
    return <>
      <Modal.Header>Sawmill</Modal.Header>
      {state.accounts && state.buildingContract ? <Sawmill idx={idx} cellState={cellState} x={x} y={y} contract={state.buildingContract} account={state.accounts[0]} updateCellState={updateCellState} /> : null}
    </>
  }
  if(type === "Mine") {
    return <>
      <Modal.Header>Mine</Modal.Header>
      {state.accounts && state.buildingContract ? <Mine idx={idx} cellState={cellState} x={x} y={y} contract={state.buildingContract} account={state.accounts[0]} updateCellState={updateCellState} /> : null}
    </>
  }
  if(type === "Manor") {
    return <>
      <Modal.Header>Manor</Modal.Header>
      {state.accounts && state.buildingContract ? <Manor idx={idx} cellState={cellState} x={x} y={y} contract={state.buildingContract} account={state.accounts[0]} updateCellState={updateCellState} /> : null}
    </>
  }
  if(type === "Quarry") {
    return <>
      <Modal.Header>Quarry</Modal.Header>
      {state.accounts && state.buildingContract ? <Quarry idx={idx} cellState={cellState} x={x} y={y} contract={state.buildingContract} account={state.accounts[0]} updateCellState={updateCellState} /> : null}
    </>
  }
  if(type === "Barrack") {
    return <>
      <Modal.Header>Barrack</Modal.Header>
      {state.accounts && state.buildingContract && state.barrackContract  ? <Barrack idx={idx} cellState={cellState} x={x} y={y} buildingContract={state.buildingContract} barrackContract={state.barrackContract} account={state.accounts[0]} updateCellState={updateCellState} /> : null}
    </>
  }

  return <></>
  
}

export default ModalContent;