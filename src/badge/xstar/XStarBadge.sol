// SPDX-License-Identifier: MIT

pragma solidity 0.8.19;

import {Attestation} from "@eas/contracts/IEAS.sol";

import {Strings} from "@openzeppelin/contracts/utils/Strings.sol";

import {ScrollBadge} from "../ScrollBadge.sol";
import {ScrollBadgeAccessControl} from "../extensions/ScrollBadgeAccessControl.sol";
import {ScrollBadgeNoExpiry} from "../extensions/ScrollBadgeNoExpiry.sol";
import {ScrollBadgeNonRevocable} from "../extensions/ScrollBadgeNonRevocable.sol";
import {ScrollBadgeSingleton} from "../extensions/ScrollBadgeSingleton.sol";

/// @title XStarBadge
contract XStarBadge is
    ScrollBadgeAccessControl,
    ScrollBadgeNoExpiry,
    ScrollBadgeNonRevocable,
    ScrollBadgeSingleton
{
    string public sharedTokenURI;

    constructor(address resolver_, string memory tokenUri_) ScrollBadge(resolver_) {
        sharedTokenURI = tokenUri_;
    }

    /// @notice Update the shared token URI.
    /// @param sharedTokenURI_ The new shared token URI.
    function updateSharedTokenURI(string memory sharedTokenURI_) external onlyOwner {
        sharedTokenURI = sharedTokenURI_;
    }

    /// @inheritdoc ScrollBadge
    function onIssueBadge(Attestation calldata attestation)
        internal
        override (
            ScrollBadgeAccessControl,
            ScrollBadgeNoExpiry,
            ScrollBadgeNonRevocable,
            ScrollBadgeSingleton
        )
        returns (bool)
    {
        return super.onIssueBadge(attestation);
    }

    /// @inheritdoc ScrollBadge
    function onRevokeBadge(Attestation calldata attestation)
        internal
        override (
            ScrollBadge, ScrollBadgeAccessControl, ScrollBadgeNoExpiry, ScrollBadgeSingleton
        )
        returns (bool)
    {
        return super.onRevokeBadge(attestation);
    }

    /// @inheritdoc ScrollBadge
    function badgeTokenURI(bytes32 uid) public view override returns (string memory) {
        return sharedTokenURI;
    }
}
