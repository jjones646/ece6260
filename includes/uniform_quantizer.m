function [ xq ] = uniform_quantizer( x, rate, xmin, xmax )
% uniform_quantizer: Implement a uniform quantizer and output the quantized
% signal
% Input:
%   x: input signal
%   rate: bit rate
% Output:
%   xq: quantized signal

n = 2^rate;
delta = (xmax - xmin)/n;

indices = round((x - xmin - 0.5*delta)/delta);
indices(indices < 0) = 0;
indices(indices > n-1) = n-1;
xq = xmin + delta*(0.5+indices);

end

