// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

// util functions for strings
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

import {Base64} from "./libraries/Base64.sol";

// Inherit the contract we imported, so we can use its methods
contract MyEpicNFT is ERC721URIStorage {
    // OpenZeppelin helps us keep track of `tokenIds`
    // it's a unique identifier that starts at 0
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // SVG code - make a baseSvg variable here that all our NFTs can use
    string baseSvg =
        "<svg xmlns='http://www.w3.org/2000/svg' preserveAspectRatio='xMinYMin meet' viewBox='0 0 350 350'><style>.base { fill: white; font-family: serif; font-size: 24px; }</style><rect width='100%' height='100%' fill='black' /><text x='50%' y='50%' class='base' dominant-baseline='middle' text-anchor='middle'>";

    // Three arrays, each with their own theme of random words (adjectives, Dragon Ball characters, food)
    string[] firstWords = [
        "Rabid",
        "Right",
        "Wakeful",
        "Terrible",
        "Careless",
        "Protective",
        "Divergent",
        "Plucky",
        "Dizzy",
        "Serious",
        "Quiet",
        "Macho",
        "Evasive",
        "Hulking",
        "Purring",
        "Earthy",
        "Sufficient",
        "Humdrum",
        "Angry",
        "Lame"
    ];
    string[] secondWords = [
        "Goku",
        "Bulma",
        "Krillin",
        "Piccolo",
        "Gohan",
        "Vegeta",
        "Bardock",
        "MajinBuu",
        "Broly",
        "Trunks",
        "Pan",
        "Baby",
        "Shenron",
        "Bulma",
        "Frieza",
        "Android18",
        "Uub",
        "Videl",
        "ChiChi",
        "Cell"
    ];
    string[] thirdWords = [
        "Sushi",
        "Sashimi",
        "Unagi",
        "Tempura",
        "Soba",
        "Onigiri",
        "Yakitori",
        "Sukiyaki",
        "Pizza",
        "Risotto",
        "Polenta",
        "Lasagna",
        "Ravioli",
        "Arancini",
        "Spaghetti",
        "Bruschetta",
        "Gelato",
        "Doner",
        "Kofte",
        "Baklava"
    ];

    event NewEpicNFTMinted(address sender, uint256 tokenId);

    // We need to pass the name of our NFTs token and it's symbol
    // `ERC721` is the NFT standard
    constructor() ERC721("SquareNFT", "SQUARE") {
        console.log("This is my NFT contract!");
    }

    // Randomly pick a word from each array
    function pickRandomFirstWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        // Seed the random generator
        uint256 rand = random(
            string(abi.encodePacked("FIRST_WORD", Strings.toString(tokenId)))
        );
        // Squash the # between 0 and the length of the array to avoid going out of bounds
        rand = rand % firstWords.length;
        return firstWords[rand];
    }

    function pickRandomSecondWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("SECOND_WORD", Strings.toString(tokenId)))
        );
        rand = rand % secondWords.length;
        return secondWords[rand];
    }

    function pickRandomThirdWord(uint256 tokenId)
        public
        view
        returns (string memory)
    {
        uint256 rand = random(
            string(abi.encodePacked("THIRD_WORD", Strings.toString(tokenId)))
        );
        rand = rand % thirdWords.length;
        return thirdWords[rand];
    }

    function random(string memory input) internal pure returns (uint256) {
        return uint256(keccak256(abi.encodePacked(input)));
    }

    // Public function that users will hit to get their NFT
    function makeAnEpicNFT() public {
        // Get the current tokenId
        uint256 newItemId = _tokenIds.current();

        // Randomly grab one word from each of the three arrays
        string memory first = pickRandomFirstWord(newItemId);
        string memory second = pickRandomSecondWord(newItemId);
        string memory third = pickRandomThirdWord(newItemId);
        string memory combinedWord = string(
            abi.encodePacked(first, second, third)
        );

        // Concatenate it all together, and then close the <text> and <svg> tags
        string memory finalSvg = string(
            abi.encodePacked(baseSvg, combinedWord, "</text></svg>")
        );

        // Get all the JSON metadata in place and base64 encode it
        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        // Set the title of the NFT as the generated word
                        combinedWord,
                        '", "description": "A highly acclaimed collection of squares.", "image": "data:image/svg+xml;base64,',
                        // Add data:image/svg+xml;base64 and then append SVG to base64 encode
                        Base64.encode(bytes(finalSvg)),
                        '"}'
                    )
                )
            )
        );

        // Prepend data:application/json;base64, to our data
        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log("\n--------------------");
        console.log(finalTokenUri);
        console.log("--------------------\n");

        // Mint the NFT with id `newItemId` to the user with public address `msg.sender`
        // You can't call a contract anonymously, you need to have your wallet credentials connected (just like "signing in" and being authenticated).
        _safeMint(msg.sender, newItemId);

        // Set the NFTs unique identifier along with the data associated with that unique identifier
        // This is what makes the NFT valuable!!!
        _setTokenURI(newItemId, finalTokenUri);

        // Increment the counter for when the next NFT is minted
        _tokenIds.increment();

        console.log(
            "An NFT with ID %s has been minted to %s",
            newItemId,
            msg.sender
        );

        emit NewEpicNFTMinted(msg.sender, newItemId);
    }
}
