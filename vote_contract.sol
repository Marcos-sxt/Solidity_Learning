// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.26;

contract Poll {
    struct VoteOption {
        string description;
        uint256 count;
    }

    struct PollInfo {
        string title;
        address creator;
        bool active;
        VoteOption[] options;
        mapping(address => bool) hasVoted;
    }

    mapping(uint256 => PollInfo) private polls;
    uint256 private pollCounter;

    event PollCreated(uint256 pollId, string title, address creator);
    event VoteRegistered(uint256 pollId, uint256 optionIndex, address voter);
    event PollEnded(uint256 pollId, address creator);

    function createPoll(string memory _title, string[] memory _options) external {
        require(_options.length >= 2 && _options.length <= 10, "Must define at least 2 and at most 10 options");

        pollCounter++;
        PollInfo storage newPoll = polls[pollCounter];
        newPoll.title = _title;
        newPoll.creator = msg.sender;
        newPoll.active = true;

        for (uint256 i = 0; i < _options.length; i++) {
            newPoll.options.push(VoteOption({description: _options[i], count: 0}));
        }

        emit PollCreated(pollCounter, _title, msg.sender);
    }

    function vote(uint256 _pollId, uint256 _optionIndex) external {
        PollInfo storage poll = polls[_pollId];
        require(poll.active, "Poll is closed");
        require(!poll.hasVoted[msg.sender], "You have already voted");
        require(_optionIndex < poll.options.length, "Invalid option");

        poll.options[_optionIndex].count++;
        poll.hasVoted[msg.sender] = true;

        emit VoteRegistered(_pollId, _optionIndex, msg.sender);
    }

    function endPoll(uint256 _pollId) external {
        PollInfo storage poll = polls[_pollId];
        require(poll.active, "Poll is already closed");
        require(poll.creator == msg.sender, "Only the creator can end the poll");

        poll.active = false;

        emit PollEnded(_pollId, msg.sender);
    }

    function getPoll(uint256 _pollId) external view returns(
        string memory title,
        bool active,
        string[] memory optionNames,
        uint256[] memory optionVotes
    ) {
        PollInfo storage poll = polls[_pollId];

        uint256 totalOptions = poll.options.length;
        optionNames = new string[](totalOptions);
        optionVotes = new uint256[](totalOptions);

        for (uint256 i = 0; i < totalOptions; i++) {
            optionNames[i] = poll.options[i].description;
            optionVotes[i] = poll.options[i].count;
        }

        return (poll.title, poll.active, optionNames, optionVotes);
    }
}
