import React, { useState } from "react";
import "../styles/Cell.css";
import { Modal, Button, Icon } from 'semantic-ui-react'
import Building from "./Building"
import ModalContent from './ModalContent'


const Cell = ({ upgradingIdx, idx , x, y, initialized,  cellState, updateCellState }) => {
  const [ open, setOpen ] = useState(false);
  const [ CellStyle, setCellStyle ] = useState({
    left: `${x}px`,
    top: `${y}px`,
    // color: "#6CC",
    backgroundColor: "rgba(255,255,255,0.05)",
  });

  const onHover = () => {
    setCellStyle({
      left: `${x}px`,
      top: `${y}px`,
    });
  }
  const unHover = () => {
    setCellStyle({
      left: `${x}px`,
      top: `${y}px`,
    });
  }

  return <>
    <div className="Cell_1x1" tabIndex="1" id={`Cell-${x}*${y}`} style={CellStyle}  
      onMouseEnter={() => onHover()} 
      onMouseLeave={() => unHover()} 
      onClick={() => setOpen(true)}>
      <Building type={initialized? cellState.type : "undefined"} />
    </div>

    <Modal
      dimmer='inverted'
      onClose={() => setOpen(false)}
      onOpen={() => setOpen(true)}
      open={open}
    >
      <ModalContent upgradingIdx={upgradingIdx} idx={idx} x={x} y={y} cellState={initialized? cellState : null} type={initialized? cellState.type : "undefined"} index={initialized? cellState.index : "undefined"} updateCellState={updateCellState} />
      <Modal.Actions>
        <Button onClick={() => setOpen(false)} color='red'>
          <Icon name='close' /> close
        </Button>
      </Modal.Actions>
    </Modal>
  </>

}

export default Cell;