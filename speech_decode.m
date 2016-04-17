%% ECE 6260 - Decode the speech portion of the signal from the encoded parameters
%  Yifei Fan & Jonathan Jones
%  April 17, 2016

%% Decoder for MLK's speech
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
        x13 = double(C(indices+1));
    case 5
        % Method 5: Uniform Quantizer
        x13 = x11m(1) + (x11m(2)-x11m(1))/(2^bitrate)*(0.5+indices);
        x13 = double(x13);
    case 6
        % Method 6: Feedback Adaptive Quantizer
        G0 = 1;
        Gs = ones(size(indices));
        sigmas = zeros(size(indices));
        yq = x11m(1) + (x11m(2)-x11m(1))/(2^bitrate)*(0.5+indices);
        x13 = yq(1) * ones(size(indices));
        for i = 2:length(indices)
            sigmas(i) = sqrt(alpha * sigmas(i-1)^2 + yq(i-1)^2);
            Gs(i) = G0/sigmas(i);
            x13(i) = yq(i)/Gs(i);
        end
    case 7
        % Method 7: LPC
        x13 = lpc_reconstruct(es, as, x11len, fs);
    otherwise
        error('Please specify the encoding method: enmethod = {1,2..7}');
end

x14 = interp(x13, 3);

% add/remove zero padding if needed
if length(x14) < xlen
    x14 = [x14; zeros(xlen-length(x14),1)];
elseif length(x14) > xlen
    x14 = x14(1:xlen);
end

% take transpose if needed
speech = x14;
if size(x14,1) > 1
    speech = x14';
end
