clear; close all; clc;
dataLengthGens = 1:0.5:11;
dataLengthSecs = round((0.05*2.^dataLengthGens),2);

load fft_errors_two.mat
load welch_errors_two.mat
load med_welch_errors_two.mat
load music_errors_two.mat
load esprit_errors_two.mat
load burg_errors_two.mat
load mem_errors_two.mat
load envl_errors_two.mat

% %% FFT
% min_fft_errors = squeeze(min(fft_errors,[],2));
% figure_min(dataLengthSecs,min_fft_errors, 'o', [0 0 1], 'FFT', 'two', 'Error');
% 
% med_fft_errors = squeeze(median(fft_errors,2));
% figure_median(dataLengthSecs,med_fft_errors, 'o', [1 0 0], 'FFT', 'two', 'Error');
% 
% %% Welch
% min_welch_errors = squeeze(min(min(min(welch_errors,[],1),[],2),[],3));
% figure_min(dataLengthSecs,min_welch_errors, 'o', [0 0 1], 'Welch', 'two', 'Error');
% 
% median_welch_errors = squeeze(median(median(median(welch_errors,1),2),3));
% figure_median(dataLengthSecs,median_welch_errors, 'o', [1 0 0], 'Welch', 'two', 'Error');
% 
% %% Med Welch
% min_med_welch_errors = squeeze(min(min(min(med_welch_errors,[],1),[],2),[],3));
% figure_min(dataLengthSecs,min_med_welch_errors, 'o', [0 0 1], 'Med Welch', 'two', 'Error');
% 
% median_med_welch_errors = squeeze(median(median(median(med_welch_errors,1),2),3));
% figure_median(dataLengthSecs,median_med_welch_errors, 'o', [1 0 0], 'Med Welch', 'two', 'Error');
% 
% %% MUSIC
% min_music_errors = squeeze(min(music_errors,[],2));
% figure_min(dataLengthSecs,min_music_errors, 'o', [0 0 1], 'MUSIC', 'two', 'Error');
% 
% median_music_errors = squeeze(median(music_errors,2));
% figure_median(dataLengthSecs,median_music_errors, 'o', [1 0 0], 'MUSIC', 'two', 'Error');
% 
% %% eSPRIT
% min_esprit_errors = squeeze(min(min(esprit_errors,[],2),[],3));
% figure_min(dataLengthSecs,min_esprit_errors, 'o', [0 0 1], 'eSPRIT', 'two', 'Error');
% 
% median_esprit_errors = squeeze(median(median(esprit_errors,2),3));
% figure_median(dataLengthSecs,median_esprit_errors, 'o', [1 0 0], 'eSPRIT', 'two', 'Error');
% 
% %% Burg
% min_burg_errors = squeeze(min(min(burg_errors,[],2),[],3));
% figure_min(dataLengthSecs,min_burg_errors, 'o', [0 0 1], 'Burg', 'two', 'Error');
% 
% median_burg_errors = squeeze(median(median(burg_errors,2),3));
% figure_median(dataLengthSecs,median_burg_errors, 'o', [1 0 0], 'Burg', 'two', 'Error');
% 
% %% MEM
% min_mem_errors = squeeze(min(min(mem_errors,[],1),[],2));
% figure_min(dataLengthSecs,min_mem_errors, 'o', [0 0 1], 'MEM', 'two', 'Error');
% 
% median_mem_errors = squeeze(median(median(mem_errors,1),2));
% figure_median(dataLengthSecs,median_mem_errors, 'o', [1 0 0], 'MEM', 'two', 'Error');

%% Spec_Envl
min_envl_errors = squeeze(min(min(min(envl_errors,[],1),[],2),[],3));
figure_min(dataLengthSecs,min_envl_errors, 'o', [0 0 1], 'SpecEnvl', 'two', 'Error');

median_envl_errors = squeeze(median(median(median(envl_errors,1),2),3));
figure_median(dataLengthSecs,median_envl_errors, 'o', [1 0 0], 'SpecEnvl', 'two', 'Error');
