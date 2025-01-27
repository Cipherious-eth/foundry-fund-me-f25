//SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {Script, console} from "forge-std/Script.sol";
import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {FundMe} from "../src/FundMe.sol";

contract FundFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;
    address USER = makeAddr("user");

    //writng a function that will fund the most recent deployment of FundMe
    function fundFundMe(address mostRecentDeployed) public {
        vm.prank(USER);
        vm.deal(USER, 100 ether);

        FundMe(payable(mostRecentDeployed)).fund{value: SEND_VALUE}();
        console.log("funded FundMe with a %s", SEND_VALUE);
    }

    //Getting the address of the most recent deployment of FundMe
    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        vm.startBroadcast();
        fundFundMe(mostRecentDeployed);
        vm.stopBroadcast();
    }
}

contract WithdrawFundMe is Script {
    uint256 constant SEND_VALUE = 0.01 ether;

    function withdrawFundMe(address mostRecentDeployed) public {
        vm.startBroadcast();
        FundMe(payable(mostRecentDeployed)).withDraw();
        vm.stopBroadcast();
        console.log("funded FundMe with a %s", SEND_VALUE);
    }

    //Getting the address of the most recent deployment of FundMe
    function run() external {
        address mostRecentDeployed = DevOpsTools.get_most_recent_deployment(
            "FundMe",
            block.chainid
        );
        vm.startBroadcast();
        withdrawFundMe(mostRecentDeployed);
        vm.stopBroadcast();
    }
}
