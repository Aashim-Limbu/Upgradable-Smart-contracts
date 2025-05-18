// SPDX-License-Identifier: MIT
pragma solidity ^0.8.29;

import {Test} from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";

contract DeployandUpgradTest is Test {
    address public proxy;
    DeployBox public deployer;
    UpgradeBox public upgrader;
    address public OWNER = makeAddr("OWNER");
    BoxV1 public boxv1;
    BoxV2 public boxv2;

    function setUp() public {
        deployer = new DeployBox();
        upgrader = new UpgradeBox();
        proxy = deployer.deployBox();
        deployer.run();
    }
    function testProxyStartAsBoxV1() public {
        vm.expectRevert();
        BoxV2(proxy).setNumber(7);

    }
    function testUpgrades() public {
        boxv2 = new BoxV2();
        upgrader.upgradeBox(proxy, address(boxv2));
        uint256 expectedValue = 2;
        assertEq(expectedValue, BoxV2(proxy).getVersion());

        BoxV2(proxy).setNumber(7);
        assertEq(7,BoxV2(proxy).getNumber());
    }
}
