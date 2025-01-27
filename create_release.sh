#!/usr/bin/env bash
#
# Script Name: createRelease.sh
# Description: Creates a release branch based on develop and the main branch (master or main).
# Usage: ./createRelease.sh
#

# Step 1: Prompt the user for ticket number(s)
echo "Enter the ticket(s) number (e.g. 'TGB-123, TGB-423'):"
read tickets

# Step 2: Normalize the ticket strings by replacing commas, spaces,
# and other non-alphanumeric characters (except for '-' and '_') with '_'
# Additionally, ensure that multiple tickets are separated by '_'
cleanTickets=$(echo "$tickets" | sed -E 's/[ ,]+/_/g')

# Step 3: Determine if the repository uses 'main' or 'master'
# We check for the existence of 'origin/main'.
# If it does not exist, we assume 'master'.
if git rev-parse --verify origin/main >/dev/null 2>&1; then
    MAIN_BRANCH="main"
else
    MAIN_BRANCH="master"
fi

# Step 4: Switch to develop and pull
echo "Switching to develop..."
git switch develop
git pull

# Step 5: Switch to the main branch (main or master) and pull
echo "Switching to ${MAIN_BRANCH}..."
git switch "${MAIN_BRANCH}"
git pull

# Step 6: Create the new release branch
newBranchName="release/${cleanTickets}"
echo "Creating and switching to the new branch ${newBranchName}..."
git switch -c "${newBranchName}"

echo "Done! You have successfully created and switched to the branch ${newBranchName}."
