%% ECE 6260 - Final Project
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

%% Signal Frequency Segmentation
% MLK's speech
x1 = fftfilter(x, fs, 20, 3800);

% Morse pulse
x2 = fftfilter(x, fs, 3800, 4100);

% Mid freq noise
x3 = fftfilter(x, fs, 4100, 5500);

% Chirp
x4 = fftfilter(x, fs, 5500, 6500);

% High frequency noise
x5 = x - x1 - x2 - x3 - x4;

% Reconstructed signal
xrec = x1 + x2 + x3 + x4 + x5;

%% SQNR calculation
err = x - xrec;
sqnr = 10 * log10(norm(x)^2/norm(err)^2);

%% Compare with reconstructed signal
figure('units','normalized','outerposition',[0 0 1 1])
psdest = psd(spectrum.periodogram,x,'Fs',fs,'NFFT',length(x));
h = plot(psdest);
set(h,'Color',[0 0 1 0.25]);
hold on
psdest = psd(spectrum.periodogram,xrec,'Fs',fs,'NFFT',length(xrec));
h = plot(psdest);
set(h,'Color',[1 0 0 0.075]);
axis tight
