%By Raphaël BOICHOT, 28/08/2022
%https://github.com/Raphael-Boichot/Inject-pictures-in-your-Game-Boy-Camera-saves
% creates a legit save full of random data
clc
clear

Magic=[0x4D 0x61 0x67 0x69 0x63];
a=ceil(rand(1,131072)*256-1);
%a=zeros(1,131072);

% fid = fopen('Universal_unlocking_save.sav','r');    
% a=fread(fid);

%Unlock regular cameras B album (Pocket, Zelda, Eu, Int)
%first range
beginning_data_address=0x01000;
beginning_checksum_address=0x010D7;
a(beginning_checksum_address-4:beginning_checksum_address)=Magic;
data=a(beginning_data_address+1:beginning_checksum_address-5);
[a]=checksum_from_scratch(a,beginning_data_address,beginning_checksum_address,data);
%echo
beginning_data_address=0x010D9;
beginning_checksum_address=0x011B0;
a(beginning_checksum_address-4:beginning_checksum_address)=Magic;
data=a(beginning_data_address+1:beginning_checksum_address-5);
[a]=checksum_from_scratch(a,beginning_data_address,beginning_checksum_address,data);

%---------Vector state
%first range
beginning_data_address=0x11B2;
beginning_checksum_address=0x11D5;
a(beginning_checksum_address-4:beginning_checksum_address)=Magic;
a(beginning_data_address+1:beginning_data_address+30)=[0x00 0x01 0x02 0x03 0x04 0x05 0x06 0x07 0x08 0x09 0x0A 0x0B 0x0C 0x0D 0x0E 0x0F 0x10 0x11 0x12 0x13 0x14 0x15 0x16 0x17 0x18 0x19 0x1A 0x1B 0x1C 0x1D];
data=a(beginning_data_address+1:beginning_checksum_address-5);
[a]=checksum_from_scratch(a,beginning_data_address,beginning_checksum_address,data);
% %echo
beginning_data_address=0x011D7;
beginning_checksum_address=0x011FA;
a(beginning_checksum_address-4:beginning_checksum_address)=Magic;
a(beginning_data_address+1:beginning_data_address+30)=[0x00 0x01 0x02 0x03 0x04 0x05 0x06 0x07 0x08 0x09 0x0A 0x0B 0x0C 0x0D 0x0E 0x0F 0x10 0x11 0x12 0x13 0x14 0x15 0x16 0x17 0x18 0x19 0x1A 0x1B 0x1C 0x1D];
data=a(beginning_data_address+1:beginning_checksum_address-5);
[a]=checksum_from_scratch(a,beginning_data_address,beginning_checksum_address,data);

%---------camera owner
%first range
beginning_data_address=0x02FB8;
beginning_checksum_address=0x02FCF;
a(beginning_checksum_address-4:beginning_checksum_address)=Magic;
data=a(beginning_data_address+1:beginning_checksum_address-5);
[a]=checksum_from_scratch(a,beginning_data_address,beginning_checksum_address,data);
% %echo
beginning_data_address=0x02FD1;
beginning_checksum_address=0x02FE8;
a(beginning_checksum_address-4:beginning_checksum_address)=Magic;
data=a(beginning_data_address+1:beginning_checksum_address-5);
[a]=checksum_from_scratch(a,beginning_data_address,beginning_checksum_address,data);

for i=0:1:29
%---------image data
%---------image owner
%first range
beginning_data_address=0x02F00+i*0x01000;
beginning_checksum_address=0x02F5A+i*0x01000;
a(beginning_checksum_address-4:beginning_checksum_address)=Magic;
data=a(beginning_data_address+1:beginning_checksum_address-5);
[a]=checksum_from_scratch(a,beginning_data_address,beginning_checksum_address,data);
% %echo
beginning_data_address=0x02F5C+i*0x01000;
beginning_checksum_address=0x02FB6+i*0x01000;
a(beginning_checksum_address-4:beginning_checksum_address)=Magic;
data=a(beginning_data_address+1:beginning_checksum_address-5);
[a]=checksum_from_scratch(a,beginning_data_address,beginning_checksum_address,data);
end


fid = fopen('Game Boy Camera glitched save.sav','w');
a=fwrite(fid,a);
fclose(fid);
disp('Glitched save created !')

