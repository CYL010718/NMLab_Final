import React from 'react';
import { Icon, Image } from 'semantic-ui-react';
import farm from '../images/farm.png';
import mine from '../images/mine.png';
import quarry from '../images/quarry.png';
import manor from '../images/manor.png';
import barrack from '../images/barrack.png';
import lab from '../images/lab.png'
import sawmill from '../images/sawmill.png';
import redTriangle from '../images/triangle_red.png'
import yellowTriangle from '../images/triangle_yellow.png'
import blueTriangle from '../images/triangle_blue.png'

const Building = ({ type, page  }) => {
  // console.log(`building type: ${type}`);
  
  if(type === "None") {
     if(page === 0) {
       return <Image src={yellowTriangle} size = "tiny"/>
     } 
     if(page === 1){
       return <Image src={redTriangle} size = "tiny"/>
     }
     if(page === 2){
       return <Image src={blueTriangle} size = "tiny"/>
     }
  }
  if(type === "Farm") {
    return <Image src={farm} />
    // return <Icon name='food'  size='huge' style={{transform: "rotate(-45deg)", color: "gainsboro"}} />
  }
  if(type === "Mine") {
    return <Image src={mine} />
    // return <Icon name='lock' color="black" size='huge' style={} />
  }
  if(type === "Manor") {
    return <Image src={manor} />
    // return <Icon name="bitcoin"  size='huge' style={} />
  }
  if(type === "Quarry") {
    return <Image src={quarry} />
    // return <Icon name="hand rock"  size='huge' style={} />
  }
  if(type === "Sawmill") {
    return <Image src={sawmill} style={{opacity:"1"}}  size = "huge"/>
    // return <Icon name="tree"  size='huge' style={} />
  }
  if(type === "Castle") {
    return <> </>
    // return <Icon name="chess rook"  size='huge' style={} />
  }
  if(type === "Barrack") {
    return <Image src={barrack} />
    // return <Icon name="shield alternate"  size='huge' style={} />
  }

  if(type === "Laboratory") {
    return <Image src={lab} />
    // return <Icon name="shield alternate"  size='huge' style={} />
  }
  else return<></>;
}

export default Building;