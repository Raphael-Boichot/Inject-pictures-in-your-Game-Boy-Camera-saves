clc
clear
%------------------------------------------------------------------------
fid = fopen('GAMEBOYCAMERA.sav','r');    %save file to check (your file)
while ~feof(fid)
a=fread(fid);
end
fclose(fid);
vector_state=a(4531:4560);
pos=4531;
for k=1:1:30
    start=8193+4096*(k-1);
    ending=start+3839;
    image=a(start:ending);
    status=sum(image);
    if not(vector_state(k)==255);
        if status==0;
        disp(['Slot ',num2str(k),' contains image ',(num2str(vector_state(k)+1)),' (available for injection, blank slot)']);
        else
        disp(['Slot ',num2str(k),' contains image ',(num2str(vector_state(k)+1)),' (available for injection)']);
        end
    else
        if status==0;
        disp(['Slot ',num2str(k),' is blank (not available)']);
        else
        disp(['Slot ',num2str(k),' was erased (not available)']);
        end
    end
end
%------------------------------------------------------------------------
