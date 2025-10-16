import { network } from "hardhat";
const { viem } = await network.connect();
const reputation = await viem.deployContract("Reputation");
console.log("Reputation deployed to:", reputation.address);
const lend = await viem.deployContract("CipherLend", [reputation.address]);
console.log("Lend deployed to:", lend.address);