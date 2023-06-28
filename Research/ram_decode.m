%By Raphaël BOICHOT, 1 june 2021
function GB_pixels=ram_decode(GB_tile,PACKET_image_width,PACKET_image_height)
    PACKET_image=zeros(PACKET_image_height,PACKET_image_width);    
    pos=1;
    %tile decoder
    tile_count=0;
    height=1;
    width=1;
while tile_count<(PACKET_image_width/8)*(PACKET_image_height/8)-1
    tile=zeros(8,8);
    for i=1:1:8
    byte1=dec2bin(GB_tile(pos),8);
    pos=pos+1;
    byte2=dec2bin(GB_tile(pos),8);
    pos=pos+1;
      for j=1:1:8
      tile(i,j)=bin2dec([byte2(j),byte1(j)]);
      end
    end
    PACKET_image((height:height+7),(width:width+7))=tile;
    tile_count=tile_count+1;
    width=width+8;
      if width>=PACKET_image_width
      width=1;
      height=height+8;     
      end
      
end
GB_pixels=3-PACKET_image;