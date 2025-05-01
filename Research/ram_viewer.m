%By Raphaël BOICHOT, 1 june 2021

clc
clear
PACKET_image_width=128;
listing = dir('*.sav*');

for i=1:1:length(listing)
    name=listing(i).name
fid = fopen(name,'r');    
a=fread(fid);
fclose(fid);
tiles=round(length(a)/16)
PACKET_image_height=round(8*tiles/(PACKET_image_width/8))
GB_tile=a(1:16*tiles);
frame=ram_decode(GB_tile,PACKET_image_width,PACKET_image_height);
frame_png=(frame==3)*255+(frame==2)*125+(frame==1)*80+(frame==0)*0;
imwrite(uint8(frame_png),[name(1:end-4),'.png'])
disp('Ram extracted')
figure(1)
      imagesc(frame)
      colormap gray
      drawnow
end