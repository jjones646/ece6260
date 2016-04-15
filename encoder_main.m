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
% Specify the downsampling and encoding method
dsmethod = 1; % downsampling method: 1-decimate; 2-resample
enmethod = 6; % encoding method: 1-DCT, 2-mu-law, 3-a-law, 4-Lloyd, 5-uniform quantizer, 6-feedback adaptive quantizer

% Down sampling

if dsmethod == 1
    dsrate = 3; % down sampling factor
    x11 = decimate(x1, dsrate); % down sampled signal
else
    dsfreq = 4000; % down sampling frequency
    x11 = resample(x1, dsfreq, fs);
end

% Encoder for MLK's speech (x1)
switch enmethod
    case 1
        % Method 1: Discrete Cosine Transform Compression
        cR = 0.4; % required compression ratio
        win = 0.25; % window size in second
        dsfreq = fs/dsrate; % frequency of the input
        [DCTcoeffs, INDcoeffs] = dctCompress(x11, win, dsfreq, cR);
        DCTcoeffs = single(DCTcoeffs); INDcoeffs = uint16(INDcoeffs);
        cR = single(cR); win = single(win); dsfreq = single(dsfreq);
        save('speech.mat', 'DCTcoeffs', 'INDcoeffs', 'cR', 'win', 'dsfreq');
    case 2
        % Method 2: mu-law algorithm
        x12 = uint8(lin2pcmu(x11));
        save('speech.mat', 'x12');
    case 3
        % Method 3: a-law algorithm
        x12 = uint8(lin2pcma(x11));
        save('speech.mat', 'x12');
    case 4
        % Method 4: Lloyd Algorithm
        bitrate = 3;
        [indices, C] = kmeans(x11, 2^bitrate, 'MaxIter', 1000);
        C = single(C);
        indices = indices - 1; % k-mean cluster label: from 1 to 2^bitrate
        indices_bitstream = ints2bitstream(indices, bitrate);
        [indices_bytes, indices_res] = bitstream2bytes(indices_bitstream);
        indices_res = uint8(indices_res);
        
        save('speech.mat', 'C', 'indices_bytes', 'indices_res', 'bitrate');
    case 5
        % Method 5: Uniform Quantizer
        bitrate = 4;
        bitrate = min(bitrate, 7); % the maximum bitrate is set to be 7
        
        [x12, indices] = uniform_quantizer(x11, bitrate, min(x11), max(x11)); % minimum bit rate should be 4
        
        indices_bitstream = ints2bitstream(indices, bitrate);
        [indices_bytes, indices_res] = bitstream2bytes(indices_bitstream);
        x11min = min(x11); x11max = max(x11);
        indices_res = uint8(indices_res);
               
        save('speech.mat', 'x11min', 'x11max', 'indices_bytes', 'indices_res', 'bitrate');
    case 6
        % Method 6: Feedback Adaptive Quantizer
        bitrate = 4;
        alpha = 0.99;
        [yq, indices] = feedback_quantizer(x11, bitrate, alpha);
        
        indices_bitstream = ints2bitstream(indices, bitrate);
        [indices_bytes, indices_res] = bitstream2bytes(indices_bitstream);
        x11min = min(x11); x11max = max(x11);
        save('speech.mat', 'x11min', 'x11max', 'indices_bytes', 'indices_res', 'bitrate', 'alpha');
        
    otherwise
        disp('Please specify the encoding method: enmethod = {1,2..5}');
end

%% Save all info into compressed file
dsmethod = uint8(dsmethod);
enmethod = uint8(enmethod);
stdx5 = single(std(x5));
save('speech.mat', 'enmethod', 'dsmethod', 'xlen', 'stdx5', '-append');