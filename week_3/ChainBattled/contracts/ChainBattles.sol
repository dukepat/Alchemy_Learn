// SPDX-License-Identifier: MIT

pragma solidity ^0.8.2;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "@openzeppelin/contracts/utils/Base64.sol";

// Contract Address: 0x1F3096B0Bdd5d890E3040aDEaba501b1a87f3716
// Second Contract: 0x3AE2c1Ea4E426B833415b62E627185c6368707de
contract ChainBattles is ERC721URIStorage {
    using Strings for uint256;
    using Counters for Counters.Counter; 
    Counters.Counter private _tokenIds;

    struct Props {
        uint256 level;
        uint256 strength;
        uint256 speed;
        uint256 life;
    }

    //Props props;

    mapping(uint256 => Props) public tokenIdToProps;

    event propsAfterMint(string, uint256, string, uint256, string, uint256, string, uint256);
    event propsBeforeTrain(string, uint256, string, uint256, string, uint256, string, uint256);
    event propsAfterTrain(string, uint256, string, uint256, string, uint256, string, uint256);
    constructor() ERC721 ("Chain Battles", "CBTLS") {

    }

    function random(uint256 number) internal returns(uint256){
        return uint(keccak256(abi.encodePacked(block.timestamp,block.difficulty,  
        msg.sender))) % number;
    }

    function getLevels(uint256 tokenId) public view returns (string memory) {
        uint256 levels = tokenIdToProps[tokenId].level;
        return levels.toString();
    }

    function getStrength(uint256 tokenId) public view returns (string memory) {
        uint256 strength = tokenIdToProps[tokenId].strength;
        return strength.toString();
    }

    function getSpeed(uint256 tokenId) public view returns (string memory) {
        uint256 speed = tokenIdToProps[tokenId].speed;
        return speed.toString();
    }

    function getLife(uint256 tokenId) public view returns (string memory) {
        uint256 life = tokenIdToProps[tokenId].life;
        return life.toString();
    }

    function generateCharacter(uint256 tokenId) public view returns(string memory){
        bytes memory svg = abi.encodePacked(
            '<svg xmlns="http://www.w3.org/2000/svg" preserveAspectRatio="xMinYMin meet" viewBox="0 0 350 350">',
            '<style>.base { fill: white; font-family: serif; font-size: 14px; }</style>',
            '<rect width="100%" height="100%" style="fill:blue;stroke:black;stroke-width:5;opacity:0.5"/>',
            '<text x="50%" y="40%" class="base" dominant-baseline="middle" text-anchor="middle">',"Warrior",'</text>',
            '<text x="25%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Levels: ",getLevels(tokenId),'</text>',
            '<text x="75%" y="50%" class="base" dominant-baseline="middle" text-anchor="middle">', "Strength: ",getStrength(tokenId),'</text>',
            '<text x="25%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Speed: ",getSpeed(tokenId),'</text>',
            '<text x="75%" y="70%" class="base" dominant-baseline="middle" text-anchor="middle">', "Life: ",getLife(tokenId),'</text>',
            '</svg>'
        );
        return string(
            abi.encodePacked(
                "data:image/svg+xml;base64,",
                Base64.encode(svg)
            )    
        );
    }

    function getTokenURI(uint256 tokenId) public view returns (string memory){
        bytes memory dataURI = abi.encodePacked(
            '{',
                '"name": "Chain Battles #', tokenId.toString(), '",',
                '"description": "Battles on chain",',
                '"image": "', generateCharacter(tokenId), '"',
            '}'
        );
        return string(
            abi.encodePacked(
                "data:application/json;base64,",
                Base64.encode(dataURI)
            )
        );
    }

    function mint() public {
        _tokenIds.increment();
        uint256 newItemId = _tokenIds.current();
        _safeMint(msg.sender, newItemId);
        tokenIdToProps[newItemId] = Props({
            level: 0,
            strength: random(25),
            speed: random(55),
            life: random(21)
        });
        // tokenIdToLevels[newItemId] = 0;
        _setTokenURI(newItemId, getTokenURI(newItemId));
        emit propsAfterMint(
            "level:", tokenIdToProps[newItemId].level,
            "strength:", tokenIdToProps[newItemId].strength,
            "speed:", tokenIdToProps[newItemId].speed,
            "life", tokenIdToProps[newItemId].life);
    }

    function train(uint256 tokenId) public {
        require(_exists(tokenId));
        require(ownerOf(tokenId) == msg.sender, "You must own this NFT to train it!");
        emit propsBeforeTrain(
            "level:", tokenIdToProps[tokenId].level,
            "strength:", tokenIdToProps[tokenId].strength,
            "speed:", tokenIdToProps[tokenId].speed,
            "life:", tokenIdToProps[tokenId].life
        );
        uint256 currentLevel = tokenIdToProps[tokenId].level;
        tokenIdToProps[tokenId].level = currentLevel + 1;
        tokenIdToProps[tokenId].strength = random(tokenIdToProps[tokenId].strength + 21);
        tokenIdToProps[tokenId].speed = random(tokenIdToProps[tokenId].speed + 13);
        tokenIdToProps[tokenId].life = random(tokenIdToProps[tokenId].life + 15);
        _setTokenURI(tokenId, getTokenURI(tokenId));

        emit propsAfterTrain(
            "level:", tokenIdToProps[tokenId].level,
            "strength:", tokenIdToProps[tokenId].strength,
            "speed:", tokenIdToProps[tokenId].speed,
            "life:", tokenIdToProps[tokenId].life
        );
    }

}