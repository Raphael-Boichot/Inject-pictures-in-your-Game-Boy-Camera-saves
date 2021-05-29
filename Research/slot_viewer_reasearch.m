clc
clear
%------------------------------------------------------------------------
fid = fopen('GAMEBOYCAMERA_erase_all_save_data.sav','r');    %save file to check (your file)
while ~feof(fid)
a=fread(fid);
end
fclose(fid);
vector=[];
vector=[vector,a(4529:4560)];
vector=[vector,a(4566:4597)];

pos=4567;
image_information=[];
for k=1:1:30
    if not(a(pos+k)==255);
    disp(['Slot ',num2str(k),' contains image ',(num2str(a(pos+k)+1)),' (available) Last byte=',num2str(a(12288+(k-1)*4096))]);
    else
    disp(['Slot ',num2str(k),' is empty or erased (not available) Last byte=',num2str(a(12287+(k-1)*4096))]);    
    end
    image_information=[image_information,a((12033+(k-1)*4096):(12288+(k-1)*4096))];
end
%------------------------------------------------------------------------
vector'
image_information'