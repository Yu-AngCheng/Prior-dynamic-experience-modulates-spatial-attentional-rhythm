%% Load a specific variable that was saved out to a mat file

% Load exponents
exps = load('exps.mat');

% Check out the exponents
exps

%% Load in FOOOF results that have been saved out - from json file

% Add the utils folder to path, that has the load function
addpath('utils')

% Load the fooof-formated json file, saved out from Python
fooof_results = load_fooof_results('fooof_results.json');

% Check out fooof_results
fooof_results

%% Load in FOOOF results that have been saved out - from mat files

fooof_results = [];
for ind = 0:49
    cur_result = load(strcat('f_results_', string(ind)));
    fooof_results = [fooof_results, cur_result];
end

% Check out outputs
fooof_results

%% Now you can do anything you want with your FOOOF results