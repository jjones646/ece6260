%% ECE 6260 - Run all speech encoding/decoding methods
%  Yifei Fan & Jonathan Jones
%  April 17, 2016

%% Setup environment
close all; clear all; clc;

%% Iterate over all methods
for method=1:7
    save('tmp_encoding_method.mat','method');
    run('project_main.m');
end

% cleanup temporary file
delete('tmp_encoding_method.mat');
