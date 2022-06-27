%By Raphaël BOICHOT, 22/04/2022
%https://github.com/Raphael-Boichot/Inject-pictures-in-your-Game-Boy-Camera-saves
clc
clear

fid = fopen('GAMEBOYCAMERA.sav','r');    
a=fread(fid);

%-----------------Unlock Hello kitty Pocket camera animations--------------
%first range
% beginning_data_address=0x01000;
% beginning_checksum_address=0x010D7;
% data=[0x99 0x99 0x99 0x99 0x99 0x99 0x99 0x99 0x99 0x99 0x99 0x99 0x99 0x60 0x00 0x00 0x00 0x00 0x4D 0x61 0x67 0x69 0x63];
% [a]=checksum(a,beginning_data_address,beginning_checksum_address,data);
%no echo on this one
%-----------------Unlock Hello kitty Pocket camera animations--------------

%---------Unlock regular cameras B album (Pocket, Zelda, Eu, Int)----------
%first range
% beginning_data_address=0x010BB;
% beginning_checksum_address=0x010D7;
% data=[0x99 0x99 0x99 0x99 0x99 0x99 0x99 0x99 0x99 0x99 0x99 0x99 0x99 0x99 0x99 0x99 0x99 0x99];
% [a]=checksum(a,beginning_data_address,beginning_checksum_address,data);
% %echo
% beginning_data_address=beginning_data_address+217;
% beginning_checksum_address=beginning_checksum_address+217;
% [a]=checksum(a,beginning_data_address,beginning_checksum_address,data);
%---------Unlock regular cameras B album (Pocket, Zelda and Eu, Int--------

%---------Unlock Corocoro content for the Pocket Camera--------------------
%a(8190:8190+2)=[0x56 0x56 0x53]; 
%---------Unlock Corocoro content for the Pocket Camera--------------------

%{
%---------Unerase all images-----------------------------------------------
%first range
beginning_data_address=0x011B2;
beginning_checksum_address=0x11D5;
data=[0x00 0x01 0x02 0x03 0x04 0x05 0x06 0x07 0x08 0x09 0x0A 0x0B 0x0C 0x0D 0x0E 0x0F 0x10 0x11 0x12 0x13 0x14 0x15 0x16 0x17 0x18 0x19 0x1A 0x1B 0x1C 0x1D];
[a]=checksum(a,beginning_data_address,beginning_checksum_address,data);
%echo
beginning_data_address=beginning_data_address+37;
beginning_checksum_address=beginning_checksum_address+37;
[a]=checksum(a,beginning_data_address,beginning_checksum_address,data);
%---------Unerase all images-----------------------------------------------

% ---------Entering 66666666 as camera ID----------------------------------
% first range
beginning_data_address=0x02FB8;%just below the first image
beginning_checksum_address=0x02FCF;%just below the first image
data=[0x77 0x77 0x77 0x77];
[a]=checksum(a,beginning_data_address,beginning_checksum_address,data);
% echo
beginning_data_address=beginning_data_address+25;
beginning_checksum_address=beginning_checksum_address+25;
[a]=checksum(a,beginning_data_address,beginning_checksum_address,data);
% ---------Entering 66666666 as camera ID----------------------------------

% ---------Entering "GB camera Club" as comment on first image-------------
% first range
beginning_data_address=0x02F15;%+0x01000 to jump to next image
beginning_checksum_address=0x02F5A;%+0x01000 to jump to next image
data=[0x5C 0x57 0x87 0x58 0x88 0x94 0x8C 0x99 0x88 0x58 0x93 0x9C 0x89];
[a]=checksum(a,beginning_data_address,beginning_checksum_address,data);
% echo
beginning_data_address=beginning_data_address+91;
beginning_checksum_address=beginning_checksum_address+91;
[a]=checksum(a,beginning_data_address,beginning_checksum_address,data);
% ---------Entering "GB camera Club" as comment on first image-------------
%}


%---------Calculate seed for minigame checksum-----------------------------
%first range
beginning_data_address=0x01000;
beginning_checksum_address=0x010D7;
%data=zeros(1,210);
data=ceil(rand(1,210)*256-1);
[a]=checksum(a,beginning_data_address,beginning_checksum_address,data);
% %echo
beginning_data_address=beginning_data_address+217;
beginning_checksum_address=beginning_checksum_address+217;
[a]=checksum(a,beginning_data_address,beginning_checksum_address,data);
%---------Calculate seed for minigame checksum-----------------------------

%---------Calculate seed for vector state----------------------------------
%first range
beginning_data_address=0x011B2;
beginning_checksum_address=0x011D5;
%data=zeros(1,30);
data=ceil(rand(1,30)*256-1);
[a]=checksum(a,beginning_data_address,beginning_checksum_address,data);
% %echo
beginning_data_address=beginning_data_address+37;
beginning_checksum_address=beginning_checksum_address+37;
[a]=checksum(a,beginning_data_address,beginning_checksum_address,data);
%---------Calculate seed for vector state----------------------------------

%---------Calculate seed for camera owner section--------------------------
%first range
beginning_data_address=0x02FB8;
beginning_checksum_address=0x02FCF;
%data=zeros(1,18);
data=ceil(rand(1,18)*256-1);
[a]=checksum(a,beginning_data_address,beginning_checksum_address,data);
% %echo
beginning_data_address=beginning_data_address+25;
beginning_checksum_address=beginning_checksum_address+25;
[a]=checksum(a,beginning_data_address,beginning_checksum_address,data);
%---------Calculate seed for camera owner section--------------------------


fid = fopen('random_save.sav','w');
a=fwrite(fid,a);
fclose(fid);
disp('Random save created !')

