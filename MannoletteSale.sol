// SPDX-License-Identifier: MIT
pragma solidity ^0.8.3;

/**
 * @title MannoletteToken..
 * @dev Interface with the values that we are interested in obtaining from 
 * the smart contract of the MannoletteToken..
 */
interface MannoletteToken {
    function decimals() external view returns(uint8);
    function balanceOf(address _address) external view returns(uint);
    function transfer(address _to, uint256 _value) external returns (bool success);
}

/**
 * @title MannoletteSale..
 * @dev Contract that allows to exchange the tokens for money..
 */
contract MannoletteSale {
    address owner;
    uint price;
    MannoletteToken MannoletteContract;
    uint tokensSold;
    
    event Sold(address _buyer, uint _amount);
    
    /**
     * @dev A new sales contract is created assigning value to the state variables..
     * @param _price token price..
     * @param _addressContract We connect the token interface, with this contract..
     */
    constructor (uint _price, address _addressContract) {
        owner = msg.sender;
        price = _price;
        MannoletteContract = MannoletteToken(_addressContract); 
    }
    
    /**
     * @dev SafeMath library function, it is not exported complete. 
     * Since we are only interested in using this particular function in this small project..
     */
    function mul(uint a, uint b) internal pure returns(uint) {
        if(a == 0)
            return 0;
        
        uint c = a * b;
        assert(c / a == b);
        return c;
    }
    
    /**
     * @dev Token purchase function..
     * @param _numTokens amount of tokens..
     */
    function buy(uint _numTokens) public payable {
        require(msg.value == mul(price, _numTokens));
        //The number of Tokens is multiplied with the casting of 10 
        //raised to the number of decimal places indicated by the token contract. 
        //Which we obtain through the interface.
        uint scaledAmount = mul(_numTokens, uint(10) ** MannoletteContract.decimals());
        require(MannoletteContract.balanceOf(address(this)) >= scaledAmount);
        tokensSold += _numTokens;
        require(MannoletteContract.transfer(msg.sender, scaledAmount));
        emit Sold(msg.sender, _numTokens);
    }
    
    /**
     * @dev Token purchase function..
     */
    function endSold() public {
        require(msg.sender == owner);
        MannoletteContract.transfer(owner, MannoletteContract.balanceOf(address(this)));
        //If we do not cast payable the line gives an error,
        //since from version 8.0 by default the addresses do not come payable.
        payable(msg.sender).transfer(address(this).balance); 
    }
}