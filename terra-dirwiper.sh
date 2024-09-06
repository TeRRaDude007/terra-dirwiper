#!/bin/bash
##################################################
## TeRRaDuDe directory wiper vers 2.0          ##
##################################################
#
# Setup:
#
#    1. Copy the Script: Copy the script into a file, e.g., terra-dirwiper.sh.
#    2. Make It Executable: Run chmod +x terra-dirwiper.sh to make the script executable.
#    3. Run the Script: Execute the script with ./terra-dirwiper.sh.
#
# Flexibility:
#
#    - To Change Patterns: Simply modify the values of start_prefix, wildcard_pattern, and end_suffix to match the directories you want to target.
#    - To Skip Matching: If you don't want to use one of the patterns (e.g., you only care about the start_prefix), you can leave the other variables empty  eg: " " not "", or set them to a pattern that won't match anything.
#
#    This script provides a flexible way to target directories based on the beginning, middle, or end of their names.
#
# Confirmation and Deletion:
#
#    - The script lists the directories that match and prompts for user confirmation before deleting them.
#
# Free Space Calculation:
#
#    - After deletion, the script calculates and displays the available free space in the target directory.
#
#
########### Changelog ##########################
#
# 1.x BETA Some idea...
# 1.1 Added search option now with REGEX...
# 1.2 Added Calc freespace under that dir....
# 2.0 Rerwited Code Replaced find for ls,
#     and removed REGEX / New intro/setup added.
#
#################################################
#############    CONFIG SETUP    ################
#################################################

# What section to search for?
search_path="/glftpd/site/TVSECTION"

# Change to specific needs;
start_prefix="All"     # The prefix to match at the beginning of the directory e.g.; \All\.We.care.About.
wildcard_pattern="Good" # The pattern to match anywhere in the directory name e.g.; This.Feels.\Good.\That.We.Care
end_suffix="-LAZYCUNTS"     # The suffix to match at the end of the directory name e.g.; -LAZYCUNTS$.

#################################################
###### END OF CONFIG ## DONT EDIT BELOW #########
#################################################

# Check if the directory exists
if [ ! -d "$search_path" ]; then
    echo "Directory $search_path does not exist."
    exit 1
fi

# Initialize an empty variable to store the directories to delete
dirs_to_delete=""

# Iterate over each directory in the search path
for dir in "$search_path"/*; do
    # Check if it is a directory
    if [ -d "$dir" ]; then
        dir_name=$(basename "$dir")
        # Check if the directory name matches any of the three conditions
        if [[ "$dir_name" == "$start_prefix"* ]] || [[ "$dir_name" == *"$wildcard_pattern"* ]] || [[ "$dir_name" == *"$end_suffix" ]]; then
            dirs_to_delete+="$dir"$'\n'
        fi
    fi
done

# If no directories are found
if [ -z "$dirs_to_delete" ]; then
    echo "No directories found matching the specified patterns."
    exit 0
fi

# Display the found directories
echo "The following directories were found matching the specified patterns:"
echo "$dirs_to_delete"

# Ask for user confirmation before deletion
read -p "Do you want to delete these directories? (y/n): " confirmation
if [[ "$confirmation" != "y" && "$confirmation" != "Y" ]]; then
    echo "Operation cancelled."
    exit 0
fi

# Delete the directories
while IFS= read -r dir; do
    echo "Deleting directory: $dir"
    rm -rf "$dir"
done <<< "$dirs_to_delete"

# Calculate and display free space after deletion
echo "Calculating free space..."
free_space=$(df -h "$search_path" | awk 'NR==2 {print $4}')
echo "Free space available in $search_path: $free_space"

#eof
