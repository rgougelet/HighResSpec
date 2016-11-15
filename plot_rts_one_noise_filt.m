clear; close all; clc;
dataLengthGens = 1:0.5:11;
dataLengthSecs = round((0.05*2.^dataLengthGens),2);

load fft_rts_one_noise_filt.mat
load welch_rts_one_noise_filt.mat
load med_welch_rts_one_noise_filt.mat
load music_rts_one_noise_filt.mat

load esprit_rts_one_noise_filt.mat
load burg_rts_one_noise_filt.mat
load mem_rts_one_noise_filt.mat
load envl_rts_one_noise_filt.mat

%% FFT
med_fft_rts = squeeze(median(fft_rts,2));
figure_median(dataLengthSecs,med_fft_rts, 'o', [0 0 0], 'FFT', 'one_noise_filt', 'Runtime');

%% Welch
median_welch_rts = squeeze(median(median(median(welch_rts,4),3),2));
figure_median(dataLengthSecs,median_welch_rts, 'o', [0 0 0], 'Welch', 'one_noise_filt', 'Runtime');

%% Med Welch
median_welch_rts = squeeze(median(median(median(med_welch_rts,4),3),2));
figure_median(dataLengthSecs,median_welch_rts, 'o', [0 0 0], 'Med Welch', 'one_noise_filt', 'Runtime');

%% MUSIC
median_music_rts = squeeze(median(music_rts,2));
figure_median(dataLengthSecs,median_music_rts, 'o', [0 0 0], 'MUSIC', 'one_noise_filt', 'Runtime');

%% eSPRIT
median_esprit_rts = squeeze(median(median(esprit_rts,2),3));
figure_median(dataLengthSecs,median_esprit_rts, 'o', [0 0 0], 'eSPRIT', 'one_noise_filt', 'Runtime');

%% Burg
median_burg_rts = squeeze(median(median(burg_rts,2),3));
figure_median(dataLengthSecs,median_burg_rts, 'o', [0 0 0], 'Burg', 'one_noise_filt', 'Runtime');

%% MEM
median_mem_rts = squeeze(median(median(mem_rts,1),2));
figure_median(dataLengthSecs,median_mem_rts, 'o', [0 0 0], 'MEM', 'one_noise_filt', 'Runtime');

%% Spec_Envl
median_envl_rts = squeeze(median(median(median(envl_rts,2),3),4));
figure_median(dataLengthSecs,median_envl_rts, 'o', [0 0 0], 'SpecEnvl', 'one_noise_filt', 'Runtime');
