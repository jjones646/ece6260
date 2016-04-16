function y = highpassNoiseFilter(x)
%HIGHPASSNOISEFILTER Filters input x and returns output y.

% MATLAB Code
% Generated by MATLAB(R) 9.0 and the Signal Processing Toolbox 7.2.
% Generated on: 16-Apr-2016 18:42:23

persistent Hd;

if isempty(Hd)
    
    Fstop = 4150;   % Stopband Frequency
    Fpass = 4600;   % Passband Frequency
    Astop = 60;     % Stopband Attenuation (dB)
    Apass = 3;      % Passband Ripple (dB)
    Fs    = 16000;  % Sampling Frequency
    
    h = fdesign.highpass('fst,fp,ast,ap', Fstop, Fpass, Astop, Apass, Fs);
    
    Hd = design(h, 'kaiserwin');
    
    
    
    set(Hd,'PersistentMemory',true);
    
end

y = filter(Hd,x);

