%By Raphael BOICHOT, 1 june 2021, revised 2025

clc;
clear;
mkdir("./Images");
% --- Read save file ---
filename = 'POCKETCAMERA.sav';  % Change this if needed
fid = fopen(filename, 'r');
if fid == -1
    error(['Failed to open file: ', filename]);
end
a = fread(fid);
fclose(fid);

% --- Extract image 0 (default "zero" image) ---
image_zero = a(1:4096);
frame = decode_zero(image_zero);
frame_png = to_grayscale(frame);
imwrite(frame_png, './Images/Image_0.png');
disp('Saved Image_0.png');

% --- Extract Game Face image (first saved photo) ---
game_face = a(4605 : 4605 + 3584 - 1);
frame = decode(game_face);
frame_png = to_grayscale(frame);
imwrite(frame_png, './Images/Image_Game_Face.png');
disp('Saved Image_Game_Face.png');

% --- Extract next 30 images ---
for i = 1:30
    start = 8193 + 4096 * (i - 1);
    imagek = a(start : start + 3584 - 1);
    frame = decode(imagek);
    frame_png = to_grayscale(frame);
    filename = ['./Images/Image_', num2str(i), '.png'];
    imwrite(frame_png, filename);
    disp(['Saved ', filename]);
end

disp('All images extracted.');



