// SPDX-License-Identifier: MIT
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
pragma solidity 0.8.27;
contract DealToken is ERC20{
    uint256 public constant BURN_AMOUNT = 800000000 * 10 ** 18;    // 800 million tokens to burn
    uint256 public constant PUBLIC_SALE_SUPPLY = 100000000 * 10 ** 18; // 100 million tokens for public sale
    uint256 public constant JACKPOT_SUPPLY = 100000000 * 10 ** 18;     // 100 million tokens for Jackpot
    
    constructor() ERC20("DEALING","DEAL"){
        _mint(msg.sender,  1000000000 * 10 ** 18);
        _burn(0x0000000000000000000000000000000000000000, BURN_AMOUNT);
    }

}