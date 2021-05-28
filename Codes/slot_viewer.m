clc
clear
%------------------------------------------------------------------------
fid = fopen('GAMEBOYCAMERA.sav','r');    %save file to check (your file)
while ~feof(fid)
a=fread(fid);
end
fclose(fid);
pos=4567;
for k=1:1:30
    if not(a(pos+k)==255);
    disp(['Slot ',num2str(k),' contains image ',(num2str(a(pos+k)+1)),' (available for injection)']);
    else
    disp(['Slot ',num2str(k),' is empty or erased (not available)']);    
    end
end
%------------------------------------------------------------------------
