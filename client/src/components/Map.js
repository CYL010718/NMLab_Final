import React, { useState, useEffect, useContext } from "react";
import { Icon, Image, Button } from 'semantic-ui-react';
import { ContractContext } from "../App";
import { Battle } from './index'
import { useMeasure } from 'react-use'
import Cell from './Cell';
import "../styles/Map.css";
import gameBackground from '../images/map.JPG';
import Draggable from 'react-draggable';


const imgWidth = 1512//1021;//1803
const imgHeight = 1050//700;//1086 
const cellAry = [[420, 860], [180, 530], [1000, 390], [900, 440], [500, 430], [1050, 500], [695, 520], [360, 380], [812, 390], [715, 435], [1175, 525], [745, 880],  [220, 708], [980, 290], [650, 645]];

const Map = () => {
  const state = useContext(ContractContext);
  const [ ref, { width, height } ] = useMeasure();
  const [ initialized, setInitialized ] = useState(false);
  const [ cellStateList, setCellStateList ] = useState([]);
  const [ upgradingIdx, setUpgradingIdx ] = useState(0);
  const [ producingIdx, setProducingIdx ] = useState(0);
  const [ reload, setReload ] = useState(false);
  console.log(width, height);

  const updateCellState = (idx, newState) => {
    console.log("update: ", idx);
    console.log(newState);
    setCellStateList([ ...cellStateList.slice(0, idx), newState, ...cellStateList.slice(idx+1)]);
    if(newState.upgrade) {
      if(upgradingIdx === 0) {
        setUpgradingIdx(idx);
      }
    }
    if(newState.upgrade === false) {
      setUpgradingIdx(0);
    }
    if(newState.produce) {
      if(producingIdx === 0) {
        setProducingIdx(idx);
      }
    }
    if(newState.produce === false) {
      setProducingIdx(0);
    }
  }

  const updateProduce = () => {
    if(producingIdx === 0) {
      return;
    }
    const [ a, b ] = cellStateList[producingIdx].produce;
    console.log(a, b);
    if(a < b) {
      const newState = { ...cellStateList[producingIdx], produce: [a + 3, b] };
      updateCellState(producingIdx, newState);
      console.log("produce progress")
    }
    else {
      setProducingIdx(0);
    }
  }

  const updateProgress = () => {
    if(upgradingIdx === 0) {
      return;
    }
    console.log(upgradingIdx);
    const [ a, b ] = cellStateList[upgradingIdx].upgrade;
    console.log(a, b);
    if(a < b) {
      const newState = { ...cellStateList[upgradingIdx], upgrade: [a + 3, b] };
      updateCellState(upgradingIdx, newState);
    }
    else {
      setUpgradingIdx(0);
    }
  }

  const updateBothProgress = () => {
    const [ a, b ] = cellStateList[upgradingIdx].upgrade;
    const [ c, d ] = cellStateList[producingIdx].produce;
    const upgradeNewState = { ...cellStateList[upgradingIdx], upgrade: [a + 3, b] }
    const produceNewState = { ...cellStateList[producingIdx], produce: [c + 3, d] }
    if(a < b) {
      if(c < d) {
        if(upgradingIdx > producingIdx) {
          setCellStateList([ ...cellStateList.slice(0, producingIdx), produceNewState, ...cellStateList.slice(producingIdx+1, upgradingIdx), upgradeNewState, ...cellStateList.slice(upgradingIdx+1)]);
        }
        else {
          setCellStateList([ ...cellStateList.slice(0, upgradingIdx), upgradeNewState, ...cellStateList.slice(upgradingIdx+1, producingIdx), produceNewState, ...cellStateList.slice(producingIdx+1)]);
        }
      }
      else {
        setCellStateList([ ...cellStateList.slice(0, upgradingIdx), upgradeNewState, ...cellStateList.slice(upgradingIdx+1)]);
        setProducingIdx(0);
      }
    }
    else {
      if(c < d) {
        setCellStateList([ ...cellStateList.slice(0, producingIdx), produceNewState, ...cellStateList.slice(producingIdx+1)]);
        setUpgradingIdx(0);
      }
      else {
        setProducingIdx(0);
        setUpgradingIdx(0);
      }
    }
  }

  const callUpdateProgress = () => {
    if(upgradingIdx !== 0 && producingIdx !== 0) {
      updateBothProgress();
    }
    else {
      //updateProduce();
      updateProgress();
    }
    setReload(!reload);
  }

  useEffect(() => {
    const { buildingContract, barrackContract, soldierContract, cannonContract, protectorContract, spyContract, wallContract, labContract, accounts } = state;
    let upgIdx = 0;
    let pdIdx = 0;
    const load = async (x, y, idx, upgradingId) => {
      const building = await buildingContract.methods.getBuildingByOwner(accounts[0], x, y).call({from: accounts[0]});
      const loadIndex = parseInt(building[0]);
      const loadType = building[1];
      let newState = { type: loadType, index: loadIndex };
      if(loadType === "Barrack") {
        const getSoldierCreateTime = await soldierContract.methods.getCreateSoldierTime().call({from: accounts[0]});
        console.log(getSoldierCreateTime)
        const soldierStartTime= parseInt( getSoldierCreateTime[0] );
        const createSoldierTimeNeed = parseInt( getSoldierCreateTime[2] );
        if(createSoldierTimeNeed != 0) {
          pdIdx = idx;
          newState = { ...newState, soldierProduce: [ parseInt(Date.now() / 1000) - soldierStartTime, createSoldierTimeNeed ] };
        }
        const getSpyCreateTime = await spyContract.methods.getCreateSpyTime().call({from: accounts[0]});
        const spyStartTime = parseInt( getSpyCreateTime[0] );
        const createSpyTimeNeed = parseInt( getSpyCreateTime[2] );
        if(createSpyTimeNeed != 0) {
          pdIdx = idx;
          newState = { ...newState, spyProduce: [ parseInt(Date.now() / 1000) - spyStartTime, createSpyTimeNeed ] };
        }
        //await cannonContract.methods.updateCreateCannon(accounts[0]).send({from: accounts[0]});
        const getCannonCreateTime = await cannonContract.methods.getCreateCannonTime().call({from: accounts[0]});
        const cannonStartTime = parseInt( getCannonCreateTime[0] );
        const createCannonTimeNeed = parseInt( getCannonCreateTime[2] );
        if(createCannonTimeNeed != 0) {
          pdIdx = idx;
          newState = { ...newState, cannonProduce: [ parseInt(Date.now() / 1000) - cannonStartTime, createCannonTimeNeed ] };
        }
        const getProtectorCreateTime = await protectorContract.methods.getCreateProtectorTime().call({from: accounts[0]});
        const protectorStartTime = parseInt( getProtectorCreateTime[0] );
        const createProtectorTimeNeed = parseInt( getProtectorCreateTime[2] );
        console.log(parseInt(Date.now() / 1000))
        if(createProtectorTimeNeed != 0) {
          pdIdx = idx;
          newState = { ...newState, protectorProduce: [ parseInt(Date.now() / 1000) - protectorStartTime, createProtectorTimeNeed ] };
        }
        const getWallCreateTime = await wallContract.methods.getCreateWallTime().call({from: accounts[0]});
        const wallStartTime = parseInt( getWallCreateTime[0] );
        const createWallTimeNeed = parseInt( getWallCreateTime[2] );
        if(createWallTimeNeed != 0) {
          pdIdx = idx;
          newState = { ...newState, wallProduce: [ parseInt(Date.now() / 1000) - wallStartTime, createWallTimeNeed ] };
        }
      }
      if(loadType === "Laboratory"){
        const getSoldierUpgradeTime = await labContract.methods.getUpgradeSoldierTime().call({from: accounts[0]});
        const soldierStartTime = parseInt( getSoldierUpgradeTime[0] );
        const upgradeSoldierTimeNeed = parseInt( getSoldierUpgradeTime[2] );
        if(upgradeSoldierTimeNeed != 0) {
          pdIdx = idx;
          newState = { ...newState, soldierUpgrade: [ parseInt(Date.now() / 1000) - soldierStartTime, upgradeSoldierTimeNeed ] };
        }
        const getSpyUpgradeTime = await labContract.methods.getUpgradeSpyTime().call({from: accounts[0]});
        const spyStartTime = parseInt( getSpyUpgradeTime[0] );
        const upgradeSpyTimeNeed = parseInt( getSpyUpgradeTime[2] );
        if(upgradeSpyTimeNeed != 0) {
          pdIdx = idx;
          newState = { ...newState, spyUpgrade: [ parseInt(Date.now() / 1000) - spyStartTime, upgradeSpyTimeNeed ] };
        }
        const getCannonUpgradeTime = await labContract.methods.getUpgradeCannonTime().call({from: accounts[0]});
        const cannonStartTime= parseInt( getCannonUpgradeTime[0] );
        const upgradeCannonTimeNeed = parseInt( getCannonUpgradeTime[2] );
        if(upgradeCannonTimeNeed != 0) {
          pdIdx = idx;
          newState = { ...newState, cannonUpgrade: [ parseInt(Date.now() / 1000) - cannonStartTime, upgradeCannonTimeNeed ] };
        }
        const getProtectorUpgradeTime = await labContract.methods.getUpgradeProtectorTime().call({from: accounts[0]});
        const protectorStartTime = parseInt( getProtectorUpgradeTime[0] );
        const upgradeProtectorTimeNeed = parseInt( getProtectorUpgradeTime[2] );
        if(upgradeProtectorTimeNeed != 0) {
          pdIdx = idx;
          newState = { ...newState, protectorUpgrade: [ parseInt(Date.now() / 1000) - protectorStartTime, upgradeProtectorTimeNeed ] };
        }
      }
      if(loadIndex === upgradingId && upgradingId !== 0) {
        const remainTime = parseInt( await buildingContract.methods.getRemainingTime(accounts[0]).call({from: accounts[0]}) );
        if(remainTime < 1000) {
          console.log(idx);
          upgIdx = idx;
          return { ...newState, upgrade: [0, remainTime] }
        }
        upgIdx = 0;
      }
      return newState;
    }
    const init = async () => {
      const upgradingId = parseInt( await buildingContract.methods.getUpgradingId(accounts[0]).call({from: accounts[0]}) );
      console.log(upgradingId);
      Promise.all(cellAry.map((val, idx) => {
        return load(val[0], val[1], idx, upgradingId);
      })).then(result => {
        console.log(result);
        setCellStateList(result);
        setInitialized(true);
        setUpgradingIdx(upgIdx);
        setProducingIdx(pdIdx);
        // updateProgress();
      })
    }
    if(buildingContract && barrackContract && labContract && accounts.length > 0) {
      if(!initialized) {
        init();
      }
    }
    if(upgradingIdx !== 0 || producingIdx !== 0) {
      setTimeout(() => {
        callUpdateProgress();
      }, 3000);
    }
  }, [state, upgradingIdx, producingIdx, reload])

  const boundStyle = {left: -(imgWidth - width)/2, right: (imgWidth - width)/2, top: -(imgHeight - height), bottom: 0 };
  
  return (
    // <CellStateContext.Provider value={cellStateList}>
      <div className="flex_div container" ref={ref} >
        {/* <div className="popup_div" style={{visibility: popupState.visible?"visible":"hidden"}}>
          <PopupContent popupState={popupState} setPopup={setPopup} makeReload={makeReload} />
        </div> */}
        <Draggable bounds={boundStyle}>
          <div className="inline_div">
            <img src={gameBackground} alt="Workplace" className="background_img"/>
            {
              cellAry.map((xy_list, idx) => {
                const [x, y] = xy_list;
                if(idx === 10){
                  return <Cell key={idx} upgradingIdx={upgradingIdx} idx={idx} x={x} y={y} initialized={initialized} cellState={cellStateList[idx]} updateCellState={updateCellState} page = {1} />
                }
                else if(idx === 11){
                  return <Cell key={idx} upgradingIdx={upgradingIdx} idx={idx} x={x} y={y} initialized={initialized} cellState={cellStateList[idx]} updateCellState={updateCellState} page = {2}/>
                }
                else{
                  return <Cell key={idx} upgradingIdx={upgradingIdx} idx={idx} x={x} y={y} initialized={initialized} cellState={cellStateList[idx]} updateCellState={updateCellState} page = {0}/>
                }
              })
            }
          </div>
        </Draggable>
      </div>
    // </CellStateContext.Provider>
  );
}

export default Map;