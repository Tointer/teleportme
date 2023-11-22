// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";
import "@openzeppelin/contracts/token/ERC1155/IERC1155.sol";
import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract BasicMessageSender {
    struct Payload {
      address receiver;
      address tokenContract;
      uint256 amount;
      uint256[] tokenIds;
    }

    enum ER{
        C20, C721, C1155
    }

    address immutable i_router;

    event MessageSent(bytes32 messageId);

    constructor(address router) {
        i_router = router;
    }

    receive() external payable {}

    function send(
        uint64 destinationChainSelector,
        ER tokenType,
        address destinationCollection,
        address collection,
        uint amount,
        uint256[] memory tokenIds
    ) external {
        Client.EVM2AnyMessage memory message = Client.EVM2AnyMessage({
            receiver: abi.encode(destinationCollection),
            data: abi.encode(Payload({
                receiver: msg.sender,
                tokenContract: collection,
                amount: amount,
                tokenIds: tokenIds
            })),
            tokenAmounts: new Client.EVMTokenAmount[](0),
            extraArgs: "",
            feeToken: address(0)
        });

        //deposit token(s)
        for (uint256 i = 0; i < tokenIds.length; i++) {
            depositToken(tokenType, collection, amount, tokenIds[i]);
        }

        uint256 fee = IRouterClient(i_router).getFee(
            destinationChainSelector,
            message
        );

        bytes32 messageId;

        messageId = IRouterClient(i_router).ccipSend{value: fee}(
            destinationChainSelector,
            message
        );

        emit MessageSent(messageId);
    }

    function depositToken(ER tokenType, address collection, uint amount, uint tokenId) private {
        if(tokenType == ER.C20){
            IERC20(collection).transferFrom(msg.sender, address(this), amount);
        } else if(tokenType == ER.C721){
            IERC721(collection).transferFrom(msg.sender, address(this), tokenId);
        } else if(tokenType == ER.C1155){
            IERC1155(collection).safeTransferFrom(msg.sender, address(this), tokenId, amount, "");
        }
    }
}