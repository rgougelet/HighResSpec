clear; close all; clc;
dataLengthGens = 1:0.5:11;
dataLengthSecs = round((0.05*2.^dataLengthGens),2);

load fft_rts_one.mat
load welch_rts_one.mat
% load med_welch_rts_one.mat
load music_rts_one.mat
load esprit_rts_one.mat
load burg_rts_one.mat
load mem_rts_one.mat
load envl_rts_one.mat


% %% FFT
min_fft_rts = squeeze(min(fft_rts,[],2));
figure_min(dataLengthSecs,min_fft_rts, 'o', [0 0 1], 'FFT', 'one', 'Runtimes');

med_fft_rts = squeeze(median(fft_rts,2));
figure_median(dataLengthSecs,med_fft_rts, 'o', [1 0 0], 'FFT', 'one', 'Runtimes');
% 
% %% Welch
% min_welch_rts = squeeze(min(min(min(welch_rts,[],4),[],3),[],2));
% figure_min(dataLengthSecs,min_welch_rts, 'o', [0 0 1], 'Welch', 'one');
% 
% median_welch_rts = squeeze(median(median(median(welch_rts,4),3),2));
% figure_median(dataLengthSecs,median_welch_rts, 'o', [1 0 0], 'Welch', 'one');
% 
% %% Med Welch
% min_med_welch_rts = squeeze(min(min(min(med_welch_rts,[],2))));
% figure_min(dataLengthSecs,min_med_welch_rts, 'o', [0 0 1], 'Med Welch', 'one');
% 
% median_med_welch_rts = squeeze(median(median(median(med_welch_rts))));
% figure_median(dataLengthSecs,median_med_welch_rts, 'o', [1 0 0], 'Med Welch', 'one');
% 
% %% MUSIC
% min_music_rts = squeeze(min(min(min(music_rts,[],2))));
% figure_min(dataLengthSecs,min_music_rts, 'o', [0 0 1], 'MUSIC', 'one');
% 
% median_music_rts = squeeze(median(median(median(music_rts))));
% figure_median(dataLengthSecs,median_music_rts, 'o', [1 0 0], 'MUSIC', 'one');

% %% eSPRIT
% min_esprit_rts = squeeze(min(min(min(esprit_rts,[],2))));
% figure_min(dataLengthSecs,min_esprit_rts, 'o', [0 0 1], 'eSPRIT', 'one');
% 
% median_esprit_rts = squeeze(median(median(median(esprit_rts))));
% figure_median(dataLengthSecs,median_esprit_rts, 'o', [1 0 0], 'eSPRIT', 'one');
% 
% %% Burg
% min_burg_rts = squeeze(min(min(min(burg_rts,[],2))));
% figure_min(dataLengthSecs,min_burg_rts, 'o', [0 0 1], 'Burg', 'one');
% 
% median_burg_rts = squeeze(median(median(median(burg_rts))));
% figure_median(dataLengthSecs,median_burg_rts, 'o', [1 0 0], 'Burg', 'one');
% 
% %% MEM
% min_mem_rts = squeeze(min(min(min(mem_rts,[],2))));
% figure_min(dataLengthSecs,min_mem_rts, 'o', [0 0 1], 'MEM', 'one');
% 
% median_mem_rts = squeeze(median(median(median(burg_rts))));
% figure_median(dataLengthSecs,median_mem_rts, 'o', [1 0 0], 'MEM', 'one');
% 
% %% Spec_Envl
% min_envl_rts = squeeze(min(min(min(envl_rts,[],2))));
% figure_min(dataLengthSecs,min_envl_rts, 'o', [0 0 1], 'SpecEnvl', 'one');
% 
% median_envl_rts = squeeze(median(median(median(envl_rts))));
% figure_median(dataLengthSecs,median_envl_rts, 'o', [1 0 0], 'SpecEnvl', 'one');
