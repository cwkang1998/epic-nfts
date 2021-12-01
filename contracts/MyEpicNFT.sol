//SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import {Base64} from "./libraries/Base64.sol";

contract MyEpicNFT is ERC721URIStorage {
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    string[] firstWords = [
        "Basic",
        "Hulking",
        "Sincere",
        "Narrow",
        "Silent",
        "Madly",
        "Troubled",
        "Calculating",
        "Handsome",
        "Magical"
    ];
    string[] secondWords = [
        "Outlining",
        "Wandering",
        "Attempting",
        "Kissing",
        "Attaining",
        "Sticking",
        "Giving",
        "Remaining",
        "Suceeding"
    ];
    string[] thirdWords = [
        "Knowledge",
        "Replacement",
        "Child",
        "Funeral",
        "Truth",
        "Organization",
        "Map",
        "Video",
        "Weakness",
        "Judgement"
    ];

    constructor() ERC721("RandomWordsNFT", "RWNFT") {
        console.log("This is my NFT contract.");
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    function pickRandomWord(string[] memory arr, uint256 tokenId)
        public
        pure
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("WORDINGSLIST", Strings.toString(tokenId)))
        );

        rand = rand % arr.length;
        return arr[rand];
    }

    function makeAnEpicNFT() public {
        uint256 newItemId = _tokenIds.current();

        string memory first = pickRandomWord(firstWords, newItemId);
        string memory second = pickRandomWord(secondWords, newItemId);
        string memory third = pickRandomWord(thirdWords, newItemId);
        string memory combinedWord = string(
            abi.encodePacked(first, second, third)
        );

        string memory finalSvg = string(
            abi.encodePacked(baseSvg, combinedWord, "</text></svg>")
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        combinedWord,
                        '",',
                        '"description": "A highly scalable collections of random words nft.",',
                        '"image": "data:image/svg+xml;base64,',
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        string memory finalTokenUrl = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n---");
        console.log(finalTokenUrl);
        console.log("\n---");

        _safeMint(msg.sender, newItemId);

        _setTokenURI(newItemId, finalTokenUrl);

        _tokenIds.increment();
        console.log(
            "An NFT w/ ID %s has been minted to %s",
            newItemId,
            msg.sender
        );
    }
}
