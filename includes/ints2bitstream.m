function [ codestr ] = ints2bitstream( intarray, bitrate )
% ints2bitstream: Convert the integers into '0101...' bitstream
% Input: 
%   intarray: an array of integers, can be double, but will be converted
%             into uint8
%   bitrate: the bitrate, indicating how many bits for each integer
% Output:
%   codestr: the '0101...' bitstream that represents the intarray, in which
%            'bitrate' number of characters corresponds to one integer 

intarray = uint8(intarray);
codestr = '';
for i = 1:length(intarray)
    c = dec2bin(intarray(i), bitrate);
    codestr = [codestr, c];
end

end

