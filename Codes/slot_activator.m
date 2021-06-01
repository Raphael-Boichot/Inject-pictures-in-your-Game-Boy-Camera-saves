%By Raphaël BOICHOT, 1 june 2021
clc
clear
fid = fopen('GAMEBOYCAMERA.sav','r');    %save file where you want to activate all slots
while ~feof(fid)
a=fread(fid);
end

vector_state=[0;1;2;3;4;5;6;7;8;9;10;11;12;13;14;15;16;17;18;19;20;21;22;23;24;25;26;27;28;29];
checksum=[226;20];
fclose(fid);
%------------------------------------------------------------------------
a(4531:4560)=vector_state;
a(4566:4567)=checksum;
fid = fopen('GAMEBOYCAMERA.sav','w');
a=fwrite(fid,a);
fclose(fid);
disp('All slot are now activated !')