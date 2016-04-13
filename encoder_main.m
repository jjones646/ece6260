%% ECE 6260 - Final Project
%  Yifei Fan & Jonathan Jones
%  April 17, 2016

%% Setup environment
close all; clc;
% clear all;

% cd into the directory where this script is
cd(fileparts(mfilename('fullpath')));

% add the 'includes' directory to the path for using the filters
addpath('includes');

%% Read in the signal
[x,fs] = audioread('Signal.wav');

%% Signal Frequency Segmentation
% MLK's speech
x1 = fftFilter(x, fs, 0, 3800);

% Morse pulse
x2 = fftFilter(x, fs, 3800, 4100);

% Mid freq noise
x3 = fftFilter(x, fs, 4100, 5500);

% Chirp
x4 = fftFilter(x, fs, 5500, 6500);

% High frequency noise
x5 = x - x1 - x2 - x3 - x4;

% Reconstructed signal
xrec = x1 + x2 + x3 + x4 + x5;

%% SQNR calculation
err = x - xrec;
clearvars xrec % don't keep this in memory
sqnr = 10 * log10(norm(x)^2/norm(err)^2);

% display the SQNR in the console
fprintf('SQNR:\t%0.3f dB\n',sqnr);

%% Save the filtered sections as a struct variable
s.speech = x1;
s.morse = x2;
s.midNoise = x3;
s.chirp = x4;
s.highNoise = x5;
orig = x;
% save to file
save('signal_sections.mat','s','orig','fs');

%% Compare with reconstructed signal
figure('units','normalized','outerposition',[0 0 1 1]); % fullscreen

% show the original signal's power spectrum in its own subplot
pxx = psd(spectrum.periodogram,x,'Fs',fs,'NFFT',length(x));
subplot(2,1,1);
h = plot(pxx); axis tight
set(h,'Color',[0 0 1 .25]);
% set the top subplot's title
subt = get(gca,'Title');
subt.String = 'Power Spectral Density of Original Signal';
set(gca,'Title',subt);
% add a legend to the top subplot
legend('Original Signal');
% get the y axis limits for the top subplot so we can make both
% subplot axes equal
y_limits = get(gca,'ylim');

% show the power spectrum of each filtered section in a different subplot
pxx = psd(spectrum.periodogram,x1,'Fs',fs,'NFFT',length(x1));
subplot(2,1,2);
h = plot(pxx); hold on
set(h,'Color',[.8 0 0 1]);
pxx = psd(spectrum.periodogram,x2,'Fs',fs,'NFFT',length(x2));
h = plot(pxx);
set(h,'Color',[0 .8 0 1]);
pxx = psd(spectrum.periodogram,x3,'Fs',fs,'NFFT',length(x3));
h = plot(pxx);
set(h,'Color',[.5 0 .5 1]);
pxx = psd(spectrum.periodogram,x4,'Fs',fs,'NFFT',length(x4));
h = plot(pxx);
set(h,'Color',[0 .8 .8 1]);
pxx = psd(spectrum.periodogram,x5,'Fs',fs,'NFFT',length(x5));
h = plot(pxx);
set(h,'Color',[1 .75 0 1]);
% set the bottom subplot's title
subt = get(gca,'Title');
sqnrString = sprintf('SQNR: %0.1f dB',sqnr);
subt.String = ['Power Spectral Density of Filtered Sections (' sqnrString ')'];
set(gca,'Title',subt);
% add a legend to the bottom subplot
legend('Speech','Moorse Code','Mid Freq. Noise','Chirp','High Freq. Noise');
set(gca,'ylim',y_limits);

figure
Nx = length(x);
nsc = floor(Nx/1024);
nov = floor(nsc/2);
nff = max(256,2^nextpow2(nsc));
spectrogram(x,hamming(nsc),nov,nff,fs,'yaxis');
