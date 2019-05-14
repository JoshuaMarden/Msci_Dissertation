#This script will correlate each Nifti file trying to essentially find components that match and maybe represent the same neural pathway or event etc...  

#fslcc - run cross-correlations between every volume in one 4D data set with every volume in another (for investigating similarities in ICA outputs). 

echo -e "\nRunning Cross Correlations\n"
sleep 2

Source="/Users/joshuamarden/University_Work/4th_Year_Neuroscience/Research_Project/Data/BRCOPT_preprocessed_Working/Melodic_ICAs_GSSRemoved"

Output="/Users/joshuamarden/University_Work/4th_Year_Neuroscience/Research_Project/Data/BRCOPT_preprocessed_Working/Cross_Correlations"

# This finds i the output already exists and delets it to neate the overwritin issues I ave a 
if [ ! -d $Output ]; then
    echo -e "\nDeleting old Files to prevent errors\n" # ------------> Doesn't work don't know why
    rmdir -rf $((Output))
    sleep 1
fi
    

# Create output folder
echo -e "\nCreating new output folder.\n"
mkdir -v $Output
sleep 1

#eine arrays 
NoCs=(6)

Conditions=(PL IV IN NB)

ComparisonConditions=(PL IV IN NB)

Thresholds=("0.000")

# give user some info on arrays bein used
echo -e "\nNumber of Compnents:\n"
echo "${NoCs[@]}"
sleep 2.1

echo -e "\nThresholds Specified:\n"
echo "${Thresholds[@]}"
sleep 2.1


for Threshold in "${Thresholds[@]}"; do

	echo -e "\n Starting Analsysis with a Threshold of "$Threshold"\n"

        for CN in "${NoCs[@]}"; do

        	echo -e "\n Correlating maps for analyses generated using "$CN" components\n"
 
            for Condition in "${Conditions[@]}"; do

            	echo -e "\n Correlating maps for analyses generated using "$CN" components for "$Condition" group"

            	for ComparisonCondition in "${ComparisonConditions[@]}"; do

            		echo -e "\nagainst "$ComparisonCondition"\n"

                    fslcc -p 3 -t $Threshold $Source"/Melodic_ICA_"$CN"C_GSRemoved/Melodic_ICA_"??*"_"$Condition"/melodic_IC.nii.gz" $Source"/Melodic_ICA_"$CN"C_GSRemoved/Melodic_ICA_"??*"_"$ComparisonCondition"/melodic_IC.nii.gz" > $Output"/CC_for_"$CN"C_"$Condition"_vs_"$ComparisonCondition"_threshold_"$Threshold.txt

            done #Comp Condition

        done #Conditions

    done #No. Components 

done #Thresolds

echo -e "\nCompleted Cross Correlations... Sorting results\n"
sleep 2


#Create oer ieracy
for Threshold in "${Thresholds[@]}"; do
	for CN in "${NoCs[@]}"; do
		for Condition in "${Conditions[@]}"; do
	        mkdir -p $Output'/Threshold_'$Threshold'/'$((CN))'_Components/'$Condition
	        mv $Output'/CC_for_'$((CN))C'_'$Condition'_vs_'??'_threshold_'$Threshold'.txt' $Output'/Threshold_'$Threshold'/'$((CN))'_Components/'$Condition
	    done
	done
done   


echo -e "\nCompleted Cross Correlations"

#CC_for_11C_PL_vs_IV_threshold_0.5.txt

#Cou be us to cec i ie exists
#[ -f /etc/hosts ] && echo "Found" || echo "Not found"


#FMRIB web page  https://fsl.fmrib.ox.ac.uk/fsl/fslwiki/Fslutils


#############################################################################
#																			#
#Part of FSL (ID: 5.0.11)													#
# 																			# 
#Usage:  																	#
#fslcc [options] <first_input> <second_input>   		   				    #
#																			#
#Optional arguments (You may optionally specify one or more of):            #
#	-m	mask file name 													    #
#	--noabs		Don't return absolute values (keep sign)                    #
#	--nodemean	Don't demean the input files                                #
#	-t		Threshhold ( default 0.1 )                                      #
#	-p		Number of decimal places to display in output ( default 2 )     #
#																			#
#																			#
#############################################################################


#This is ust to test te comman

# Source="/Users/joshuamarden/University_Work/4th_Year_Neuroscience/Research_Project/Data/BRCOPT_preprocessed_Working/Melodic_ICAs_GSSRemoved"
# fslcc $Source"/Melodic_ICA_7C_GSRemoved/Melodic_ICA_"??*"_PL/melodic_IC.nii.gz" $Source"/Melodic_ICA_7C_GSRemoved/Melodic_ICA_"??*"_NB/melodic_IC.nii.gz"


#    An asterisk (*) – matches one or more occurrences of any character, including no character.
#    Question mark (?) – represents or matches a single occurrence of any character.
#    Bracketed characters ([ ]) – matches any occurrence of character enclosed in the square brackets. It is possible to use different types of characters (alphanumeric characters): numbers, letters, other special characters etc.


# fslcc reports the spatial normalised correlation coefficient between  
# two spatial maps. If either or both inputs are 4D, it tests every time  
# point in one against every timepoint in the other, telling you which  
# results it finds above threhsold (by default 0.1).



# if [ ! -d $Output ]; then
#     echo -e "\nDeleting old Files to prevent errors\n"
#     rmdir -r $Output
#     echo -e "\Creating new output folder.\n"
#     mkdir $Output
#     else 
#   	echo -e "\Creating output folder.\n"
#   	mkdir $Output
# fi


#makes a tree-> A tmpdir B Trunk C Includes C docs B Brancehs B Trash 
# mkdir -p tmpdir/{trunk/sources/{includes,docs},branches,tags}








# Maybe something like this? I found this on here a while ago, and I use it all the time. It will move files into a folder based on the file name and type. If the folder doesn't exist, it will create the folder in the current location of the batch file. If the folder already exists, it will simply move it to that folder.

# @echo off &setlocal
# for /f "delims=" %%i in ('dir /b /a-d *.text') do (
# set "filename1=%%~i"
# setlocal enabledelayedexpansion
# set "folder1=!filename1:~0,1!"
# mkdir "!folder1!" 2>nul
# move "!filename1!" "!folder1!" >nul
# endlocal
# )

# The ".pdf" in line 2 can be changed to specify the file type. You may use ".*" to move all file types, though this will also move the .bat file and folders.

# The "~0,1!" in line 5 determines which characters are looked at to determine the folder names. The first number determines which character it begins looking at (0 is at the beginning, 1 is 1 character from the beginning, etc). The second number determines how many characters it looks at. If it was changed to 2, it will look at the first 2 characters in the file.

# Currently it is set to only look at the first character and move only .text files. For the files in your example, it would move all of the "Arrow" files for a folder named "A", and all of the "Spear" files to a folder named "S". The "Shield" files would stay where they are, as their extension is .txt, not .text. If you changed ".text" to ".t*" it will move both the .txt and .text files into the "A" and "S" folders.
