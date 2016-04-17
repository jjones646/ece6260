%% ECE 6260 - Morse Decoding & Reconstruction
%  Yifei Fan & Jonathan Jones
%  April 17, 2016

%% Setup environment
close all; clear all; clc;

% cd into the directory where this script is
cd(fileparts(mfilename('fullpath')));

% add the 'includes' directory to the path for using the filters
addpath('includes');

%% Set encoding method to use for speech
% Encoding Methods:
%   1 = DCT
%   2 = mu-law
%   3 = a-law
%   4 = Lloyd
%   5 = uniform quantizer
%   6 = feedback adaptive quantizer
method = 5;

% override the encoding method if we're using the 'runall.m' script
if exist('tmp_encoding_method.mat','file') == 2
    load('tmp_encoding_method.mat','method');
end

%% Construct the encoded/decoded filenames that will be exported
fnEncoded = sprintf('Signal_encoded%u.mat', method);
fnDecoded = sprintf('Signal_decoded%u.wav', method);

%% Encode the signal
% writes the reconstructed signal to the given filename
signalEncode('Signal.wav', fnEncoded, method);

%% Flush ALL memory, storing the method to disk temporarily
save('tmp_speech_method.mat', 'method');

clear all; % clear all matlab variables

% load our method back so we can add it to the filenames
load('tmp_speech_method.mat', 'method');
delete('tmp_speech_method.mat'); % cleanup

% reset our filenames
fnEncoded = sprintf('Signal_encoded%u.mat', method);
fnDecoded = sprintf('Signal_decoded%u.wav', method);

% now clear the method again before entering into decoding
clear method

%% Decode the signal
% writes the reconstructed signal to the given filename
signalDecode(fnEncoded, fnDecoded);
