pragma solidity ^0.4.24;
import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol";



contract TryGongToken is StandardToken{
        string public name = "TryGongCoin";
        string public symbol = "TGC";
        uint8 public decimals = 3;
        uint256 public INITIAL_SUPPLY = 1000000000000000000000;
        
        constructor() payable public {
        totalSupply_ = INITIAL_SUPPLY;
        balances[msg.sender] = INITIAL_SUPPLY;
        }
        
        
}