%By Raphael BOICHOT, 7 june 2021, revised 2025

clc;
clear;

% --- Open and read the save file ---
filename = 'POCKETCAMERA.sav';
fid = fopen(filename, 'r');
a = fread(fid);
fclose(fid);

% --- Extract vector state for slots ---
vector_state = a(4531:4560);

% --- Analyze slots ---
for k = 1:30
    start = 8193 + 4096 * (k - 1);
    ending = start + 3584 - 1;
    image = a(start:ending);
    status = sum(image);

    if vector_state(k) ~= 255
        if status == 0
            disp(['Slot ', num2str(k), ' contains image ', num2str(vector_state(k) + 1), ' (available for injection, blank slot)']);
        else
            disp(['Slot ', num2str(k), ' contains image ', num2str(vector_state(k) + 1), ' (available for injection)']);
        end
    else
        if status == 0
            disp(['Slot ', num2str(k), ' is blank (not available)']);
        else
            disp(['Slot ', num2str(k), ' was erased (not available)']);
        end
    end
end

% --- Extract special images ---
game_face = a(4605 : 4605 + 3584 - 1);
image_zero = a(1:4096);

% --- Create a 4x8 grid composite image from Game Boy Camera Slots ---

% Cell array to hold all 32 images (4 rows × 8 columns)
images = cell(4, 8);

% --- Slot -1 (zero image, 128x128) ---
img0 = decode_zero(image_zero);
img0_scaled = uint8(img0 * (255/3));
img0_cropped = img0_scaled(9:end-8, :);  % Crop top and bottom 8 pixels
images{1, 1} = img0_cropped;

% --- Game Face Slot 0 (128x112) ---
imgGame = decode(game_face);
imgGame_scaled = uint8(imgGame * (255/3));
images{1, 2} = imgGame_scaled;

% --- Slots 1 to 30 (128x112 each) ---
for i = 1:30
    row = floor((i + 1) / 8) + 1;  % +1 for offset due to Slot -1 and Slot 0
    col = mod(i + 1, 8) + 1;

    start = 8193 + 4096 * (i - 1);
    ending = start + 3584 - 1;
    imagek = a(start:ending);

    img = decode(imagek);
    img_scaled = uint8(img * (255/3));
    images{row, col} = img_scaled;
end

% --- Assemble the 4x8 grid image ---
row_images = cell(4, 1);
for r = 1:4
    row_images{r} = images{r, 1};
    for c = 2:8
        row_images{r} = [row_images{r}, images{r, c}];  % Horizontal concatenation
    end
end

giant_image = row_images{1};
for r = 2:4
    giant_image = [giant_image; row_images{r}];  % Vertical concatenation
end

% --- Display the giant image ---
figure('Name', 'Giant Game Boy Camera Image', 'NumberTitle', 'off');
imshow(giant_image);
title('Giant 4x8 Composite Image');

% --- Save as PNG ---
imwrite(giant_image, 'giant_gameboy_grid.png');
disp('Saved giant 4x8 image as giant_gameboy_grid.png');



% 	0x010BB-0x010BC: counter for image taken (on 2x2 digits reversed);
% 	0x010BD-0x010BE: counter for image erased (on 2x2 digits reversed);
% 	0x010BF-0x010C0: counter for image transfered (on 2x2 digits reversed);
% 	0x010C1-0x010C2: counter for image printed (on 2x2 digits reversed);
% 	0x010C3-0x010C4: counter for pictures received by males an females (2x2 digits);
% 	0x010C5-0x010C6: Score at Space Fever II (on 4x2 digits reversed);
% 	0x010C9-0x010CA: score at balls (on 2x2 digits reversed);
% 	0x010CB-0x010CC: score at Run! Run! Run! (on 2x2 digits reversed, 99 minus value on screen);
% 	0x010D2-0x010D6: "Magic" word in ascii;
% 	0x010D7-0x010D8: checksum (2 bytes, left is a 8-bit sum, rigth is a 8-bit XOR);

minigames=a(4284:4313);
disp(['number of image taken: ',dec2hex(minigames(2),2),dec2hex(minigames(1),2)]);
disp(['number of image erased: ',dec2hex(minigames(4),2),dec2hex(minigames(3),2)]);
disp(['number of image printed: ',dec2hex(minigames(6),2),dec2hex(minigames(5),2)]);
disp(['number of image transfered: ',dec2hex(minigames(8),2),dec2hex(minigames(7),2)]);
disp(['number of image exchanged with males: ',dec2hex(minigames(9),2)]);
disp(['number of image exchanged with females: ',dec2hex(minigames(10),2)]);
space_fever=[dec2hex(minigames(14),2),dec2hex(minigames(13),2),dec2hex(minigames(12),2),dec2hex(minigames(11),2)];
disp(['Score at Space Fever II: ',space_fever]);
disp(['Score at Ball: ',dec2hex(minigames(16),2),dec2hex(minigames(15),2)]);
cent=[dec2hex(minigames(17),2)];
d3=9-str2num(cent(1));
d4=9-str2num(cent(2));
cent=[num2str(d3),num2str(d4)];
sec=[dec2hex(minigames(18),2)];
d1=9-str2num(sec(1));
d2=9-str2num(sec(2));
sec=[num2str(d1),num2str(d2)];
disp(['Time at Run!Run!Run!: ',sec,'.',cent,' sec']);
disp(['Checksum: ', dec2hex(minigames(29),2),' ',dec2hex(minigames(30),2)])

