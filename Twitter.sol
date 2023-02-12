//SPDX-License-Identifier: MIT
pragma solidity = 0.8.9;

contract Twitter{

    struct Tweet{
        string body;
        bytes32 hash;
        uint time;
        address tweeter;
    }

    Tweet [] private Tweets;
    uint private totalCounts = 0;
    mapping(bytes32 => uint) private hashToindex;
    mapping(address => uint) private userTweetCount;

    event Tweetting(string body, bytes32 hash, uint time, address timer);

    
    function createTweet(string memory _body) public returns(bool) {
        uint time = block.timestamp;
        bytes32 hash = keccak256(abi.encodePacked(_body,msg.sender,time));
        hashToindex[hash] = totalCounts;
        userTweetCount[msg.sender]++;
        totalCounts += 1;
        Tweet memory temp;
        temp.body = _body;
        temp.hash = hash;
        temp.time = time;
        temp.tweeter = msg.sender;
        Tweets.push(temp);
        emit Tweetting(temp.body,temp.hash,temp.time,temp.tweeter);
        return true;
    }
 
    function getAllTweet() public view returns(Tweet [] memory){
        return Tweets;
    }
    
    function getTweetByUser(address _sender) public view returns(Tweet [] memory){
        uint tweetsLength = Tweets.length;
        uint _userTweetCount = userTweetCount[_sender];
        Tweet [] memory _tweet = new Tweet[](_userTweetCount);
        uint j;
        for(uint a = 0; a < tweetsLength; a++){
            if(Tweets[a].tweeter == _sender){
                _tweet[j] = Tweets[a];
                j += 1;
            }
        }
        return _tweet;
    }
}