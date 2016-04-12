function prettySpec(x,fs)
    if nargin < 2
        fs = 16000;
    end
    valFn = @(x) isnumeric(x)&&isscalar(x)&&(x>0);
    
    ip = inputParser;
    ip.FunctionName = 'PRETTYSPEC';
    
    ip.addRequired('x',@isnumeric);
    ip.addOptional('fs',fs,valFn);
    ip.parse(x,fs);
    
    spectrogram(x,512,384,[],fs,'yaxis');
    colorbar
    title('{\bfSpectrogram}');
    xlabel('Time (s)');
end