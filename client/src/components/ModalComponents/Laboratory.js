import React, { useState, useEffect } from 'react';
import LabPage from './LabPage'
import { Button, Modal, Grid, Icon, Segment, Header, Input, Progress, Menu, Image } from 'semantic-ui-react';
import soldierpng from '../../images/soldier_noback.png';

const Laboratory = ({ idx, x, y, cellState, buildingContract, labContract, account, updateCellState }) => {
  

  useEffect(() => {
  
    
  }, [buildingContract, labContract, account, cellState])

  return <>
    <Modal.Content image>
      <Grid columns='equal' divided padded>
        <Grid.Row stretched>
          <Grid.Column>
            <Header icon>
              Lab
              <br/>
              <Image size='massive' src={soldierpng} />
            </Header>
            <Segment padded color='black'>
              <p>Upgrade Technology  </p>
            </Segment>
          </Grid.Column>
        </Grid.Row>
        <Grid.Row>
          <LabPage idx = {idx} contract = {labContract} account = {account} cellState = {cellState} updateCellState = {updateCellState}/>
        </Grid.Row>
      </Grid>
    </Modal.Content>
  </>

}

export default Laboratory;