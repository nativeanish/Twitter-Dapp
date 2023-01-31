# Building A Decentralized Twitter on the Celo Blockchain 

## Table of Contents
- [Building A Decentralized Twitter on the Celo Blockchain](#building-a-decentralized-twitter-on-the-celo-blockchain)
  * [Introduction](#introduction)
  * [Prerequisites](#prerequisites)
  * [Intro to Solidity](#intro-to-solidity)
  * [Getting Our Code Environment Ready](#getting-our-code-environment-ready)
  * [Structure of a Tweet](#structure-of-a-tweet)
  * [Creating Tweet's collection and more](#creating-tweet-s-collection-and-more)
  * [Creating Tweet on the Celo blockchain](#creating-tweet-on-the-celo-blockchain)
  * [Getting the Tweet which is recorded on the Celo blockchain network](#getting-the-tweet-which-is-recorded-on-the-celo-blockchain-network)
  * [Final Source Code](#final-source-code)
  * [Deploying the Contract on the blockchain](#deploying-the-contract-on-the-blockchain)
  * [Conclusion](#conclusion)

## Introduction
In this series, we will create a twitter-like decentralized application that will run without a centralized server and will run on the Celo blockchain. It is 2 part series in which we are on the first series where we will learn how to create a smart contract in solidity for decentralize Twitter and connect with a UI using ReactJs library.  

## Prerequisites
- Basic knowledge of [Solidity](https://docs.soliditylang.org) programming language
- Basic knowledge of working with Ethereum or Celo blockchain  

Let's get to fundamentals about How Twitter works in real life. 

![Twitter Page](./direct.png) 

When you hit twitter.com on the URL bar, it goes to Twitter's server and shares a ReactJs page from public cloud storage resources available in Twitter's data center to you on your browser which is compiled then with Javascript engine and rendered on your screen. According to your preferences, you use the functionality and features of Twitter with proper authorization. But what is the problem with the traditional method of sharing and receiving data from Twitter? 

The problem is with our data and its privacy policy. When we signup on Twitter, we agree with their terms and condition which states that they will share our data with 3rd party app which is not known to the general public and us. We need to confide our trust with Twitter. So there is not enough trust build with Twitter because we don't know what the heck they are doing with our data. Have you heard about big tech data breaches? 

Let's Deep Dive into Twitter's Decentralized Application that we are going to build.  

![Decentralized Twitter Page](./blockchain.png) 

**Now we need to ask some big and universal questions!**

**How decentralization will help to solve the major issues above listed?** 

**And how the second diagram will solve the problem?**

This question will be staying along with our journey and will be answered by us in the last section by doing and understanding it. 

In our dapp which will be built by us in this series, we will use the Celo blockchain network (specially Alfajores testnet for testing and will be deployed on Mainnet network in Series 2)

## Intro to Solidity 

***Solidity is an object-oriented programming language for writing smart contracts. It is used for implementing smart contracts on various blockchain platforms, most notably, Ethereum.*** 

 <p align="right">- Wikipedia</p> 

Solidity is an advanced programming language for implementing smart contracts on EVM (Ethereum Virtual Machine). It is highly influenced by Javascript, C++, Python and was created by Gavin Wood. It is a statically typed language where variables are explicitly declared.  

Solidity itself cannot be understood by Ethereum Virtual Machine, thus converted into EVM assembly or low-level byte code. There are other languages for interacting with EVM like Vyper, LLL, eWasm, and Huff, etc. 

Celo blockchain uses the official Golang implementation of the Ethereum protocol - GoEthereum (GETH). So all EVM assembly code which is understood by Ethereum Network can be understand by Celo Network.

Let's get started in building our Twitter's smart contract.

## Getting Our Code Environment Ready  

We will write our Solidity code on web IDE provided by Ethereum foundation which can be found on [Remix IDE](https://remix.ethereum.org) or you can download the Remix IDE on your system from Github. [Download Remix IDE for system here](https://github.com/ethereum/remix-desktop/releases). 

After opening Remix IDE on your browser or installing Remix IDE on System, you can create a Solidity file called `Twitter.sol` in your workspace section. 

![File Created on Remix IDE](./filecreation.png) 

Let's start the coding section of our smart contract for Twitter Dapp.  

Attach an SPDX License to the heading of your contract by a comment indicating the license. 

```solidity 

 // SPDX-License-Identifier: MIT 

 ``` 

You can include a specific license according to the trust you want to build in smart contract. The SPDX Licensing System in source code is for describing your smart contract or solidity code about copyright issues. If you don't want to attach a license then you can specify the value ```UNLICENSED```. More information about SPDX License System is on the SPDX website. You can visit here [SPDX](https://spdx.dev/). The List of License supported by SPDX is on the SPDX website [License List](https://spdx.org/licenses/). 

Now we need to touch the compiler versioning of the solidity code. 

```solidity 
pragma solidity = 0.8.9; 

``` 

At the start of the Solidity code, we need to define the compiler version of solidity which will be helpful for getting the latest syntax and generating ABI and bytecode. (ABI stands for Application Binary Interface. It allows interaction with Solidity outside the Ethereum or Celo blockchain network. It is mainly helpful for UI which tends to invoke the contract method and properties. Bytecode are the opcodes (operation codes) actually deployed on the Celo blockchain network). The `pragma` keyword is used to tell the compiler about the version it needs to use for compilation.

A contract in Solidity code is a collection of codes that have a specific address on blockchain. It is defined by  

```solidity

contract Twitter{} 

```  
## Structure of a Tweet 

<b>If you have experience with C/C++ programming language then it will be easy to code in Solidity because Solidity and C/C++ are both statically typed language and Solidity borrow some syntax from C/C++.</b> 

A Twitter dapp is made by tweets which are tweeted by different users. We can define the structure of a tweet in Solidity as:

```solidity
struct Tweet{} 
``` 

Here we have given a basic structure of a Tweet that doesn't contain any information about the tweet. For that, we need to define some basic structure of data that contains information about Tweet. We can have four information resources like tweet body, a unique hash for that tweet, a time when the tweet was created, and the owner of the tweet. 

```solidity

 struct Tweet{ 

     string body; 

     bytes32 hash; 

     uint time; 

     address tweeter; 

 } 
``` 

Let's break the code into pieces.
- ```string body``` defines the tweet of the body which is a string.
- ```bytes32 hash``` is a unique hash generated at the time of the creation of tweet. It will help to index the tweet easily from the blockchain. 
- ```uint time``` is a time variable that can store an unsigned integer from 0 up to 2^256-1 but here it will store a UNIX timestamp (UNIX timestamp is a way to track the time in running total of seconds from January 1, 1970). 
- ```address tweeter``` is an address variable that stores a 40 hexadecimal character long prefixed by ```0x``` which is also known as a unique account address created by a wallet. 

## Creating Tweet's collection and more 

After we have defined the structure of a Tweet. We need to create a database that contains all the Tweets created by each user.  

```solidity
Tweet [] public tweets;
``` 
Here we have created a dynamic state array variable that will store all the Tweets. There are three kinds of variables in solidity which are state, local and global variables. But now we need a hashTable that can store a key-value pairs (unique hash of Tweet => index of Tweet in storage). For creating hashTable, solidity provides a special keyword called mapping which will directly implement the hashTable for storing and reading the data. 

 ```solidity

 mapping(bytes32 => uint) hashtoindex; 

 ``` 

Now we have created a hashTable for mapping our unique hash to the index number of the tweet in ```tweets``` array in storage. Let's create a constructor which will be used for a different purpose or more specifically will used in Series 2 but for now, let's create an empty constructor by using the ```constructor``` keyword followed by empty parameters and curly braces. 

 ```solidity
 constructor(){} 
 ``` 

For now, we need to log our created Tweet on the celo network also known as event log which stores tweet descriptions in transaction log. Solidity provides two special keywords called ```event``` and `emit`. `event` describes what event needs to be emitted and should be defined in our Solidity code, ```emit``` keyword is used for invoking an ```event``` which is stored on transaction log. 

```solidity
event Tweeting(string body, bytes32 hash, uint time, address indexed tweeter); 
``` 

Above code is the definition of an event that stores the tweet information like body also know as tweet statement, a unique hash of tweet, the time when blockchain recorded the tweet and the address which made this tweet. 

## Creating Tweet on the Celo blockchain 
We will write a function that takes a string argument and return a true variable if the tweet is successfully created. 

```solidity 
function createTweet(string memory _body) public returns(bool success){} 
``` 

The above code states that there is a function named `createTweet()` which takes a string as a parameter and is also available publicly and could be called with the contract and returns a true variable as return type. Let's write some more code onto the `createTweet` function for creating Tweet on the Celo blockchain network and logging the `Tweeting` event.
  

 ```solidity

 function createTweet(string memory _body) public returns(bool success){ 

     uint time = block.timestamp; 

     bytes32 hash = keccak256(abi.encodePacked(_body,msg.sender,time)); 

     hashtoindex[hash] = tweets.length; 

     Tweet memory _temporaryTweet; 

     _temporaryTweet.body = _body; 

     _temporaryTweet.hash = hash; 

     _temporaryTweet.time = time; 

     _temporaryTweet.tweeter = msg.sender; 

     tweets.push(_temporaryTweet); 

     emit Tweetting(temp.body,temp.hash,temp.time,temp.tweeter); 

     return true; 

 } 

 ``` 

 In the `createTweet` function, there is an unsigned variable named `time` which takes the Transaction created time as a UNIX timestamp in its value. A `hash` variable is created which is a  derive primitive type of bytes32 which holds 32 bytes. `hash` variable takes a invoke nested function return. 

`keccak256` is a function that computes the Keccak-256 hash of the input. It gives a signature hash of the input data.  <b>`keccak256` shouldn't be confused with sha256. They both are relatively the same.</b> 

  
`keccak256` takes another function as input. `abi.encodePacked` takes a list of different data types and return bytes of memory. `abi.encodePacked` performs packed encoding (Packed Encoding also called ASN.1 which takes any kind of data types or cross-platform data and return a single encoded data.) `abi.encodePacked` gives an ambiguous encoding which doesn't mean anything.  

We call the mapping variable created as `hashtoindex` that takes a key as the hash of the tweet and makes a pair with the length of the tweets variable. Why do we create `hashtoindex` mapping variable? We will know in the next series. 

We named a variable `_temporaryTweet` that is a local variable and doesn't store in the blockchain network. The purpose of `_temporaryTweet` variable is to store the data of creating Tweet types. While we assigned the complete data respectively to the temporary Tweet variable we created and also pushed the temporary Tweet variable to the state variable `tweets`, we need to invoke the event Tweeting to make a Transaction log on this current Transaction. For that, we need to invoke by keyword `emit` following the event name define as `Tweeting` by passing down the exact order of data. 

At Last, we need to return `true` because we have successfully created a tweet in the `tweets` state array variable like database and made a Transaction Log on the Transaction block that a Tweet had been created so at then end we ```return true```. 

## Getting the Tweet which is recorded on the Celo blockchain network 
For reading the tweets from the celo blockchain network. We are creating two function named ```getAllTweets``` and ```getTweetsByUser```. 

```solidity

 function getAllTweets() public view returns(Tweet [] memory){ 

     return tweets; 

 } 

 ``` 

We have created the `getAllTweets` function that takes no parameter and is a public function, which can be called with the contract itself and have a view modifier which means no state variable will be modified and can read the state variable and will return Tweet array variable which is created to store all the Tweet. At the end of `getAllTweets` function, the function returns the tweets state variable which acts as a storage for this contract. 

```solidity

  function getTweetByUser(address _senter) public view returns(Tweet [] memory){ 

         uint totalCounts; 

         for(uint a = 0; a <= tweets.length-1; a++){ 

             if(tweets[a].tweeter == _senter){ 

                 totalCounts += 1; 

             } 

         } 

         Tweet [] memory _tweet = new Tweet[](totalCounts); 

         uint j; 

         for(uint a = 0; a <= tweets.length-1; a++){ 

             if(Tweets[a].tweeter == _senter){ 

                 _tweet[j] = tweets[a]; 

                 j += 1; 

             } 

         } 

         return _tweet; 

     } 

 } 

 ``` 

In `getTweetByUser` function we took a parameter as a tweeter address which will then return an array of Tweet, the tweeter created. There are 2 loops in the function in which the first one counts the number of tweets the sender had created and makes a temporary static or fixed array named `_tweet` of Tweet data types. The second loop is for the assignment of the tweet to the temporary variable created as `__tweet` and at last, it returns the temporary variable by fulfilling the return type as expected. 

## Final Source Code 

Here is your final Source code for this first series of Twitter Dapps. 

```solidity

 //SPDX-License-Identifier: MIT 

 pragma solidity = 0.8.9; 

 contract Twitter{ 

     struct Tweet{ 

         string body; 

         bytes32 hash; 

         uint time; 

         address tweeter; 

     } 

     Tweet [] public tweets; 

     mapping(bytes32 => uint) hashtoindex; 

     constructor(){} 

     event Tweeting(string body, bytes32 hash, uint time, address indexed tweeter); 

     function createTweet(string memory _body) public returns(bool success){ 

         uint time = block.timestamp; 

         bytes32 hash = keccak256(abi.encodePacked(_body,msg.sender,time)); 

         hashtoindex[hash] = tweets.length; 

         Tweet memory _temporaryTweet; 

         _temporaryTweet.body = _body; 

         _temporaryTweet.hash = hash; 

         _temporaryTweet.time = time; 

         _temporaryTweet.tweeter = msg.sender; 

         tweets.push(_temporaryTweet); 

         emit Tweeting(_temporaryTweet.body, _temporaryTweet.hash,_temporaryTweet.time,_temporaryTweet.tweeter); 

         return true; 

     } 

     function getAllTweets() public view returns(Tweet [] memory){ 

         return tweets; 

     } 

     function getTweetByUser(address _senter) public view returns(Tweet [] memory){ 

         uint totalCounts; 

         for(uint a = 0; a <= tweets.length-1; a++){ 

             if(tweets[a].tweeter == _senter){ 

                 totalCounts += 1; 

             } 

         } 

         Tweet [] memory _tweet = new Tweet[](totalCounts); 

         uint j; 

         for(uint a = 0; a <= tweets.length-1; a++){ 

             if(tweets[a].tweeter == _senter){ 

                 _tweet[j] = tweets[a]; 

                 j += 1; 

             } 

         } 

         return _tweet; 

     } 

 } 

 ``` 

 ## Deploying the Contract on the blockchain 

 Now we are at the final stage of deploying our simple Twitter-like smart contract on our preferable network. We will deploy on Alfajores  Testnet. You can also choose hardhat, truffle, or your favorite library that can interact with Celo Mainnet or testnet like Alfajores Testnet.   

(1) Install [Celo Extension Wallet](https://chrome.google.com/webstore/detail/celoextensionwallet/kkilomkmpmkbdnfelcpgckmpcaemjcdh?hl=en) or [Metamask](https://metamask.io/)

(2) Create a wallet using Cell Extension Wallet and follow the instruction or if you choose metamask then follow the setup [guide](https://docs.celo.org/blog/tutorials/3-simple-steps-to-connect-your-metamask-wallet-to-celo)

(3) Get tokens for Alfajores Testnet using [faucet](https://celo.org/developers/faucet)

(4) At last we have to compile and deploy our code on Alfajores Testnet. You can use this [guide](https://docs.celo.org/developer/deploy/remix) for compilation and deployment guide.

## Conclusion

Now we are at the end of this series one. Hope you enjoy the first series by creating a smart contract and deploying it to testnet.  

What we are going to do in series two?  

(1) Adding more features like a retweet, setting up Twitter handle username, uploading your profile picture, sending a personal message to any user, searching user by username, and adding a like button to each tweet. 

(2) We need a frontend to interact with our Twitter Dapp. So We will try to connect with pre-built frontend application.

(3) Getting some real and hard stuff done like gas optimization and interacting with inline assembly or bytecode.

(4) Writing test scripts 

(5) Deploying on Mainnet. 

(6) Answering to <b>some big and universal questions! How decentralization will help to solve the major issues above listed? And how the second diagram will solve the problem?</b>

<b>If you have any suggestion or change you think it should be made then you can make a pull request or DM me on Github or Discord </b>
