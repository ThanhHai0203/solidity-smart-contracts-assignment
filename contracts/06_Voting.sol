// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract Voting {
    struct Candidate {
        string name;
        uint256 voteCount;
    }

    struct Voter {
        bool authorized;
        bool voted;
        uint256 voteIndex;
    }

    Candidate[] public candidates;
    mapping(address => Voter) public voters;

    address public chairperson;

    modifier onlyChairperson() {
        require(msg.sender == chairperson, "Not the chairperson");
        _;
    }

    constructor(string[] memory candidateNames) {
        chairperson = msg.sender;

        for (uint256 i = 0; i < candidateNames.length; i++) {
            candidates.push(
                Candidate({
                    name: candidateNames[i],
                    voteCount: 0
                })
            );
        }
    }

    function authorize(address voter) external onlyChairperson {
        require(voter != address(0), "Invalid voter address");
        require(!voters[voter].authorized, "Voter already authorized");

        voters[voter].authorized = true;
    }

    function vote(uint256 candidateIndex) external {
        require(voters[msg.sender].authorized, "Not authorized");
        require(!voters[msg.sender].voted, "Already voted");
        require(candidateIndex < candidates.length, "Invalid candidate");

        voters[msg.sender].voted = true;
        voters[msg.sender].voteIndex = candidateIndex;

        candidates[candidateIndex].voteCount++;
    }

    function totalVotes(
        uint256 candidateIndex
    ) external view returns (uint256) {
        require(candidateIndex < candidates.length, "Invalid candidate");

        return candidates[candidateIndex].voteCount;
    }

    function winnerName() external view returns (string memory) {
        require(candidates.length > 0, "No candidates");

        uint256 winnerIndex = 0;

        for (uint256 i = 1; i < candidates.length; i++) {
            if (
                candidates[i].voteCount >
                candidates[winnerIndex].voteCount
            ) {
                winnerIndex = i;
            }
        }

        return candidates[winnerIndex].name;
    }
}