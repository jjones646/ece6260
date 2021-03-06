function morse = makeMorse(varargin)
% MAKEMORSE converts text to playable morse code in wav format
% 
% SYNTAX
% makeMorse(text)
% makeMorse(text,file);
% 
% Description:
% 
%   If the wave file name is specified, then the funtion will output a wav
%   file with that file name.  If only text is specified, then the function
%   will only play the morse code wav file without saving it to a wav file.

    text = varargin{1};
    if nargin==2
        file = varargin{2};
    end

    fs = 16000;
    freq = 4000;

    % 796 <-- # samples for a short beep
    % 740 <-- # samples for silence after short beep

    tt = 0:1/fs:(796/fs);
    Dit = cos(2*pi*freq.*tt); Dit = Dit';
    
    % 2332 <-- # samples for a long beep
    % 2276 <-- # samples for silence after long beep

    % 3107 is significant somehow
    
    ttt = 0:1/fs:(2332/fs);
    Dah = cos(2*pi*freq.*ttt); Dah = Dah';
    
    ttJ = 0:1/fs:(3107/fs);
    DahJ = cos(2*pi*freq.*ttJ); DahJ = DahJ';

    ssp = zeros(1,740); ssp = ssp';
    lsp = zeros(1,2276); lsp = lsp';

    % 7652 <-- # samples after a word

    % Defining Characters & Numbers
    A = [Dit;ssp;Dah];
    B = [Dah;ssp;Dit;ssp;Dit;ssp;Dit];
    C = [Dah;ssp;Dit;ssp;Dah;ssp;Dit];
    D = [Dah;ssp;Dit;ssp;Dit];
    E = [Dit];
    F = [Dit;ssp;Dit;ssp;Dah;ssp;Dit];
    G = [Dah;ssp;Dah;ssp;Dit];
    H = [Dit;ssp;Dit;ssp;Dit;ssp;Dit];
    I = [Dit;ssp;Dit];
    J = [Dit;ssp;DahJ;ssp;DahJ;ssp;Dah];
    K = [Dah;ssp;Dit;ssp;Dah];
    L = [Dit;ssp;Dah;ssp;Dit;ssp;Dit];
    M = [Dah;ssp;Dah];
    N = [Dah;ssp;Dit];
    O = [Dah;ssp;Dah;ssp;Dah];
    P = [Dit;ssp;Dah;ssp;Dah;ssp;Dit];
    Q = [Dah;ssp;Dah;ssp;Dit;ssp;Dah];
    R = [Dit;ssp;Dah;ssp;Dit];
    S = [Dit;ssp;Dit;ssp;Dit];
    T = [Dah];
    U = [Dit;ssp;Dit;ssp;Dah];
    V = [Dit;ssp;Dit;ssp;Dit;ssp;Dah];
    W = [Dit;ssp;Dah;ssp;Dah];
    X = [Dah;ssp;Dit;ssp;Dit;ssp;Dah];
    Y = [Dah;ssp;Dit;ssp;Dah;ssp;Dah];
    Z = [Dah;ssp;Dah;ssp;Dit;ssp;Dit];
    period = [Dit;ssp;Dah;ssp;Dit;ssp;Dah;ssp;Dit;ssp;Dah];
    comma = [Dah;ssp;Dah;ssp;Dit;ssp;Dit;ssp;Dah;ssp;Dah];
    question = [Dit;ssp;Dit;ssp;Dah;ssp;Dah;ssp;Dit;ssp;Dit];
    slash_ = [Dah;ssp;Dit;ssp;Dit;ssp;Dah;ssp;Dit];
    n1 = [Dit;ssp;Dah;ssp;Dah;ssp;Dah;ssp;Dah];
    n2 = [Dit;ssp;Dit;ssp;Dah;ssp;Dah;ssp;Dah];
    n3 = [Dit;ssp;Dit;ssp;Dit;ssp;Dah;ssp;Dah];
    n4 = [Dit;ssp;Dit;ssp;Dit;ssp;Dit;ssp;Dah];
    n5 = [Dit;ssp;Dit;ssp;Dit;ssp;Dit;ssp;Dit];
    n6 = [Dah;ssp;Dit;ssp;Dit;ssp;Dit;ssp;Dit];
    n7 = [Dah;ssp;Dah;ssp;Dit;ssp;Dit;ssp;Dit];
    n8 = [Dah;ssp;Dah;ssp;Dah;ssp;Dit;ssp;Dit];
    n9 = [Dah;ssp;Dah;ssp;Dah;ssp;Dah;ssp;Dit];
    n0 = [Dah;ssp;Dah;ssp;Dah;ssp;Dah;ssp;Dah];

    text = upper(text);
    vars ={'period','comma','question','slash_'};
    morsecode=[];
    for i=1:length(text)
        if isvarname(text(i))
            morsecode = [morsecode;eval(text(i))];
        elseif ismember(text(i),'.,?/')
            x = findstr(text(i),'.,?/');
            morsecode = [morsecode;eval(vars{x})];
        elseif ~isempty(str2num(text(i)))
            morsecode = [morsecode;eval(['n' text(i)])];
        elseif text(i)==' '
            morsecode = [morsecode;zeros(1,3090)'];
        end
        morsecode = [morsecode;lsp];
    end

    if exist('file','var')
        audioplayer(morsecode,fs,16,file);
    else
        morse = morsecode';
    end
end
