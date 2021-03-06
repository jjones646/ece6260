%% ECE 6260 - Encode parameters from the speech portion of the signal
%  Yifei Fan & Jonathan Jones
%  April 17, 2016
%
% === MLK's speech should be: 'x1' ===

%% Specify the downsampling and encoding method
enmethod = ENCODING_METHOD; % encoding method: 1-DCT, 2-mu-law, 3-a-law, 4-Lloyd, 5-uniform quantizer, 6-feedback adaptive quantizer

% store length
xlen = numel(x1);

% down sample
x11 = decimate(x1,3);

%% Encoder for MLK's speech
switch enmethod
    case 1
        %% Method 1: Discrete Cosine Transform Compression
        cR = 0.4; % required compression ratio
        win = 0.25; % window size in second
        dsfreq = fs/3; % frequency of the input
        [DCTcoeffs, INDcoeffs] = dctCompress(x11', win, dsfreq, cR);
        DCTcoeffs = single(DCTcoeffs); INDcoeffs = uint16(INDcoeffs);
        cR = single(cR); win = single(win); dsfreq = single(dsfreq);
        
        save(outFile, 'DCTcoeffs', 'INDcoeffs', 'cR', 'win', 'dsfreq', '-append');
    case 2
        %% Method 2: mu-law algorithm
        x12 = uint8(lin2pcmu(x11));
        
        save(outFile, 'x12', '-append');
    case 3
        %% Method 3: a-law algorithm
        x12 = uint8(lin2pcma(x11));
        
        save(outFile, 'x12', '-append');
    case 4
        %% Method 4: Lloyd Algorithm
        bitrate = 3;
        [indices, C] = kmeans(x11', 2^bitrate, 'MaxIter', 1000);
        C = single(C);
        indices = indices - 1; % k-mean cluster label: from 1 to 2^bitrate
        
        save(outFile, 'C', 'indices', 'bitrate', '-append');
    case 5
        %% Method 5: Uniform Quantizer
        bitrate = 3;
        bitrate = min(bitrate, 7); % the maximum bitrate is set to be 7
        [x12, indices] = uniform_quantizer(x11, bitrate, min(x11), max(x11)); % minimum bit rate should be 4
        x11m = [min(x11) max(x11)];
        
        save(outFile, 'x11m', 'indices', 'bitrate', '-append');
    case 6
        %% Method 6: Feedback Adaptive Quantizer
        bitrate = 4;
        alpha = 0.99;
        [yq, indices] = feedback_quantizer(x11, bitrate, alpha);
        x11m = [min(x11) max(x11)];
        
        save(outFile, 'x11m', 'indices', 'bitrate', 'alpha', '-append');
    case 7
        %% Method 7: LPC
        p = 10; % prediction order
        [ es, as ] = lpc_analysis(x11', fs, p);
        % Quantization for error signal
        rate = 3;
        es = uniform_quantizer(es, rate, min(es(:)), max(es(:)));
        as = single(as); p = uint8(p);
        x11len = length(x11);
        
        save(outFile, 'es', 'as', 'p', 'x11len', '-append');
    otherwise
        error('Please specify the encoding method: enmethod = {1,2..7}');
end

%% Save additional info to the mat file
enmethod = uint8(enmethod);
save(outFile, 'enmethod', 'xlen', '-append');
