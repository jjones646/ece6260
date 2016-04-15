function [ bytes, res ] = bitstream2bytes( bitstream )
% bitstream2bytes: convert the 01 bitstream to bytes: 8->1
% Input: 
%   bitstream: the input bitstream: '01010101101000...'
% Output:
%   bytes: the bytes, each bit comes from one symbol in bitstream
%   res: residue, number of bits that are valid in the last byte

% Function starts here
len = length(bitstream);
bytenum = floor(len/8);
res = mod(len, 8);
bytes = [];
for i = 0:bytenum-1
    bits = bitstream(i*8+1:i*8+8);
    byte = uint8(bin2dec(bits));
    bytes = [bytes, byte];
end

% for the last byte
bits = bitstream(bytenum*8+1:end);
if 0 < res && res < 8
    byte = uint8(bitshift(bin2dec(bits), 8-res));
    bytes = [bytes, byte];
end

end
