//SPDX-License-Identifier: Unlicense
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract UnpolitePass is ERC1155, Ownable {
    uint256 public totalSupply;
    address public UnpoliteContract;
    uint256 private constant TOKEN_ID = 0;

    constructor() ERC1155("json-url") {}

    // @dev mint function.
    // @notice This function can only be called by EOAs
    // so we prevent contracts from calling it.
    function mint() public payable {
        require(totalSupply < 690, "No more left");
        require(msg.sender == tx.origin, "EOAs only");
        require(balanceOf(msg.sender, TOKEN_ID) == 0, "One per address");
        require(msg.value == 0.1 ether, "Wrong value");

        unchecked {
            ++totalSupply;
        }
        _mint(msg.sender, TOKEN_ID, 1, "");
    }

    // @dev This fucntion is used to burn the mint pass once it has been used by the user.
    function redeem(address holder) public {
        require(msg.sender == UnpoliteContract, "Should be called from main");
        _burn(holder, TOKEN_ID, 1);
    }

    // @dev Function to change the main contract address if needed.
    function setUnpoliteContractAddress(address newAddress) public onlyOwner {
        UnpoliteContract = newAddress;
    }

    // @dev Function to withdraw funds from this contract.
    function withdrawAll() public onlyOwner {
        require(payable(msg.sender).send(address(this).balance));
    }
}
