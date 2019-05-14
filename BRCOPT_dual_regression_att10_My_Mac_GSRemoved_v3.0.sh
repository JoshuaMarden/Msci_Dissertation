#This script runs a dual regression for the melodic outputs. The actual melodic command is one that worked with Robert and I.
#Do not use FSL 6 because it doesn't work

#This is the actual working command:
#dual_regression $MelICs'/Melodic_ICA_'$ComponentNumber'C/Melodic_ICA_'$ComponentNumber'C_'$Condition'/melodic_IC.nii.gz' 1 -1 0 DR_output `cat /data/project/OXYML/BRCOPT_preprocessed_Working/lists_for_melodic/all_lists_for_melodic.txt `

#DO NOT USE FSL 6
#module switch fsl/5.0.11

#source='/data/project/OXYML/BRCOPT_preprocessed_Working'

mkdir -p "/Users/joshuamarden/University_Work/4th_Year_Neuroscience/Research_Project/Data/BRCOPT_preprocessed_Working"

DRFolder="/Users/joshuamarden/University_Work/4th_Year_Neuroscience/Research_Project/Data/BRCOPT_preprocessed_Working"

MelICs="/Users/joshuamarden/University_Work/4th_Year_Neuroscience/Research_Project/Data/BRCOPT_preprocessed_Working/Melodic_ICAs_GSSRemoved"

declare -a NumberofComponents=('2' '3' '4' '5' '6' '7')

declare -a Conditions=('NB' 'IV' 'IN' 'PL')

for ComponentNumber in ${NumberofComponents[@]} ; do

	for Condition in ${Conditions[@]} ; do

		mkdir -p $DRFolder'/Melodic_ICA_'$ComponentNumber'C_dual_regression/Melodic_ICA_'$ComponentNumber'C_dual_regression_'$Condition
		cd $DRFolder'/Melodic_ICA_'$ComponentNumber'C_dual_regression/Melodic_ICA_'$ComponentNumber'C_dual_regression_'$Condition
		dual_regression $MelICs'/Melodic_ICA_'$ComponentNumber'C_GSRemoved/Melodic_ICA_'$ComponentNumber'C_'$Condition'/melodic_IC.nii.gz' 1 -1 0 DR_output `cat /Users/joshuamarden/University_Work/4th_Year_Neuroscience/Research_Project/Data/BRCOPT_preprocessed_Working/lists_for_melodic/all_lists_for_melodic_local_mac_TCCGSRemoved.txt `
	done # Conditions
done # For each Number Components
