pragma solidity^0.4.24;
import "./SafeMath.sol";
import "./ERC20.sol";

contract Trivia {
    using SafeMath for uint256;
    
    Game public game;
    
    function newGame(uint fund) public {
        game = new Game(fund, msg.sender);
    }
}

contract Game {
    using SafeMath for uint256;
    
    uint256 public bounty = 1000;
    address public manager;
    address public player;
    bool public firstGame = true;
    string private answer;
    
    constructor(uint fund, address creator) public payable {
        manager = creator;
        //add to the balance, bounty is already set
        address(this).balance.add(fund);
    }
    function enter(string _answer, uint bet) public payable {
        //this may need to account for gas
        answer = _answer;
        if(!firstGame){
            require(bet >= bounty);
            player = msg.sender;
        } else {
            player = msg.sender;
            firstGame = false;
        }
    }
    function win(string _answer) public payable {
        if(compareStrings(answer, _answer)){
            require(msg.sender == player);
            player.transfer(bounty);
            stakes();   
        }
    }
    function lose() public payable {
        manager.transfer(bounty);
    }
    function bounty() public view returns (uint256) {
        return bounty;
    }
    function compareStrings(string one, string two) internal pure returns (bool) {
        if(bytes(one).length != bytes(two).length) {
            return false;
        } else {
            return keccak256(one) == keccak256(two);
        }
    }
    //this should raise the stakes on the game
    function stakes() private {
        if(bounty > 1000000000000000000){
            bounty = 1000000000000000000;
        } else {
            bounty *= 100;   
        }
    }
    function fundGas() private view {
        require(msg.sender == manager);
        address(this).balance.add(msg.value);
    }
}

//contract needs to be funded with 1.1010101 ether for the bounty and some for gas?
//the first question will be free - need a bool variable to mark the first question - security concerns?
//the next level should require a player to add a certain number of ether into the bounty
//to enter each level, they have to pay into the bounty
//if they win, they get the whole of the bounty
//if they lose, they forfeit the ether, and it gets sent to the manager "house" account
//does the lost bounty get sent to the manager? Or does the difference get raised by the manager
//the amount of the bounty depends on the level of the game