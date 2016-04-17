function [ xrecs ] = lpc_reconstruct( es, as, xlen, fs )
% lpc_reconstruct: reconstruct the signal using LPC
% Input: 
%   es: the LPC prediction errors
%   as: the LPC coefficients, each row corresponds to a window buffer
%   xlen: length of the original signal
%   fs: sampling frequency of the orignal signal
% Output:
%   xrec: the reconstructed signal

start = 1;
winlen = round(fs*30/1000); % size of the window
overlap = round(winlen*0.5); % overlapping length
stepsize = winlen - overlap;

xrecs = zeros(xlen, 1);

for i = 1:size(as, 1)
    finish = min(start+winlen-1, xlen);

    a = as(i, :);
    e = es(:, i);
    
    if finish == xlen
        e = e(1: finish-start+1);
    end
    
    xrec = filter(1, a, e);
    xrecs(start:finish) = xrec;
    
    start = start + stepsize;
end

end

