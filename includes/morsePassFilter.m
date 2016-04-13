function y = morsePassFilter(x)
%MORSEPASSFILTER Filters input x and returns output y.

% MATLAB Code
% Generated by MATLAB(R) 8.5 and the DSP System Toolbox 9.0.
% Generated on: 13-Apr-2016 08:41:32

persistent Hd;

if isempty(Hd)
    
    N  = 2;         % Order
    F0 = 4000;   % Center frequency
    Q  = 100;       % Q-factor
    Fs = 16000;  % Sampling Frequency
    
    h = fdesign.peak('N,F0,Q', N, F0, Q, Fs);
    
    Hd = design(h, 'butter', ...
        'SOSScaleNorm', 'Linf');
    
    
    
    set(Hd,'PersistentMemory',true);
    
end

y = filter(Hd,x);


