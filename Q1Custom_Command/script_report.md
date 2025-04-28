# *mygrip script*


### *Overview*

This script is a simple, mini version of the grep command in Linux. It lets you search for a string in a file and display matching lines, with a few added options like showing line numbers and inverting the match (showing non-matching lines). You can also get a quick help message if you're unsure about the options.

### *Features* 

* Search for a string in a file
* Show line numbers for matching lines with the -n option
* Invert the match (show lines that don’t match) with the -v option
* Use -vn or -nv together to combine both options
* Display a usage message with --help if you need a reminder on how to use it

### *How to use*
#### Command syntax 
```bash
./mygrep.sh [-n] [-v] search_string filename
```

#### Options
* -n: Shows line numbers where the matches are found
* -v: Shows lines that don’t match the search string (invert the match)
* --help: Displays the help message

#### Hands-On Validation

* for *./mygrep.sh hello testfile.txt*
  
![Screenshot 2025-04-28 1048366](https://github.com/user-attachments/assets/172aa959-87d4-4211-8f0b-862df12f919f)

* for  *./mygrep.sh -n hello testfile.txt*

![Screenshot 2025-04-28 1048367](https://github.com/user-attachments/assets/d8239263-30d5-4d37-80b0-20df2f4d6252)

* for *./mygrep.sh -vn hello testfile.txt*

![Screenshot 2025-04-28 1048368](https://github.com/user-attachments/assets/ccb82e9e-6356-47d7-9225-c1bc10caf942)

* for *./mygrep.sh -v testfile.txt*

![Screenshot 2025-04-28 1048369](https://github.com/user-attachments/assets/f34de775-f018-42d8-9375-27bf06193951)


### *Reflective Section*
#### 1. How the Script Handles Arguments and Options
The script takes user input in the form of options and arguments. First, it checks if any input is given and ensures that at least the search string and filename are provided. Then it checks if any options (-n, -v, or combinations of them) are specified. Based on those options, the script constructs a grep command and runs it to display the search results

#### 2. Supporting Regex or -i/-c/-l Options
If I were to add support for things like regular expressions or other options (-i, -c, -l), I'd adjust the script to

* Regex: Allow users to input regex patterns, which grep already supports, so I wouldn't need to do anything special for that
* -i Option: For case-insensitive searches, I could add a -i flag that would make the script search without worrying about uppercase or lowercase letters
* -c Option: If -c were included, it would modify the script to count the number of matches instead of showing the matching lines
* -l Option: For -l, the script would just show the filenames where matches are found, not the matching lines themselves

#### 3. The Hardest Part of the Script to Implement and Why
The trickiest part of the script was handling errors. Specifically:

* Missing search string or filename: The script needs to catch cases where either the search string or filename is missing and provide clear error messages this was important to make the script user-friendly


### *BONUS*
* The --help option is included, so users can quickly see how to use the script if they’re unsure

* Option Parsing: I used basic shell scripting logic to handle options, but I could improve this by using getopts for a more professional way to handle multiple flags and options. This would make the script more flexible and easier to expand in the future













