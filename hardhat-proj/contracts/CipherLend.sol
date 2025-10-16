// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;
import "./Reputation.sol";


contract CipherLend {
    Reputation public immutable reputationContract;
    uint256 private _proposalCounter;

    enum ProposalState {
        SeekingFunds, // Proposal created, awaiting an investor
        Active,       // Funded, project underway
        Completed,    // Successfully concluded and profits shared
        Defaulted     // Entrepreneur failed to complete the terms
    }

    struct Proposal {
        uint256 id;
        address payable entrepreneur;
        address investor;
        uint256 capitalAmount;
        ProposalState state;
        string nillionDataId; // Pointer to encrypted data on Nillion
    }

    mapping(uint256 => Proposal) public proposals;
    event ProposalCreated(uint256 indexed id, address indexed entrepreneur, uint256 capitalAmount, string nillionDataId);
    event ProposalFunded(uint256 indexed id, address indexed investor);
    event ProposalCompleted(uint256 indexed id, address entrepreneur, address investor);
    event ProposalDefaulted(uint256 indexed id, address indexed entrepreneur);

    int256 private constant SCORE_ON_COMPLETION_ENTREPRENEUR = 20;
    int256 private constant SCORE_ON_COMPLETION_INVESTOR = 5;
    int256 private constant SCORE_ON_DEFAULT = -50;

    constructor(address _reputationAddress) {
        reputationContract = Reputation(_reputationAddress);
    }


    /**
     * Creates a new financing proposal 
     * _capitalAmount The amount of capital needed in wei
     *  _nillionDataId The ID referencing the encrypted business plan on Nillion
     */
    function createProposal(uint256 _capitalAmount, string memory _nillionDataId) external {
        require(_capitalAmount > 0, "CipherLend: Capital must be greater than zero");

        _proposalCounter++;
        uint256 newId = _proposalCounter;
        proposals[newId] = Proposal({
            id: newId,
            entrepreneur: payable(msg.sender),
            investor: address(0),
            capitalAmount: _capitalAmount,
            state: ProposalState.SeekingFunds,
            nillionDataId: _nillionDataId
        });

        emit ProposalCreated(newId, msg.sender, _capitalAmount, _nillionDataId);
    }

    /**
     *  An investor funds an existing proposal.
     *  _proposalId The ID of the proposal to fund.
     */
    function fundProposal(uint256 _proposalId) external payable {
        Proposal storage p = proposals[_proposalId];

        require(p.state == ProposalState.SeekingFunds, "CipherLend: Proposal not seeking funds");
        require(msg.value == p.capitalAmount, "CipherLend: Incorrect funding amount sent");
        require(msg.sender != p.entrepreneur, "CipherLend: Cannot fund your own proposal");

        p.investor = msg.sender;
        p.state = ProposalState.Active;

        // Transfer capital to the entrepreneur to start their venture
        (bool success, ) = p.entrepreneur.call{value: msg.value}("");
        require(success, "CipherLend: Fund transfer to entrepreneur failed");

        emit ProposalFunded(_proposalId, msg.sender);
    }

    /**
     *  The entrepreneur concludes the venture and repays the capital + profit share.
     * The `msg.value` sent with this call is the total amount due to the investor.
     *  _proposalId The ID of the proposal being completed.
     */
    function completeProposal(uint256 _proposalId) external payable {
        Proposal storage p = proposals[_proposalId];

        require(msg.sender == p.entrepreneur, "CipherLend: Only entrepreneur can complete");
        require(p.state == ProposalState.Active, "CipherLend: Proposal is not active");
        require(msg.value >= p.capitalAmount, "CipherLend: Payout must be at least the principal");
        
        p.state = ProposalState.Completed;

        // Pay the investor their capital back plus their share of the profits
        (bool success, ) = p.investor.call{value: msg.value}("");
        require(success, "CipherLend: Payout to investor failed");
        
        // Update reputation scores for a successful partnership
        reputationContract.updateScore(p.entrepreneur, SCORE_ON_COMPLETION_ENTREPRENEUR);
        reputationContract.updateScore(p.investor, SCORE_ON_COMPLETION_INVESTOR);

        emit ProposalCompleted(_proposalId, p.entrepreneur, p.investor);
    }

    /**
     * The investor reports that the entrepreneur has defaulted on the agreement.
     * To do: this would be locked behind a time delay or oracle.
     *  _proposalId The ID of the proposal being reported.
     */
    function reportDefault(uint256 _proposalId) external {
        Proposal storage p = proposals[_proposalId];

        require(msg.sender == p.investor, "CipherLend: Only investor can report default");
        require(p.state == ProposalState.Active, "CipherLend: Proposal is not active");
        
        p.state = ProposalState.Defaulted;

        // Heavily penalize the entrepreneur's reputation score
        reputationContract.updateScore(p.entrepreneur, SCORE_ON_DEFAULT);

        emit ProposalDefaulted(_proposalId, p.entrepreneur);
    }
}