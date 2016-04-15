clear all;
%% Read the compressed file
load speech.mat;
dsrate = 3; fs = 16000; dsfreq = 4000;
%% Dncoder for MLK's speech (x1)
switch enmethod
    case 1
        % Method 1: Discrete Cosine Transform Compression
        x13 = dctDecompress(DCTcoeffs, INDcoeffs, win, dsfreq);
    case 2
        % Method 2: mu-law algorithm
        x13 = pcmu2lin(double(x12));
    case 3
        % Method 3: a-law algorithm
        x13 = pcma2lin(double(x12));
    case 4
        % Method 4: Lloyd Algorithm
        indices_bitstream = bytes2bitstream(indices_bytes, indices_res);
        indices = bitstream2ints(indices_bitstream, bitrate) + 1; % index start from 1
        x12 = C(indices);
        x13 = double(x12);
    case 5
        % Method 5: Uniform Quantizer
        indices_bitstream = bytes2bitstream(indices_bytes, indices_res);
        indices = bitstream2ints(indices_bitstream, bitrate);
        
        x13 = x11min + (x11max-x11min)/(2^bitrate)*(0.5+indices);
        x13 = double(x13);
    case 6
        % Method 6: Feedback Adaptive Quantizer
        indices_bitstream = bytes2bitstream(indices_bytes, indices_res);
        indices = bitstream2ints(indices_bitstream, bitrate);
        G0 = 1;
        Gs = ones(size(indices));
        sigmas = zeros(size(indices));
        indices = double(indices);
        yq = x11min + (x11max-x11min)/(2^bitrate)*(0.5+indices);
        x13 = yq(1) * ones(size(indices));        
        for i = 2:length(indices)
            sigmas(i) = sqrt(alpha * sigmas(i-1)^2 + yq(i-1)^2);
            Gs(i) = G0/sigmas(i);
            x13(i) = yq(i)/Gs(i);
        end
    otherwise
        disp('Please specify the encoding method: enmethod = {1,2..5}');
end

if dsmethod == 1
    x14 = interp(x13, dsrate);
else
    x14 = resample(x13, fs, dsfreq);
end

%% Decoder for 


%% Decoder for x5
x55 = 4 * stdx5 * randn(xlen, 1);
x55 = fftfilter(x55, fs, 6500, 8000);

%% Calculate SQNR 
[x1, fs] = audioread('speech.wav');
xlen = length(x1);
if length(x14) < xlen
    x14 = [x14; zeros(xlen-length(x14),1)];
end
if length(x14) > xlen
    x14 = x14(1:xlen);
end

err = x1 - x14;
sqnr = 10 * log10(norm(x1)^2/norm(err)^2);

