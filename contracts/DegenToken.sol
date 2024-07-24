// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "hardhat/console.sol";

contract DegenToken is ERC20, Ownable, ERC20Burnable {

    struct StoreItem {
        string name;
        uint256 price;
    }

    StoreItem[] public storeItems;

    constructor() ERC20("Degen", "DGN") Ownable() {
        storeItems.push(StoreItem("Bronze Card", 100));
        storeItems.push(StoreItem("Silver Card", 200));
        storeItems.push(StoreItem("Gold Card", 300));
    }

    function mintTokens(address to, uint256 amount) public onlyOwner {
        _mint(to, amount); 
    }

    function decimals() override public pure returns (uint8) {
        return 0;
    }

    function retrieveBalance() external view returns (uint256) {
        return this.balanceOf(msg.sender);
    }

    function transferTokens(address _receiver, uint256 _value) external {
        require(balanceOf(msg.sender) >= _value, "Token balance not enough for transfer!");
        approve(msg.sender, _value);
        transferFrom(msg.sender, _receiver, _value);
    }

    function burnTokens(uint256 _value) external {
        require(balanceOf(msg.sender) >= _value, "Token balance not enough to burn");
        burn(_value);
    }

    function redeemItem(uint256 itemIndex) public {
        require(itemIndex < storeItems.length, "Item does not exist");
        StoreItem memory item = storeItems[itemIndex];
        require(balanceOf(msg.sender) >= item.price, "Insufficient balance");
        
        _burn(msg.sender, item.price);
        emit ItemRedeemed(msg.sender, item.name, item.price);
    }
    
    event ItemRedeemed(address player, string itemName, uint256 price);
}
