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

% --- Display images in subplots ---
figure('Name', 'Game Boy Camera Slots', 'NumberTitle', 'off');

% Slot -1 (zero image)
subplot(4, 8, 1);
img0 = decode_zero(image_zero);
img0_scaled = uint8(img0 * (255/3)); % scale 0-3 to 0-255
imshow(img0_scaled);
title('Slot -1');
disp('Displaying Slot -1 image');
drawnow;

% Game Face Slot 0
subplot(4, 8, 2);
imgGame = decode(game_face);
imgGame_scaled = uint8(imgGame * (255/3));
imshow(imgGame_scaled);
title('Game Face Slot 0');
disp('Displaying Game Face Slot 0 image');
drawnow;

% Slots 1 to 30
for i = 1:30
    start = 8193 + 4096 * (i - 1);
    ending = start + 3584 - 1;
    imagek = a(start:ending);

    subplot(4, 8, 2 + i);
    img = decode(imagek);
    img_scaled = uint8(img * (255/3));
    imshow(img_scaled);

    status = sum(imagek);
    if vector_state(i) ~= 255
        if status == 0
            title(['Slot ', num2str(i), ': active (blank)']);
            disp(['Displaying Slot ', num2str(i), ': active (blank)']);
        else
            title(['Slot ', num2str(i), ': active']);
            disp(['Displaying Slot ', num2str(i), ': active']);
        end
    else
        if status == 0
            title(['Slot ', num2str(i), ': blank']);
            disp(['Displaying Slot ', num2str(i), ': blank']);
        else
            title(['Slot ', num2str(i), ': erased']);
            disp(['Displaying Slot ', num2str(i), ': erased']);
        end
    end

    drawnow;
end



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

