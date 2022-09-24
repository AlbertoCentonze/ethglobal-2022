// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@forge-std/Test.sol";

import {IInstantDistributionAgreementV1} from
    "@superfluid-finance/interfaces/agreements/IInstantDistributionAgreementV1.sol";

import {ISuperfluidToken} from "@superfluid-finance/interfaces/superfluid/ISuperfluidToken.sol";
import {Test} from "@forge-std/Test.sol";
import {
    Superfluid,
    ConstantFlowAgreementV1,
    InstantDistributionAgreementV1,
    SuperTokenFactory,
    SuperfluidFrameworkDeployer
} from "@superfluid-finance/utils/SuperfluidFrameworkDeployer.sol";
import {ERC1820RegistryCompiled} from "@superfluid-finance/libs/ERC1820RegistryCompiled.sol";
import {CFAv1Library} from "@superfluid-finance/apps/CFAv1Library.sol";
import {IDAv1Library} from "@superfluid-finance/apps/IDAv1Library.sol";
import {ISuperfluidToken} from "@superfluid-finance/interfaces/superfluid/ISuperfluidToken.sol";
import {ISuperToken} from "@superfluid-finance/interfaces/superfluid/ISuperToken.sol";

abstract contract MaticTest is Test {
    uint256 maticFork;

    function activateFork() public {
        string memory MATIC_RPC_URL = vm.envString("MATIC_RPC_URL");
        maticFork = vm.createSelectFork(MATIC_RPC_URL);
    }
}

abstract contract MaticSuperfluidTest is MaticTest {
    // use the IDAv1Library for the InitData struct

    // declare `_idaLib` of type InitData

    function getIdaLibrary() public {}
}
