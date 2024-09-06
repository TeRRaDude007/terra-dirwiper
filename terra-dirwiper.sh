#!/bin/bash
##################################################
## TeRRaDuDe directort wiper vers 1.2           ##
##################################################
#
# Search for directories: The script searches for directories matching the regular expression.
# Confirm and wipe: It confirms with the user before deleting the directories.
# 
# Calculate and display free space: After deletion, 
# it calculates and displays the available free space 
# on the filesystem containing the target directory.
#
# Make it executable:
# chmod +x terra-dirwiper.sh
#
# Run the script:
# ./terra-dirwiper.sh
#
########### Changelog ##########################
#
# 1.x BETA Some idea...
# 1.1 Added search option now with REGEX...
# 1.2 Added Calc freespace under that dir....
#
#################################################
######     Change below  to your Needs    #######
#################################################

# Glftpd directory to search in
search_dir="/glftpd/site/SECTION"

# Regular expression to match directory names
regex=".*-WECARE$"  # Example regex to match directories ending with '-WECARE'

#################################################
######## DONT EDIT BELOW THIS LINE ##############
#################################################

# Find directories matching the regular expression
dirs=$(find "$search_dir" -type d -regex "$regex")

# If no directories found, exit
if [ -z "$dirs" ]; then
    echo "No directories found matching regex '$regex' in '$search_dir'."
    exit 0
fi

# Echo directories found
echo "Directories found:"
for dir in $dirs; do
    echo "$dir"
done

# Confirm before wiping
read -p "Are you sure you want to wipe these directories? (y/n): " confirmation
if [[ "$confirmation" != "y" ]]; then
    echo "Operation cancelled."
    exit 0
fi

# Wipe directories
for dir in $dirs; do
    echo "Wiping $dir"
    rm -rf "$dir"
done

echo "All directories matching regex '$regex' have been wiped."

# Calculate free space in the filesystem containing the search_dir
free_space=$(df -h "$search_dir" | awk 'NR==2 {print $4}')

# Display the free space available after deletion
echo "Free space left in the filesystem containing '$search_dir': $free_space"

#eof
