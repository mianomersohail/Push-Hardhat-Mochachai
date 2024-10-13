const { ethers } =require('hardhat')
describe("Check Dealing Smart Contract", function () {
    let addr1, addr2, Contract, contract, expect;

    before(async function () {
        // Dynamically import Chai
        const chai = await import('chai');
        expect = chai.expect;

        // Get signers from Hardhat environment
        [addr1, addr2] = await ethers.getSigners(); // Correct Hardhat signers
        console.log(addr1.address, addr2.address);

        // Get contract factory (match the contract name 'Dealing' as per Solidity)
        Contract = await ethers.getContractFactory('Dealing');

        // Deploy the contract
        contract = await Contract.deploy();
        await contract.deployed();
    });

    it('Check initial value of current id after deploy', async function () {
        const initialId = await contract.Balance(addr1.address);
        console.log(initialId) // Call the correct state variable
        expect(initialId.eq(0)).to.be.true; // Adjust this to match your contract's logic
    });
    it('Check the Current Id value after a deploy of statevariable',async function(){
        const id=await contract.CurrentId()
        expect(id.eq(0)).to.be.true
    })
});
