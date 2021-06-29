# NmlabFinal
Final Project for NTUEE Networking and Multimedia Lab(109-2)
## Prequisites
node.js, npm, ganache-cli(or ganache), truffle, Metamask(browser add-ons)
```
~ $ sudo apt install nodejs
~ $ sudo apt install npm
~ $ npm install -g ganache-cli
~ $ npm install -g truffle
```
## Quick Start
```
~ $ git clone https://github.com/CYL010718/NMLab_Final.git
~ $ cd client
~/client$ npm install
```
## Usage
Open ganache-cli by using command:
```
~ $ ganache-cli -l 0xfffffffffff
```
Truffle
```
~$ truffle compile
~$ truffle migrate
```
Start react
```
~$ cd client
~/client$ npm start
```
Choose Localhost 8545 as the network on Metamask, and add an account on ganache to metamask
```
點擊 <匯入帳戶> 並選擇匯入私鑰，將 ganache 中的帳號的私鑰輸入，即可成功匯入帳戶
```
Connect the account to the network
```
在帳號頁面的左上方可看到帳號是否為connected
```
Enjoy the game!

