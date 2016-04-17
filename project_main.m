%% ECE 6260 - Morse Decoding & Reconstruction
%  Yifei Fan & Jonathan Jones
%  April 17, 2016

% cd into the directory where this script is
cd(fileparts(mfilename('fullpath')));

% add the 'includes' directory to the path for using the filters
addpath('includes');

%% Set encoding method to use for speech
% set the method that we will use
method = 4;

% override the encoding method if we're using the 'runall.m' script
if exist('tmp_encoding_method.mat','file') == 2
    load('tmp_encoding_method.mat','method');
end

fprintf('Running encoding & decoding steps\n');

%% Construct the encoded/decoded filenames that will be exported
fnEncoded = sprintf('Signal_encoded%u.mat', method);
fnDecoded = sprintf('Signal_decoded%u.wav', method);

%% Get and show the true signal file we're using
signalFile = which('Signal.wav');
% get the true original filesize
origBytes = subsref(dir(signalFile), substruct('.','bytes'));
fprintf('  using ''%s''\n    - %u bytes\n', signalFile, origBytes);

%% Encode the signal
% writes the reconstructed signal to the given filename
signalEncode(signalFile, fnEncoded, method);

% show size results
encodedBytes = subsref(dir(fnEncoded), substruct('.','bytes'));
compRatio = 1-encodedBytes/origBytes;
fprintf('  saved to ''%s''\n', fnEncoded);
fprintf('    - %u bytes\n', encodedBytes);
fprintf('    - %.2f%% space savings\n', compRatio*100);

%% Flush ALL memory, storing the method to disk temporarily
save('tmp_speech_method.mat', 'method');
fprintf('  == Clearing MATLAB Workspace ==\n');
clear all;

% load our method back so we can add it to the output filenames
load('tmp_speech_method.mat', 'method');
delete('tmp_speech_method.mat'); % cleanup

% reset our filenames
fnEncoded = sprintf('Signal_encoded%u.mat', method);
fnDecoded = sprintf('Signal_decoded%u.wav', method);

% now clear the method again before entering into decoding
% clear method

%% Decode the signal
% writes the reconstructed signal to the given filename
signalDecode(fnEncoded, fnDecoded);

decodedBytes = subsref(dir(fnDecoded), substruct('.','bytes'));
fprintf('  saved to ''%s''\n', fnDecoded);
fprintf('    - %u bytes\n\n', decodedBytes);

[ox,ofs] = audioread('Signal.wav');
poxx = psd(spectrum.periodogram,ox,'Fs',ofs,'NFFT',length(ox));
figure('units','normalized','outerposition',[0 0 1 1])
% original signal
h = plot(poxx); hold on;
set(h,'color',[0 0 1 .25]);
% reconstructed signal
[x,fs] = audioread(sprintf('Signal_decoded%u.wav',method));
sqnr = 10*log10(norm(x)^2/norm(ox-x)^2);
pxx = psd(spectrum.periodogram,x,'Fs',fs,'NFFT',length(x));
h = plot(pxx);
set(h,'color',[.8 0 0 .15]);
title(sprintf('Method %u (SQNR: %.2f dB)',method,sqnr));
