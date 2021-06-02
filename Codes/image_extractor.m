%By Raphaël BOICHOT, 1 june 2021

clc
clear
fid = fopen('GAMEBOYCAMERA.sav','r');    
while ~feof(fid)
a=fread(fid);
end
fclose(fid);

game_face=a(4605:4605+3584);
image_zero=a(1:4096);
frame=decode_zero(image_zero);
frame_png=(frame==3)*255+(frame==2)*125+(frame==1)*80+(frame==0)*0;
imwrite(uint8(frame_png),'Image_0.png')


frame=decode(game_face);
frame_png=(frame==3)*255+(frame==2)*125+(frame==1)*80+(frame==0)*0;
imwrite(uint8(frame_png),'Image_Game_Face.png')
drawnow

for i=1:1:30
start=8193+4096*(i-1);
ending=start+3584;
imagek=a(start:ending);
frame=decode(imagek);
frame_png=(frame==3)*255+(frame==2)*125+(frame==1)*80+(frame==0)*0;
imwrite(uint8(frame_png),['Image_',num2str(i),'.png']);
end


disp('All images extracted')
