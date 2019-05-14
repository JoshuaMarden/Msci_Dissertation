#Merges and runs melodic ICA - very crude, doesn't use many variables



##### ----------------------------> Do not use data from subject 15-IV set 8

mkdir '/Users/joshuamarden/University_Work/4th_Year_Neuroscience/Research_Project/Data/BRCOPT_preprocessed_Working/Melodic_ICAs_GSSRemoved/'



#Melodic	

NumberofCs=(2 3 4 5 6 7 )

for Number in "${NumberofCs[@]}"; do
    
    mkdir '/Users/joshuamarden/University_Work/4th_Year_Neuroscience/Research_Project/data/BRCOPT_preprocessed_Working/Melodic_ICAs_GSSRemoved/Melodic_ICA_'$Number'C_GSRemoved'

done

for Number in "${NumberofCs[@]}"; do
	
	DataOutputFolder='/Users/joshuamarden/University_Work/4th_Year_Neuroscience/Research_Project/data/BRCOPT_preprocessed_Working/Melodic_ICAs_GSSRemoved/Melodic_ICA_'$Number'C_GSRemoved'

	melodic -iv /Users/joshuamarden/University_Work/4th_Year_Neuroscience/Research_Project/Data/BRCOPT_preprocessed_Working/lists_for_melodic/PL_list_for_melodic_local_macGSRemoved.txt -o $DataOutputFolder'/Melodic_ICA_'$Number'C_PL' -d $((Number)) --report


	melodic -iv /Users/joshuamarden/University_Work/4th_Year_Neuroscience/Research_Project/Data/BRCOPT_preprocessed_Working/lists_for_melodic/NB_list_for_melodic_local_macGSRemoved.txt -o $DataOutputFolder'/Melodic_ICA_'$Number'C_NB' -d $((Number)) --report


	melodic -iv /Users/joshuamarden/University_Work/4th_Year_Neuroscience/Research_Project/Data/BRCOPT_preprocessed_Working/lists_for_melodic/IN_list_for_melodic_local_macGSRemoved.txt -o $DataOutputFolder'/Melodic_ICA_'$Number'C_IN' -d $((Number)) --report


	melodic -iv /Users/joshuamarden/University_Work/4th_Year_Neuroscience/Research_Project/Data/BRCOPT_preprocessed_Working/lists_for_melodic/IV_list_for_melodic_local_macGSRemoved.txt -o $DataOutputFolder'/Melodic_ICA_'$Number'C_IV' -d $((Number)) --report

		
	echo $'Completed_ICA_using_'$Number'_components!'

done


echo $'Finished_Processing_For_'$NumberofCs'Components!'


