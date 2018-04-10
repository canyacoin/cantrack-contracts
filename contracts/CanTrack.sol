pragma solidity '0.4.19';

import '../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol';
import '../lib/strUtils.sol';

contract CanTrack is Ownable {
    
    using strUtils for *;
    
    
    string URL;
    
    mapping(string => uint256) private config;

    struct data {
        uint256 timestamp; 
        string json; 
        address sender;
    }
    
    mapping (string => data) private cantrack;

    string public mostRecentCode;
    
    
    event ShortLink(uint256 timestamp, string code);


    function CanTrack() public {
        // change the block offset to 1000000 to use contract in testnet
        setConfig('blockoffset', 1000000);
        setURL('https://canya-tracker.firebaseapp.com/');
    }
    
    function setURL(string _url) public onlyOwner {
        URL = _url;
    }

    function getURL() public view returns (string) {
        return URL;
    }
    
    function setConfig(string _key, uint256 _value) public onlyOwner {
        config[_key] = _value;
    }

    function getConfig(string _key) public view returns (uint256 _value) {
        return config[_key];
    }

    // Add record
    function addData(string json) public {
        // require(json.isValidJson());

        mostRecentCode = generateShortLink();
        
        cantrack[mostRecentCode] = data({
            timestamp: block.timestamp,
            json: json,
            sender: tx.origin
        });

        ShortLink(block.timestamp, mostRecentCode);
    }

    function getMostRecentCode() public view returns (string) {
        return mostRecentCode;
    }

    // Get record timestamp
    function getTimestamp(string code) public view returns (uint256) {
        return cantrack[code].timestamp;
    }

    // Get record JSON
    function getData(string code) public view returns (string) {
        return cantrack[code].json;
    }

    // Get record sender
    function getSender(string code) public view returns (address) {
        return cantrack[code].sender;
    }

    // Generates a shortlink code for this transaction
    function generateShortLink() internal view returns (string) {
        uint value = block.number - getConfig("blockoffset");
        string memory s1 = value.toBase58(11);
        
        uint256 value2 = uint256(tx.origin);
        string memory s2 = value2.toBase58(2);

        string memory s = strUtils.concat(s1, s2);
        
        return s;
    }
}