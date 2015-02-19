# README file for data

In this file you can find very brief informations about the script and the output.
For more detailed informations about the data and the script you have to read the PDF named *CodeBook*.

There is also a LaTeX version of the *CodeBook* if you are a Tex user.

The script does essentially:

*   Load files from a folder inside the working directory
*   Create dataframes for test and train variables
*   Merge together train and test dataframes
*   Check for identical columns and rename columns with same names but different contents
*   Create subset for columns with only means and standard deviations of the variables
*   Groups variables by the subjects and the activities
*   Create a new dataframe with the mean of every measurements and write it as a txt file.

The output file is a text file with 14580 observations in total, 180 rows and 81 columns.