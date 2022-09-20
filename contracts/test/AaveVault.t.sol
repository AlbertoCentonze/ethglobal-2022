// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@forge-std/Test.sol";
import "@forge-std/console.sol";
import "./TestWithHelpers.sol";
import "../src/AaveVault.sol";

//Those tests need to be executed on Polygon
contract aaveVaultTest is TestWithHelpers {


    function setUp() public {
        // Deploy the AaveVault contract
        PolUSDCAddr = 0x2791Bca1f2de4661ED88A30C99A7a9449Aa84174;
        aPolUSDCAddr = 0x625E7708f30cA75bfd92586e17077590C60eb4cD; //aave V3
        //give eth to the DEPLOYER
        vm.hoax(DEPLOYER, 1001 ether);
        aaveVault = new AaveVault(PolUSDCAddr, aPolUSDCAddr);
        vm.stopPrank();

        // Gives ETH to RANDOM user address to be used in tests
        vm.deal(RANDOM, 1001 ether);
    }

    function depositTest(uint256 amount) public {
        // Gives USDC to RANDOM user address to be used in tests
        vm.deal(PolUSDCAddr, RANDOM, amount ether);
        vm.startPrank(RANDOM);
        aaveVault.deposit(amount);
        vm.stopPrank();
        //check if RANDOM's USDC balance = 0 and if Vault's aUSDC balance is >= amount
        assertEq(IERC20(PolUSDCAddr).balanceOf(RANDOM), 0);
        assertEq(IERC20(aPolUSDCAddr).balanceOf(address(aaveVault)));
    }

    function withdrawTest(uint256 amount) public {
        // Gives USDC to RANDOM user address to be used in tests
        vm.deal(PolUSDCAddr, RANDOM, amount ether);
        vm.startPrank(RANDOM);
        aaveVault.deposit(amount);
        vm.stopPrank();

        vm.startPrank(DEPLOYER);
        uint256 initVaultBalance = IERC20(aPolUSDCAddr).balanceOf(address(aaveVault));
        if (amount > IERC20(aPolUSDCAddr).balanceOf(address(aaveVault))){
            vm.expectRevert(); //can't worthdraw more than the total balance
            aaveVault.witdraw(amount);
        }
        else {
            aaveVault.witdraw(amount);
            //check if vault balance = init - amount
            //check if DEPLOYER balance
            assertEq(IERC20(aPolUSDCAddr).balanceOf(address(aaveVault)), initVaultBalance - amount);
            assertEq(IERC20(PolUSDCAddr).balanceOf(DEPLOYER), amount);
        }
        
        vm.stopPrank();
    }

    //claim test
    function claimTest(address recepient, uint256 usdcAmount; uint256 claimableAmount) public {
        //state is reset so need to deposit
        // Gives USDC to RANDOM user address to be used in tests
        vm.deal(PolUSDCAddr, RANDOM, amount ether);
        vm.startPrank(RANDOM);
        aaveVault.deposit(amount);
        vm.stopPrank();
        //get initial vault aPolUSDC balance
        uint256 initVaultBalance = IERC20(aPolUSDCAddr).balanceOf(address(aaveVault));

        //add aPolUSDC in the vault by minting "amount"
        vm.deal(aPolUSDC, address(aaveVault), claimableAmount);

        //claim and send to recipient
        vm.startPrank(DEPLOYER);
        address recipient = makeAddr('recipient');
        aaveVault.claim(recipient);

        //check if the recipient's PolUSDC balance is equal to "amount"
        assertEq(IERC20(PolUSDCAddr).balanceOf(recipient), claimableAmount);
    }

    //multiple deposit and a withdraw
    function multipleDepositAndWithdraw(address[] addresses, uint256[] balances, uint256 withdrawals) public {
        vm.assume(addresses.length == balances.lenth);
        uint256 totalAmount = 0;
        //deposits
        for (uint256 i = 0; i< addresses.length; i++){
            vm.startPrank(addresses[i]);
            //TODO: mint them a random "amount" of USDC;
            aaveVault.deposit(amount);
            totalAmount += amount;
            vm.stopPrank();
        }
        //try a claim and assertEq(recipient balance, 0)
        vm.startPrank(DEPLOYER);
        address recipient = makeAddr('recipient');
        aaveVault.claim(recipient);
        assertEq(IERC20(PolUSDCAddr).balanceOf(recipient), 0);
        for (uint256 i = 0; i<withdrawals; i++){
            //withdrawal
            aaveVault.withdraw(totalAmount/withdrawals);
            //assertEq(recipient balance, totalAmount/withdrawals)
            assertApproxEqAbs(IERC20(PolUSDCAddr).balanceOf(recipient), totalAmount * (i +1) / withdrawals, 0,1 ether);
        }
        vm.stopPrank();
    }

    //multiple deposit, time goes by and claim
    function multipleDepositAndWithdraw(address[] addresses, uint256 withdrawals, uint256 claimableAmount) public {
        uint256 totalAmount = 0;
        //deposits
        for (uint256 i = 0; i< addresses.length; i++){
            vm.startPrank(addresses[i]);
            //mint them random "amount" of USDC;
            aaveVault.deposit(amount);
            totalAmount += amount;
            vm.stopPrank();
        }
        //try a claim and assertEq(recipient balance, claimableAmount)
        vm.deal(aPolUSDC, address(aaveVault), claimableAmount);
        vm.startPrank(DEPLOYER);
        address recipient = makeAddr('recipient');
        aaveVault.claim(recipient);
        assertEq(IERC20(PolUSDCAddr).balanceOf(recipient), claimableAmount);
        for (uint256 i = 0; i<withdrawals; i++){
            //withdrawal
            aaveVault.withdraw(totalAmount/withdrawals);
            //assertEq(recipient balance, totalAmount/withdrawals)
            assertApproxEqAbs(IERC20(PolUSDCAddr).balanceOf(recipient), totalAmount * (i +1) / withdrawals, 0,1 ether);
        }
        vm.stopPrank();
    }
}