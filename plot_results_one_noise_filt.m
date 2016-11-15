clear; close all; clc;
dataLengthGens = 1:0.5:11;
dataLengthSecs = round((0.05*2.^dataLengthGens),2);

load fft_errors_one_noise_filt.mat
load welch_errors_one_noise_filt.mat
load med_welch_errors_one_noise_filt.mat
load music_errors_one_noise_filt.mat
% load esprit_errors_one_noise_filt.mat
% load burg_errors_one_noise_filt.mat
% load mem_errors_one_noise_filt.mat
% load envl_errors_one_noise_filt.mat

%% FFT
min_fft_errors = squeeze(min(fft_errors,[],2));
figure_min(dataLengthSecs,min_fft_errors, 'o', [0 0 1], 'FFT', 'one_noise_filt', 'Error');

med_fft_errors = squeeze(median(fft_errors,2));
figure_median(dataLengthSecs,med_fft_errors, 'o', [1 0 0], 'FFT', 'one_noise_filt', 'Error');

%% Welch
min_welch_errors = squeeze(min(min(min(welch_errors,[],4),[],3),[],2));
figure_min(dataLengthSecs,min_welch_errors, 'o', [0 0 1], 'Welch', 'one_noise_filt', 'Error');

median_welch_errors = squeeze(median(median(median(welch_errors,4),3),2));
figure_median(dataLengthSecs,median_welch_errors, 'o', [1 0 0], 'Welch', 'one_noise_filt', 'Error');

%% Med Welch
min_med_welch_errors = squeeze(min(min(min(med_welch_errors,[],4),[],3),[],2));
figure_min(dataLengthSecs,min_med_welch_errors, 'o', [0 0 1], 'Med Welch', 'one_noise_filt', 'Error');

median_med_welch_errors = squeeze(median(median(median(med_welch_errors,4),3),2));
figure_median(dataLengthSecs,median_med_welch_errors, 'o', [1 0 0], 'Med Welch', 'one_noise_filt', 'Error');

%% MUSIC
min_music_errors = squeeze(min(music_errors,[],2));
figure_min(dataLengthSecs,min_music_errors, 'o', [0 0 1], 'MUSIC', 'one_noise_filt', 'Error');

median_music_errors = squeeze(median(music_errors,2));
figure_median(dataLengthSecs,median_music_errors, 'o', [1 0 0], 'MUSIC', 'one_noise_filt', 'Error');

% %% eSPRIT
% min_esprit_errors = squeeze(min(min(esprit_errors,[],2)));
% figure_min(dataLengthSecs,min_esprit_errors, 'o', [0 0 1], 'eSPRIT', 'one_noise_filt', 'Error');
% 
% median_esprit_errors = squeeze(median(median(esprit_errors)));
% figure_median(dataLengthSecs,median_esprit_errors, 'o', [1 0 0], 'eSPRIT', 'one_noise_filt', 'Error');
% 
% %% Burg
% min_burg_errors = squeeze(min(min(burg_errors,[],2)));
% figure_min(dataLengthSecs,min_burg_errors, 'o', [0 0 1], 'Burg', 'one_noise_filt', 'Error');
% 
% median_burg_errors = squeeze(median(median(burg_errors)));
% figure_median(dataLengthSecs,median_burg_errors, 'o', [1 0 0], 'Burg', 'one_noise_filt', 'Error');
% 
% %% MEM
% min_mem_errors = squeeze(min(min(mem_errors,[],2)));
% figure_min(dataLengthSecs,min_mem_errors, 'o', [0 0 1], 'MEM', 'one_noise_filt', 'Error');
% 
% median_mem_errors = squeeze(median(median(burg_errors)));
% figure_median(dataLengthSecs,median_mem_errors, 'o', [1 0 0], 'MEM', 'one_noise_filt', 'Error');
% 
% %% Spec_Envl
% min_envl_errors = squeeze(min(min(min(envl_errors,[],2),[],3),[],4));
% figure_min(dataLengthSecs,min_envl_errors, 'o', [0 0 1], 'SpecEnvl', 'one_noise_filt', 'Error');
% 
% median_envl_errors = squeeze(median(median(median(envl_errors,2),3),4));
% figure_median(dataLengthSecs,median_envl_errors, 'o', [1 0 0], 'SpecEnvl', 'one_noise_filt', 'Error');
