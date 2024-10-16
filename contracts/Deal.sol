// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import '../contracts/DealToken.sol';
contract Dealing is DealToken {
    mapping(address => uint256) public Balance;
    mapping(address => uint256) public LockAmount;
    mapping(uint256 => Deal) public Deals;
    uint256 public CurrentId;

    enum Status { Initial, DealAdd, BuyerAgree, SellerSend, BuyerReceive, BuyerSatisfy, SellerSatisfy, DealDone }

    // Modifier to check if the caller is the buyer
    modifier OnlyBuyer(uint256 id) {
        require(msg.sender == Deals[id].buyer, "Only the buyer can modify this deal");
        _;
    }

    // Modifier to check if the caller is the seller
    modifier OnlySeller(uint256 id) {
        require(msg.sender == Deals[id].seller, "Only the seller can send the parcel");
        _;
    }

    struct Deal {
        uint256 id;
        uint256 dealAmount;
        uint256 lateFees;
        uint256 lateDays;
        address buyer;
        address seller;
        uint256 dealAddDate;
        uint256 dealDeadline;
        uint256 sendDate;
        uint256 receiveDate;
        uint256 fine;
        Status dealStatus;
    }

    receive() external payable {
        require(msg.value > 0, "Value should not be zero");
        Balance[msg.sender] += msg.value;
    }

    function withdraw(uint256 amount, address to) external payable {
        require(Balance[msg.sender] >= amount, "Insufficient balance");
        uint256 balanceCheckLock = LockAmount[msg.sender];
        uint256 availableToWithdraw = Balance[msg.sender] - balanceCheckLock;

        require(availableToWithdraw >= amount, "Amount is locked in deals; you cannot withdraw this amount while a deal is running");

        // Transfer the amount to the specified address
        Balance[msg.sender] -= amount;
        payable(to).transfer(amount);
    }

    function sellerDealAdd(address _buyer, uint256 _dealAmount, uint256 _lateFees, uint256 _dealDeadline) external {
        require(msg.sender != _buyer, "Buyer and seller addresses cannot be the same");
        require(block.timestamp < _dealDeadline, "Deal deadline cannot be in the past");

        Deals[CurrentId] = Deal({
            id: CurrentId,
            dealAmount: _dealAmount,
            lateFees: _lateFees,
            lateDays: 0,
            buyer: _buyer,
            seller: msg.sender,
            dealAddDate: block.timestamp,
            dealDeadline: _dealDeadline,
            sendDate: 0,
            receiveDate: 0,
            fine: 0,
            dealStatus: Status.DealAdd
        });

        CurrentId++;
    }

    function buyerAgree(uint256 _id) external OnlyBuyer(_id) {
        require(Deals[_id].dealStatus == Status.DealAdd, "Deal is not in the correct state or already closed");
        require(Balance[Deals[_id].buyer] >= Deals[_id].dealAmount * 2, "Buyer balance should be at least double the deal amount");
        require(Balance[Deals[_id].seller] >= Deals[_id].dealAmount, "Seller balance should be at least equal to the deal amount");

        uint256 balanceLockBuyer = Deals[_id].dealAmount * 2;
        uint256 balanceLockSeller = Deals[_id].dealAmount;

        LockAmount[Deals[_id].buyer] += balanceLockBuyer;
        LockAmount[Deals[_id].seller] += balanceLockSeller;

        Deals[_id].dealStatus = Status.BuyerAgree;
    }

    function sellerSend(uint256 _id) external OnlySeller(_id) {
        require(Deals[_id].dealStatus == Status.BuyerAgree, "Buyer must agree before the seller can send the parcel");

        Deals[_id].sendDate = block.timestamp;
        Deals[_id].dealStatus = Status.SellerSend;
    }

    function buyerReceive(uint256 _id) external OnlyBuyer(_id) {
        require(Deals[_id].dealStatus == Status.SellerSend, "Parcel must be sent by the seller before the buyer can receive it");

        Deals[_id].receiveDate = block.timestamp;

        // Calculate late days if the parcel was received after the deal deadline
        if (Deals[_id].receiveDate > Deals[_id].dealDeadline) {
            uint256 lateDays = (Deals[_id].receiveDate - Deals[_id].dealDeadline) / 1 days;
            uint256 fine = lateDays * Deals[_id].lateFees;
            Deals[_id].lateDays = lateDays;
            Deals[_id].fine = fine;
        }

        Deals[_id].dealStatus = Status.BuyerReceive;
    }

    function buyerSatisfy(uint256 _id) external OnlyBuyer(_id) {
        require(Deals[_id].dealStatus == Status.BuyerReceive, "Buyer must receive the parcel before expressing satisfaction");

        Deals[_id].dealStatus = Status.BuyerSatisfy;
    }

    function sellerSatisfy(uint256 _id) external OnlySeller(_id) {
        require(Deals[_id].dealStatus == Status.BuyerSatisfy, "Buyer must express satisfaction before the seller can complete the deal");

        Deals[_id].dealStatus = Status.SellerSatisfy;
    }
}
