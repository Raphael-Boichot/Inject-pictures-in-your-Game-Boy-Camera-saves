%By Raphaël BOICHOT, 7 Mai 2022
%this code replaces pictures by random data
clc
clear
fid = fopen('POCKETCAMERA.sav','r');    %save file where you want to activate all slots
while ~feof(fid)
a=fread(fid);
end
fclose(fid);
vector_state=[0xFF;0xFF;0xFF;0xFF;0xFF;0xFF;0xFF;0xFF;0xFF;0xFF;0xFF0;0xFF;0xFF;0xFF;0xFF;0xFF;0xFF;0xFF;0xFF;0xFF;0xFF;0xFF;0xFF;0xFF;0xFF;0xFF;0xFF;0xFF;0xFF;0xFF];
checksum=[0x11;0x15];

%------------------------------------------------------------------------
a(4531:4560)=vector_state;
a(4566:4567)=checksum;


for i=1:1:30
start=8193+4096*(i-1);
ending=start+3584;
a(start:ending)=uint8(rand(ending-start+1,1)*255);
end

fid = fopen('POCKETCAMERA.sav','w');
a=fwrite(fid,a);
fclose(fid);
disp('All slot are now erased !')