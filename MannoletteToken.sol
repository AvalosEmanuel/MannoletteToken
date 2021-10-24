// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

/**
 * @title MannoletteToken..
 * @dev Token ERC20.. allows authorizing a third party to handle a certain volume of own tokens..
 */
contract MannoletteToken {
    string public name; //Token name..
    string public symbol; //Token symbol..
    uint8 public decimals; //Number of decimals
    uint public totalSupply; //Amount of tokens
    address public owner; //Owner's address
    
    mapping(address => uint) public balanceOf; //indicates the amount of token with which an address has..
    mapping(address => mapping(address => uint)) public allowance; //indicates how many tokens can be managed by the authorized..
    
    event Transfer(address indexed _from, address indexed _to, uint256 _value); 
    event Approval(address indexed _owner, address indexed _spender, uint256 _value);
    
    /**
     * @dev value is assigned to each of the state variables..
     */
    constructor() {
        name = "Mannolette";
        symbol = "MNT";
        decimals = 18;
        totalSupply = 1000000 * (uint(10) ** decimals);
        balanceOf[msg.sender] = totalSupply;
        owner = msg.sender;
    }
    
    /**
     * @dev Function to transfer tokens..
     * @param _to shipping address of the new owner..
     * @param _value amount of tokens to send..
     * @return success_ indicates if the operation was performed..
     */
    function transfer(address _to, uint256 _value) public returns (bool success_) {
        require(balanceOf[msg.sender] >= _value);
        balanceOf[msg.sender] -= _value;
        balanceOf[_to] += _value;
        emit Transfer(msg.sender, _to, _value);
        return true;
    }
    
    /**
     * @dev Function to authorize a third party to manage part of my token portfolio..
     * @param _spender authorized address..
     * @param _value amount of tokens you have available..
     * @return success_ indicates if the operation was performed..
     */
    function approve(address _spender, uint256 _value) public returns (bool success_) {
        allowance[msg.sender][_spender] = _value;
        emit Approval(msg.sender, _spender, _value);
        return true;
    }
    
    /**
     * @dev Function to transfer tokens by the authorized..
     * @param _from address of the original owner of the tokens..
     * @param _to shipping address of the new owner..
     * @param _value amount of tokens to send..
     * @return success_ indicates if the operation was performed..
     */
    function transferFrom(address _from, address _to, uint256 _value) public returns (bool success_) {
        require(balanceOf[_from] >= _value);
        require(allowance[_from][msg.sender] >= _value);
        balanceOf[_from] -= _value;
        balanceOf[_to] += _value;
        allowance[_from][msg.sender] -= _value;
        emit Transfer(_from, _to, _value);
        return true;
    }
}