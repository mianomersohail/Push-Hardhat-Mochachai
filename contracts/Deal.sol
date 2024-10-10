// SPDX-License-Identifier: MIT
pragma solidity 0.8.27;
contract Dealing{
    mapping(address=>uint256)internal Balance;
    mapping(uint256=>Deal)public Deals;
    uint CurrentId;
    enum Status{Initial,DealAdd,SellerAgree,BuyerSend,SellerReceive,BuyerSatisfy,SellerSatisfy,DealDone}
    struct Deal{
        uint id;
        uint dealamount;
        address buyer;
        address seller;
        Status dealstatus;
    }
    
}
