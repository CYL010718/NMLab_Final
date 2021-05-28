import React, { useState, useEffect } from "react";
import ProduceContract from "./contracts/Produce.json";
import BarrackContract from "./contracts/Barrack.json";
import getWeb3 from "./getWeb3";
import { Navbar, GameScene } from './components';

// import "./App.css";

import 'semantic-ui-css/semantic.min.css';
import Building from "./components/Building";

export const ContractContext = React.createContext();
const App = () => {
  const [ state, setState ] = useState({ storageValue: 0, web3: null, accounts: null, contract: null, contractB: null });
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
        const deployedNetworkB = BarrackContract.networks[networkId];
        const instanceB = new web3.eth.Contract(
          BarrackContract.abi,
          deployedNetworkB && deployedNetworkB.address,
        );
        // Set web3, accounts, and contract to the state, and then proceed with an
        // example of interacting with the contract's methods.
        setState({ web3, accounts, contract: instanceP, contractB: instanceB });
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
      (state.contract && state.contractB && state.accounts.length>0)
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

