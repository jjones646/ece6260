function [ intarray ] = bitstream2ints( codestr, bitrate )
% ints2bitstream: Convert the '0101...' bitstream into integers
% Input:
%   codestr: the '0101...' bitstream that represents the intarray, in which
%            'bitrate' number of characters corresponds to one integer 
% Output: 
%   intarray: an array of integers, that are translated from codestr
%   bitrate: the bitrate, indicating how many bits for each integer

bitrate = double(bitrate);
intnum = length(codestr)/bitrate;
intarray = zeros(intnum, 1);
for i = 0:intnum-1
    c = codestr(bitrate*i+1: bitrate*i+bitrate);
    int = bin2dec(c);
    intarray(i+1) = int;
end

end



