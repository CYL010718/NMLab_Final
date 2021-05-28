# NmlabFinal
Build your own kingdom!
## Prequisites
node.js, npm, ganache-cli(or ganache), truffle, Metamask(browser add-ons)
```
~ $ sudo apt install nodejs
~ $ sudo apt install npm
~ $ npm install -g ganache-cli
~ $ npm install -g truffle
```
## Usage
clone the github page
```
~ $ git clone
```
open ganache-cli by using command:
```
~ $ ganache-cli -l 0xfffffffffff
```
if you want to always use the same chain, type the following command instead:
```
~ $ ganache-cli -m [MNEMONIC] --db [DB_DIR] -i [NETWORK_ID] -l 0xfffffffffff
```
then do truffle migrate
```
~$ truffle migrate
```
start react
```
~$ cd client
~/client$ npm start
```
choose the network on metamask: Localhost 8545
add an account on ganache to metamask
```
在<匯入帳戶>中選擇<匯入私鑰>，把開啟的ganache中的其中一個帳號的私鑰輸入，即可成功匯入帳戶
```
remember to connect the account to the network
```
在帳號頁面的左上方可看到帳號是否為connected
```
after all this, refresh the page, then enjoy the game!
## Notice
If the game looks weird during playing, please remember to refresh the page, and everything will be alright.
