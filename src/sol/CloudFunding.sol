// SPDX-License-Identifier: MIT
pragma solidity ^0.8.15;

contract CloudFunding {


    event ProposalCreated(uint256 proposalID, string name, string projectCID, address proposer, uint256 goalAmount, uint256 deadline, uint256 raisedAmount, uint256 votes, bool approved, bool funded);
    event ProposalVoted(uint256 proposalID, uint256 votes);
    event ProposalApproved(uint256 proposalID, bool approved);
    event ProposalFunded(uint256 proposalID, bool funded);
    event ProposalWithdrawn(uint256 proposalID, uint256 raisedAmount);
    event ProposalRefunded(uint256 proposalID, uint256 raisedAmount);
    event ProposalExpired(uint256 proposalID);
    event LogFallback(address sender, uint value);

    address admin;

    address[] public voters;

    mapping(address => bool) public isVoter;
    uint private requiredVotes;
    uint private requiredVotesPercentage;
    uint private totalVoters;



    uint[] public proposalIDs;


    struct fundProposal {
        string name;
        string description;
        string projectCID;
        address payable proposer;
        uint256 goalAmount;
        uint256 deadline;
        uint256 raisedAmount;
        uint256 votes;
        bool approved;
        bool funded;
        uint proposalTime;
        bool paidOut;
        // mapping(address => bool) voted;
    }


    struct proposalFunders {
        address funder;
        uint256 amount;
    }

    mapping(uint => mapping(address => bool)) public hasVoted;


    

    mapping(uint256 => uint256) public fundersCount;
    mapping(uint256 => mapping(uint256 => proposalFunders))  public  fundersList;
    // uint256 public proposalCount;


    fundProposal[] public proposalsArray;
    mapping(uint256 => fundProposal) public allProposalsMap;
    mapping(uint256 => fundProposal) public proposals;



    modifier onlyAdmin() {
        require(msg.sender == admin, "Only admin can call this function");
        _;
    }

    modifier onlyVoter() {
        require(isVoter[msg.sender], "Only voters can call this function");
        _;
    }

    modifier onlyProposer(uint256 _proposalID) {
        require(proposals[_proposalID].proposer == msg.sender, "Only proposer can call this function");
        _;
    }

    modifier notApproved(uint256 _proposalID) {
        require(proposals[_proposalID].approved == false, "Proposal has already been approved");
        _;
    }

    modifier approved (uint256 _proposalID) {
        require(proposals[_proposalID].approved == true, "Proposal has not been approved");
        _;
    }

    modifier notVoted(uint256 _proposalID) {
        require(hasVoted[_proposalID][msg.sender] == false, "You have already voted");
        _;
    }

    modifier notFunded(uint256 _proposalID) {
        require(proposals[_proposalID].funded == false, "Proposal has already been funded");
        _;
    }

    modifier funded (uint256 _proposalID) {
        require(proposals[_proposalID].funded == true, "Proposal has not been funded");
        _;
    }

    modifier notExpired(uint256 _proposalID) {
        
        require(block.timestamp <= ( proposals[_proposalID].proposalTime + (proposals[_proposalID].deadline * 1 days)), "Proposal has expired");
        _;
    }
    
    modifier expired(uint256 _proposalID) {
        require(block.timestamp > ( proposals[_proposalID].proposalTime + (proposals[_proposalID].deadline * 1 days)), "Proposal has not expired");
        _;
    }

    modifier notPaidOut(uint256 _proposalID) {
        require(proposals[_proposalID].paidOut == false, "Proposal has already been paid out");
        _;
    }



    constructor (address _voter, uint _requiredVotesPercentage)  {
        admin = msg.sender;

        // require(_voters.length > 0, "Voters list cannot be empty");

        // for (uint i = 0; i < _voters.length; i++) {
        //     require(_voters[i] != address(0), "Voter address cannot be empty");
        //     require(!isVoter[_voters[i]], "Voter address cannot be repeated");
        //     isVoter[_voters[i]] = true;
        //     voters.push(_voters[i]);
        // }

        requiredVotesPercentage = _requiredVotesPercentage;
        addVoter(msg.sender);
        addVoter(_voter);
        isVoter[msg.sender] = true;
        isVoter[_voter] = true;

        // totalVotes();

        // requiredVotes = (totalVoters * requiredVotesPercentage) / 100;


    }

    function transferOwnership(address _newAdmin) public onlyAdmin {
        admin = _newAdmin;
    }

    function totalVotes() public  returns (uint) {
        totalVoters = voters.length * 10;
        return totalVoters;
    }


    // goal amount should be in wei

    function createProposal(string memory _name, string memory _description, string memory _projectCID, uint256 _goalAmount, uint256 _deadline) public  returns (uint256){
        uint max = 1000000000; // 10^10
        uint min = 100000000; // 10^9
        require(_goalAmount > 0, "Goal amount cannot be 0");
        require(_deadline > 0, "Deadline cannot be 0");
        require(_deadline <= 100, "Deadline cannot be more than 365 days");
        require(bytes(_name).length > 0, "Name cannot be empty");
        require(bytes(_description).length > 0, "Description cannot be empty");
        require(bytes(_projectCID).length > 0, "Project CID cannot be empty");


        uint256 proposalID = uint256(keccak256(abi.encodePacked(block.timestamp, msg.sender))) % (max - min) + min; 
        require(proposals[proposalID].proposer == address(0), "Proposal ID already exists");
        fundProposal storage proposal = proposals[proposalID];
        proposal.name = _name;
        proposal.description = _description;
        proposal.projectCID = _projectCID;
        proposal.proposer = payable(msg.sender);
        proposal.goalAmount = _goalAmount;
        proposal.deadline = _deadline;
        proposal.raisedAmount = 0;
        proposal.votes = 0;
        proposal.approved = false;
        proposal.funded = false;
        proposal.proposalTime = block.timestamp;
        proposal.paidOut = false;

        proposalsArray.push(fundProposal(_name, _description ,_projectCID, payable(msg.sender), _goalAmount, _deadline, 0, 0, false, false, block.timestamp, false));
        proposalIDs.push(proposalID);
        uint totalProposals = proposalIDs.length -1;
        allProposalsMap[totalProposals] = fundProposal(_name, _description ,_projectCID, payable(msg.sender), _goalAmount, _deadline, 0, 0, false, false, block.timestamp, false);

        emit ProposalCreated(proposalID, _name, _projectCID, msg.sender, _goalAmount, _deadline, 0, 0, false, false);
        return proposalID;
    
        
    }

    function getAllProposalMap(uint256 _index) public view returns (fundProposal memory) {
        return allProposalsMap[_index];
    }
    


    function vote(uint256 _proposalID) public onlyVoter notVoted(_proposalID) notApproved(_proposalID) returns(uint) {
        fundProposal storage proposal = proposals[_proposalID];
        require(block.timestamp < proposal.proposalTime + 3 days, "You can only vote on a proposal for 72 hours after it is created");
        require(proposal.proposer != msg.sender, "You cannot vote on your own proposal");

        hasVoted[_proposalID][msg.sender] = true;

        proposal.votes += 1;

        approveProposal(_proposalID);

       

        emit ProposalVoted(_proposalID, proposal.votes);
        return proposal.votes;
    }


    function approveProposal(uint256 _proposalID) internal {
        fundProposal storage proposal = proposals[_proposalID];

         if ((proposal.votes * 10 )  >= requiredVotes) {
            proposal.approved = true;
            emit ProposalApproved(_proposalID, proposal.approved);
        }
       
    }


    function fundProposals(uint256 _proposalID) public payable notFunded(_proposalID) approved(_proposalID) notExpired(_proposalID) returns (bool) {
        fundProposal storage proposal = proposals[_proposalID];
        
       require(proposal.raisedAmount < proposal.goalAmount, "Proposal has already reached its goal");
       require(msg.value > 0, "You cannot fund a proposal with 0 ETH");

        fundersList[_proposalID][fundersCount[_proposalID]] = proposalFunders(msg.sender, msg.value);
        fundersCount[_proposalID] += 1;
        proposal.raisedAmount += msg.value;

        fullyFunded(_proposalID);

        emit ProposalFunded(_proposalID, proposal.funded);
        
        return true;

    }

    function fullyFunded (uint256 _proposalID)  internal {
        fundProposal storage proposal = proposals[_proposalID];

        if (proposal.raisedAmount >= proposal.goalAmount) {
            proposal.funded = true;
            // proposal.proposer.transfer(proposal.raisedAmount);
            // proposal.paidOut = true;
        }
    }


    function getProposal(uint256 _proposalID) public view returns (string memory, string memory, string memory, address, uint256, uint256, uint256, uint256, bool, bool) {
        fundProposal storage proposal = proposals[_proposalID];
        return (proposal.name, proposal.description, proposal.projectCID, proposal.proposer, proposal.goalAmount, proposal.deadline, proposal.raisedAmount, proposal.votes, proposal.approved, proposal.funded);
    }


    function getProposalVotes(uint256 _proposalID) public view returns (uint256) {
        fundProposal storage proposal = proposals[_proposalID];
        return proposal.votes;
    }


    function withdrawFunds(uint256 _proposalID) public funded(_proposalID) notPaidOut(_proposalID)  {
        fundProposal storage proposal = proposals[_proposalID];
        proposal.paidOut = true;
        proposal.proposer.transfer(proposal.raisedAmount);
        emit ProposalWithdrawn(_proposalID, proposal.raisedAmount);
    }


    function refundFunders(uint256 _proposalID) public onlyAdmin approved(_proposalID) expired(_proposalID)  notPaidOut(_proposalID) {
        fundProposal storage proposal = proposals[_proposalID];
        

       
        for (uint256 i = 0; i < fundersCount[_proposalID]; i++) {
            proposalFunders storage funders = fundersList[_proposalID][i];
            payable(funders.funder).transfer(funders.amount);
        }

        emit ProposalRefunded(_proposalID, proposal.raisedAmount);
    }

    function getFunders(uint256 _proposalID) public view returns (address[] memory, uint256[] memory) {
        address[] memory funders = new address[](fundersCount[_proposalID]);
        uint256[] memory amounts = new uint256[](fundersCount[_proposalID]);

        for (uint256 i = 0; i < fundersCount[_proposalID]; i++) {
            funders[i] = fundersList[_proposalID][i].funder;
            amounts[i] = fundersList[_proposalID][i].amount;
        }

        return (funders, amounts);
    }

    function getProposalIDs() public view returns (uint256[] memory) {
        return proposalIDs;
    }

    function getProposalsArray() public view returns (fundProposal[] memory) {
        return proposalsArray;
    }

    function getVoters() public view returns (address[] memory) {
        return voters;
    }

    function getRequiredVotes() public view returns (uint256) {
        return requiredVotes;
    }


    function getRequiredVotesPercentage() public view returns (uint256) {
        return requiredVotesPercentage;
    }

    function getTotalVoters() public view returns (uint256) {
        return totalVoters;
    }

    function getProposalCount() public view returns (uint256) {
        return proposalIDs.length;
    }

    function getFundersCount(uint256 _proposalID) public view returns (uint256) {
        return fundersCount[_proposalID];
    }


    function removeVoter (address _voter) public onlyAdmin {
        for (uint256 i = 0; i < voters.length; i++) {
            if (voters[i] == _voter) {
                voters[i] = voters[voters.length - 1];
                voters.pop();
                totalVotes();
                requiredVotes = (totalVoters * requiredVotesPercentage) / 100;
            }
        }
        isVoter[_voter] = false;
    }

    function setRequiredVotesPercentage (uint256 _requiredVotesPercentage) public onlyAdmin {
        require(_requiredVotesPercentage > 0, "Required votes percentage cannot be 0");
        requiredVotesPercentage = _requiredVotesPercentage;
        requiredVotes = (totalVoters * requiredVotesPercentage) / 100;
    }

   function addVoter (address _voter) public onlyAdmin {
        isVoter[_voter] = true;
        voters.push(_voter);
        totalVotes();
        requiredVotes = (totalVoters * requiredVotesPercentage) / 100;
       
    }

    
    // function getMyProposal(address _user) public view  returns(fundProposal[] memory) {
        

    //     fundProposal[] memory myProposals = new fundProposal[](proposalIDs.length);
        
    //     for (uint256 i = 0; i < proposalIDs.length; i++) {
    //         if (proposals[proposalIDs[i]].proposer == _user) {
    //             myProposals[i] = proposals[proposalIDs[i]]; 
    //             return myProposals;
    //         }

            
    //     }
    // }

    function getMyProposal(address _user) public view returns (fundProposal[] memory) {
    fundProposal[] memory myProposals = new fundProposal[](proposalIDs.length);

    uint256 counter = 0;
    for (uint256 i = 0; i < proposalIDs.length; i++) {
        if (proposals[proposalIDs[i]].proposer == _user) {
            myProposals[counter] = proposals[proposalIDs[i]];
            counter++;
        }
    }

    // Trim the array to remove any unused elements
    assembly {
        mstore(myProposals, counter)
    }

    return myProposals;
}
    
    // fallback() external payable {
    //     emit LogFallback(msg.sender, msg.value);
    // }

}