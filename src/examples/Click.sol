// SPDX-License-Identifier: MIT
pragma solidity 0.8.23;

import {Ownable} from "openzeppelin-contracts/contracts/access/Ownable.sol";
import {Address} from "openzeppelin-contracts/contracts/utils/Address.sol";
import {SignatureChecker} from "openzeppelin-contracts/contracts/utils/cryptography/SignatureChecker.sol";

import {IOffchainAuthorization} from "../offchain-authorization/IOffchainAuthorization.sol";
import {PermissionCallable} from "../permissions/AllowedContract/PermissionCallable.sol";

contract Click is PermissionCallable {
    event Clicked(address indexed account);

    function click() public {
        emit Clicked(msg.sender);
    }

    function supportsPermissionedCallSelector(bytes4 /*selector*/ ) public pure override returns (bool) {
        return true;
    }
}

contract AuthorizedClick is Click, Ownable, IOffchainAuthorization {
    constructor(address initialOwner) Ownable(initialOwner) {}

    function getRequestAuthorization(bytes32 hash, bytes calldata signature) external view returns (Authorization) {
        if (!SignatureChecker.isValidSignatureNow(owner(), hash, signature)) {
            return Authorization.UNPROTECTED;
        } else {
            return Authorization.AUTHORIZED;
        }
    }
}