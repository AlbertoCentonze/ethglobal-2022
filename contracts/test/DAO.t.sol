// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "@forge-std/Test.sol";
import "@forge-std/console.sol";
import "./TestWithHelpers.sol";
import "../src/Shirtless.sol";
import "../src/DAO.sol";
import "@openzeppelin/finance/PaymentSplitter.sol";

contract DaoTest is TestWithHelpers {
    address[] payees;
    uint256[] shares;

    Dao dao;
    Shirtless collection;

    function setUp() public {
        // Deploy the DAO contract
        dao = new Dao();
        // Deploy the NFT collection
        collection = new Shirtless();

        collection.transferOwnership(address(dao));
        dao.setCollection(address(collection));

        setUpSplitter();
    }

    function setUpSplitter() public {
        payees = [DEV_FUND, address(dao)]; // Solidity sucks
        shares = [9, 1];
        dao.setMintSplitter(payable(address(new PaymentSplitter(payees, shares))));
    }

    function testFailMintWithoutSplitter() public {
        // vm.expectRevert(SetUpError);
        dao.mint{value: 1 ether}(); //TODO this test is wrong
    }

    function testFailMintWithNotEnoughMoney() public {
        dao.mint{value: 0.5 ether}();
    }

    function testFailMintWithTooMuchMoney() public {
        dao.mint{value: 1.5 ether}();
    }

    function mintUpToId(uint256 maxId) public {
        address RANDOM = address(34987);
        vm.deal(RANDOM, 1001 ether);
        vm.startPrank(RANDOM);
        for (uint256 id = 0; id < maxId; id++) {
            uint256 idBalance = collection.balanceOf(RANDOM, id);
            assertEq(idBalance, 0);
            dao.mint{value: 1 ether}();
            idBalance = collection.balanceOf(RANDOM, id);
            assertEq(idBalance, 1);
        }
        vm.stopPrank();
    }

    function testMintWholeSupply() public {
        mintUpToId(100);
    }

    function testFailMintMoreThanMaxSupply(uint256 idBiggerThanSupply) public {
        vm.assume(idBiggerThanSupply > 100);
        mintUpToId(idBiggerThanSupply);
    }
}
