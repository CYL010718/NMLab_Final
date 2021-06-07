import React from 'react';
import { Button, Grid, Icon, Segment, Header, Image } from 'semantic-ui-react';
import woodpng from '../../images/wood_noback.png';
import ironpng from '../../images/iron_noback.png';
import stonepng from '../../images/stone_noback.png';
import coinpng from '../../images/coin_noback.png';
import foodpng from '../../images/food_noback.png';
import soldierpng from '../../images/soldier_noback.png';

const Page = ({ page, build }) => {
  if(page === 0) {
    return <>
      <Grid.Column>
        <Segment placeholder>
          <Header icon>
            Sawmill
            <br/>
            <Image size='massive' src={woodpng} />
          </Header>
          <Button primary onClick={() => build("Sawmill")}>Build</Button>
        </Segment>
      </Grid.Column>
      <Grid.Column>
        <Segment placeholder>
          <Header icon>
            Farm
            <br/>
            <Image size='massive' src={foodpng} />
          </Header>
          <Button primary onClick={() => build("Farm")}>Build</Button>
        </Segment>
      </Grid.Column>
      <Grid.Column>
        <Segment placeholder>
          <Header icon>
            Mine
            <br/>
            <Image size='massive' src={ironpng} />
            <br/>
            <br/>
          <Button primary onClick={() => build("Mine")}>Build</Button>
          </Header>
        </Segment>
      </Grid.Column>
      <Grid.Column>
        <Segment placeholder>
          <Header icon>
            Quarry
            <br/>
            <Image size='massive' src={stonepng} />
          </Header>
          <Button primary onClick={() => build("Quarry")}>Build</Button>
        </Segment>
      </Grid.Column>
      <Grid.Column>
        <Segment placeholder>
          <Header icon>
            Manor
            <br/>
            <Image size='massive' src={coinpng} />
          </Header>
          <Button primary onClick={() => build("Manor")}>Build</Button>
        </Segment>
      </Grid.Column>
    </>
  }
  if(page === 1) {
    return <>
      <Grid.Column>
        <Segment placeholder>
          <Header icon>
            Barrack
            <br/>
            <Image size='massive' src={soldierpng} />
          </Header>
          <Button primary onClick={() => build("Barrack")}>Build</Button>
        </Segment>
      </Grid.Column>
    </>
  }
}

export default Page;