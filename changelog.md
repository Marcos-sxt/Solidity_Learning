# Changelog

All notable changes to this project will be documented in this file.

## [1.1.0] - 2025-03-13

### Added
- Added `getAllPolls` function to retrieve the list of all created polls, returning poll IDs and titles.
- Added `getPollCreator` function to get the creator's address for a given poll ID.

## [1.0.0] - 2025-03-13

### Added
- Initial release of the Poll smart contract.
- Users can create polls with titles and options.
- Users can vote on active polls.
- Only poll creators can end their respective polls.
- Users can retrieve poll details including title, status, options, and vote counts.