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
    address maticSuperfluidHost = 0x3E14dC1b13c488a8d5D310918780c983bD5982E7;
    address maticIdaAddress = 0xB0aABBA4B2783A72C52956CDEF62d438ecA2d7a1;
    address polETHx = 0x27e1e4E6BC79D93032abef01025811B7E4727e85;
    // use the IDAv1Library for the InitData struct

    using IDAv1Library for IDAv1Library.InitData;

    // declare `_idaLib` of type InitData
    IDAv1Library.InitData internal idaLib;
    Superfluid host = Superfluid(maticSuperfluidHost);

    function getIdaLibrary() public {
        idaLib = IDAv1Library.InitData(
            host,
            IInstantDistributionAgreementV1(
                address(
                    host.getAgreementClass(
                        keccak256("org.superfluid-finance.agreements.InstantDistributionAgreement.v1")
                    )
                )
            )
        );
    }
}
