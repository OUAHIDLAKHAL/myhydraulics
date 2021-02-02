# myhydraulics
you find here a optimized version of script given by prof arbaoui, on my machine 100 cycle take 11 sec.
<br/ >
you can change the N_Cyle variable to specific the number of iterations you want, in this script i use 100
<br/ >
for speed up the script, i disable the ploting, if you want to plot uncomment the code.
<br/ >
Pmoy_m = double(zeros(1,N_cycle)); % la puissance moyenne en regime moteur dans chaque iteration
<br/ >
Pmax_m = double(zeros(1,N_cycle)); % la puissance max en regime moteur dans chaque iteration
<br/ >
Pmoy_r = double(zeros(1,N_cycle)); % la puissance moyenne en regime generateur dans chaque iteration
<br/ >
Pmax_r = double(zeros(1,N_cycle)); % la puissance max en regime generateur dans chaque iteration
<br/ >
if you want to get rid of window type "close all" and "clear all" to clean the workspace.
