function y = morsePassFilter2(x)
%MORSEPASSFILTER2 Filters input x and returns output y.

% MATLAB Code
% Generated by MATLAB(R) 8.5 and the DSP System Toolbox 9.0.
% Generated on: 13-Apr-2016 08:50:39

persistent Hd;

if isempty(Hd)
    
    N     = 8;     % Order
    F0    = 4000;   % Center frequency
    BW    = 500;    % Bandwidth
    Apass = 3;      % Passband Ripple (dB)
    Fs    = 16000;  % Sampling Frequency
    
    h = fdesign.peak('N,F0,BW,Ap', N, F0, BW, Apass, Fs);
    
    Hd = design(h, 'cheby1', ...
        'SOSScaleNorm', 'Linf');
    
    
    
    set(Hd,'PersistentMemory',true);
    
end

y = filter(Hd,x);

