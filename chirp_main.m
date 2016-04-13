%% ECE 6260 - Chirp Reconstruction
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

%% Create the chirp signal
cc = makeChirp(0.5,6000,100,fs);
cc = fftFilter(cc,fs,5500,6500);

%% Show some plots for comparison
figure('units','normalized','outerposition',[0 0 1 1])
subplot(2,1,2);
prettySpec(cc,fs);

subplot(2,1,1);
psdest = psd(spectrum.periodogram,x,'Fs',fs,'NFFT',length(x));
h = plot(psdest);
set(h,'Color',[0 0 1 0.08]);
hold on
psdest = psd(spectrum.periodogram,cc,'Fs',fs,'NFFT',length(cc));
h = plot(psdest);
set(h,'Color',[1 0 0 0.15]);
axis tight

%% Play the filtered chirp for 2 periods
load('signal_sections.mat');
x2 = s.chirp(1:4*fs);
player1 = audioplayer(x2,fs);
% play(player1);

% wait for it to finish playing
pause(5);

%% Play the reconstructed chirp for 5 periods
player2 = audioplayer(repmat(cc,1,5),fs);
% play(player2);
