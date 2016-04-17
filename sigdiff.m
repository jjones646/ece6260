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
    % original signal
    h = plot(poxx); hold on;
    set(h,'color',[0 0 1 .25]);
    % reconstructed signal
    [x,fs] = audioread(sprintf('Signal_decoded%u.wav',method));
    sqnr = 10*log10(norm(x)^2/norm(ox-x)^2);
    pxx = psd(spectrum.periodogram,x,'Fs',fs,'NFFT',length(x));
    h = plot(pxx);
    set(h,'color',[.8 0 0 .15]);
    title(sprintf('%s (SQNR: %.2f dB)',METHODS{method},sqnr));
end
