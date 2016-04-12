function y = makeChirp(freqCarrier,freqCenter,span,fs)
    if nargin < 4
        fs = 16000;
    end
    valFn = @(x) isnumeric(x)&&isscalar(x)&&(x>0);
  
    ip = inputParser;
    ip.FunctionName = 'MAKECHIRP';
    ip.addRequired('freqCarrier',@isnumeric);
    ip.addRequired('freqCenter',@isnumeric);
    ip.addRequired('span',@isnumeric);
    ip.addOptional('fs',fs,valFn);
    ip.parse(freqCarrier,freqCenter,span,fs);
    
    tf = 1/ip.Results.freqCarrier;
    tt = 0:1/ip.Results.fs:2*tf; % time vector
    xtal = ip.Results.span*cos(2*pi*ip.Results.freqCarrier*tt);
    theta = 2*pi*(ip.Results.freqCenter*tt + xtal);
    y = cos(theta); % the last component in equation
end