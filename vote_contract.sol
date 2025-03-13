// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.26;

/// @title Poll - A decentralized polling (voting) contract
/// @notice This contract allows users to create polls, vote, and view poll results.
/// @dev Uses mappings and dynamic arrays to manage poll data.
contract Poll {
    // Structure to represent a vote option in a poll
    struct VoteOption {
        string description; // Description of the option
        uint256 count;      // Number of votes received
    }

    // Structure to store information about a poll
    struct PollInfo {
        string title;        // Title of the poll
        address creator;     // Address of the poll creator
        bool active;         // Poll status (active or ended)
        VoteOption[] options; // Array of voting options
        mapping(address => bool) hasVoted; // Tracks if an address has already voted
    }

    // Mapping from poll ID to its corresponding PollInfo
    mapping(uint256 => PollInfo) private polls;
    // Counter to generate unique poll IDs
    uint256 private pollCounter;

    // Events to log key actions in the contract
    event PollCreated(uint256 pollId, string title, address creator);
    event VoteRegistered(uint256 pollId, uint256 optionIndex, address voter);
    event PollEnded(uint256 pollId, address creator);

    /// @notice Creates a new poll with a title and an array of options.
    /// @param _title The title of the poll.
    /// @param _options An array of option descriptions (must be between 2 and 10).
    function createPoll(string memory _title, string[] memory _options) external {
        // Validate that there are at least 2 and at most 10 options
        require(_options.length >= 2 && _options.length <= 10, "Must define at least 2 and at most 10 options");

        // Increment the poll counter to get a new poll ID
        pollCounter++;

        // Create a new poll in storage
        // Note: mappings inside structs cannot be initialized in memory, so we use storage directly
        PollInfo storage newPoll = polls[pollCounter];
        newPoll.title = _title;
        newPoll.creator = msg.sender;
        newPoll.active = true;

        // Add each option to the poll's options array
        for (uint256 i = 0; i < _options.length; i++) {
            newPoll.options.push(VoteOption({description: _options[i], count: 0}));
        }

        // Emit an event to log the creation of the poll
        emit PollCreated(pollCounter, _title, msg.sender);
    }

    /// @notice Casts a vote for a specific option in a poll.
    /// @param _pollId The ID of the poll.
    /// @param _optionIndex The index of the option to vote for.
    function vote(uint256 _pollId, uint256 _optionIndex) external {
        PollInfo storage poll = polls[_pollId];

        // Ensure the poll is active
        require(poll.active, "Poll is closed");

        // Check if the sender has already voted in this poll
        require(!poll.hasVoted[msg.sender], "You have already voted");

        // Validate that the option index is within range
        require(_optionIndex < poll.options.length, "Invalid option");

        // Register the vote: increase the count for the selected option
        poll.options[_optionIndex].count++;
        // Mark the sender as having voted
        poll.hasVoted[msg.sender] = true;

        // Emit an event to log the vote
        emit VoteRegistered(_pollId, _optionIndex, msg.sender);
    }

    /// @notice Ends a poll, preventing further votes.
    /// @dev Only the poll creator can call this function.
    /// @param _pollId The ID of the poll.
    function endPoll(uint256 _pollId) external {
        PollInfo storage poll = polls[_pollId];

        // Ensure the poll is active before attempting to end it
        require(poll.active, "Poll is already closed");

        // Ensure only the creator of the poll can end it
        require(poll.creator == msg.sender, "Only the creator can end the poll");

        // Mark the poll as ended (inactive)
        poll.active = false;

        // Emit an event to log the ending of the poll
        emit PollEnded(_pollId, msg.sender);
    }

    /// @notice Retrieves details of a specific poll.
    /// @param _pollId The ID of the poll.
    /// @return title The title of the poll.
    /// @return active The current status of the poll (active/closed).
    /// @return optionNames An array of the option descriptions.
    /// @return optionVotes An array of the vote counts for each option.
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

        // Populate the arrays with option data
        for (uint256 i = 0; i < totalOptions; i++) {
            optionNames[i] = poll.options[i].description;
            optionVotes[i] = poll.options[i].count;
        }

        return (poll.title, poll.active, optionNames, optionVotes);
    }

    /// @notice Retrieves all polls' IDs and titles.
    /// @return pollIds An array of poll IDs.
    /// @return titles An array of poll titles.
    function getAllPolls() external view returns (uint256[] memory pollIds, string[] memory titles) {
        pollIds = new uint256[](pollCounter);
        titles = new string[](pollCounter);

        // Iterate through all poll IDs from 1 to pollCounter
        for (uint256 i = 1; i <= pollCounter; i++) {
            pollIds[i - 1] = i;
            titles[i - 1] = polls[i].title;
        }

        return (pollIds, titles);
    }

    /// @notice Retrieves the creator address of a specific poll.
    /// @param _pollId The ID of the poll.
    /// @return The address of the poll's creator.
    function getPollCreator(uint256 _pollId) external view returns (address) {
        return polls[_pollId].creator;
    }
}
