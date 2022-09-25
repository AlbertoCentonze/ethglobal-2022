// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "@forge-std/Test.sol";
import "@forge-std/console.sol";
import "./TestWithHelpers.sol";
import "../src/AaveVault.sol";
import "./MaticTest.sol";

//Those tests need to be executed on Polygon
contract aaveVaultTest is TestWithHelpers, MaticTest {
    AaveVault aaveVault;

    function setUp() public {
        activateFork(33424436);

        //create the new vault
        vm.deal(RANDOM, 10 ether);
        vm.startPrank(DEPLOYER);
        address COLLECTION = makeAddr('collection');
        aaveVault = new AaveVault(polWeth, 50, 0xa97684ead0e402dC232d5A977953DF7ECBaB3CDb);
        vm.stopPrank();
        //give RANDOM enough to pay for gas
        vm.deal(RANDOM, 10 ether);
        //console.log("RANDOM possess ", IERC20(polWeth).balanceOf(RANDOM), " polWETH");
    }

    function testDeposit(uint128 amount) public {//TODO: find why it doesn't work with uint256
        vm.assume(amount > 0);
        deal(polWeth, RANDOM, amount);
        require(amount > 0);
        console.log("amount is ", amount);
        //initial RANDOM's balance of polWETH
        vm.startPrank(RANDOM); //RANDOM possess 10 polWETH and 10 MATIC
        IERC20(polWeth).approve(address(aaveVault), amount);
        aaveVault.deposit(amount);
        vm.stopPrank();
        //check if RANDOM's polWETH balance = 0 and if Vault's aUSDC balance is >= amount and if totalDepositedUnderlying == amount
        assertEq(IERC20(polWeth).balanceOf(RANDOM), 0);
        console.log("aaveVault balance is ", IERC20(aPolWeth).balanceOf(address(aaveVault)));
        console.log("amount = ", amount);
        assertApproxEqAbs(IERC20(aPolWeth).balanceOf(address(aaveVault)) - amount, 0, 1);
        //assertEq(true, IERC20(aPolWeth).balanceOf(address(aaveVault)) >= amount);
        assertEq(aaveVault.totalUnderlyingDeposited(), amount);
    }

    function testWithdraw(uint128 amount) public {//TODO: find why it doesn't work with uint256
        vm.assume(amount > 0);
        require(amount > 0);
        //Gives polWETH to RANDOM's address to be used in tests
        deal(polWeth, RANDOM, amount);
        console.log("RANDOM possesses ", amount, " of polWETH");

        //let RANDOM deposit amount of polWeth
        vm.startPrank(RANDOM);
        IERC20(polWeth).approve(address(aaveVault), amount);
        aaveVault.deposit(amount);
        vm.stopPrank();
        console.log("RANDOM deposited ", amount, " of polWETH");

        //let the owner of aaveVault withdraw the deposit
        vm.startPrank(DEPLOYER);

        uint256 initVaultBalance = IERC20(aPolWeth).balanceOf(address(aaveVault));
        console.log("initial vault balance is ", initVaultBalance);
        console.log("Checking if the amount deposited by RANDOM == initVaultBalance");
        console.log("amount = ", amount, " and vaultBalance = ", initVaultBalance);

        assertApproxEqAbs(amount, initVaultBalance, 1);
        console.log("first test passed");
        //let the deployer withdraw what is in the vault
        aaveVault.withdraw(initVaultBalance, DEPLOYER);
        //check if vault balance = init - amount
        console.log("checking if vaultBalance == 0 after withdrawing");
        console.log("finalVaultBalance = ", IERC20(aPolWeth).balanceOf(address(aaveVault)), " and initialVaultBalance - amount = ", initVaultBalance - amount);
        assertApproxEqAbs(IERC20(aPolWeth).balanceOf(address(aaveVault)), initVaultBalance - amount, 1);
        console.log("second test passed");
        //check if DEPLOYER balance is equal to amount
        assertEq(IERC20(polWeth).balanceOf(DEPLOYER), amount);
        vm.stopPrank();
    }

    //test burner value
    function testBurnerWithdraw(uint256 amount) public {
        deal(polWeth, RANDOM, amount); 
        vm.startPrank(RANDOM);
        //RANDOM is depositing amount polWeth
        //IERC20(polWeth).approve(address(aaveVault), amount);
        //aaveVault.deposit(amount);
        console.log("RANDOM has deposited ", amount, " of polWETH");
        //TODO deploy a DAO and mint some NFT to see if we get (amount/totalSupply*0.5)
        /*dao.mint{value: 1 ether}();
        assertEq(collection.balanceOf(RANDOM), 1);

        dao.mint{value: 1 ether}();
        assertEq(collection.balanceOf(RANDOM), 2);

        dao.burn(1);
        assertEq(collection.balanceOf(RANDOM), 1);

        dao.mint{value: 1 ether}();
        assertEq(collection.balanceOf(RANDOM), 2);
        vm.stopPrank();*/
    }
    
    //claim test
    function testClaimInterest(address recipient, uint128 amount, uint128 claimableAmount) public {
        vm.assume(amount > 0 && claimableAmount > 0 && recipient != 0x0000000000000000000000000000000000000000);
        //state is reset so need to deposit
        // Gives polWETH to RANDOM user address to be used in tests
        deal(polWeth, RANDOM, amount); 
        vm.startPrank(RANDOM);
        //RANDOM is depositing amount polWeth
        IERC20(polWeth).approve(address(aaveVault), amount);
        aaveVault.deposit(amount);
        console.log("RANDOM has deposited ", amount, " of polWETH");
        vm.stopPrank();
        //get initial vault aPolUSDC balance
        uint256 initVaultBalance = IERC20(aPolWeth).balanceOf(address(aaveVault));
        console.log("aaveVault balance before interests = ", initVaultBalance);

        //add aPolUSDC in the vault by minting "amount"
        address aPolWethHolder = 0x3A5bd1E37b099aE3386D13947b6a90d97675e5e3;
        vm.assume(claimableAmount <= IERC20(aPolWeth).balanceOf(aPolWethHolder));
        vm.startPrank(aPolWethHolder);
        IERC20(aPolWeth).transfer(address(aaveVault), claimableAmount);
        vm.stopPrank();

        //claim and send to recipient
        vm.startPrank(DEPLOYER);
        console.log("Claiming interests");
        aaveVault.claimInterest(recipient);

        //check if the recipient's polWEtH balance is equal to "amount"
        console.log("RECIPIENT balance of polWETH = ", IERC20(polWeth).balanceOf(recipient), "; Claimable amount = ", claimableAmount);
        assertApproxEqAbs(IERC20(polWeth).balanceOf(recipient), claimableAmount, 1);
    }
    
    
    //multiple deposit and a withdraw
    function testMultipleDepositAndWithdraw(address[] calldata addresses, uint256[] calldata balances, uint256 withdrawals) public {
        vm.assume(addresses.length == balances.length);
        uint256 totalAmount = 0;
        //deposits
        for (uint256 i = 0; i< addresses.length; i++){
            vm.startPrank(addresses[i]);
            //TODO: mint them a random "amount" of USDC;
            uint256 amount = balances[i];
            aaveVault.deposit(amount);
            totalAmount += amount;
            vm.stopPrank();
        }
        //try a claim and assertEq(recipient balance, 0)
        vm.startPrank(DEPLOYER);
        address RECIPIENT = makeAddr('recipient');
        console.log("trying to claim interests");
        aaveVault.claimInterest(RECIPIENT);
        console.log("checking that the recipient doesn't get any interest");
        console.log("RECIPIENT balance = ", IERC20(polWeth).balanceOf(RECIPIENT));
        assertEq(IERC20(polWeth).balanceOf(RECIPIENT), 0);
        for (uint256 i = 0; i<withdrawals; i++){
            //withdrawal
            aaveVault.withdraw(totalAmount/withdrawals, RECIPIENT);
            //assertEq(recipient balance, totalAmount/withdrawals);
            console.log("asserting that RECIPIENT balance : ", IERC20(polWeth).balanceOf(RECIPIENT), " equal to currentlyWithdrawnAmount: ", totalAmount * (i +1) / withdrawals);
            assertApproxEqAbs(IERC20(polWeth).balanceOf(RECIPIENT), totalAmount * (i +1) / withdrawals, 0.1 ether);
        }
        vm.stopPrank();
    }

    /*
    //multiple deposits and withdrawals + interests claim
    function multipleDepositAndWithdraw(address[] addresses, uint256 withdrawals, uint256 claimableAmount) public {
        uint256 totalAmount = 0;
        //deposits
        for (uint256 i = 0; i< addresses.length; i++){
            vm.startPrank(addresses[i]);
            //mint them random "amount" of USDC;
            // aaveVault.deposit(amount);
            //totalAmount += amount;
            vm.stopPrank();
        }
        //try a claim and assertEq(recipient balance, claimableAmount)
        // vm.deal(aPolUSDC, address(aaveVault), claimableAmount);
        // vm.startPrank(DEPLOYER);
        address recipient = makeAddr('recipient');
        // aaveVault.claim(recipient);
        // assertEq(IERC20(PolUSDCAddr).balanceOf(recipient), claimableAmount);
        for (uint256 i = 0; i<withdrawals; i++){
            //withdrawal
            // aaveVault.withdraw(totalAmount/withdrawals);
            //assertEq(recipient balance, totalAmount/withdrawals)
            // assertApproxEqAbs(IERC20(PolUSDCAddr).balanceOf(recipient), totalAmount * (i +1) / withdrawals, 0,1 ether);
        }
        vm.stopPrank();
    }*/
}
