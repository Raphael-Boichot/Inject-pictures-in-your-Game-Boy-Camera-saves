%By Raphaël BOICHOT, 1 june 2021

clc
clear
fid = fopen('full-kitty.sav','r');%indicate your .sav file name here    
while ~feof(fid)
a=fread(fid);
end
fclose(fid);

game_face=a(4605:4605+3584);
image_zero=a(1:4096);
frame=decode_zero(image_zero);
frame_png=(frame==3)*255+(frame==2)*125+(frame==1)*80+(frame==0)*0;
imwrite(uint8(frame_png),'Image_0.png')

figure(2)
kitty=a(4605:4605+560);
subplot(1,3,1)
frame=decode_kitty(kitty);
frame_png=(frame==3)*255+(frame==2)*125+(frame==1)*80+(frame==0)*0;
imwrite(uint8(frame_png),'Image_Kitty_Face_1.png')
imagesc(frame_png);


kitty=a(4605+560:4605+560*2);
subplot(1,3,2)
frame=decode_kitty(kitty);
frame_png=(frame==3)*255+(frame==2)*125+(frame==1)*80+(frame==0)*0;
imwrite(uint8(frame_png),'Image_Kitty_Face_2.png')
imagesc(frame_png);

kitty=a(4605+560*2:4605+560*3);
subplot(1,3,3)
frame=decode_kitty(kitty);
frame_png=(frame==3)*255+(frame==2)*125+(frame==1)*80+(frame==0)*0;
imwrite(uint8(frame_png),'Image_Kitty_Face_3.png')
imagesc(frame_png);



for i=1:1:30
start=8193+4096*(i-1);
ending=start+3584;
imagek=a(start:ending);
frame=decode(imagek);
frame_png=(frame==3)*255+(frame==2)*125+(frame==1)*80+(frame==0)*0;
imwrite(uint8(frame_png),['Image_',num2str(i),'.png']);
end


disp('All images extracted')
