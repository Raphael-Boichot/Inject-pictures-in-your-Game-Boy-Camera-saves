%By Raphael BOICHOT, 1 june 2021
clc;
clear;
slot=-1;                                 %slot for injection after inspection with slot_viewer.m
                                        %Slot 1...30 regular slots, Slot 0 : Game Face, Slot -1 : Address 0
input_name='POCKETCAMERA.sav';         %save file to modify (your file)
output_name='POCKETCAMERA.sav';        %save file modified to burn (can be the same name)
image2inject='Image_0_2_inject.png';                   %your image 128x112 pixels 4 shades of gray
thumbnail='thumbnail.png';              %your thumbnail 32x32 pixels 4 shades of gray

    fid = fopen(input_name,'r');
    while ~feof(fid)
        a=fread(fid);
    end
    fclose(fid);


if (slot>0)
    O=[];
    for k=1:1:2
        if k==1;im = image2inject;end;   %your image 128x112 pixels 4 shades of gray
        if k==2;im = thumbnail;end;   %your thumbnail 32x32 pixels 4 shades of gray

        pixels=imread(im);
        [hauteur, largeur, profondeur]=size(pixels);
        pixels=pixels(:,:,1);
        C = unique(pixels);
            if not(length(C)==4); msgbox('The image is not 4 colors !');end
        if k==1;
            if not(hauteur==112);msgbox('The image height is not 112 pixels');end
            if not(largeur==128);msgbox('The image width is not 128 pixels');end
        end

        if k==2;
            if not(hauteur==32);msgbox('The image height is not 32 pixels');end
            if not(largeur==32);msgbox('The image width is not 32 pixels');end
        end

        O=[O;encode(pixels)];
    end
    start=8193+4096*(slot-1);
    ending=start+3839;
    a(start:ending)=O;
end

if (slot==0)
        O=[];
        im = image2inject;
        pixels=imread(im);
        pixels=pixels(:,:,1);
        [hauteur, largeur, profondeur]=size(pixels);
        C = unique(pixels);
            if not(length(C)==4); msgbox('The image is not 4 colors !');end
            if not(hauteur==112);msgbox('The image height is not 112 pixels');end
            if not(largeur==128);msgbox('The image width is not 128 pixels');end

        O=encode(pixels);
        a(4605:4605+3583)=O;
end

if (slot==-1)
        O=[];
        im = image2inject;
        pixels=imread(im);
        pixels=pixels(:,:,1);
        [hauteur, largeur, profondeur]=size(pixels);
        C = unique(pixels);
            if not(length(C)==4); msgbox('The image is not 4 colors !');end
            if not(hauteur==128);msgbox('The image height is not 128 pixels');end
            if not(largeur==128);msgbox('The image width is not 128 pixels');end

        O=encode(pixels);
        a(1:4096)=O;
end


fid = fopen(output_name,'w');
a=fwrite(fid,a);
fclose(fid);
disp('End of injection, file ready to burn');

%------------------------------------------------------------------------
