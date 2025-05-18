// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {DevOpsTools} from "foundry-devops/src/DevOpsTools.sol";
import {Script} from "forge-std/Script.sol";
import {BoxV2} from "../src/BoxV2.sol";
import {BoxV1} from "../src/BoxV1.sol";

contract UpgradeBox is Script {
    function run() external returns (address) {
        address mostRecentDeployment = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);
        vm.startBroadcast();
        BoxV2 newBox = new BoxV2();
        vm.stopBroadcast();
        address proxy = upgradeBox(mostRecentDeployment, address(newBox));
        return proxy;
    }

    function upgradeBox(address proxyAddress, address newBox) public returns (address) {
        vm.startBroadcast();
        BoxV1(proxyAddress).upgradeToAndCall(newBox, "");//Hey proxy contract now point to this newBox contract
        vm.stopBroadcast();
        return proxyAddress;
    }
}
