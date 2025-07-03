%By Raphaël BOICHOT, 1 june 2021
function GB_tile=encode(a)
[hauteur, largeur, profondeur]=size(a);
O=[];
C = unique(a);
if length(C)==2;
    Black=C(1);
    Dgray=C(2);
    Lgray=C(2);
    White=C(2);
else
    Black=C(1);
    Dgray=C(2);
    Lgray=C(3);
    White=C(4);
end
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
GB_tile=O;