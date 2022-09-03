// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts@4.7.3/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts@4.7.3/access/Ownable.sol";

contract UNPP is ERC1155, Ownable {
    error SoldOrToMany(string message);
    error LessThanZero(string message);

    uint256 MAX_SUPPLY = 690;
    uint256 public minted = 0;

    constructor()
        ERC1155(
            "ipfs://bafkreifrrlvmjc74fh75ngrdmbs5i737q6ecsxd2h27oqxbsoranxgs3ki"
        )
    {}

    function mint(uint256 amount) public payable {
        require(
            msg.value == 0.042 ether * amount,
            "You didn't pay enough, the price is 0.0420 for each pass"
        );

        if (amount < 0)
            revert LessThanZero("You CAN'T mint less than 1 token mate...");
        if (minted + amount >= MAX_SUPPLY)
            revert SoldOrToMany(
                "We either sold out, or you are trying to mint more than the amount left"
            );

        _mint(msg.sender, 1, amount, "");

        unchecked {
            minted += amount;
        }
    }

    function withdrawFunds() public onlyOwner {
        require(address(this).balance > 0, "There are no funds to withdraw");
        payable(owner()).transfer(address(this).balance);
    }
}
