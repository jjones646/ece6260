function [ yq, indices ] = feedback_quantizer( x, k, alpha )
% feedback_quantizer: Implement a feedback adaptive quantizer
% Input: 
%   x: the target signal to be quantized
%   k: bitrate
%   alpha: the leaky factor
% Output:
%   yq: the scaled quantized signal
%   the indices of the quantized signal

% Initialize
Gs = ones(size(x)); % gain
G0 = 1; 

ymax = max(x);
ymin = min(x);

sigmas = zeros(length(x), 1);
y = x(1) * ones(size(x));
indices = zeros(length(x), 1);
yq = uniform_quantizer(y(1), k, ymin, ymax) * ones(size(y));
[~, indices(1)] = uniform_quantizer(y(1), k, ymin, ymax);
for i = 2:length(x)
    sigmas(i) = sqrt(alpha * sigmas(i-1)^2 + yq(i-1)^2);
    Gs(i) = G0/sigmas(i);
    y(i) = Gs(i) * x(i);
    [yq(i), indices(i)] = uniform_quantizer(y(i), k, ymin, ymax);
end

end

