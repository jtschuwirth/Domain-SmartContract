// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.10;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";

import { StringUtils } from "./libraries/StringUtils.sol";
import {Base64} from "./libraries/Base64.sol";

import "hardhat/console.sol";

contract Domains is ERC721URIStorage {

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string svgPartOne = '<svg width="270" height="283" viewBox="0 0 270 283" fill="none" xmlns="http://www.w3.org/2000/svg"><rect width="270" height="283" fill="white"/><rect width="270" height="283" fill="#847DD9"/><path d="M135 56L172.239 128H97.7609L135 56Z" fill="#07FCD0"/><path d="M135 227L97.7609 128.75H172.239L135 227Z" fill="#07FCD0"/><path d="M219.5 141.5C219.5 188.45 181.886 226.5 135.5 226.5C89.1136 226.5 51.5 188.45 51.5 141.5C51.5 94.5502 89.1136 56.5 135.5 56.5C181.886 56.5 219.5 94.5502 219.5 141.5Z" stroke="#07FCD0"/></svg>';
    string svgPartTwo = '</text></svg>';

    string public tld;

    mapping(string => address) public domains;
    mapping(string => string) public records;

    constructor(string memory _tld) payable ERC721("Patagonian Name Service", "PNS") {
        tld = _tld;
        console.log("%s name service deployed", _tld);
    }

    function price(string calldata name) public pure returns(uint) {
        uint len = StringUtils.strlen(name);
        require(len > 0);
        if (len == 3) {
            return 5 * 10**17; 
        } else if (len == 4) {
            return 3 * 10**17;
        } else {
            return 1 * 10**17;
        }
    }

    function register(string calldata name) public payable {
        require(domains[name] == address(0));

        uint256 _price = price(name);
        require(msg.value >= _price, "Not enough Matic paid");
		
		    // Combine the name passed into the function  with the TLD
        string memory _name = string(abi.encodePacked(name, ".", tld));
		    // Create the SVG (image) for the NFT with the name
        string memory finalSvg = string(abi.encodePacked(svgPartOne, _name, svgPartTwo));
        uint256 newRecordId = _tokenIds.current();
  	    uint256 length = StringUtils.strlen(name);
		    string memory strLen = Strings.toString(length);

        console.log("Registering %s.%s on the contract with tokenID %d", name, tld, newRecordId);

		    // Create the JSON metadata of our NFT. We do this by combining strings and encoding as base64
        string memory json = Base64.encode(
        bytes(
            string(
            abi.encodePacked(
                '{"name": "',
                _name,
                '", "description": "A domain on the Patagonian name service", "image": "data:image/svg+xml;base64,',
                Base64.encode(bytes(finalSvg)),
                '","length":"',
                strLen,
                '"}'
            )
            )
        )
        );

        string memory finalTokenUri = string( abi.encodePacked("data:application/json;base64,", json));

		    console.log("\n--------------------------------------------------------");
	    console.log("Final tokenURI", finalTokenUri);
	    console.log("--------------------------------------------------------\n");

        _safeMint(msg.sender, newRecordId);
        _setTokenURI(newRecordId, finalTokenUri);
        domains[name] = msg.sender;

        _tokenIds.increment();
    }

  function getAddress(string calldata name) public view returns (address) {
      // Check that the owner is the transaction sender
      return domains[name];
  }

  function setRecord(string calldata name, string calldata record) public {
      // Check that the owner is the transaction sender
      require(domains[name] == msg.sender);
      records[name] = record;
  }

  function getRecord(string calldata name) public view returns(string memory) {
      return records[name];
  }
}