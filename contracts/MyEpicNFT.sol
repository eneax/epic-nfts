// SPDX-License-Identifier: MIT

pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "hardhat/console.sol";

// Inherit the contract we imported, so we can use its methods
contract MyEpicNFT is ERC721URIStorage {
    // OpenZeppelin helps us keep track of `tokenIds`
    // it's a unique identifier that starts at 0
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    // We need to pass the name of our NFTs token and it's symbol
    // `ERC721` is the NFT standard
    constructor() ERC721("SquareNFT", "SQUARE") {
        console.log("This is my NFT contract!");
    }

    // Public function that users will hit to get their NFT
    function makeAnEpicNFT() public {
        // Get the current tokenId
        uint256 newItemId = _tokenIds.current();

        // Mint the NFT with id `newItemId` to the user with public address `msg.sender`
        // You can't call a contract anonymously, you need to have your wallet credentials connected (just like "signing in" and being authenticated).
        _safeMint(msg.sender, newItemId);

        // Set the NFTs unique identifier along with the data associated with that unique identifier
        // This is what makes the NFT valuable!!!
        _setTokenURI(
            newItemId,
            "data:application/json;base64,ewogICJuYW1lIjogIkVuZXJ1VmVnZXRhT3JvY2hpbWFydSIsCiAgImRlc2NyaXB0aW9uIjogIkFuIE5GVCBmcm9tIHRoZSBoaWdobHkgYWNjbGFpbWVkIHNxdWFyZSBjb2xsZWN0aW9uIiwKICAiaW1hZ2UiOiAiZGF0YTppbWFnZS9zdmcreG1sO2Jhc2U2NCxQSE4yWnlCNGJXeHVjejBpYUhSMGNEb3ZMM2QzZHk1M015NXZjbWN2TWpBd01DOXpkbWNpSUhCeVpYTmxjblpsUVhOd1pXTjBVbUYwYVc4OUluaE5hVzVaVFdsdUlHMWxaWFFpSUhacFpYZENiM2c5SWpBZ01DQXpOVEFnTXpVd0lqNEtJQ0FnSUR4emRIbHNaVDR1WW1GelpTQjdJR1pwYkd3NklIZG9hWFJsT3lCbWIyNTBMV1poYldsc2VUb2djMlZ5YVdZN0lHWnZiblF0YzJsNlpUb2dNVFJ3ZURzZ2ZUd3ZjM1I1YkdVK0NpQWdJQ0E4Y21WamRDQjNhV1IwYUQwaU1UQXdKU0lnYUdWcFoyaDBQU0l4TURBbElpQm1hV3hzUFNKaWJHRmpheUlnTHo0S0lDQWdJRHgwWlhoMElIZzlJalV3SlNJZ2VUMGlOVEFsSWlCamJHRnpjejBpWW1GelpTSWdaRzl0YVc1aGJuUXRZbUZ6Wld4cGJtVTlJbTFwWkdSc1pTSWdkR1Y0ZEMxaGJtTm9iM0k5SW0xcFpHUnNaU0krUlc1bGNuVldaV2RsZEdGUGNtOWphR2x0WVhKMVBDOTBaWGgwUGdvOEwzTjJaejQ9Igp9"
        );
        console.log(
            "An NFT with ID %s has been minted to %s",
            newItemId,
            msg.sender
        );

        // Increment the counter for when the next NFT is minted
        _tokenIds.increment();
    }
}
