%% ECE 6260 - Morse Decoding & Reconstruction
%  Yifei Fan & Jonathan Jones
%  April 17, 2016

%% Setup environment
close all; clear all; clc;

% cd into the directory where this script is
cd(fileparts(mfilename('fullpath')));

% add the 'includes' directory to the path for using the filters
addpath('includes');

%% Manually set encoding method here
% Encoding Methods:
%   1 = DCT
%   2 = mu-law
%   3 = a-law
%   4 = Lloyd
%   5 = uniform quantizer
%   6 = feedback adaptive quantizer
ENCODING_METHOD = 5;
%
% override the encoding method if we're using the 'runall.m' script
if exist('tmp_encoding_method.mat','file') == 2
    load('tmp_encoding_method.mat','ENCODING_METHOD');
end
sigFn = sprintf('Signal_encoded%u.mat', ENCODING_METHOD);

%% Read in the signal
[x,fs] = audioread('Signal.wav');

%% Create the chirp signal
% Encoding
chp.a = .4;
chp.v = [.5 6000 100];
save(sigFn, 'chp');

% Decode
% load(sigFn, 'chp');
% compute the chirp signal
chirp = chp.a*makeChirp(chp.v(1),chp.v(2),chp.v(3),fs);
chirp = fftFilter(chirp, fs, 5500, 6500);

%% Create the morse code signal
% Encoding
sMorse = fftFilter(x,fs,3800,4100);
[msg, msg_i0] = deMorse(sMorse); % ascii string message & starting sample
save(sigFn, 'msg', 'msg_i0', '-append');

% Decoding
% load(sigFn, 'msg');
morse = .8*makeMorse(msg);
% zero pad from the start of the signal, and also at the end
morse = [zeros(1,msg_i0) morse];
morse(end:length(sMorse)) = 0;
winSz = 7; b = (1/winSz)*ones(1,winSz);
morse = filter(b,1,morse);
morse = fftFilter(morse, fs, 3800, 4100);

%% Create the background noise
% Encoding
pd = [.0163 .0325];
save(sigFn, 'pd', '-append');

% Decoding
% load(sigFn, 'pd');
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
outfile = sprintf('Signal_decoded%u.wav', ENCODING_METHOD);
audiowrite(outfile, reconstructed, fs);
