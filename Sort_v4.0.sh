#This sorts the cross correlations into useful folders

#Some of the ground work has been laid for if you want to do this for multiple
#components numbers but it will probably not work first time, or it will 
#generate a mess instead of a nice hierachy. This is probably true for if
#you start messing with any of the starting arrays aside from 
#Conditions, but it's not far off.

#best place to srat would be to add some 'if's in for whether arrays contained
#than one component. In future I will script thsi way.


ICAsource="/Users/joshuamarden/University_Work/4th_Year_Neuroscience/Research_Project/Data/BRCOPT_preprocessed_Working/Melodic_ICAs_GSSRemoved"
CCsource="/Users/joshuamarden/University_Work/4th_Year_Neuroscience/Research_Project/Data/BRCOPT_preprocessed_Working/Cross_Correlations"

components=(6)
conditions=(IN IV NB PL)
thresholddirs=('0.1')
minCCcorrelation=(0.2)

for thresholddir in "${thresholddirs[@]}"; do
    for component in "${components[@]}"; do
        for condition in "${conditions[@]}"; do

            #Move to a specific condition folder containing the cc .txt files

            currentCCfolder=$CCsource"/Threshold_"$thresholddir"/"$component'_Components/'$condition
            echo "$currentCCfolder"
            cd $currentCCfolder

                #creates array of all .txt files (e.g 6C IV vs NB etc)

                currentCCoutputs=($currentCCfolder'/'*.txt*)

                #Look at each .txt file

                for currentCCoutput in "${currentCCoutputs[@]}"; do

                    #decompose name of .txt into components and conditions for later use
                    #e.g. CC_for_3C_IV_vs_NB_threshold_0.0.txt

                CCfilename="${currentCCoutput##*/}" #strips entire front of path away
                CCfilenameWOExt="${CCfilename%.*}" #strips .txt ending away
                IFS="_" read -a partialoutput <<< "$CCfilenameWOExt" #removes hyphens and put in array (is reversed array so starts at back?)
                                                                    #(works but array components in odd places so be cafeul when modifying..)
         
                        #read each line of the current .txt file to extract the data
                        # e.g. lines look like   <1   2 0.14>

                        while read -r C1 C2 CCvalue; do

                            #set conditions for whether the information of the line is useful
                            #and should be used

                            if [ "$(bc -l <<<"$CCvalue > $minCCcorrelation")" = 1 ]; then

                                #Create a folder to put this useful data in
                                
                                sortdir=$CCsource'/Sorted_Outputs/'${partialoutput[3]}'/'${partialoutput[3]}'_C'$C1'_vs_'${partialoutput[5]}'_C'$C2'_corr_'$CCvalue
                                mkdir -p ${sortdir}

                                #Duplicate and move some useful files
                                #into our new directory

                                #First do .png files for each component

                                cp $ICAsource'/Melodic_ICA_'$component'C_GSRemoved/Melodic_ICA_'$component'C_'${partialoutput[3]}'/report/IC_'$C1'_thresh.png' .tmp2
                                mv .tmp2 $sortdir'/'${partialoutput[3]}'_IC_'$C1'_thresh.png'

                                cp $ICAsource'/Melodic_ICA_'$component'C_GSRemoved/Melodic_ICA_'$component'C_'${partialoutput[5]}'/report/IC_'$C2'_thresh.png' .tmp3
                                mv .tmp3 $sortdir'/'${partialoutput[5]}'_IC_'$C2'_thresh.png'

                                #Add text file with useful data

                                echo "$LINE" > $sortdir'/Correlation_'${partialoutput[3]}'_C'$C1'_vs_'${partialoutput[5]}'_C'$C2'_'$CCvalue'.txt'

                                #Duplicate time plots into new folder

                                cp '/Users/joshuamarden/University_Work/4th_Year_Neuroscience/Research_Project/Data/BRCOPT_preprocessed_Working/Melodic_ICA_'$component'C_dual_regression/Melodic_ICA_'$component'C_dual_regression_'${partialoutput[3]}'/'${partialoutput[3]}'_C'$C1'.fig' .tmp4
                                mv .tmp4 $sortdir'/'${partialoutput[3]}'_'$C1'C.fig'

                                cp '/Users/joshuamarden/University_Work/4th_Year_Neuroscience/Research_Project/Data/BRCOPT_preprocessed_Working/Melodic_ICA_'$component'C_dual_regression/Melodic_ICA_'$component'C_dual_regression_'${partialoutput[5]}'/'${partialoutput[5]}'_C'$C2'.fig' .tmp5
                                mv .tmp5 $sortdir'/'${partialoutput[5]}'_'$C2'C.fig'




                                echo "Huzzah!!!!"
                            fi
                        done < "$currentCCoutput" #ends while read loop
                done #ends loop of CC outputs

                #Duplicate and move the 4D ICA file into the parent dir
                #of each correlation folder, which will be one of the 
                #conditons (PL, IN, NB, IV) as long as they have been
                #correctly put into the $partialoutputs array. This does 
                #duplicate NIFTI images so could be ignored, but keeping
                #them close to hand can't be a bad idea?


                cp $ICAsource'/Melodic_ICA_'$component'C_GSRemoved/Melodic_ICA_'$component'C_'$condition'/melodic_IC.nii.gz' .tmp1
                mv .tmp1 $CCsource'/Sorted_Outputs/'$condition'/'$condition'_'$component'C_melodic_ICA.nii.gz'


        done #conditions
    done #components
