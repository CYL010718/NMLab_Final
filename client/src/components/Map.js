import React, { useState, useEffect, useContext } from "react";
import { ContractContext } from "../App";
import { useMeasure } from 'react-use'
import Cell from './Cell';
import "../styles/Map.css";
import gameBackground from '../images/main_map_small.png';
import Draggable from 'react-draggable';


const imgWidth = 1700;//1803
const imgHeight = 1086;//1086
const cellAry = [[188, 278], [360, 364], [801, 163], [1092, 166], [1384, 364], [1500, 250], [1597, 428], [1500, 723], [1560, 903], [1264, 813], [842, 663], [131, 708], [310, 843], [554, 940]];

const Map = () => {
  const state = useContext(ContractContext);
  const [ ref, { width, height } ] = useMeasure();
  const [ initialized, setInitialized ] = useState(false);
  const [ cellStateList, setCellStateList ] = useState([]);
  const [ upgradingIdx, setUpgradingIdx ] = useState(0);
  const [ producingIdx, setProducingIdx ] = useState(0);
  const [ reload, setReload ] = useState(false);
  // console.log(width, height);

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
      console.log("produe progress")
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
      updateProduce();
      updateProgress();
    }
    setReload(!reload);
  }

  useEffect(() => {
    const { contract, accounts } = state;
    let upgIdx = 0;
    let pdIdx = 0;
    const load = async (x, y, idx, upgradingId) => {
      const building = await contract.methods.getBuildingByOwner(accounts[0], x, y).call({from: accounts[0]});
      const loadIndex = parseInt(building[0]);
      const loadType = building[1];
      let newState = { type: loadType, index: loadIndex };
      if(loadType === "Barrack") {
        const getCreateTime = await contract.methods.getCreateSoldierTime().call({from: accounts[0]});
        const nowStartPeriod = parseInt( getCreateTime[0] );
        const createTimeNeed = parseInt( getCreateTime[1] );
        if(createTimeNeed != 0) {
          pdIdx = idx;
          newState = { ...newState, produce: [ nowStartPeriod, createTimeNeed ] };
        }
      }
      if(loadIndex === upgradingId && upgradingId !== 0) {
        const remainTime = parseInt( await contract.methods.getRemainingTime(accounts[0]).call({from: accounts[0]}) );
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
      const upgradingId = parseInt( await contract.methods.getUpgradingId(accounts[0]).call({from: accounts[0]}) );
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
    if(contract && accounts.length > 0) {
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
                return <Cell key={idx} upgradingIdx={upgradingIdx} idx={idx} x={x} y={y} initialized={initialized} cellState={cellStateList[idx]} updateCellState={updateCellState} />
              })
            }
          </div>
        </Draggable>
      </div>
    // </CellStateContext.Provider>
  );
}

export default Map;