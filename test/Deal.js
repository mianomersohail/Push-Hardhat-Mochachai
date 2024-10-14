const { ethers } = require("hardhat");
describe("Check Dealing Smart Contract", function () {
  let addr1, addr2, Contract, contract, expect;
  before(async function () {
    const chai = await import("chai");
    expect = chai.expect;
    [addr1, addr2] = await ethers.getSigners();
    console.log(addr1.address, addr2.address);
    Contract = await ethers.getContractFactory("Dealing");
    contract = await Contract.deploy();
    await contract.deployed();
  });
  it("Calling sellerAgreewidthdeal to add new deal and then check the Current Id for update", async function () {
    await contract.BuyerDealAdd(1, 2, addr2.address);
    const id = await contract.CurrentId();
    expect(id.eq(1)).to.be.true;
  });
  it("check the Deal status after deal add by buyer", async function () {
    const dealstatus = await contract.Deals(0);
    const id = dealstatus.id.toNumber();
    const dealamount = dealstatus.dealamount.toNumber();
    const latefees = dealstatus.latefeesperday.toNumber();
    const latedays = dealstatus.latedays.toNumber();
    const buyeraddress = dealstatus.buyer;
    const selleraddress = dealstatus.seller;
    const DealStatus = dealstatus.dealstatus;
    expect(id).to.equal(0);
    expect(dealamount).to.equal(1);
    expect(latefees).to.equal(2);
    expect(latedays).to.equal(0);
    expect(buyeraddress).to.equal(addr1.address);
    expect(selleraddress).to.equal(addr2.address);
    expect(DealStatus).to.equal(1);
  });
  it("Should check the Balance functions to check the status update and any potential vulnerbility",async function(){
      const Address1balance=await contract.Balance(addr1.address)
      console.log(Address1balance)
      //testing for the receive 
      const Address2balance=await contract.Balance(addr2.address)
      const address1=Address1balance.toNumber()
      const Value=await ethers.utils.parseEther('1.0')
      await addr1.sendTransaction({to:contract.address,value:Value})
      const afterdepositbalance=await contract.Balance(addr1.address)
      //Testing for Withdraw

      expect(address1).to.equal(0)
      expect(afterdepositbalance.toString()).to.equal(Value.toString())
      
      await contract.connect(addr1).Withdraw(Value)
      const Baalanceafterwithdraw=await contract.Balance(addr1.address)
      expect(Baalanceafterwithdraw.toString()).to.equal('0')
      //Check for revert from smart contract for withdraw balance which is not available in my smart contract

      const withdrawAmount = ethers.utils.parseEther("1.0"); // Amount to withdraw

    // Check that addr1's initial balance is zero
    const initialBalance = await contract.Balance(addr1.address);
    expect(initialBalance.toString()).to.equal('0');

    // Attempt to withdraw and expect it to revert with "Insufficient Balance"
    await expect(contract.connect(addr1).Withdraw(withdrawAmount)).to.be.revertedWith('Insufficient Balance');


      
    })
});
