// SPDX-License-Identifier: MIT
// Website: https://color.sale
pragma solidity >=0.7.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract ColorSale is ERC721, ERC721Enumerable, Ownable {
    using Strings for uint256;

    string  private baseURIExtended;
    uint256 public  PRICE = 0.00369 ether;
    uint256 public  MAX_MINT = 50;
    uint256 public  MAX_MINT_COMMUNITIES = 15;
    uint256 public  MAX_MINT_RAFFLE = 2;
    uint256 public  MAX_SUPPLY = 16777216;
    mapping(address => bool) public addressCommunities;
    mapping(address => bool) public addressRaffle;
    address private mainAddress;

    constructor(string memory _baseURI) ERC721 ("Color Sale", "CLRS") {
        mainAddress = msg.sender;
        baseURIExtended = _baseURI;
    }

    modifier onlyEOA() {
        require(tx.origin == msg.sender, "The caller must be an EOA");
        _;
    }

    modifier notExceedingMaxSupply(uint256 numberOfTokens) {
        uint256 currentSupply = totalSupply();
        require(currentSupply + numberOfTokens <= MAX_SUPPLY, "Purchase would exceed max tokens");
        _;
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function setBaseURI(string memory newBaseURI) external onlyOwner {
        baseURIExtended = newBaseURI;
    }

    function setPrice(uint256 newPrice) external onlyOwner {
        PRICE = newPrice;
    }

    function setMaxMint(uint256 newMax) external onlyOwner {
        MAX_MINT = newMax;
    }

    function setMaxMintCommunities(uint256 newMax) external onlyOwner {
        MAX_MINT_COMMUNITIES = newMax;
    }

    function setMaxMintRaffle(uint256 newMax) external onlyOwner {
        MAX_MINT_RAFFLE = newMax;
    }

    function addAddresses(address _address, bool isCommunity) external onlyOwner {
        isCommunity ? addressCommunities[_address] = true : addressRaffle[_address] = true;
    }

    function removeAddresses(address _address, bool isCommunity) public onlyOwner {
        isCommunity ? addressCommunities[_address] = false : addressRaffle[_address] = false;
    }

    function baseURI() public view returns (string memory) {
        return baseURIExtended;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
        string memory base = baseURI();
        string memory _tokenURI = tokenId.toString();

        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }
        return string(abi.encodePacked(base, tokenId.toString()));
    }

    function setMainAddress(address _mAddress) public onlyOwner {
        mainAddress = _mAddress;
    }
    
    function mint(uint numberOfTokens) public payable onlyEOA notExceedingMaxSupply(numberOfTokens) {
        uint256 supply = totalSupply();
        uint256 newTokenId = supply + 1;

        require(numberOfTokens <= MAX_MINT, "Exceeded max token purchase");
        require(PRICE * numberOfTokens <= msg.value, "Ether value sent is not correct");

        for (uint256 i = 1; i <= numberOfTokens; i++) {
            _safeMint(msg.sender, newTokenId);
            newTokenId++;
        }
    }

    function freeMintCommunity() public onlyEOA {
        require(addressCommunities[msg.sender], "Not authorized to mint for free [Community].");
        freeMint(msg.sender, MAX_MINT_COMMUNITIES);
        addressCommunities[msg.sender] = false;
    }

    function freeMintRaffle() public onlyEOA {
        require(addressRaffle[msg.sender], "Not authorized to mint for free [Raffle].");
        freeMint(msg.sender, MAX_MINT_RAFFLE);
        addressRaffle[msg.sender] = false;
    }

    function freeMint(address _address, uint256 maxMint) private notExceedingMaxSupply(maxMint) {
        uint256 supply = totalSupply();
        uint256 newTokenId = supply + 1;

        for (uint256 i = 1; i <= maxMint; i++) {
            _safeMint(_address, newTokenId);
            newTokenId++;
        }
    }

    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(mainAddress).transfer(balance);
    }
}