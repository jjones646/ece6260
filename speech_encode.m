%% ECE 6260 - Encode parameters from the speech portion of the signal
%  Yifei Fan & Jonathan Jones
%  April 17, 2016
%
% ** MLK's speech should be: 'x1' **

%% Specify the downsampling and encoding method
dsmethod = 1; % downsampling method: 1-decimate; 2-resample
enmethod = 5; % encoding method: 1-DCT, 2-mu-law, 3-a-law, 4-Lloyd, 5-uniform quantizer, 6-feedback adaptive quantizer

xlen = numel(x1);

% Down sampling
if dsmethod == 1
    dsrate = 3; % down sampling factor
    x11 = decimate(x1, dsrate); % down sampled signal
else
    dsfreq = 4000; % down sampling frequency
    x11 = resample(x1, dsfreq, fs);
end

%% Encoder for MLK's speech
switch enmethod
    case 1
        %% Method 1: Discrete Cosine Transform Compression
        cR = 0.4; % required compression ratio
        win = 0.25; % window size in second
        dsfreq = fs/dsrate; % frequency of the input
        [DCTcoeffs, INDcoeffs] = dctCompress(x11, win, dsfreq, cR);
        DCTcoeffs = single(DCTcoeffs); INDcoeffs = uint16(INDcoeffs);
        cR = single(cR); win = single(win); dsfreq = single(dsfreq);
        
        save('speech_parameters.mat', 'DCTcoeffs', 'INDcoeffs', 'cR', 'win', 'dsfreq');
    case 2
        %% Method 2: mu-law algorithm
        x12 = uint8(lin2pcmu(x11));
        
        save('speech_parameters.mat', 'x12');
    case 3
        %% Method 3: a-law algorithm
        x12 = uint8(lin2pcma(x11));
        
        save('speech_parameters.mat', 'x12');
    case 4
        %% Method 4: Lloyd Algorithm
        bitrate = 3;
        [indices, C] = kmeans(x11, 2^bitrate, 'MaxIter', 1000);
        C = single(C);
        indices = indices - 1; % k-mean cluster label: from 1 to 2^bitrate
        indices_bitstream = ints2bitstream(indices, bitrate);
        [indices_bytes, indices_res] = bitstream2bytes(indices_bitstream);
        indices_res = uint8(indices_res);
        
        save('speech_parameters.mat', 'C', 'indices_bytes', 'indices_res', 'bitrate');
    case 5
        %% Method 5: Uniform Quantizer
        bitrate = 4;
        bitrate = min(bitrate, 7); % the maximum bitrate is set to be 7
        
        [x12, indices] = uniform_quantizer(x11, bitrate, min(x11), max(x11)); % minimum bit rate should be 4
        
        indices_bitstream = ints2bitstream(indices, bitrate);
        [indices_bytes, indices_res] = bitstream2bytes(indices_bitstream);
        x11min = min(x11); x11max = max(x11);
        indices_res = uint8(indices_res);
               
        save('speech_parameters.mat', 'x11min', 'x11max', 'indices_bytes', 'indices_res', 'bitrate');
    case 6
        %% Method 6: Feedback Adaptive Quantizer
        bitrate = 4;
        alpha = 0.99;
        [yq, indices] = feedback_quantizer(x11, bitrate, alpha);
        
        indices_bitstream = ints2bitstream(indices, bitrate);
        [indices_bytes, indices_res] = bitstream2bytes(indices_bitstream);
        x11min = min(x11); x11max = max(x11);
        save('speech_parameters.mat', 'x11min', 'x11max', 'indices_bytes', 'indices_res', 'bitrate', 'alpha');
        
    otherwise
        disp('Please specify the encoding method: enmethod = {1,2..5}');
end

%% Save additional info to the mat file
dsmethod = uint8(dsmethod); enmethod = uint8(enmethod);
save('speech_parameters.mat', 'enmethod', 'dsmethod', 'xlen', '-append');