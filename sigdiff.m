%% ECE 6260 - Run all speech encoding/decoding methods
%  Yifei Fan & Jonathan Jones
%  April 17, 2016

clear all; close all; clc; warning off;

% make sure files are written
run('runall.m');

% method names dictionary
METHODS = {'DCT', 'μ-law', 'A-law', 'Lloyd''s algorithm', 'Uniform Quantizer',...
    'Adaptive Quantization', 'LPC'};

% original signal
[ox,ofs] = audioread('Signal.wav');
poxx = psd(spectrum.periodogram,ox,'Fs',ofs,'NFFT',length(ox));

% make fullscreen figure
figure('units','normalized','outerposition',[0 0 1 1])

%% Iterate over all methods, plotting each one
for method=1:7
    subplot(2,4,method);
    % original power density
    h = plot(poxx);
    set(h,'color',[0 0 1 .25]);
    hold on;
    % reconstructed power density
    [x,fs] = audioread(sprintf('Signal_decoded%u.wav',method));
    pxx = psd(spectrum.periodogram,x,'Fs',fs,'NFFT',length(x));
    h = plot(pxx);
    set(h,'color',[.8 0 0 .08]);
    title(METHODS{method});
end
