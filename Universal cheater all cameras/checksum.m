function [a]=checksum(a,beginning_data_address,beginning_checksum_address,data)
sum_byte=double(a(beginning_checksum_address+1));
xor_byte=a(beginning_checksum_address+2);

for i=1:length(data)
sum_byte=sum_byte-double(a(i+beginning_data_address))+double(data(i));
xor_byte=bitxor(xor_byte,a(i+beginning_data_address)); 
xor_byte=bitxor(xor_byte,data(i));
a(i+beginning_data_address)=data(i);
end
sum_byte=rem(sum_byte,256);
if sum_byte<0;sum_byte=sum_byte+256;end

a(beginning_checksum_address+1)=sum_byte;
a(beginning_checksum_address+2)=xor_byte;