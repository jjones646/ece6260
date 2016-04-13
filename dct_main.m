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
xlen = length(x);

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
% err = x - xrec;
% sqnr = 10 * log10(norm(x)^2/norm(err)^2);
% 
 %% Compare with reconstructed signal
% figure('units','normalized','outerposition',[0 0 1 1])
% psdest = psd(spectrum.periodogram,x,'Fs',fs,'NFFT',length(x));
% h = plot(psdest);
% set(h,'Color',[0 0 1 0.25]);
% hold on
% psdest = psd(spectrum.periodogram,xrec,'Fs',fs,'NFFT',length(xrec));
% h = plot(psdest);
% set(h,'Color',[1 0 0 0.075]);
% axis tight

%% MLK's speech: x1
% Down sampling
dsrate = 3; % down sampling rate
x11 = decimate(x1, dsrate); % down sampled signal

%% Encoding and Decoding
% Method 1: Discrete Cosine Transform Compression
cR = 0.2; % required compression ratio
win = 0.25; % window size in second
[DCTcoeffs, INDcoeffs] = dctCompress(x11, win, fs/dsrate, cR);
DCTcoeffs = single(DCTcoeffs); INDcoeffs = uint16(INDcoeffs);
save('1.mat', 'DCTcoeffs', 'INDcoeffs');
% Inverse Discrete Cosine Transform Decompression
x13 = dctDecompress(DCTcoeffs, INDcoeffs, win, fs/dsrate);

% % Method 2: mu-law or a-law
% x12 = uint8(lin2pcmu(x11));
% x13 = pcmu2lin(double(x12));
% 
% x12 = uint8(lin2pcma(x11));
% x13 = pcma2lin(double(x12));

% Method 3: Lloyd Algorithm
% [idx, C] = kmeans(x11, 256);
% x12 = C(idx);
% x13 = x12;

% % Method 4: Uniform Quantizer
% x12 = uniform_quantizer(x11, 4, min(x11), max(x11)); % minimum bit rate should be 4
% x13 = x12;

%% 
x14 = interp(x13, dsrate);
if length(x14) < xlen
    x14 = [x14; zeros(xlen-length(x14),1)];
end

err = x1 - x14;
sqnr = 10 * log10(norm(x1)^2/norm(err)^2);

%% 
