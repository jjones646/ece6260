function [ es, as ] = lpc_analysis( x, fs, p )
% lpc_analysis: lpc analysis
% Input: 
%   x: the input signal
%   fs: the frequency of the input signal
% Output:
%   es: the error signals
%   as: the autocorrelation coefficients

% Initialize
xlen = length(x);
winlen = round(fs*30/1000); % length of the window 30 msec
overlap = round(winlen * 0.5); % overlap length
stepsize = winlen - overlap; % step size

as = []; es = [];
start = 1;

while start < xlen
    finish = min(start+winlen-1, xlen);
    % hamming window
    buf = x(start:finish) .* hamming(finish-start+1);
    % calculation of the autocorrelation terms
    a = lpc(buf, p);
    
    as = [as; a]; % row vectors
    % Inverse filter the speech signal to obtain the prediction error
    % signal e[n]
    e = filter(a, 1, buf);
    
    if length(e) < winlen
        res = winlen - length(e);
        e = [e; zeros(res, 1)];
    end
    
    es = [es, e]; % column vectors    
    
    start = start + stepsize;
    if finish == xlen
        break;
    end
end

