%% ECE 6260 - Morse Decoding & Reconstruction
%  Yifei Fan & Jonathan Jones
%  April 17, 2016

%% Setup environment
close all; clear all; clc

% cd into the directory where this script is
cd(fileparts(mfilename('fullpath')));

% add the 'includes' directory to the path for using the filters
addpath('includes');

%% Read in the signal
[x,fs] = audioread('Signal.wav');

% filter out the morse code frequencies
xx = fftFilter(x, fs, 3800, 4100);

% downsample signal
ratio = 1;
fs = round(fs/ratio);
xx = xx(1:ratio:end);

%% Decode morse code message
[msg,yy] = deMorse(xx);

% print out the message
fprintf('Decoded Message: %s\n',msg);

%% Find out what the delay timings are like
aa = find(diff(yy)~=0);
histogram(diff(aa),150); grid on;
title('{\bfHistogram of Morse Code Transitions Timings}');
ylabel('Number of Transitions');
xlabel('Samples Until Next Transition');

%% Reconstruct the morse code beeps centered at 4kHz
figure('units','normalized','outerposition',[0 0 1 1]); % fullscreen

tt = linspace(0,length(yy)/fs,length(yy));
% sig = yy .* cos(2*pi*4000*tt');
sig = yy;

Nx = length(sig);
nsc = floor(Nx/1024);
nov = floor(nsc/1.5);
nff = max(512,2^nextpow2(nsc));

% spectrogram(sig,hamming(nsc),nov,nff,fs,'yaxis');
title('{\bfSpectrogram of Reconstructed Morse Code Beeps}');
xlabel('Time (s)');

pyy = psd(spectrum.periodogram,sig,'Fs',fs,'NFFT',length(sig));
h = plot(pyy); hold on

% regenerate the signal
morsecode = makeMorse(msg);

% show some timing stats
fprintf('Reconstructed Length: %0.2f s\n',length(morsecode)/fs);

% play the regenerated message
soundsc(morsecode,fs);
