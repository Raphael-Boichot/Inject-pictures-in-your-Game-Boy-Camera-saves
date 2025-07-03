%By Raphael BOICHOT, 1 june 2021, revised 2025

clc;
clear;

% --- Open and read the entire file ---
fid = fopen('POCKETCAMERA.sav', 'rb');
a = fread(fid, inf, 'uint8=>uint8');  % read as uint8
fclose(fid);

% --- Set vector_state to activate slots 0..29 ---
vector_state = uint8(0:29)';  % column vector

% --- Set checksum bytes ---
checksum = uint8([226; 20]);

% --- Update vector_state and checksum bytes in file buffer ---
a(4531:4560) = vector_state;
a(4566:4567) = checksum;

% --- Write modified data back to the file ---
fid = fopen('POCKETCAMERA.sav', 'wb');
if fid == -1
    error('Failed to open GAMEBOYCAMERA.sav for writing.');
end
fwrite(fid, a);
fclose(fid);

disp('All slots are now activated!');

