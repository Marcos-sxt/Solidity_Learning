# Poll Smart Contract

A Poll is a simple smart contract written in Solidity that allows users to create polls, vote on options, and end polls. This contract demonstrates fundamental concepts in Solidity such as structs, mappings, events, and function modifiers.

## Features

- **Create Polls**:
  - Users can create a new poll with a title and a set of options (between 2 and 10).

- **Voting Mechanism**:
  - Each user can vote only once per poll, and votes are counted for each option.

- **Poll Management**:
  - Only the poll creator can end the poll, closing it for further votes.

- **Event Logging**:
  - The contract emits events for poll creation, vote registration, and poll termination, allowing external applications to track poll activity.

- **View Polls**:
  - Anyone can retrieve poll details such as the title, status, options, and the vote counts.

## Prerequisites

- **Solidity Compiler**: Version ^0.8.26
- **Ethereum Environment**:
  - Deploy and test the contract using tools like Remix, Hardhat, or Truffle.
- **MetaMask**: (Optional) For interacting with deployed contracts on testnets or the Ethereum mainnet.

## Installation & Deployment

1. **Clone or Copy the Code**:
   - Copy the `Poll.sol` contract code into your preferred Solidity IDE (e.g., Remix).

2. **Compile the Contract**:
   - Ensure you are using Solidity version ^0.8.26.

3. **Deploy the Contract**:
   - Deploy the contract to your desired network (e.g., a local blockchain, testnet, or mainnet).

## Contract Overview

### Structs

- **VoteOption**:
  - Represents a single voting option.
  ```solidity
  struct VoteOption {
      string description;
      uint256 count;
  }
  ```

- **PollInfo**:
  - Contains the poll’s details including the title, creator, active status, voting options, and a mapping to track which addresses have voted.
  ```solidity
  struct PollInfo {
      string title;
      address creator;
      bool active;
      VoteOption[] options;
      mapping(address => bool) hasVoted;
  }
  ```

### Variables & Mappings

- **polls**:
  - A mapping from a unique poll ID (`uint256`) to its `PollInfo`.
  ```solidity
  mapping(uint256 => PollInfo) private polls;
  ```

- **pollCounter**:
  - A counter that increments with each new poll, ensuring unique poll IDs.
  ```solidity
  uint256 private pollCounter;
  ```

### Events

- **PollCreated**:
  - Emitted when a new poll is created.
- **VoteRegistered**:
  - Emitted when a vote is cast.
- **PollEnded**:
  - Emitted when a poll is closed by its creator.

### Functions

- **createPoll**:
  - Creates a new poll.
  - Parameters:
    - `_title`: Poll title.
    - `_options`: Array of option descriptions (must be between 2 and 10 options).
  ```solidity
  function createPoll(string memory _title, string[] memory _options) external
  ```

- **vote**:
  - Casts a vote for a specific option in a poll.
  - Parameters:
    - `_pollId`: The ID of the poll.
    - `_optionIndex`: The index of the option to vote for.
  ```solidity
  function vote(uint256 _pollId, uint256 _optionIndex) external
  ```

- **endPoll**:
  - Ends a poll, allowing no further votes. Only the creator can call this function.
  - Parameter:
    - `_pollId`: The ID of the poll.
  ```solidity
  function endPoll(uint256 _pollId) external
  ```

- **getPoll**:
  - Returns the poll details including the title, active status, option names, and vote counts.
  - Parameter:
    - `_pollId`: The ID of the poll.
  ```solidity
  function getPoll(uint256 _pollId) external view returns (string memory title, bool active, string[] memory optionNames, uint256[] memory optionVotes)
  ```

## Usage

### Creating a Poll

Call the `createPoll` function with a title and an array of option names:
```javascript
await pollContract.createPoll("Favorite Programming Language", ["Solidity", "Python", "JavaScript"]);
```

### Voting

To cast a vote:
```javascript
await pollContract.vote(1, 0); // Votes for the first option in poll with ID 1.
```

### Ending a Poll

Only the creator of the poll can end it:
```javascript
await pollContract.endPoll(1);
```

### Retrieving Poll Details

Call `getPoll` to fetch poll information:
```javascript
const pollDetails = await pollContract.getPoll(1);
console.log("Title:", pollDetails.title);
console.log("Active:", pollDetails.active);
console.log("Options:", pollDetails.optionNames);
console.log("Votes:", pollDetails.optionVotes);
```
