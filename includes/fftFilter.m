function [y] = fftFilter(x, Fs, flb, fub)
% fftFilter: An FFT filter, same as Adobe Audition's FFT filter
% Input:
%   x: the orignal to be filtered
%   Fs: the sampling frequency
%   flb: lower bound of frequency
%   fub: upper bound of frequency
% Output:
%   y: the filtered signal

    flb = max(0, flb);
    fub = min(Fs/2, fub);
    X = fft(x);
    X = [X; X(1)]; % Add a padding at the last which corresponds to negtive 0 freq
    f = Fs/length(x) * (0:length(x)-1);

    mididx = length(x)/2 + 1; % mid-point index

    indices = find(f > flb & f < fub); % Pass band indices
    indices = [indices; 2*mididx - indices]; % Add the indices of negative frequency

    muteindices = setdiff((1:length(x)+1), indices); % Filtered band indices
    X(muteindices) = 0; % mute the filtered band
    X = X(1:end-1); % throw the padding

    y = ifft(X); % Take the inverse transform
end

