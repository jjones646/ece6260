function [message,Y] = deMorse(x,varargin)
% Decode a given morse code audio signal.
    
    visOn = 0;
    if nargin < 2
        threshold = .025;
    else
        threshold = varargin{1};
    end
    
    x = abs(x); % half-wave rectify x
    y = filter(ones(1,30)/30,1,x); % slow-wave filter
    
    % threshold the limits for digital representation
    X = y > threshold;
    
    % the vector that we return back
    %Y = mat2gray(y);
    Y = mat2gray(X);
    
    if visOn
       figure('units','normalized','outerposition',[0 0 1 1]); % fullscreen
       % top subplot
       subplot(3,1,1);
       plot(x,'r');
       title('Original Signal');
       grid on, axis tight, hold on
       % middle subplot
       subplot(3,1,2);
       plot(y);
       title('HWR + Slow-wave Filter');
       grid on, axis tight, hold on
       % bottom subplot
       subplot(3,1,3);
       title('Digitized Morse Signal');
       grid on, axis tight, hold on     
       area(X);
       % fixup axis on bottom subplot
       y_limits = get(gca,'ylim');
       y_limits = [0,(1.08*y_limits(2))];
       set(gca,'ylim',y_limits);
    end

    % zero pad z so we always start with an onset
    X = [zeros(10,1); X];

    % 1: change from 1 to 0
    % 0: no change
    % -1: change from 0 to 1
    b = diff(X);
    c_i = find(b~=0);
    c = b(c_i);
    
    if ~numel(c)
        [message,Y] = deMorse(x, abs(threshold-0.0075));
        return
    end
    
    tokens = -c .* diff([0; c_i]);
    % value == length of token
    % sign == tone/space
    
    % cutoff tones, cutoff spaces;
    cut_t = mean(tokens(tokens>0));
    cut_s = mean(tokens(tokens<0));

    % set the tokens for the tones in the signal
    hh1 = (find(tokens > 0 & tokens < cut_t));
    hh2 = (find(tokens > 0 & tokens > cut_t));
    ll1 = (find(tokens < 0 & tokens > cut_s));
    ll2 = (find(tokens < 0 & tokens < cut_s));
    ww1 = (find(tokens < 0 & tokens < 1.5*cut_s));
    tokens(hh1) = 1; tokens(hh2) = 2;
    tokens(ll1) = -1; tokens(ll2) = -2;
    tokens(ww1) = -3;
    
    % can drop little spaces, b/c they don't matter when parsing;
    tokens(tokens == -1) = [];
       
    % put a final wordstop at the end
    tokens = [tokens(2:end);-3];
    
    % break everything down into words determined by word spacing time
    toparse = find(tokens==-3); ltp = length(toparse);
    words = cell(2,ltp); ix = 1;
    for j=1:length(toparse)
       a = toparse(j);
       words{1,j} = tokens(ix:a-1);
       ix = a + 1;
    end

    % break down each word into a set of symbols
    for i=1:size(words,2)
        % set end of word flag token
        wd = [words{1,i};-2];
        toparse = find(wd==-2); ltp = length(toparse);
        toks = cell(1,ltp); ix = 1;
        for j=1:ltp
           a = toparse(j);
           toks{j} = wd(ix:a-1);
           ix = a + 1;
        end
        words{2,i} = toks';
    end
    
    % get the alphabet map we will use for decoding
    [code, decode] = getMap();
    
    % construct the words into a full message
    totalChars = arrayfun(@(x) size(x{:},1),words(2,:));
    totalChars = sum(totalChars)+size(words(1,:),2);
    message = repmat('_',1,totalChars); ii = 0;
    for i=1:size(words,2)
        wd=words{2,i};
        for j=1:length(wd)
            sym = wd{j}';
            for k=1:length(code)
               if isequal(sym,code{k})
                   message(ii+j) = char(decode{k});
                   break;
               end
            end
        end
        ii = ii + length(wd);
        message(ii+1) = ' ';
        ii = ii + 1;        
    end
end


function [code,decode] = getMap()
    code{1} = [1 2];
    code{2} = [2 1 1 1];
    code{3} = [2 1 2 1];
    code{4} = [2 1 1];
    code{5} = [1];
    code{6} = [1 1 2 1];
    code{7} = [2 2 1];
    code{8} = [1 1 1 1];
    code{9} = [1 1];
    code{10} = [1 2 2 2];
    code{11} = [2 1 2];
    code{12} = [1 2 1 1];
    code{13} = [2 2];
    code{14} = [2 1];
    code{15} = [2 2 2];
    code{16} = [1 2 2 1];
    code{17} = [1 2 1 2];
    code{18} = [1 2 1];
    code{19} = [1 1 1];
    code{20} = [2];
    code{21} = [1 1 2]; 
    code{22} = [1 1 1 2];
    code{23} = [1 2 2];
    code{24} = [2 1 1 2];
    code{25} = [2 1 2 2];
    code{26} = [2 2 1 1];
    % punct
    code{27} = [1 2 1 2 1 2];
    code{28} = [2 2 1 1 2 2];
    code{29} = [1 1 2 2 1 1];    
    code{30} = [2 1 1 2 1];
    % numbers
    code{31} = [1 2 2 2 2];
    code{32} = [1 1 2 2 2];
    code{33} = [1 1 1 2 2];
    code{34} = [1 1 1 1 2];
    code{35} = [1 1 1 1 1];
    code{36} = [2 1 1 1 1];
    code{37} = [2 2 1 1 1];
    code{38} = [2 2 2 1 1];
    code{39} = [2 2 2 2 1];
    code{40} = [2 2 2 2 2];

    % alphabet
    decode{1} = 'A';
    decode{2} = 'B';
    decode{3} = 'C';
    decode{4} = 'D';
    decode{5} = 'E';
    decode{6} = 'F';
    decode{7} = 'G';
    decode{8} = 'H';
    decode{9} = 'I';
    decode{10} = 'J';
    %decode{10} = '.';
    decode{11} = 'K';
    decode{12} = 'L';
    decode{13} = 'M';
    decode{14} = 'N';
    decode{15} = 'O';
    decode{16} = 'P';
    decode{17} = 'Q';
    decode{18} = 'R';
    decode{19} = 'S';
    decode{20} = 'T';
    decode{21} = 'U';
    decode{22} = 'V';
    decode{23} = 'W';
    decode{24} = 'X';
    decode{25} = 'Y';
    decode{26} = 'Z';
    decode{27} = '.';
    decode{28} = ',';
    decode{29} = '?';
    decode{30} = '/';
    decode{31} = '1';
    decode{32} = '2';
    decode{33} = '3';
    decode{34} = '4';
    decode{35} = '5';
    decode{36} = '6';
    decode{37} = '7';
    decode{38} = '8';
    decode{39} = '9';
    decode{40} = '0';
end
