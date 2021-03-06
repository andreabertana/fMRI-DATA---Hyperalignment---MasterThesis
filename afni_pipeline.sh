#!/bin/bash
pwd
#for subjname in $(cat /home/andreabertana/Projects/HCP/results/list_subject_first10.txt)
subjname=100307
#do
cd /home/andreabertana/Projects/HCP/results/MNI/MOTOR
pwd
#this script convert  nifti files to .brik

3dcopy ./mc/$subjname'_mc.nii.gz' ./afni/mc/$subjname'_mc'

#calculate intracranial mask to limit smoothing
3dAutomask -prefix ./afni/whole_mask/$subjname'_mask' ./afni/mc/$subjname'_mc'+orig

#smoothing 4mm 
3dmerge -1blur_fwhm 4.0 -doall -prefix ./afni/smoothing/$subjname'_smo' ./afni/mc/$subjname'_mc'+orig   

#scaling
3dTstat -prefix ./afni/mean/$subjname'_mean' ./afni/smoothing/$subjname'_smo'+orig 

3dcalc -prefix ./afni/scaling/$subjname'_norm' -a ./afni/smoothing/$subjname'_smo'+orig -b ./afni/mean/$subjname'_mean'+orig -c ./afni/whole_mask/$subjname'_mask'+orig -expr 'c*100*((a - b)/ b)'

#glm
waver -WAV -TR 0.72s -input ./afni/label/stim/$subjname'_t_afni.txt' -numout 568 > ./afni/label/hrf/$subjname't_hrf.txt'
waver -WAV -TR 0.72s -input ./afni/label/stim/$subjname'_rh_afni.txt' -numout 568 > ./afni/label/hrf/$subjname'rh_hrf.txt'
waver -WAV -TR 0.72s -input ./afni/label/stim/$subjname'_lh_afni.txt' -numout 568 > ./afni/label/hrf/$subjname'lh_hrf.txt'
waver -WAV -TR 0.72s -input ./afni/label/stim/$subjname'_rf_afni.txt' -numout 568 > ./afni/label/hrf/$subjname'rf_hrf.txt'
waver -WAV -TR 0.72s -input ./afni/label/stim/$subjname'_lf_afni.txt' -numout 568 > ./afni/label/hrf/$subjname'lf_hrf.txt'

3dDeconvolve -input ./afni/scaling/$subjname'_norm'+orig -mask ./afni/whole_mask/$subjname'_mask'+orig -numstimts 5 -stim_file 1 ./afni/label/hrf/$subjname't_hrf.txt' -stim_label tongue -stim_file 2 ./afni/label/hrf/$subjname'rh_hrf.txt' -stim_label right_hand stim_file 3 ./afni/label/hrf/$subjname'lh_hrf.txt' -stim_label left_hand -stim_file 4 ./afni/label/hrf/$subjname'rf_hrf.txt' -stim_label right_foot -stim_file 5 ./afni/label/hrf/$subjname'lf_hrf.txt' -stim_label left_foot -fout -tout -bucket ./afni/glm/$subjname'_glm'
cd .. 
#done

