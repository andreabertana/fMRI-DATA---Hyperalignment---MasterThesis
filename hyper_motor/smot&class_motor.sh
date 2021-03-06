#!/bin/bash
 #this script should be run from andreabertana dir

chmod +x /home/andreabertana/Projects/HCP/pipeline/hyper_motor/hyper_motor_anova_svm.py 
chmod +x /home/andreabertana/Projects/HCP/pipeline/hyper_motor/anatomic_motor_anova_svm.py 

for subjname in $(cat ./Projects/HCP/results/list_subject_first10.txt)
do

#smoothing on det
./Projects/HCP/pipeline/preprocess/smoothing.sh /home/andreabertana/Projects/HCP/results/MNI/MOTOR/detrend/$subjname'_det_mc.nii.gz' /home/andreabertana/Projects/HCP/results/MNI/MOTOR/smoothing/$subjname'_det_smo_motor.nii.gz' 

done	

cd /home/andreabertana/Projects/HCP/pipeline

#lauch hyper for mc ANOVA SVM 
python ./hyper_motor/hyper_motor_anova_svm.py mc
#lauch hyper for detrend ANOVA SVM 
python ./hyper_motor/hyper_motor_anova_svm.py detrend
#lauch hyper for smo ANOVA SVM 
python ./hyper_motor/hyper_motor_anova_svm.py smoothing

#lauch anatomic for mc ANOVA SVM 
python hyper_motor/anatomic_motor_anova_svm.py mc
#lauch anatomic for detrend ANOVA SVM 
python hyper_motor/anatomic_motor_anova_svm.py detrend
#lauch anatomic for smoothing ANOVA SVM 
python hyper_motor/anatomic_motor_anova_svm.py smoothing

cd ..
