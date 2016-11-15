clear; close all; clc;
dataLengthGens = 1:0.5:11;
dataLengthSecs = round((0.05*2.^dataLengthGens),2);

% load fft_errors_two.mat
% load welch_errors_two.mat
% load med_welch_errors_two.mat
% load music_errors_two.mat
% load esprit_errors_two.mat
% load burg_errors_two.mat
% load mem_errors_two.mat
% load envl_errors_two.mat

%% FFT
% min_fft_errors = squeeze(min(fft_errors,[],2));
% figure_min(dataLengthSecs,min_fft_errors, 'o', [0 0 1], 'FFT', 'two');
% 
% med_fft_errors = squeeze(median(fft_errors,2));
% figure_median(dataLengthSecs,med_fft_errors, 'o', [1 0 0], 'FFT', 'two');
% 
% %% Welch
% min_welch_errors = squeeze(min(min(min(welch_errors,[],2))));
% figure_min(dataLengthSecs,min_welch_errors, 'o', [0 0 1], 'Welch', 'two');
% 
% median_welch_errors = squeeze(median(median(median(welch_errors))));
% figure_median(dataLengthSecs,median_welch_errors, 'o', [1 0 0], 'Welch', 'two');
% 
% %% Med Welch
% min_med_welch_errors = squeeze(min(min(min(med_welch_errors,[],2))));
% figure_min(dataLengthSecs,min_med_welch_errors, 'o', [0 0 1], 'Med Welch', 'two');
% 
% median_med_welch_errors = squeeze(median(median(median(med_welch_errors))));
% figure_median(dataLengthSecs,median_med_welch_errors, 'o', [1 0 0], 'Med Welch', 'two');
% 
% %% MUSIC
% min_music_errors = squeeze(min(min(min(music_errors,[],2))));
% figure_min(dataLengthSecs,min_music_errors, 'o', [0 0 1], 'MUSIC', 'two');
% 
% median_music_errors = squeeze(median(median(median(music_errors))));
% figure_median(dataLengthSecs,median_music_errors, 'o', [1 0 0], 'MUSIC', 'two');
% 
% %% eSPRIT
% min_esprit_errors = squeeze(min(min(min(esprit_errors,[],2))));
% figure_min(dataLengthSecs,min_esprit_errors, 'o', [0 0 1], 'eSPRIT', 'two');
% 
% median_esprit_errors = squeeze(median(median(median(esprit_errors))));
% figure_median(dataLengthSecs,median_esprit_errors, 'o', [1 0 0], 'eSPRIT', 'two');
% 
% %% Burg
% min_burg_errors = squeeze(min(min(min(burg_errors,[],2))));
% figure_min(dataLengthSecs,min_burg_errors, 'o', [0 0 1], 'Burg', 'two');
% 
% median_burg_errors = squeeze(median(median(median(burg_errors))));
% figure_median(dataLengthSecs,median_burg_errors, 'o', [1 0 0], 'Burg', 'two');
% 
% %% MEM
% min_mem_errors = squeeze(min(min(min(mem_errors,[],2))));
% figure_min(dataLengthSecs,min_mem_errors, 'o', [0 0 1], 'MEM', 'two');
% 
% median_mem_errors = squeeze(median(median(median(burg_errors))));
% figure_median(dataLengthSecs,median_mem_errors, 'o', [1 0 0], 'MEM', 'two');
% 
%% Spec_Envl
% min_envl_errors = squeeze(min(min(min(envl_errors,[],2))));
% figure_min(dataLengthSecs,min_envl_errors, 'o', [0 0 1], 'SpecEnvl', 'two');
% 
% median_envl_errors = squeeze(median(median(median(envl_errors))));
% figure_median(dataLengthSecs,median_envl_errors, 'o', [1 0 0], 'SpecEnvl', 'two');
