import React, { useState, useEffect, useContext } from "react";
import { ContractContext } from "../App";
import { useMeasure } from 'react-use'
import {Cell, BarrackCell, LabCell} from './Cell';
import "../styles/Map.css";
import gameBackground from '../images/main_map_small.png';
import Draggable from 'react-draggable';


const imgWidth = 1700;//1803
const imgHeight = 1086;//1086
const cellAry = [[188, 278], [360, 364], [801, 163], [1092, 166], [1384, 364], [1500, 250], [1597, 428], [1500, 723], [1560, 903], [1264, 813],  [131, 708], [310, 843], [554, 940]];
const barrackCellAry = [[842, 663]];
const labCellAry = [[842, 500]];

const Map = () => {
  const state = useContext(ContractContext);
  const [ ref, { width, height } ] = useMeasure();
  const [ initialized, setInitialized ] = useState(false);
  const [ barrackInitialized, setBarrackInitialized ] = useState(false);
  const [ labInitialized, setLabInitialized ] = useState(false);
  const [ cellStateList, setCellStateList ] = useState([]);
  const [ barrackCellStateList, setBarrackCellStateList ] = useState([]);
  const [ labCellStateList, setLabCellStateList ] = useState([]);
  const [ upgradingIdx, setUpgradingIdx ] = useState(0);
  const [ barrackUpgradingIdx, setBarrackUpgradingIdx ] = useState(0);
  const [ labUpgradingIdx, setLabUpgradingIdx ] = useState(0);
  const [ producingIdx, setProducingIdx ] = useState(0);
  const [ barrackProducingIdx, setBarrackProducingIdx ] = useState(0);
  const [ labProducingIdx, setLabProducingIdx ] = useState(0);
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

  const updateBarrackCellState = (idx, newState) => {
    console.log("update: ", idx);
    console.log(newState);
    setBarrackCellStateList([ ...barrackCellStateList.slice(0, idx), newState, ...barrackCellStateList.slice(idx+1)]);
    if(newState.upgrade) {
      if(barrackUpgradingIdx === 0) {
        setBarrackUpgradingIdx(idx);
      }
    }
    if(newState.upgrade === false) {
      setBarrackUpgradingIdx(0);
    }
    if(newState.produce) {
      if(barrackProducingIdx === 0) {
        setBarrackProducingIdx(idx);
      }
    }
    if(newState.produce === false) {
      setBarrackProducingIdx(0);
    }
  }

  const updateLabCellState = (idx, newState) => {
    console.log("update: ", idx);
    console.log(newState);
    setLabCellStateList([ ...labCellStateList.slice(0, idx), newState, ...labCellStateList.slice(idx+1)]);
    if(newState.upgrade) {
      if(labUpgradingIdx === 0) {
        setLabUpgradingIdx(idx);
      }
    }
    if(newState.upgrade === false) {
      setLabUpgradingIdx(0);
    }
    if(newState.produce) {
      if(labProducingIdx === 0) {
        setLabProducingIdx(idx);
      }
    }
    if(newState.produce === false) {
      setLabProducingIdx(0);
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

  const updateBarrackProduce = () => {
    if(barrackProducingIdx === 0) {
      return;
    }
    const [ a, b ] = barrackCellStateList[barrackProducingIdx].produce;
    console.log(a, b);
    if(a < b) {
      const newState = { ...barrackCellStateList[barrackProducingIdx], produce: [a + 3, b] };
      updateBarrackCellState(barrackProducingIdx, newState);
      console.log("produce progress")
    }
    else {
      setBarrackProducingIdx(0);
    }
  }

  const updateLabProduce = () => {
    if(labProducingIdx === 0) {
      return;
    }
    const [ a, b ] = labCellStateList[labProducingIdx].produce;
    console.log(a, b);
    if(a < b) {
      const newState = { ...labCellStateList[labProducingIdx], produce: [a + 3, b] };
      updateLabCellState(labProducingIdx, newState);
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

  const updateBarrackProgress = () => {
    if(barrackUpgradingIdx === 0) {
      return;
    }
    console.log(barrackUpgradingIdx);
    const [ a, b ] = barrackCellStateList[barrackUpgradingIdx].upgrade;
    console.log(a, b);
    if(a < b) {
      const newState = { ...barrackCellStateList[barrackUpgradingIdx], upgrade: [a + 3, b] };
      updateBarrackCellState(barrackUpgradingIdx, newState);
    }
    else {
      setBarrackUpgradingIdx(0);
    }
  }

  const updateLabProgress = () => {
    if(labUpgradingIdx === 0) {
      return;
    }
    console.log(labUpgradingIdx);
    const [ a, b ] = labCellStateList[labUpgradingIdx].upgrade;
    console.log(a, b);
    if(a < b) {
      const newState = { ...labCellStateList[labUpgradingIdx], upgrade: [a + 3, b] };
      updateLabCellState(labUpgradingIdx, newState);
    }
    else {
      setLabUpgradingIdx(0);
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

  const updateBarrackBothProgress = () => {
    const [ a, b ] = barrackCellStateList[barrackUpgradingIdx].upgrade;
    const [ c, d ] = barrackCellStateList[barrackProducingIdx].produce;
    const upgradeNewState = { ...barrackCellStateList[barrackUpgradingIdx], upgrade: [a + 3, b] }
    const produceNewState = { ...barrackCellStateList[barrackProducingIdx], produce: [c + 3, d] }
    if(a < b) {
      if(c < d) {
        if(barrackUpgradingIdx > barrackProducingIdx) {
          setBarrackCellStateList([ ...barrackCellStateList.slice(0, barrackProducingIdx), produceNewState, ...barrackCellStateList.slice(barrackProducingIdx+1, barrackUpgradingIdx), upgradeNewState, ...barrackCellStateList.slice(barrackUpgradingIdx+1)]);
        }
        else {
          setBarrackCellStateList([ ...barrackCellStateList.slice(0, barrackUpgradingIdx), upgradeNewState, ...barrackCellStateList.slice(barrackUpgradingIdx+1, barrackProducingIdx), produceNewState, ...barrackCellStateList.slice(barrackProducingIdx+1)]);
        }
      }
      else {
        setBarrackCellStateList([ ...barrackCellStateList.slice(0, barrackUpgradingIdx), upgradeNewState, ...barrackCellStateList.slice(barrackUpgradingIdx+1)]);
        setBarrackProducingIdx(0);
      }
    }
    else {
      if(c < d) {
        setBarrackCellStateList([ ...barrackCellStateList.slice(0, barrackProducingIdx), produceNewState, ...barrackCellStateList.slice(barrackProducingIdx+1)]);
        setBarrackUpgradingIdx(0);
      }
      else {
        setBarrackProducingIdx(0);
        setBarrackUpgradingIdx(0);
      }
    }
  }

  const updateLabBothProgress = () => {
    const [ a, b ] = labCellStateList[labUpgradingIdx].upgrade;
    const [ c, d ] = labCellStateList[labProducingIdx].produce;
    const upgradeNewState = { ...labCellStateList[labUpgradingIdx], upgrade: [a + 3, b] }
    const produceNewState = { ...labCellStateList[labProducingIdx], produce: [c + 3, d] }
    if(a < b) {
      if(c < d) {
        if(labUpgradingIdx > labProducingIdx) {
          setLabCellStateList([ ...labCellStateList.slice(0, labProducingIdx), produceNewState, ...labCellStateList.slice(labProducingIdx+1, labUpgradingIdx), upgradeNewState, ...labCellStateList.slice(labUpgradingIdx+1)]);
        }
        else {
          setLabCellStateList([ ...labCellStateList.slice(0, labUpgradingIdx), upgradeNewState, ...labCellStateList.slice(labUpgradingIdx+1, labProducingIdx), produceNewState, ...labCellStateList.slice(labProducingIdx+1)]);
        }
      }
      else {
        setLabCellStateList([ ...labCellStateList.slice(0, labUpgradingIdx), upgradeNewState, ...labCellStateList.slice(labUpgradingIdx+1)]);
        setLabProducingIdx(0);
      }
    }
    else {
      if(c < d) {
        setLabCellStateList([ ...labCellStateList.slice(0, labProducingIdx), produceNewState, ...labCellStateList.slice(labProducingIdx+1)]);
        setLabUpgradingIdx(0);
      }
      else {
        setLabProducingIdx(0);
        setLabUpgradingIdx(0);
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

  const callBarrackUpdateProgress = () => {
    if(upgradingIdx !== 0 && producingIdx !== 0) {
      updateBarrackBothProgress();
    }
    else {
      updateBarrackProduce();
      updateBarrackProgress();
    }
    setReload(!reload);
  }

  const callLabUpdateProgress = () => {
    if(upgradingIdx !== 0 && producingIdx !== 0) {
      updateLabBothProgress();
    }
    else {
      updateLabProduce();
      updateLabProgress();
    }
    setReload(!reload);
  }

  useEffect(() => {
    const { contract, barrackContract, labContract, accounts } = state;
    let upgIdx = 0;
    let pdIdx = 0;
    const load = async (x, y, idx, upgradingId, con) => {
      const building = await con.methods.getBuildingByOwner(accounts[0], x, y).call({from: accounts[0]});
      const loadIndex = parseInt(building[0]);
      const loadType = building[1];
      let newState = { type: loadType, index: loadIndex };
      if(loadType === "Barrack") {
        const getCreateTime = await con.methods.getCreateSoldierTime().call({from: accounts[0]});
        const nowStartPeriod = parseInt( getCreateTime[0] );
        const createTimeNeed = parseInt( getCreateTime[1] );
        if(createTimeNeed != 0) {
          pdIdx = idx;
          newState = { ...newState, produce: [ nowStartPeriod, createTimeNeed ] };
        }
      }
      if(loadIndex === upgradingId && upgradingId !== 0) {
        const remainTime = parseInt( await con.methods.getRemainingTime(accounts[0]).call({from: accounts[0]}) );
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
        return load(val[0], val[1], idx, upgradingId, contract);
      })).then(result => {
        console.log(result);
        setCellStateList(result);
        setInitialized(true);
        setUpgradingIdx(upgIdx);
        setProducingIdx(pdIdx);
        // updateProgress();
      })

      const barrackUpgradingId = parseInt( await barrackContract.methods.getUpgradingId(accounts[0]).call({from: accounts[0]}) );
      Promise.all(barrackCellAry.map((val, idx) => {
        return load(val[0], val[1], idx, barrackUpgradingId, barrackContract);
      })).then(result => {
        console.log(result);
        setBarrackCellStateList(result);
        setBarrackInitialized(true);
        setBarrackUpgradingIdx(upgIdx);
        setBarrackProducingIdx(pdIdx);
        // updateProgress();
      })

      const labUpgradingId = parseInt( await labContract.methods.getUpgradingId(accounts[0]).call({from: accounts[0]}) );
      Promise.all(labCellAry.map((val, idx) => {
        return load(val[0], val[1], idx, labUpgradingId, labContract);
      })).then(result => {
        console.log(result);
        setLabCellStateList(result);
        setLabInitialized(true);
        setLabUpgradingIdx(upgIdx);
        setLabProducingIdx(pdIdx);
        // updateProgress();
      })
    }

    if(contract && barrackContract && labContract && accounts.length > 0) {
      if(!initialized) {
        init();
      }
    }
    if(upgradingIdx !== 0 || producingIdx !== 0) {
      setTimeout(() => {
        callUpdateProgress();
      }, 3000);
    }
    if(barrackUpgradingIdx !== 0 || barrackProducingIdx !== 0) {
      setTimeout(() => {
        callBarrackUpdateProgress();
      }, 3000);
    }
    if(labUpgradingIdx !== 0 || labProducingIdx !== 0) {
      setTimeout(() => {
        callLabUpdateProgress();
      }, 3000);
    }
  }, [state, upgradingIdx, producingIdx, barrackUpgradingIdx, barrackProducingIdx, barrackUpgradingIdx, barrackProducingIdx, reload])

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
            {
              barrackCellAry.map((xy_list, idx) => {
                const [x, y] = xy_list;
                return <BarrackCell key={idx} upgradingIdx={barrackUpgradingIdx} idx={idx} x={x} y={y} initialized={barrackInitialized} cellState={barrackCellStateList[idx]} updateCellState={updateBarrackCellState} />
              })
            }
            {
              labCellAry.map((xy_list, idx) => {
                const [x, y] = xy_list;
                return <LabCell key={idx} upgradingIdx={labUpgradingIdx} idx={idx} x={x} y={y} initialized={labInitialized} cellState={labCellStateList[idx]} updateCellState={updateLabCellState} />
              })
            }
          </div>
        </Draggable>
      </div>
    // </CellStateContext.Provider>
  );
}

export default Map;