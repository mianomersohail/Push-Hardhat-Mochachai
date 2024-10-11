// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;
contract Dealing {
    mapping(address => uint256) internal Balance;
    mapping(uint256 => Deal) public Deals;
    uint CurrentId;
    enum Status {
        Initial,
        DealAdd,
        SellerAgree,
        BuyerSend,
        SellerReceive,
        BuyerSatisfy,
        SellerSatisfy,
        DealDone
    }
    struct Deal {
        uint id;
        uint dealamount;
        address buyer;
        address seller;
        Status dealstatus;
    }
    function Withdraw(uint amount) public payable {
        require(Balance[msg.sender] >= amount, "Insuffient Balance");
        Balance[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }
    receive() external payable {
        assert(msg.value > 0);
        Balance[msg.sender] += msg.value;
    }
}
