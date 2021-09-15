// SPDX-License-Identifier: MIT
pragma solidity >=0.4.22 <0.9.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract BatchTransfer {
    // Test function for front-end
    // ---------------------------------------------
    string private message = "This is the batch transfer website!";

    function getMessage() public view returns(string memory) {
        return message;
    }

    function setMessage(string memory newMessage) public {
        message = newMessage;
    }
    // ---------------------------------------------

    constructor() ERC721("BatchTransfer", "BTS") { }

    function getBalance(address _addr, address _owner) external view returns(uint256) {
        require(_addr == msg.sender == true, "Need operator approval for 3rd party transafers.");
        ERC721 smart_contract = ERC721(_addr);
        return smart_contract.balanceOf(_owner);
    }
    
    function singleTransfer(address _addr, address _from, address _to, uint _tokenid) external {
        require(_to != address(0x0), "_to must be non-zero.");
        require(_from == msg.sender == true, "Need operator approval for 3rd party transafers.");
        safeTransferFrom(_from, _to, _tokenid, "");
        ERC721 smart_contract = ERC721(_addr);
        smart_contract.safeTransferFrom(_from, _to, _tokenid, "");
    }
    
    function batchTransfer(string[] memory addr_tokenid_list, address _from, address _to) public {
        require(_to != address(0x0), "_to must be non-zero.");
        require(_from == msg.sender == true, "Need operator approval for 3rd party transafers.");
        for (uint i = 0; i < addr_tokenid_list.length; i++) {
            bytes[2] memory addr_tokenid = splitString(addr_tokenid_list[i], ", ");
            address addr = bytesToAddress(addr_tokenid[0]);
            uint tokenId = bytesToUint(addr_tokenid[1]);
            ERC721 smart_contract = ERC721(addr);
            smart_contract.safeTransferFrom(_from, _to, tokenId, "");
        }
    }
    
    bytes splitStringTemp;
    function splitString(string memory input, string memory delimiter) internal returns(bytes[2] memory) {
        bytes[2] memory splitStringResult;
        bytes memory input_byte = bytes(input);
        bytes memory delimiter_byte = bytes(delimiter);
        for(uint i; i < input_byte.length ; i++){
            if (input_byte[i] != delimiter_byte[0]) {
                splitStringTemp.push(input_byte[i]);
            } else { 
                splitStringResult[0] = splitStringTemp;
                splitStringTemp = "";
            }
        }
        if (input_byte[input_byte.length-1] != delimiter_byte[0]) { 
            splitStringResult[1] = splitStringTemp;
            splitStringTemp = "";
        }
        return splitStringResult;
    }
    
    function bytesToUint(bytes memory _input) pure internal returns (uint result) {
        uint i;
        result = 0;
        for (i = 0; i < _input.length; i++) {
            uint c = uint(uint8(_input[i]));
            if (c >= 48 && c <= 57) {
                result = result * 10 + (c - 48);
            }
        }
    }
    
    function bytesToAddress(bytes memory _address) internal pure returns (address _parsedAddress) {
        uint160 iaddr = 0;
        uint160 b1;
        uint160 b2;
        for (uint i = 2; i < 2 + 2 * 20; i += 2) {
            iaddr *= 256;
            b1 = uint160(uint8(_address[i]));
            b2 = uint160(uint8(_address[i + 1]));
            if ((b1 >= 97) && (b1 <= 102)) {
                b1 -= 87;
            } else if ((b1 >= 65) && (b1 <= 70)) {
                b1 -= 55;
            } else if ((b1 >= 48) && (b1 <= 57)) {
                b1 -= 48;
            }
            if ((b2 >= 97) && (b2 <= 102)) {
                b2 -= 87;
            } else if ((b2 >= 65) && (b2 <= 70)) {
                b2 -= 55;
            } else if ((b2 >= 48) && (b2 <= 57)) {
                b2 -= 48;
            }
            iaddr += (b1 * 16 + b2);
        }
        return address(iaddr);
    }
}