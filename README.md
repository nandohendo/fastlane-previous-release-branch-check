# fastlane-previous-release-branch-check
This is a custom lane to check for commits from previous release branch.

Example of use case:
Let's say your repository has branch release/4.2.0, this lane whill check if release/4.1.0, release/4.1.1 and so on has been merged to release/4.2.0. 

Next iteration:
- Make `release` keyword parameterized so this lane can handle branch name like `production/4.2.0`
- Handle if branch only has major and minor version, for example: `4.2`
