%% ECE 6260 - Morse Decoding & Reconstruction Testbench
%  Yifei Fan & Jonathan Jones
%  April 17, 2016

%% Setup environment
close all; clear all; clc;

% cd into the directory where this script is
cd(fileparts(mfilename('fullpath')));

% add the 'includes' directory to the path for using the filters
addpath('includes');

%% Read in the signal
[x,fs] = audioread('Signal.wav');

%% Create the chirp signal
chirp = makeChirp(0.5,6000,100,fs);
chirp = fftFilter(chirp,fs,5675,6325);

%% Create the morse code signal
sMorse = fftFilter(x, fs, 3800, 4100);
msg = deMorse(sMorse);
morse = morsePassFilter(makeMorse(msg));
morse = 0.4*morsePassFilter2(morse);

%% Create the background noise
load('noise_model.mat');
noise = normrnd(pd.mu,pd.sigma,1,length(x));
noise = 2.2*highpassNoiseFilter(noise);

%% Get the compressed speech
speech = fftFilter(x,fs,0,3800);
speech = speech';

%% Fixup array lengths
chirpPeriods = ceil(length(x)/length(chirp));
chirp = repmat(chirp,1,chirpPeriods);
chirp = chirp(1:length(x));
chirp = 0.4*chirp;

diffInd = abs(length(x)-length(morse));
morse(end+1:end+diffInd) = 0;

%% Construct the top half of the signal
aio = chirp + noise + morse + speech;

%% Show the power spectrum
figure('units','normalized','outerposition',[0 0 1 1]); % fullscreen

pxx = psd(spectrum.periodogram,x,'Fs',fs,'NFFT',length(x));
subplot(3,2,[1 2]);
h = plot(pxx); hold on;
set(h,'Color',[0 0 1 .25]);

% show the power spectrum of each filtered section
pxx = psd(spectrum.periodogram,chirp,'Fs',fs,'NFFT',length(chirp));
h = plot(pxx);
set(h,'Color',[.8 0 0 .15]);
pxx = psd(spectrum.periodogram,noise,'Fs',fs,'NFFT',length(noise));
h = plot(pxx);
set(h,'Color',[0 .8 0 .15]);
pxx = psd(spectrum.periodogram,morse,'Fs',fs,'NFFT',length(morse));
h = plot(pxx);
set(h,'Color',[1 .75 0 .15]);
pxx = psd(spectrum.periodogram,speech,'Fs',fs,'NFFT',length(speech));
h = plot(pxx);
set(h,'Color',[1 0 1 .15]);

pxx = psd(spectrum.periodogram,x,'Fs',fs,'NFFT',length(x));
subplot(3,2,[3 4]);
h = plot(pxx); hold on
set(h,'Color',[0 0 1 .25]);
% set the subplot's title
subt = get(gca,'Title');
subt.String = 'Power Spectral Density of Reconstructed Signal';
set(gca,'Title',subt);
pxx = psd(spectrum.periodogram,aio,'Fs',fs,'NFFT',length(aio));
h = plot(pxx); hold on
set(h,'Color',[0 1 1 .15]);
legend('Original Signal','Reconstructed Signal');

subplot(3,2,5)
Nx = length(x);
nsc = floor(Nx/1024);
nov = floor(nsc/2);
nff = max(256,2^nextpow2(nsc));
spectrogram(x,hamming(nsc),nov,nff,fs,'yaxis');
title('Spectrogram of Original Signal');

subplot(3,2,6);
Nx = length(aio);
nsc = floor(Nx/1024);
nov = floor(nsc/2);
nff = max(256,2^nextpow2(nsc));
spectrogram(aio,hamming(nsc),nov,nff,fs,'yaxis');
title('Spectrogram of Reconstructed Signal');

%% Play the regenerated message
player = audioplayer(aio,fs);
play(player);
% stop(player);
