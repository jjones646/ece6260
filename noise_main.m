%% ECE 6260 - Noise Modeling
%  Yifei Fan & Jonathan Jones
%  April 17, 2016

%% Setup environment
close all; clc;
% clear all;

% cd into the directory where this script is
cd(fileparts(mfilename('fullpath')));

% add the 'includes' directory to the path for using the filters
addpath('includes');

%% Read in and filter the signal
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

%% Characterize the background noise
figure('units','normalized','outerposition',[0 0 1 1]); % fullscreen

subplot(2,1,1);
histfit(x3); grid on;
subplot(2,1,2);
histfit(x5); grid on;

% interactive GUI tools
% dfittool(x3);
dfittool(x5);
load('noise_model.mat');

noise = normrnd(pd.mu,pd.sigma,1,length(x));
noise = highpassNoiseFilter(noise);
pxx = psd(spectrum.periodogram,noise,'Fs',fs,'NFFT',length(noise));
h = plot(pxx); hold on
