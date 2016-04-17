%% ECE 6260 - Morse Decoding & Reconstruction
%  Yifei Fan & Jonathan Jones
%  April 17, 2016

function signalEncode(signalFile, outFile, method)

% set this so the other scripts will have it
ENCODING_METHOD = method;

%% Read in the signal
[x,fs] = audioread(signalFile);
% store fs as the first value in our parameters file
save(outFile, 'fs');

%% Create the chirp signal
% 4 parameters for chirp equation
chp = [.4 .5 6000 100];
save(outFile, 'chp', '-append');

%% Create the morse code signal
% filter & decode the morse beeps into a string
sMorse = fftFilter(x,fs,3800,4100);
[msg, msg_i0] = deMorse(sMorse);
save(outFile, 'msg', 'msg_i0', '-append');

%% Create the background noise
% sigma & mu for pdf of noise
pd = [.0163 .0325];
save(outFile, 'pd', '-append');

%% Encode the speech
% the script we call expects 'x1' to already be set
x1 = fftFilter(x,fs,20,3800)';
run('speech_encode.m');

end