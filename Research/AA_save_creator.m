%By Raphaël BOICHOT, 1 june 2021
clc
clear
%------------------------------------------------------------------------
a=170*ones(131072,1);
fid = fopen('DUMB_AA.sav','w');
a=fwrite(fid,a);
fclose(fid);
disp('Dumb save created !')