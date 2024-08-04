# Degen Token (ERC-20): Unlocking the Future of Gaming

This Solidity program demonstrates a custom ERC20 token contract called `DegenToken`. It includes functionalities for minting, transferring, burning tokens, and redeeming store items. The contract also incorporates ownership control and basic validations.

## Description

The `DegenToken` contract extends OpenZeppelin's `ERC20`, `Ownable`, and `ERC20Burnable` contracts. It allows the contract owner to mint new tokens and enables users to transfer, burn tokens, and redeem store items. The contract manages a list of store items with predefined prices, which users can redeem by burning tokens. Additionally, it keeps track of the items redeemed by each user.

## Functions

### Mint Tokens

- **Function**: `mintTokens(address to, uint256 amount)`
- **Visibility**: `public`
- **Modifier**: `onlyOwner`
- **Description**: Allows the contract owner to mint new tokens.
- **Parameters**:
  - `to`: Address to receive the minted tokens.
  - `amount`: Number of tokens to mint.

### Decimals

- **Function**: `decimals()`
- **Visibility**: `public pure`
- **Description**: Overrides the ERC20 `decimals` function to return 0 decimal places.

### Retrieve Balance

- **Function**: `retrieveBalance()`
- **Visibility**: `external view`
- **Description**: Retrieves the token balance of the caller.
- **Returns**: 
  - Token balance of the caller.

### Transfer Tokens

- **Function**: `transferTokens(address _receiver, uint256 _value)`
- **Visibility**: `external`
- **Description**: Allows users to transfer tokens to another address.
- **Parameters**:
  - `_receiver`: Address to receive the tokens.
  - `_value`: Number of tokens to transfer.
- **Requirements**:
  - The sender must have a sufficient balance of tokens.

### Burn Tokens

- **Function**: `burnTokens(uint256 _value)`
- **Visibility**: `external`
- **Description**: Allows users to burn (destroy) their own tokens.
- **Parameters**:
  - `_value`: Number of tokens to burn.
- **Requirements**:
  - The sender must have a sufficient balance of tokens.

### Redeem Item

- **Function**: `redeemItem(uint256 itemIndex)`
- **Visibility**: `public`
- **Description**: Allows users to redeem a store item by burning tokens.
- **Parameters**:
  - `itemIndex`: Index of the item in the storeItems array.
- **Requirements**:
  - `itemIndex` must be valid (within the range of store items).
  - The user must have a sufficient balance of tokens to cover the item's price.

### Get Redeemed Items

- **Function**: `getRedeemedItems(address user)`
- **Visibility**: `public view`
- **Description**: Retrieves the list of items redeemed by a user.
- **Parameters**:
  - `user`: Address of the user.
- **Returns**:
  - An array of `StoreItem` structs representing the items redeemed by the user.

## Events

- **Event**: `ItemRedeemed(address player, string itemName, uint256 price)`
- **Description**: Emitted when a user successfully redeems an item from the store.

## Getting Started

### Executing Program

To run this program, you can use Remix, an online Solidity IDE. Follow these steps:

1. Go to the [Remix IDE website](https://remix.ethereum.org).
2. Create a new file by clicking on the "+" icon in the left-hand sidebar.
3. Save the file with a `.sol` extension (e.g., `DegenToken.sol`).
4. Copy and paste the provided code into the file.

```solidity
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

    mapping(address => StoreItem[]) private redeemedItems;

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
        redeemedItems[msg.sender].push(item);
        emit ItemRedeemed(msg.sender, item.name, item.price);
    }

    function getRedeemedItems(address user) public view returns (StoreItem[] memory) {
        return redeemedItems[user];
    }

    event ItemRedeemed(address player, string itemName, uint256 price);
}
```
5. Click on the "Solidity Compiler" tab in the left-hand sidebar.
6. Set the "Compiler" option to "0.8.18" (or another compatible version).
7. Click on the "Compile DegenToken.sol" button.

### Deploying and Interacting

1. After compiling, deploy the contract by clicking on the "Deploy & Run Transactions" tab.
2. Select the DegenToken contract from the dropdown menu and click "Deploy."
3. Once deployed, interact with the contract by calling functions like mintTokens, transferTokens, burnTokens, and redeemItem. Enter parameters and click "transact" to execute.

## Authors

Adrian Oraya

## License

This project is licensed under the MIT License.
