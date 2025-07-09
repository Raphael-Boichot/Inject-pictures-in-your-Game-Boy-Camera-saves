%By Raphael BOICHOT, 1 june 2021, revised 2025

clc;
clear;
mkdir("./Images");
% --- Read save file ---
filename = 'Hello_Kitty.sav';  % Change this if needed
fid = fopen(filename, 'r');
if fid == -1
    error(['Failed to open file: ', filename]);
end
a = fread(fid);
fclose(fid);

kitty=a(4605:4605+560);
frame=decode_kitty(kitty);
frame_png=(frame==3)*255+(frame==2)*125+(frame==1)*80+(frame==0)*0;
filename='./Images/Image_Kitty_Face_1.png';
imwrite(uint8(frame_png),filename)
disp(['Saved ', filename]);

kitty=a(4605+560:4605+560*2);
frame=decode_kitty(kitty);
frame_png=(frame==3)*255+(frame==2)*125+(frame==1)*80+(frame==0)*0;
filename='./Images/Image_Kitty_Face_2.png';
imwrite(uint8(frame_png),filename)
disp(['Saved ', filename]);

kitty=a(4605+560*2:4605+560*3);
frame=decode_kitty(kitty);
frame_png=(frame==3)*255+(frame==2)*125+(frame==1)*80+(frame==0)*0;
filename='./Images/Image_Kitty_Face_3.png';
imwrite(uint8(frame_png),filename)
disp(['Saved ', filename]);

% --- Extract image 0 (default "zero" image) ---
image_zero = a(1:4096);
frame = decode_zero(image_zero);
frame_png = to_grayscale(frame);
imwrite(frame_png, './Images/Image_0.png');
disp('Saved Image_0.png');

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



