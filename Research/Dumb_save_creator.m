%By Raphaël BOICHOT, 1 june 2021
clc
clear
%------------------------------------------------------------------------
a=zeros(131072,1);
fid = fopen('DUMB.sav','w');
a=fwrite(fid,a);
fclose(fid);
disp('Dumb save created !')