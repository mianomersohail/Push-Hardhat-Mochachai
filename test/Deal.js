// Import ethers from Hardhat
const { ethers } = require('ethers');

describe("Check Dealing Smart Contract", function () {
    let addr1;
    let addr2;
    let Contract;
    let contract;
    let expect;

    before(async function () {
        // Dynamically import Chai
        const chai = await import('chai');
        expect = chai.expect;

        // Get signers from Hardhat environment
        [addr1, addr2] = await ethers.getSigners();

        // Get contract factory
        Contract = await ethers.getContractFactory('Deal');

        // Deploy the contract
        contract = await Contract.deploy();
        await contract.deployed(); // Wait for deployment to finish
    });

    it('Check initial value of current id after deploy', async function () {
        // Replace 'currentId' with the actual function/variable you're checking
        const initialId = await contract.currentId(); // Example call
        expect(initialId).to.equal(0); // Adjust this according to your expected initial value
    });

    // Add more tests as needed
});
