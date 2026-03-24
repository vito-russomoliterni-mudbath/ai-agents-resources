---
name: cleaning-git-branches
description: Finds and helps clean up local git branches that have no remote or have been untouched for 30+ days. Presents a report and asks the user for confirmation before removal.
---

# Cleaning Git Branches

## Overview
This skill identifies local git branches that are no longer needed (either because their remote tracking branch is gone or they haven't been updated in over 30 days) and helps the user safely remove them.

## Prerequisites
- Must be run within a valid git repository.
- The `git` CLI must be accessible.

## Workflow

1. **Identify "Gone" Branches (No Remote)**
   Run the following command to find branches whose remote tracking branch has been deleted:
   `git for-each-ref --format '%(refname:short) %(upstream:track)' refs/heads | awk '$2 == "[gone]" {print $1}'`
   Save this list.

2. **Identify Stale Branches (> 30 Days Old)**
   Run the following command to list all local branches with their last commit date:
   `git for-each-ref --sort=-committerdate --format='%(committerdate:iso8601)|%(refname:short)' refs/heads/`
   Analyze the output:
   - Calculate the date 30 days ago from today.
   - Identify any branches where the committer date is older than 30 days ago.
   - Exclude default branches such as `main`, `master`, `develop`, or `dev`.
   Save this list.

3. **Present a Report**
   Present a clear, formatted summary to the user grouping the branches into:
   - **Branches with no remote (Gone)**
   - **Stale branches (> 30 days old)**
   Do NOT delete any branches yet.

4. **Ask for User Confirmation**
   Ask the user which branches they would like to remove. 
   - You can use the `ask_user` tool if available, offering a multi-select choice.
   - Alternatively, ask the user in text to confirm whether they want to delete all, none, or specific branches.

5. **Perform Deletion**
   Once the user provides confirmation:
   - Delete the approved branches using `git branch -D <branch-name>`.
   - Provide a final brief confirmation of the branches that were successfully deleted.
