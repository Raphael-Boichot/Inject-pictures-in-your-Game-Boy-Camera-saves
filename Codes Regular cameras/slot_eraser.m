%By Raphaël BOICHOT, 7 Mai 2022, revised 2025
%this code replaces pictures by random data
clc;
clear;

% --- Read save file ---
fid = fopen('POCKETCAMERA.sav','r');
if fid == -1
    error('Failed to open POCKETCAMERA.sav for reading.');
end
a = fread(fid);
fclose(fid);

% --- Prepare vector_state with all 0xFF ---
vector_state = uint8(ones(30,1) * 255);

% --- Prepare checksum (example values) ---
checksum = uint8([0x11; 0x15]);

% --- Update vector_state and checksum in file data ---
a(4531:4560) = vector_state;
a(4566:4567) = checksum;

% --- Erase all 30 slots with random bytes ---
for i = 1:30
    start = 8193 + 4096 * (i - 1);
    ending = start + 3584 - 1;  % MATLAB inclusive indexing
    a(start:ending) = uint8(255 * rand(ending - start + 1, 1));
end

% --- Write modified data back to file ---
fid = fopen('POCKETCAMERA.sav', 'w');
if fid == -1
    error('Failed to open POCKETCAMERA.sav for writing.');
end
fwrite(fid, a);
fclose(fid);

disp('All slots are now erased and vector_state set to 0xFF!');

