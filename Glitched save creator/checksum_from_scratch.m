function [a]=checksum_from_scratch(a,beginning_data_address,beginning_checksum_address,data)
sum_byte=47;
xor_byte=21;

for i=1:length(data)
sum_byte=sum_byte+double(data(i));
xor_byte=bitxor(xor_byte,data(i));
end
sum_byte=rem(sum_byte,256);
if sum_byte<0;sum_byte=sum_byte+256;end
a(beginning_checksum_address+1)=sum_byte;
a(beginning_checksum_address+2)=xor_byte;