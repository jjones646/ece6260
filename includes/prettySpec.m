function prettySpec(x,fs)
    if nargin < 2
        fs = 16000;
    end
    valFn = @(x) isnumeric(x)&&isscalar(x)&&(x>0);
    valFn2 = @(x) isnumeric(x)||islogical(x);
    
    ip = inputParser;
    ip.FunctionName = 'PRETTYSPEC';
    
    ip.addRequired('x',valFn2);
    ip.addOptional('fs',fs,valFn);
    ip.parse(x,fs);
    
    spectrogram(double(ip.Results.x),512,384,[],ip.Results.fs,'yaxis');
    colorbar
    title('{\bfSpectrogram}');
    xlabel('Time (s)');
end