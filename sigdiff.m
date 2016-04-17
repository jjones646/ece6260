clear all; close all; clc;

% [dx,dfs] = audioread('decoded_signal6.wav');
[dx,dfs] = audioread('decoded_signal5.wav');
pyy = psd(spectrum.periodogram,dx,'Fs',dfs,'NFFT',length(dx));
h = plot(pyy);
set(h,'color',[1 0 0 .15]);

[ox,ofs] = audioread('Signal.wav');
pxx = psd(spectrum.periodogram,ox,'Fs',ofs,'NFFT',length(ox));
hold on
h = plot(pxx);
set(h,'color',[1 0 1 .1]);
