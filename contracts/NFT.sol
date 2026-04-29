//SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";

contract MyNFT is ERC1155 {

    string public name;
    string public symbol;

    uint256 public constant ROSE = 0;
    uint256 public constant LILY = 1;

    uint256 public constant ROSE_MAX_SUPPLY = 100;
    uint256 public constant LILY_MAX_SUPPLY = 10000;

    mapping(uint256 => uint256) public totalSupply;

    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "Not owner");
        _;
    }

    constructor(string memory _uri) ERC1155(_uri) {
        name   = "My Flowers";
        symbol = "MFlower";
        owner  = msg.sender;
    }

    function setURI(string memory _uri) external onlyOwner {
        _setURI(_uri);
    }

    function mintRose() external {
        require(balanceOf(msg.sender, ROSE) == 0, "Already own a Rose");
        require(totalSupply[ROSE] + 1 <= ROSE_MAX_SUPPLY, "Exceeds ROSE max supply");
        totalSupply[ROSE] += 1;
        _mint(msg.sender, ROSE, 1, "");
    }

    function mintLily(uint256 amount) external {
        require(totalSupply[LILY] + amount <= LILY_MAX_SUPPLY, "Exceeds LILY max supply");
        totalSupply[LILY] += amount;
        _mint(msg.sender, LILY, amount, "");
    }

    function mintBoth(uint256 lilyAmount) external {
        require(balanceOf(msg.sender, ROSE) == 0, "Already own a Rose");
        require(totalSupply[ROSE] + 1 <= ROSE_MAX_SUPPLY, "Exceeds ROSE max supply");
        require(totalSupply[LILY] + lilyAmount <= LILY_MAX_SUPPLY, "Exceeds LILY max supply");
        totalSupply[ROSE] += 1;
        totalSupply[LILY] += lilyAmount;

        uint256[] memory ids     = new uint256[](2);
        uint256[] memory amounts = new uint256[](2);
        ids[0] = ROSE;  amounts[0] = 1;
        ids[1] = LILY;  amounts[1] = lilyAmount;
        _mintBatch(msg.sender, ids, amounts, "");
    }

    // Block all transfers for ROSE
    function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes memory data) public override {
        require(id != ROSE, "Rose is non-transferable");
        super.safeTransferFrom(from, to, id, amount, data);
    }

    function safeBatchTransferFrom(address from, address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) public override {
        for (uint256 i = 0; i < ids.length; i++) {
            require(ids[i] != ROSE, "Rose is non-transferable");
        }
        super.safeBatchTransferFrom(from, to, ids, amounts, data);
    }
}
