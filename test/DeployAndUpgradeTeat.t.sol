// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

import {Test} from "forge-std/Test.sol";
import {DeployBox} from "../script/DeployBox.s.sol";
import {UpgradeBox} from "../script/UpgradeBox.s.sol";
import {BoxV1} from "../src/BoxV1.sol";
import {BoxV2} from "../src/BoxV2.sol";

contract DeployAndUpgradeTest is Test {
    DeployBox public deployBox;
    UpgradeBox public upgradeBox;

    address owner = makeAddr("owner");

    function setUp() public {
        deployBox = new DeployBox();
        upgradeBox = new UpgradeBox();
    }

    function testBoxWorks() public {
        address proxyAddress = deployBox.deployBox();
        uint256 expectedValue = 1;
        assertEq(expectedValue, BoxV1(proxyAddress).version());
    }

    function testDeploymentIsBoxV1() public {
        address proxyAddress = deployBox.deployBox();

        uint256 setValue = 7;

        vm.expectRevert();
        BoxV2(proxyAddress).setNumber(setValue);
    }

    function testUpgrades() public {
        address proxyAddress = deployBox.deployBox();

        BoxV2 boxV2 = new BoxV2();

        upgradeBox.upgradeBox(proxyAddress, address(boxV2));

        uint256 expectedValue = 2;
        assertEq(expectedValue, BoxV2(proxyAddress).version());

        uint256 setValue = 5;
        BoxV2(proxyAddress).setNumber(setValue);
        assertEq(setValue, BoxV2(proxyAddress).getNumber());
    }
}
