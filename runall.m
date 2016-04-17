%% ECE 6260 - Run all speech encoding/decoding methods
%  Yifei Fan & Jonathan Jones
%  April 17, 2016

%% Setup environment
close all; clear all; clc;

% cd into the directory where this script is
cd(fileparts(mfilename('fullpath')));

% add the 'includes' directory to the path for using the filters
addpath('includes');

%% Iterate over all methods
for ENCODING_METHOD=1:7
    save('tmp_encoding_method.mat','ENCODING_METHOD');
    run('project_main.m');
end

% cleanup temporary file
delete('tmp_encoding_method.mat');
