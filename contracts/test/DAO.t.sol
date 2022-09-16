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

        // Gives the dao control on the NFT collection
        collection.setOwner(address(dao));
        dao.setCollection(address(collection));

        setUpSplitter();
    }

    function setUpSplitter() public {
        payees = [DEV_FUND, address(dao)]; // Solidity sucks
        shares = [9, 1];
        dao.setMintSplitter(new PaymentSplitter(payees, shares));

        // Gives money to RANDOM user address to be used in tests
        vm.deal(RANDOM, 1001 ether);
    }

    function testCannotMintWithoutSplitter() public {
        dao.setMintSplitter(PaymentSplitter(payable(0)));
        vm.expectRevert(bytes("Splitter is not set correctly"));
        dao.mint{value: 1 ether}();
    }

    function testCannotMintWithNotEnoughMoney() public {
        vm.expectRevert(bytes("Value sent in tx does not match mint price"));
        dao.mint{value: 0.5 ether}();
    }

    function testCannotMintWithTooMuchMoney() public {
        vm.expectRevert(bytes("Value sent in tx does not match mint price"));
        dao.mint{value: 1.5 ether}();
    }

    function mintUpToId(uint256 maxId) public {}

    function testMintWholeSupply() public {
        vm.startPrank(RANDOM);
        for (uint256 id = 0; id < 100; id++) {
            uint256 idBalance = collection.balanceOf(RANDOM);
            assertEq(idBalance, id);
            dao.mint{value: 1 ether}();
            idBalance = collection.balanceOf(RANDOM);
            assertEq(idBalance, id + 1);
        }
        vm.stopPrank();
    }

    function testCannotMintMoreThanMaxSupply() public {
        vm.startPrank(RANDOM);
        for (uint256 id = 0; id < 101; id++) {
            uint256 idBalance = collection.balanceOf(RANDOM);
            if (id > 99) {
                vm.expectRevert(bytes("Can't mint more NFTs than max supply"));
            }
            dao.mint{value: 1 ether}();
        }
        vm.stopPrank();
    }

    // function testBurnSupply() public {
    //     vm.startPrank(RANDOM);

    // 			assertEq(collection.balanceOf(RANDOM, 1), 0);

    //     dao.mint{value: 1 ether}();
    //     dao.mint{value: 1 ether}();
    // 			assertEq(collection.balanceOf(RANDOM, 1), 1);

    //     dao.burn(1);
    // 			assertEq(collection.balanceOf(RANDOM, 1), 0);

    //     idBalance = collection.balanceOf(RANDOM, 0);
    //     assertEq(idBalance, 1);

    //     vm.stopPrank();
    // }

    function testBurnTransfer() public {
        vm.deal(RANDOM, 2 ether);
        vm.startPrank(RANDOM);

        dao.mint{value: 1 ether}();
        dao.mint{value: 1 ether}();

        dao.burn(1);

        uint256 ethBalance = RANDOM.balance;
        assertEq(ethBalance, 0.5 ether);

        vm.stopPrank();
    }
}
