// SPDX-License-Identifier: MIT
pragma solidity 0.8.20;

import {IRouterClient} from "@chainlink/contracts-ccip/src/v0.8/ccip/interfaces/IRouterClient.sol";
import {Client} from "@chainlink/contracts-ccip/src/v0.8/ccip/libraries/Client.sol";

contract BasicMessageSender {
    struct Payload {
      address receiver;
      address tokenContract;
      uint256 amount;
      uint256[] tokenIds;
    }

    address immutable i_router;

    event MessageSent(bytes32 messageId);

    constructor(address router) {
        i_router = router;
    }

    receive() external payable {}

    function send(
        uint64 destinationChainSelector,
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

        //get nft here

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
}