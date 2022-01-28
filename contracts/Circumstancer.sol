// SPDX-License-Identifier: MIT

//            `.-----.`              ..----.`                 `.----.`             .----.`            
//        `-+osssssssssso/.      ./ossssssssso/.           ./osssssssso/.       -+sssooosso/-         
//      `/sss+:.`   ``.:+ss/    /so/-.`   `.:oss:        .+ss/-`    `-/os-    `+ss/.`   `./ss+`       
//     `oss/`            `.`     .           .sss       .sso.           `     +ss-         .sso`      
//    `oss:                                  `sss`     `oso`                 .ss+           +ss/      
//    :sso                                   /ss:      :ss:    `...`         .sso           +sss`     
//    oss:                           ....--/os+.       +ss. -/ossssss+-`      +ss/         :soss.     
//    oss-                          -ssssssss+-`       oss-+o/.````-/sso-     `/sso:.```.:oo-+ss.     
//    +ss:                               ``.:+ss/      osso+`        .oss.      ./ossssso+:` oss`     
//    :sso                                    /ss/     /sss.          -ss/          ````    `sso      
//    `oss/                                   .sso     .sss.          -ss/                  /ss-      
//     `oss+`            `-`    ``            /ss/      :ss+         `oss.    ``          `/ss/       
//       :oss+:-`````.-:+ss/   `sso/-.`   `.-+ss+`       :oso:.   `.:oso-     oso:.`   `./oso-        
//         -/ossssssssss+:.     `-/ossssssssso/.          `:+ssssssss+:`      `-+ossssssso+-          
//            `..---..`              `.---..`                 ..--..              `.---.`             


//    Website:      https://circumstancer.com                                                                                                    
//    Instagram:    https://www.instagram.com/circumstancer_
//    Twitter:      https://twitter.com/Circumstancer_
//    Discord:      https://discord.gg/f4nfyWcT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import '@openzeppelin/contracts/access/Ownable.sol';

contract Circumstancer is ERC721, ERC721Enumerable, Ownable {

    using Counters for Counters.Counter;
    using Strings for uint256;

    Counters.Counter private _idCounter;

    address private mainAddress;
    string  private _baseURIextended;
    uint256 public  RESERVED        = 100;
    uint256 private MAX_MINT        = 15;
    uint256 public  PRICE           = 0.21 ether;
    bool    public  STATUS_SALE     = false;
    uint256 public  MAX_SUPPLY      = 9999;
    string  public  PROVENANCE;

    constructor(address mAddress, string memory _baseURI) ERC721 ("CircumstancerTest", "C369") {
        mainAddress = mAddress;
        _baseURIextended = _baseURI;
    }

    function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal override(ERC721, ERC721Enumerable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC721Enumerable) returns (bool) {
        return super.supportsInterface(interfaceId);
    }

    function setBaseURI(string memory baseURI_) external onlyOwner {
        _baseURIextended = baseURI_;
    }

    function baseURI() public view returns (string memory) {
        return _baseURIextended;
    }

    function setProvenance(string memory provenance) public onlyOwner {
        PROVENANCE = provenance;
    }

    function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
        require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");

        string memory _tokenURI = tokenId.toString();
        string memory base = baseURI();
        
        // If there is no base URI, return the token URI.
        if (bytes(base).length == 0) {
            return _tokenURI;
        }
        // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
        if (bytes(_tokenURI).length > 0) {
            return string(abi.encodePacked(base, _tokenURI));
        }
        // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
        return string(abi.encodePacked(base, tokenId.toString()));
    }

    function setStatusSale(bool newState) public onlyOwner {
        STATUS_SALE = newState;
    }

    // Just in case Eth does some crazy stuff
    function setPrice(uint256 _newPrice) public onlyOwner {
        PRICE = _newPrice;
    }

    // Just in case Eth does some crazy stuff
    function setAddress(address _mAddress) public onlyOwner {
        mainAddress = _mAddress;
    }

    // function getPrice() public view returns (uint256){
    //     return PRICE;
    // }

    // function getReserved() public view returns (uint256){
    //     return RESERVED;
    // }
    
    function mint(uint numberOfTokens) public payable {
        uint256 supply = totalSupply();
        require(STATUS_SALE, "Sale must be active to mint tokens");
        require(numberOfTokens <= MAX_MINT, "Exceeded max token purchase");
        require(supply + numberOfTokens <= MAX_SUPPLY - RESERVED, "Purchase would exceed max tokens");
        require(PRICE * numberOfTokens <= msg.value, "Ether value sent is not correct");

        for (uint256 i = 1; i <= numberOfTokens; i++) {
            _safeMint(msg.sender, supply + i);
        }
    }

    function giveAway(address _to, uint256 _amount) external onlyOwner {
        require( _amount <= RESERVED, "Exceeds Reserved Circumstancer Supply" );

        uint256 supply = totalSupply();
        for(uint256 i; i < _amount; i++){
            _safeMint( _to, supply + i );
        }

        RESERVED -= _amount;
    }

    function withdraw() public onlyOwner {
        uint balance = address(this).balance;
        payable(mainAddress).transfer(balance);
    }
}