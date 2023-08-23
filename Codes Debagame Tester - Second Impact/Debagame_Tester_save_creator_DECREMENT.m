%By Raphaël BOICHOT, 23 august 2023
clc
clear
%------------------------------------------------------------------------
byte_even=double(0x55);
byte_odd=double(0xAA);

disp('Wait, this may take a while...')
index=1;
while index<2^17
    a(index,1)=byte_even;
    index=index+1;
    a(index,1)=byte_odd;
    index=index+1;
    byte_odd=byte_odd-1;
    if byte_odd<0;
        byte_odd=255;
        byte_even=byte_even-1;
    end
    if byte_even<0;
        byte_even=255;
    end
end
fid = fopen('Debagame_DECREMENT.sav','w');
fwrite(fid,a);
fclose(fid);
disp('Dumb save created !')