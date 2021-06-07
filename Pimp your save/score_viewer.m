function []=score_viewer(minigames)
disp(['number of image taken: ',dec2hex(minigames(2),2),dec2hex(minigames(1),2)]);
disp(['number of image erased: ',dec2hex(minigames(4),2),dec2hex(minigames(3),2)]);
disp(['number of image transfered: ',dec2hex(minigames(6),2),dec2hex(minigames(5),2)]);
disp(['number of image printed: ',dec2hex(minigames(8),2),dec2hex(minigames(7),2)]);
disp(['number of image exchanged with males: ',dec2hex(minigames(9),2)]);
disp(['number of image exchanged with females: ',dec2hex(minigames(10),2)]);
space_fever=[dec2hex(minigames(14),2),dec2hex(minigames(13),2),dec2hex(minigames(12),2),dec2hex(minigames(11),2)];
disp(['Score at Space Fever II: ',space_fever]);
disp(['Score at Ball: ',dec2hex(minigames(16),2),dec2hex(minigames(15),2)]);
cent=[dec2hex(minigames(17),2)];
d3=9-str2num(cent(1));
d4=9-str2num(cent(2));
cent=[num2str(d3),num2str(d4)];
sec=[dec2hex(minigames(18),2)];
d1=9-str2num(sec(1));
d2=9-str2num(sec(2));
sec=[num2str(d1),num2str(d2)];
disp(['Time at Run!Run!Run!: ',sec,'.',cent,' sec']);
disp(['Checksum: ', dec2hex(minigames(29),2),' ',dec2hex(minigames(30),2)])