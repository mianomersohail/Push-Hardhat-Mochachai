const { ethers } = require("hardhat");
const { assert } = require('@openzeppelin/test-helpers');
describe("Check Dealing Smart Contract", function () {
  let addr1, addr2, DealToken, Dealing, dealToken, dealing, expect;
  
  before(async function () {
    const chai = await import("chai");
    expect = chai.expect;
    [addr1, addr2] = await ethers.getSigners(); // Get test accounts
    console.log("Address 1: ", addr1.address, "Address 2: ", addr2.address);
    // Deploy DealToken contract
    DealToken = await ethers.getContractFactory("DealToken");
    dealToken = await DealToken.deploy();
    await dealToken.deployed();
    
    // Deploy Dealing contract (depends on DealToken)
    Dealing = await ethers.getContractFactory("Dealing");
    dealing = await Dealing.deploy();
    await dealing.deployed();
  });  
  it("Should create a deal", async function () {
    // Add a deal as the seller (addr2 is the seller, addr1 is the buyer)
    await dealing.connect(addr2).sellerDealAdd(
      addr1.address, // buyer's address
      100,           // deal amount
      5,             // late fees
      Math.floor(Date.now() / 1000) + 86400 // deal deadline (1 day later)
    );
    0
    // Retrieve the deal from the contract
    // Verify deal details
    expect(deal.buyer).to.equal(addr1.address);  // Check buyer's address
    expect(deal.seller).to.equal(addr2.address); // Check seller's address
    expect(deal.dealAmount.eq(100)).to.be.true;       // Check deal amount
    expect(deal.lateFees.eq(5)).to.be.true;           // Check late fees
    expect(deal.fine.eq(0)).to.be.true;            //check fine
    expect(deal.dealStatus).to.equal(1);        //check deal status
    expect(deal.lateDays.eq(0)).to.be.true;
    expect(deal.sendDate.eq(0)).to.be.true;
    expect(deal.dealDeadline.eq(Math.floor(Date.now() / 1000) + 86400)).to.be.true;
    expect(deal.receiveDate.eq(0)).to.be.true;

    });
    
});
