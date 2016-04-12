function [i1,i2,dif] = chirpBounds(x)
    Y = fft(x);
    Y = Y(1:round(length(Y)/2));
    Y = Y(1:5:end);
    
    dif = diff(Y);
    dy = abs(dif);
    
    p1 = find(dy==max(dy));
    dy(p1) = min(dy);
    p2 = find(dy==max(dy));
    
    i1 = min([p1,p2]);
    i2 = max([p1,p2]);
end