done #thresholds









#––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––
#------------------------------------------------------------------------------
#
#                Just notes and rough working below here
#
#------------------------------------------------------------------------------
#––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––––

# echo
# echo "${currentCCoutputs[@]}"
# echo
# echo "${CCfilename[@]}"
# echo
# echo "${CCfilenameWOExt[@]}"
# echo
# echo "${partialoutput[@]}"
# echo
# echo "${partialoutput[1]}"
# echo
# for partialoutput in ${partialoutputs[@]}; do
#     echo "$partialoutput"
#     echo
# done





# You can also use POSIX shell variable expansion to do this.

# path=/path/to/file/drive/file/path/
# echo ${path#/path/to/file/drive/}

# The #.. part strips off a leading matching string when the variable is expanded; this is especially useful if your strings are already in shell variables, like if you're using a for loop. You can strip matching strings (e.g., an extension) from the end of a variable also, using %.... See the bash man page for the gory details.




# VARIABLE=1234-123-456-890

# PART=(${VARIABLE//-/ })

# echo ${PART[0]}-${PART[1]}-${PART[2]}-${PART[3]}

# for currentCCoutput in "${currentCCoutputs[@]}"; do
#     while read -r c1 c2 threshold; do
#         if [ "$c1" != "$c2" ] && [ "$(bc -l <<<"$threshold > 0.2")" = 1 ]; then
#             echo "Huzzah!!!! Progress at last: c1=$c1; c2=$c2; threshold=$threshold"
#         fi
#      done < "$currentCCoutput"
# done

# $ num1=3.17648E-22
# $ num2=1.5
# $ echo $num1'>'$num2 | bc -l
# 0
# $ echo $num2'>'$num1 | bc -l
# 1


#create an array of text files

# currentCCoutputs=($currentccfolder'/'*.txt*)

# #basic for loop until I can get my cat command working

# for currentCCoutput in "${currentCCoutputs[@]}"; do

#     cat "$currentCCoutput" | while read LINE; do

#         # I have .txt files with three numbers per line
#         # that I would like to read / use

#         IFS=' ' read C1 C2 threshold
#             if [ $C1 != $C2 ] && [ $threshold \> 0.2 ]; then
#             echo "Huzzah!!!! Progress at last"
#         fi

#      done < "$currrentccoutput" # I don't know what 
#                                 # this backwards chevron
#                                 # does but other people
#                                 # have used it...
# done

# cat allCCS.txt | while read LINE; do
#   threshold=${LINE##* }
#   echo $threshold
#     echo $LINE
# done

#if (( $(echo "$num1 > $num2" |bc -l) )); then

# if [ 1 -eq "$(echo "${val} < ${min}" | bc)" ]