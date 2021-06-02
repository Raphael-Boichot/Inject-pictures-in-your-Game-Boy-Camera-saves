%By Raphaël BOICHOT, 1 june 2021

clc
clear
fid = fopen('GAMEBOYCAMERA.sav','r');    
while ~feof(fid)
a=fread(fid);
end
fclose(fid);

ram=a;
frame=ram_decode(ram);
frame_png=(frame==3)*255+(frame==2)*125+(frame==1)*80+(frame==0)*0;
imwrite(uint8(frame_png),'Image_ram.png')
disp('Ram extracted')
figure(1)
      imagesc(frame)
      colormap gray
      drawnow
ram_code=a(4097:4608);
begin=1;
view=[]
for i=1:1:32
    sequence=ram_code(begin:begin+15)
    begin=begin+16;
    view=[view;sequence'];
end
figure(2)
imagesc(view)
colormap jet
