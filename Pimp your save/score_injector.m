%By Raphaël BOICHOT, 7 june 2021
% 	0x010BB-0x010BC: counter for image taken (on 2x2 digits reversed);
% 	0x010BD-0x010BE: counter for image erased (on 2x2 digits reversed);
% 	0x010BF-0x010C0: counter for image transfered (on 2x2 digits reversed);
% 	0x010C1-0x010C2: counter for image printed (on 2x2 digits reversed);
% 	0x010C3-0x010C4: counter for pictures received by males an females (2x2 digits);
% 	0x010C5-0x010C6: Score at Space Fever II (on 4x2 digits reversed);
% 	0x010C9-0x010CA: score at balls (on 2x2 digits reversed);
% 	0x010CB-0x010CC: score at Run! Run! Run! (on 2x2 digits reversed, 99 minus value on screen);
% 	0x010D2-0x010D6: "Magic" word in ascii;
% 	0x010D7-0x010D8: checksum (2 bytes, left is a 8-bit sum, rigth is a 8-bit XOR);
clc
clear
image_taken='9999';                  %number of image taken
image_erased='9999';                 %number of image erased
image_transfered='9999';             %number of image transfered
image_printed='9999';                %number of image printed
image_males='99';                    %number of image received from males
image_females='99';                  %number of image received from females
space_fever='99999999';              %score at Space Fever II
ball='9999';                         %score at Ball
run='0000';                          %time at Run!Run!Run!

fid = fopen('GAMEBOYCAMERA.sav','r');    
while ~feof(fid)
a=fread(fid);
end
disp('----The old vector---------------')
minigames=a(4284:4313);
score_viewer(minigames);

fake_vector=zeros(30,1);
fake_vector(1,1)=hex2dec(image_taken(3:4));
fake_vector(2,1)=hex2dec(image_taken(1:2));
fake_vector(3,1)=hex2dec(image_erased(3:4));
fake_vector(4,1)=hex2dec(image_erased(1:2));
fake_vector(5,1)=hex2dec(image_transfered(3:4));
fake_vector(6,1)=hex2dec(image_transfered(1:2));
fake_vector(7,1)=hex2dec(image_printed(3:4));
fake_vector(8,1)=hex2dec(image_printed(1:2));
fake_vector(9,1)=hex2dec(image_males);
fake_vector(10,1)=hex2dec(image_females);
fake_vector(11,1)=hex2dec(space_fever(7:8));
fake_vector(12,1)=hex2dec(space_fever(5:6));
fake_vector(13,1)=hex2dec(space_fever(3:4));
fake_vector(14,1)=hex2dec(space_fever(1:2));
fake_vector(15,1)=hex2dec(ball(3:4));
fake_vector(16,1)=hex2dec(ball(1:2));
d1=9-str2num(run(1));
d2=9-str2num(run(2));
sec=[num2str(d1),num2str(d2)];
d3=9-str2num(run(3));
d4=9-str2num(run(4));
cent=[num2str(d3),num2str(d4)];
hex2dec(cent);
hex2dec(sec);

fake_vector(17,1)=hex2dec(cent);
fake_vector(18,1)=hex2dec(sec);

disp('----Checksum verif---------------')
diff=fake_vector(1:18)-minigames(1:18);
disp(['the old left checksum is ',dec2hex(minigames(29))]);
new_left_byte=dec2hex(minigames(29)+sum(diff));
disp(['the new left checksum is ',new_left_byte(end-1:end)]);
disp(['the old right checksum is ',dec2hex(minigames(30))]);
init=minigames(30);
for i=1:1:16
    init=bitxor(init,fake_vector(i));
end    
new_right_byte=dec2hex(init);
disp(['the new right checksum is ',new_right_byte])
disp(['----The new vector-------------'])
new_vector=minigames;
new_vector(1:18)=fake_vector(1:18);
new_vector(end-1)=hex2dec(new_left_byte(end-1:end));
new_vector(end)=hex2dec(new_right_byte);
score_viewer(new_vector);
disp('----End of code------------------')
    
a(4284:4313)=new_vector;
fid = fopen('PIMP_MY_SAVE.sav','w');
a=fwrite(fid,a);
fclose(fid);
disp('Pimped save created !')

