import React, { useState, useEffect } from "react";
import ProduceContract from "./contracts/Produce.json";
import BarrackContract from "./contracts/Barrack.json";
import LaboratoryContract from "./contracts/Laboratory.json"
import BuildingContract from "./contracts/BuildingFactory.json"
import AccountContract from "./contracts/Account.json"
import WallContract from "./contracts/Wall.json"
import SoldierContract from "./contracts/Soldier.json"
import CannonContract from "./contracts/Cannon.json"
import ProtectorContract from "./contracts/Protector.json"
import SpyContract from "./contracts/Spy.json"

import getWeb3 from "./getWeb3";
import { GameScene } from './components';

// import "./App.css";

import 'semantic-ui-css/semantic.min.css';

export const ContractContext = React.createContext();
const App = () => {
  const [ state, setState ] = useState({ storageValue: 0, web3: null, accounts: null, produceContract: null, barrackContract: null,  buildingContract: null, accountContract: null, labContract: null, 
                                         wallContract: null, soldierContract: null, cannonContract: null, protectorContract: null, spyContract: null});
  useEffect(() => {
    async function getState() {
      try {
        // Get network provider and web3 instance.
        const web3 = await getWeb3();
        // Use web3 to get the user's accounts.
        const accounts = await web3.eth.getAccounts();
        console.log(accounts);
        // Get the contract instance.
        const networkId = await web3.eth.net.getId();
        const deployedNetworkP = ProduceContract.networks[networkId];
        const instanceP = new web3.eth.Contract(
          ProduceContract.abi,
          deployedNetworkP && deployedNetworkP.address,
        );
        const deployedNetworkBa = BarrackContract.networks[networkId];
        const instanceBa = new web3.eth.Contract(
          BarrackContract.abi,
          deployedNetworkBa && deployedNetworkBa.address,
        );
        const deployedNetworkBu = BuildingContract.networks[networkId];
        const instanceBu = new web3.eth.Contract(
          BuildingContract.abi,
          deployedNetworkBu && deployedNetworkBu.address,
        );
        const deployedNetworkA = AccountContract.networks[networkId];
        const instanceA = new web3.eth.Contract(
          AccountContract.abi,
          deployedNetworkA && deployedNetworkA.address,
        );
        const deployedNetworkL = LaboratoryContract.networks[networkId];
        const instanceL = new web3.eth.Contract(
          LaboratoryContract.abi,
          deployedNetworkL && deployedNetworkL.address,
        );
        const deployedNetworkW = WallContract.networks[networkId];
        const instanceW = new web3.eth.Contract(
          WallContract.abi,
          deployedNetworkW && deployedNetworkW.address,
        );
        const deployedNetworkSol = SoldierContract.networks[networkId];
        const instanceSol = new web3.eth.Contract(
          SoldierContract.abi,
          deployedNetworkSol && deployedNetworkSol.address,
        );
        const deployedNetworkCan = CannonContract.networks[networkId];
        const instanceCan = new web3.eth.Contract(
          CannonContract.abi,
          deployedNetworkCan && deployedNetworkCan.address,
        );
        const deployedNetworkPro = ProtectorContract.networks[networkId];
        const instancePro = new web3.eth.Contract(
          ProtectorContract.abi,
          deployedNetworkPro && deployedNetworkPro.address,
        );
        const deployedNetworkSpy = SpyContract.networks[networkId];
        const instanceSpy = new web3.eth.Contract(
          SpyContract.abi,
          deployedNetworkSpy && deployedNetworkSpy.address,
        );

        // Set web3, accounts, and contract to the state, and then proceed with an
        // example of interacting with the contract's methods.
        setState({ web3, accounts, produceContract: instanceP, barrackContract: instanceBa , buildingContract: instanceBu, accountContract: instanceA, labContract: instanceL, 
                                   wallContract: instanceW, soldierContract: instanceSol, cannonContract: instanceCan, protectorContract: instancePro, spyContract: instanceSpy});
      } catch (error) {
        // Catch any errors for any of the above operations.
        alert(
          `Failed to load web3, accounts, or contract. Check console for details.`,
        );
        console.error(error);
      }
    }
    getState();
    // return () => {
    //   cleanup
    // }
  }, []);

  return <>
    {
      (state.produceContract && state.barrackContract && state.buildingContract && state.accountContract && state.labContract && 
       state.wallContract && state.soldierContract && state.cannonContract && state.protectorContract && state.spyContract && state.accounts.length > 0)
      ? 
      <ContractContext.Provider value={state}>
        <div style={{display: "flex", flexDirection: "column", alignItems: "center"}}>
          {/* <Navbar /> */}
          <GameScene />
          {/* <Map /> */}
          <br />
        </div>
      </ContractContext.Provider>
      :
      <p>loading...</p>
    }
  </>

}

export default App;
// class App extends Component {
//   state = { storageValue: 0, web3: null, accounts: null, contract: null };

//   componentDidMount = async () => {
//     try {
//       // Get network provider and web3 instance.
//       const web3 = await getWeb3();

//       // Use web3 to get the user's accounts.
//       const accounts = await web3.eth.getAccounts();

//       // Get the contract instance.
//       const networkId = await web3.eth.net.getId();
//       const deployedNetwork = SimpleStorageContract.networks[networkId];
//       const instance = new web3.eth.Contract(
//         SimpleStorageContract.abi,
//         deployedNetwork && deployedNetwork.address,
//       );

//       // Set web3, accounts, and contract to the state, and then proceed with an
//       // example of interacting with the contract's methods.
//       this.setState({ web3, accounts, contract: instance }, this.runExample);
//     } catch (error) {
//       // Catch any errors for any of the above operations.
//       alert(
//         `Failed to load web3, accounts, or contract. Check console for details.`,
//       );
//       console.error(error);
//     }
//   };

//   runExample = async () => {
//     const { accounts, contract } = this.state;

//     // Stores a given value, 5 by default.
//     await contract.methods.set(5).send({ from: accounts[0] });

//     // Get the value from the contract to prove it worked.
//     const response = await contract.methods.get().call();

//     // Update state with the result.
//     this.setState({ storageValue: response });
//   };

//   render() {
//     if (!this.state.web3) {
//       return <div>Loading Web3, accounts, and contract...</div>;
//     }
//     return (
//       <div style={{display: "flex", flexDirection: "column", alignItems: "center"}}>
//         {/* <h1>Good to Go!</h1>
//         <p>Your Truffle Box is installed and ready.</p>
//         <h2>Smart Contract Example</h2>
//         <p>
//           If your contracts compiled and migrated successfully, below will show
//           a stored value of 5 (by default).
//         </p>
//         <p>
//           Try changing the value stored on <strong>line 40</strong> of App.js.
//         </p>
//         <div>The stored value is: {this.state.storageValue}</div> */}
//         <Navbar />
//         <br />
//         <br />
//         <Map />
//         <br />
//         <br />
//       </div>
//     );
//   }
// }

