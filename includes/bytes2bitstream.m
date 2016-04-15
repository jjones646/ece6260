function [ bitstream ] = bytes2bitstream( bytes, res )
% bytes2bitstream: convert the bytes to bitstream: 1->8
% This is the inverse of bitstream2bytes
% Input: 
%   bytes: the bytes, each bit comes from one symbol in bitstream
%   res: residue, number of bits that are valid in the last byte
% Output:
%   bitstream: the input bitstream: '01010101101000...'

% Function starts here
len = length(bytes);
bitstream = [];
for i = 1:len-1
    byte = bytes(i);
    bits = dec2bin(byte, 8);
    bitstream = [bitstream, bits];
end

% for the last byte
byte = bytes(len);
bits = dec2bin(byte, 8);
if res > 0 && res < 8
    bits = bits(1:res);
end
bitstream = [bitstream, bits];
end

