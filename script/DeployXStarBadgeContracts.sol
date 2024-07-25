// SPDX-License-Identifier: UNLICENSED
pragma solidity 0.8.19;

import {Script} from "forge-std/Script.sol";
import {console} from "forge-std/console.sol";

import {Attestation, IEAS} from "@eas/contracts/IEAS.sol";

import {AttesterProxy} from "../src/AttesterProxy.sol";
import {ScrollBadge} from "../src/badge/ScrollBadge.sol";
import {XStarBadge} from "../src/badge/xstar/XStarBadge.sol";
import {ScrollBadgeTokenOwner} from "../src/badge/examples/ScrollBadgeTokenOwner.sol";
import {ScrollBadgeSelfAttest} from "../src/badge/extensions/ScrollBadgeSelfAttest.sol";
import {ScrollBadgeSingleton} from "../src/badge/extensions/ScrollBadgeSingleton.sol";
import {ScrollBadgeResolver} from "../src/resolver/ScrollBadgeResolver.sol";

contract DeployXStarBadgeContracts is Script {
    uint256 DEPLOYER_PRIVATE_KEY = vm.envUint("DEPLOYER_PRIVATE_KEY");

    address RESOLVER_ADDRESS = vm.envAddress("SCROLL_BADGE_RESOLVER_CONTRACT_ADDRESS");
    address XSTAR_SIGNER_ADDRESS = vm.envAddress("XSTAR_SIGNER_ADDRESS");

    address EAS_ADDRESS = vm.envAddress("EAS_ADDRESS");

    bool IS_MAINNET = vm.envBool("IS_MAINNET");

    function run() external {
        vm.startBroadcast(DEPLOYER_PRIVATE_KEY);

        if (!IS_MAINNET) {
            vm.txGasPrice(10 gwei);
        }

        ScrollBadgeResolver resolver = ScrollBadgeResolver(payable(RESOLVER_ADDRESS));

        // deploy xstar badge
        string memory uri = '';

        if (IS_MAINNET) {
            require(bytes(uri).length > 0, "URI cannot be an empty string");
        }

        XStarBadge badge = new XStarBadge(address(resolver), uri);
        AttesterProxy badgeProxy = new AttesterProxy(IEAS(EAS_ADDRESS));

        // set permissions
        badge.toggleAttester(address(badgeProxy), true);
        badgeProxy.toggleAttester(XSTAR_SIGNER_ADDRESS, true);

        // set permissions
        // FIXME: 这里需要官方来设置
        // resolver.toggleBadge(address(badge), true);

        // log addresses
        logAddress("DEPLOYER_ADDRESS", vm.addr(DEPLOYER_PRIVATE_KEY));
        logAddress("XSTAR_BADGE_ADDRESS", address(badge));
        logAddress("XSTAR_ATTESTER_PROXY_ADDRESS", address(badgeProxy));

        vm.stopBroadcast();
    }

    function logAddress(string memory name, address addr) internal view {
        console.log(string(abi.encodePacked(name, "=", vm.toString(address(addr)))));
    }
}
