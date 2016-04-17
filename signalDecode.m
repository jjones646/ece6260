%% ECE 6260 - Morse Decoding & Reconstruction
%  Yifei Fan & Jonathan Jones
%  April 17, 2016

function signalDecode(encodedFile, outFile)

%% Load the signal's encoded parameters from the given file
load(encodedFile);

fprintf('  decoding ''%s''\n', encodedFile);

%% Compute the chirp signal
chirp = chp(1) * makeChirp(chp(2),chp(3),chp(4),fs);
chirp = fftFilter(chirp, fs, 5500, 6500);

%% Construct the morse code beeps from a string message
morse = .8*makeMorse(msg);
% zero pad from the start of the signal, and also at the end
morse = [zeros(1,msg_i0) morse];
morse(end:xlen) = 0;
% small averaging filter
winSz = 7; b = (1/winSz)*ones(1,winSz);
morse = filter(b,1,morse);
morse = fftFilter(morse, fs, 3800, 4100);

%% Generate background noise using the given dist
noise = 2.2*normrnd(pd(1),pd(2),1,xlen);
noise = highpassNoiseFilter(noise);

%% Get the compressed speech
run('speech_decode.m');
% can use 'speech' variable after speech_decode.m is called

%% Fixup array lengths
% remap the chirp periods to the length of our signal
chirpPeriods = ceil(xlen/length(chirp));
chirp = repmat(chirp,1,chirpPeriods);
chirp = chirp(1:xlen);
% fixup generate morse code signal length
diffInd = abs(xlen-length(morse));
morse(end+1:end+diffInd) = 0;

%% Construct the signal from all pieces
reconstructed = chirp + noise + morse + speech;

%% Write out the decoded signal
audiowrite(outFile, reconstructed, fs);

end