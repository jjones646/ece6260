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
chirp = 0.4*makeChirp(0.5,6000,100,fs);
chirp = fftFilter(chirp, fs, 5500, 6500);

%% Create the morse code signal
sMorse = fftFilter(x,fs,3800,4100);
[msg,i0] = deMorse(sMorse); % ascii string message & starting sample
morse = makeMorse(msg);
% zero pad from the start of the signal, and also at the end
morse = [zeros(1,i0) morse];
morse(end:length(sMorse)) = 0;
winSz = 7;
b = (1/winSz)*ones(1,winSz);
morse = filter(b,1,morse);
morse = fftFilter(morse, fs, 3800, 4100);

%% Create the background noise
load('noise_model.mat');
save('signal_encoded.mat', 'pd');
noise = 2.2*normrnd(pd(1),pd(2),1,length(x));
noise = highpassNoiseFilter(noise);

%% Get the compressed speech
x1 = fftFilter(x,fs,20,3800)';
run('speech_encode.m');
run('speech_decode.m');
% can use 'speech' after speech_decode.m is called

%% Fixup array lengths
chirpPeriods = ceil(length(x)/length(chirp));
chirp = repmat(chirp,1,chirpPeriods);
chirp = chirp(1:length(x));
diffInd = abs(length(x)-length(morse));
morse(end+1:end+diffInd) = 0;

%% Construct the top half of the signal
reconstructed = chirp + noise + morse + speech;

%% Write out the decoded signal
outfile = sprintf('decoded_signal%u.wav', enmethod);
audiowrite(outfile, reconstructed, fs);
