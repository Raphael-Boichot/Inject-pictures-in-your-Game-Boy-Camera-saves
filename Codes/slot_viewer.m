%By Raphaël BOICHOT, 1 june 2021
fid = fopen('GAMEBOYCAMERA.sav','r');    
while ~feof(fid)
a=fread(fid);
end
fclose(fid);
vector_state=a(4531:4560);
pos=4531;
for k=1:1:30
    start=8193+4096*(k-1);
    ending=start+3584;
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



game_face=a(4605:4605+3584);
image_zero=a(1:4096);
subplot(4,8,1)
imagesc(decode_zero(image_zero))
title('Slot -1')
colormap(gray)
drawnow
subplot(4,8,2)
imagesc(decode(game_face))
title('Game Face Slot 0')
colormap(gray)
drawnow

for i=1:1:30
start=8193+4096*(i-1);
ending=start+3584;
imagek=a(start:ending);
subplot(4,8,2+i)
imagesc(decode(imagek)) 
    status=sum(imagek);
    if not(vector_state(i)==255);
        if status==0;
        title(['Slot ',num2str(i),': active)']);
        else
        title(['Slot ',num2str(i),': active']);
        end
    else
        if status==0;
        title(['Slot ',num2str(i),': blank']);
        else
        title(['Slot ',num2str(i),': erased']);
        end
    end
    drawnow    
colormap(gray)
end



