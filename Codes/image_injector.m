clc;
clear;
%------------------------------------------------------------------------
O=[];
slot=1;                                 %slot for injection after inspection with slot_viewer.m
pocket_name='GAMEBOYCAMERA.sav';        %save file to modify (your file)
output_name='new_save.sav';             %save file modified to burn
for k=1:1:2
    if k==1;im = 'image_big.png';end;   %your image 128x112 pixels 4 shades of gray
    if k==2;im = 'thumbnail.png';end;   %your thumbnail 32x32 pixels 4 shades of gray

a=imread(im);
figure(1)
imagesc(a)
colormap gray;
[hauteur, largeur, profondeur]=size(a);

if k==1;
if not(hauteur==112);msgbox('The image height is not 112 pixels');end
if not(largeur==128);msgbox('The image width is not 128 pixels');end
end

if k==2;
if not(hauteur==32);msgbox('The image height is not 32 pixels');end
if not(largeur==32);msgbox('The image width is not 32 pixels');end
end

C = unique(a);
if not(length(C)==4); msgbox('The image is not 4 colors !');end
uni_tile=255*ones(8,8);
Black=C(1);
Dgray=C(2);
Lgray=C(3);
White=C(4);
hor_tile=largeur/8;
vert_tile=hauteur/8;
tile=0;
H=1;
L=1;
H_tile=1;
L_tile=1;

total_tiles=hor_tile*vert_tile;
for x=1:1:hor_tile   
  for y=1:1:vert_tile   
    tile=tile+1;
    b=a((H:H+7),(L:L+7));
 
    for i=1:8
        for j=1:8
          
         if b(i,j)==Lgray;  V1(j)=('1'); V2(j)=('0');end;
         if b(i,j)==Dgray;  V1(j)=('0'); V2(j)=('1');end;
         if b(i,j)==White;  V1(j)=('0'); V2(j)=('0');end;
         if b(i,j)==Black;  V1(j)=('1'); V2(j)=('1');end;
     
        end
    O=[O;bin2dec(V1);bin2dec(V2)];
    end
  rectangle('Position',[L-1 H-1 8 8],'EdgeColor','r');
  
 drawnow
  
    L=L+8;
    L_tile=L_tile+1;
      if L>=largeur
      L=1;
      L_tile=1;
      H=H+8;
      H_tile=H_tile+1;  
    end

    end
end
pause(1)
end

fid = fopen(pocket_name,'r');
while ~feof(fid)
a=fread(fid);
end
fclose(fid);
start=8193+4096*(slot-1);
ending=start+3839;
a(start:ending)=O;

fid = fopen(output_name,'w');
a=fwrite(fid,a);
fclose(fid);
msgbox('End of injection, file ready to burn');
close all
%------------------------------------------------------------------------