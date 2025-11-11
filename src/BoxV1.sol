// SPDX-License-Identifier: MIT
pragma solidity 0.8.29;

import {OwnableUpgradeable} from "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";
import {Initializable} from "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import {UUPSUpgradeable} from "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";

contract BoxV1 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    uint256 internal number;

    // we can't use any constructor in upgradeable smart contracts
    /// @custom:oz-upgrades-unsafe-allow constructor // means we are not using constructor
    constructor() {
        _disableInitializers();
    }

    // we use a proxy for implimantation(constructor)
    function initialize() public initializer {
        __Ownable_init(msg.sender); // set owner = msg.sender
    }

    function getNumber() external view returns (uint256) {
        return number;
    }

    function version() external pure returns (uint256) {
        return 1;
    }

    // we can add ownable here aswell but we added just to show how constructor works
    function _authorizeUpgrade(address newImplementation) internal override {}
}
