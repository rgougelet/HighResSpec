% 	std_welch_errors = squeeze(std(std(std(welch_errors))));
% 	createfigure(dataLengthSecs,std_welch_errors, 'o', [0 1 1]);
% 	title('Std Dev over Parameter Space', 'FontSize', 22)
% 	ylabel('Mean-Squared Error', 'FontSize', 16)
% 	xlabel('Data Length (sec)', 'FontSize', 16)
% 	saveas(gcf, 'welch STD' , 'tif')
% 	
% 	cv_welch_errors = std_welch_errors./mean_welch_errors;
% 	cv_welch_errors(isnan(cv_welch_errors)) = 0;
% 	createfigure(dataLengthSecs,cv_welch_errors, 'o', [1 1 0]);
% 	title('Coeff of Variation over Parameter Space', 'FontSize', 22)
% 	ylabel('Mean-Squared Error', 'FontSize', 16)
% 	xlabel('Data Length (sec)', 'FontSize', 16)
% 	saveas(gcf, 'welch CV' , 'tif')

% 	std_fft_errors = squeeze(std(fft_errors,[],2));
% 	createfigure(dataLengthSecs,std_fft_errors, 'o', [0 1 1]);
% 	title('Std Dev over Parameter Space', 'FontSize', 24)
% 	ylabel('Mean-Squared Error', 'FontSize', 18)
% 	xlabel('Data Length (sec)', 'FontSize', 18)
% 	saveas(gcf, 'FFT STD' , 'tif')
% 	
% 	cv_fft_errors = std_fft_errors./mean_fft_errors;
% 	cv_fft_errors(isnan(cv_fft_errors)) = 0;
% 	createfigure(dataLengthSecs,cv_fft_errors, 'o', [0 0 1]);
% 	title('Coeff of Variation over Parameter Space', 'FontSize', 24)
% 	ylabel('Mean-Squared Error', 'FontSize', 18)
% 	xlabel('Data Length (sec)', 'FontSize', 18)
% 	saveas(gcf, 'FFT CV' , 'tif')

	
% 	std_med_welch_errors = squeeze(std(std(std(med_welch_errors))));
% 	createfigure(dataLengthSecs,std_med_welch_errors, 'o', [0 1 1]);
% 	title('Std Dev over Parameter Space', 'FontSize', 22)
% 	ylabel('Mean-Squared Error', 'FontSize', 16)
% 	xlabel('Data Length (sec)', 'FontSize', 16)
% 	saveas(gcf, 'med_welch STD' , 'tif')
% 	
% 	cv_med_welch_errors = std_med_welch_errors./mean_med_welch_errors;
% 	cv_med_welch_errors(isnan(cv_med_welch_errors)) = 0;
% 	createfigure(dataLengthSecs,cv_med_welch_errors, 'o', [1 1 1]);
% 	title('Coeff of Variation over Parameter Space', 'FontSize', 22)
% 	ylabel('Mean-Squared Error', 'FontSize', 16)
% 	xlabel('Data Length (sec)', 'FontSize', 16)
% 	saveas(gcf, 'med_welch CV' , 'tif')

%%
% close all
% for method = {'fft','welch','music','burg','mem'}
% 	for measure = {'_errors','_rts'}
% 		eval(['load ', method{1},measure{1},'.mat'])
% 	end
% end
% for measure = {'_errors','_rts'}
% 	for stat = {'min', 'max', 'median', 'mean', 'std','cv'}
% 		[stat{1},'_welch',measure{1},' = squeeze(',stat{1},'(',stat{1},'(',stat{1},'(welch', measure{1},'))));']
% 		[stat{1},'_welch',measure{1},' = squeeze(',stat{1},'(',stat{1},'(',stat{1},'(welch', measure{1},'))));']
% 		[stat{1},'_welch',measure{1},' = squeeze(',stat{1},'(',stat{1},'(',stat{1},'(welch', measure{1},'))));']
% 		[stat{1},'_welch',measure{1},' = squeeze(',stat{1},'(',stat{1},'(',stat{1},'(welch', measure{1},'))));']
% 	end
% % 	figure; hold on
% end


fs = findall(0,'type','figure');
for i = 1:length(fs)
	jFrame = get(handle(fs(i)),'JavaFrame');
	pause(0.1)  %//This is important
	jFrame.setMinimized(true);
end

%% Plot errors
if plot_errors
	close all

	% Minimum
	figure; hold on;
	min_fft_errors = squeeze(min(fft_errors,[],2));
	min_welch_errors = squeeze(min(min(min(welch_errors))));
	min_med_welch_errors = squeeze(min(min(min(med_welch_errors))));
	min_music_errors = squeeze(min(music_errors,[],2));
	min_esprit_errors = squeeze(min(min(esprit_errors)));
	min_burg_errors = squeeze(min(min(burg_errors)));
	min_mem_errors = squeeze(min(min(mem_errors)));
	min_envl_errors = squeeze(min(min(min(envl_errors))));
	plot(log(dataLengthSecs),min_fft_errors, 'b-o')
	plot(log(dataLengthSecs),min_welch_errors, 'r-+')
	plot(log(dataLengthSecs),min_med_welch_errors, 'c-+')
	plot(log(dataLengthSecs),min_music_errors, 'k:v')
	plot(log(dataLengthSecs),min_esprit_errors, 'y:v')
	plot(log(dataLengthSecs),min_burg_errors, 'm--')
	plot(log(dataLengthSecs),min_mem_errors, 'g--')
	plot(log(dataLengthSecs),min_envl_errors, 'k--')
	figure1 = figure;
	set(figure1, 'Units', 'inches');
	set(figure1, 'Position', [0 0 6 4].*2);
	set(figure1, 'PaperUnits', 'inches');
	set(figure1, 'PaperPosition', [0 0 6 4].*2);
	% Create axes
	axes1 = axes('Parent',figure1);
	hold(axes1,'on');
	
% 	legend('FFT','Welch', 'Med Welch', 'MUSIC', 'esprit', 'Burg', 'Max Ent', 'Spectral Envl')
% 	title('Minimum')
%  	ylim([0,0.0002])
	
	% Median
	figure; hold on;
	median_fft_errors = squeeze(median(fft_errors,2));
	median_welch_errors = squeeze(median(median(median(welch_errors))));
	median_med_welch_errors = squeeze(median(median(median(med_welch_errors))));
	median_music_errors = squeeze(median(music_errors,2));
	median_esprit_errors = squeeze(median(median(esprit_errors)));
	median_burg_errors = squeeze(median(median(burg_errors)));
	median_mem_errors = squeeze(median(median(mem_errors)));
	plot(log(dataLengthSecs),log(median_fft_errors), 'b-o')
	plot(log(dataLengthSecs),log(median_welch_errors), 'r-+')
	plot(log(dataLengthSecs),log(median_med_welch_errors), 'c-+')
	plot(log(dataLengthSecs),log(median_music_errors), 'k:v')
	plot(log(dataLengthSecs),log(median_esprit_errors), 'y:^')
	plot(log(dataLengthSecs),log(median_burg_errors), 'm--')
	plot(log(dataLengthSecs),log(median_mem_errors), 'g--')
	legend('FFT','Welch', 'Med Welch', 'MUSIC', 'esprit', 'Burg', 'Max Ent')
	title('Median')
% 	ylim([0,0.0005])

	% Mode
	figure; hold on;
	mode_fft_errors = squeeze(mode(fft_errors,2));
	mode_welch_errors = squeeze(mode(mode(mode(welch_errors))));
	mode_med_welch_errors = squeeze(mode(mode(mode(med_welch_errors))));
	mode_music_errors = squeeze(mode(music_errors,2));
	mode_esprit_errors = squeeze(mode(mode(esprit_errors)));
	mode_burg_errors = squeeze(mode(mode(burg_errors)));
	mode_mem_errors = squeeze(mode(mode(mem_errors)));
	plot(log(dataLengthSecs),mode_fft_errors, 'b-o')
	plot(log(dataLengthSecs),mode_welch_errors, 'r-+')
	plot(log(dataLengthSecs),mode_med_welch_errors, 'c-+')
	plot(log(dataLengthSecs),mode_music_errors, 'k:v')
	plot(log(dataLengthSecs),mode_esprit_errors, 'y:v')
	plot(log(dataLengthSecs),mode_burg_errors, 'm--')
	plot(log(dataLengthSecs),mode_mem_errors, 'g--')
	legend('FFT','Welch', 'Med Welch', 'MUSIC', 'esprit', 'Burg', 'Max Ent')
	title('Mode')
	ylim([0,0.0005])

	% Max
	figure; hold on;
	max_fft_errors = squeeze(max(fft_errors,[],2));
	max_welch_errors = squeeze(max(max(max(welch_errors))));
	max_med_welch_errors = squeeze(max(max(max(med_welch_errors))));
	max_music_errors = squeeze(max(music_errors,[],2));
	max_esprit_errors = squeeze(max(max(esprit_errors)));
	max_burg_errors = squeeze(max(max(burg_errors)));
	max_mem_errors = squeeze(max(max(mem_errors)));
	plot(log(dataLengthSecs),max_fft_errors, 'b-o')
	plot(log(dataLengthSecs),max_welch_errors, 'r-+')
	plot(log(dataLengthSecs),max_med_welch_errors, 'c-+')
	plot(log(dataLengthSecs),max_music_errors, 'k:v')
	plot(log(dataLengthSecs),max_esprit_errors, 'y:v')
	plot(log(dataLengthSecs),max_burg_errors, 'm--')
	plot(log(dataLengthSecs),max_mem_errors, 'g--')
	legend('FFT','Welch', 'Med Welch', 'MUSIC', 'esprit', 'Burg', 'Max Ent')
	title('Maximum')
% 	ylim([0,0.0005])

	% Mean
	
	mean_welch_errors = squeeze(mean(mean(mean(welch_errors))));
	mean_med_welch_errors = squeeze(mean(mean(mean(med_welch_errors))));
	mean_music_errors = squeeze(mean(music_errors,2));
	mean_esprit_errors = squeeze(mean(mean(esprit_errors)));
	mean_burg_errors = squeeze(mean(mean(burg_errors)));
	mean_mem_errors = squeeze(mean(mean(mem_errors)));
	
	plot(log(dataLengthSecs),mean_welch_errors, 'r-+')
	plot(log(dataLengthSecs),mean_med_welch_errors, 'c-+')
	plot(log(dataLengthSecs),mean_music_errors, 'k:v')
	plot(log(dataLengthSecs),mean_esprit_errors, 'y:v')
	plot(log(dataLengthSecs),mean_burg_errors, 'm--')
	plot(log(dataLengthSecs),mean_mem_errors, 'g--')
	legend('FFT','Welch', 'Med Welch', 'MUSIC', 'esprit', 'Burg', 'Max Ent')
	title('Mean')
% 	ylim([0,0.0005])

	% STD
	figure; hold on;
	std_fft_errors = squeeze(std(fft_errors,[],2));
	std_welch_errors = squeeze(std(std(std(welch_errors))));
	std_med_welch_errors = squeeze(std(std(std(med_welch_errors))));
	std_music_errors = squeeze(std(music_errors,[],2));
	std_esprit_errors = squeeze(std(std(esprit_errors)));
	std_burg_errors = squeeze(std(std(burg_errors)));
	std_mem_errors = squeeze(std(std(mem_errors)));
	plot(log(dataLengthSecs),std_fft_errors, 'b-o')
	plot(log(dataLengthSecs),std_welch_errors, 'r-+')
	plot(log(dataLengthSecs),std_med_welch_errors, 'c-+')
	plot(log(dataLengthSecs),std_music_errors, 'k:v')
	plot(log(dataLengthSecs),std_esprit_errors, 'y:v')
	plot(log(dataLengthSecs),std_burg_errors, 'm--')
	plot(log(dataLengthSecs),std_mem_errors, 'g--')
	legend('FFT','Welch', 'Med Welch', 'MUSIC', 'esprit', 'Burg', 'Max Ent')
	title('STD')
	ylim([0,0.0005])

	% Quart Coeff of Disp
	figure; hold on;
	fft_errors_q3 = quantile(fft_errors,0.75,2);
	welch_errors_q3 = squeeze(quantile(quantile(quantile(welch_errors,0.75,3),0.75,2),0.75,1));
	med_welch_errors_q3 = squeeze(quantile(quantile(quantile(med_welch_errors,0.75,3),0.75,2),0.75,1));
	music_errors_q3 = quantile(music_errors,0.75,2);
	esprit_errors_q3 = squeeze(quantile(quantile(esprit_errors,0.75,2),0.75,1));
	burg_errors_q3 = squeeze(quantile(quantile(burg_errors,0.75,2),0.75,1));
	mem_errors_q3 = squeeze(quantile(quantile(mem_errors,0.75,2),0.75,1));
	fft_errors_q1 = quantile(fft_errors,0.25,2);
	welch_errors_q1 = squeeze(quantile(quantile(quantile(welch_errors,0.25,3),0.25,2),0.25,1));
	med_welch_errors_q1 = squeeze(quantile(quantile(quantile(med_welch_errors,0.25,3),0.25,2),0.25,1));
	music_errors_q1 = quantile(music_errors,0.25,2);
	esprit_errors_q1 = squeeze(quantile(quantile(esprit_errors,0.25,2),0.25,1));
	burg_errors_q1 = squeeze(quantile(quantile(burg_errors,0.25,2),0.25,1));
	mem_errors_q1 = squeeze(quantile(quantile(mem_errors,0.25,2),0.25,1));
	qcd_fft_errors = (fft_errors_q3-fft_errors_q1)./(fft_errors_q3+fft_errors_q1);
	qcd_welch_errors = (welch_errors_q3-welch_errors_q1)./(welch_errors_q3+welch_errors_q1);
	qcd_med_welch_errors = (med_welch_errors_q3-med_welch_errors_q1)./(med_welch_errors_q3+med_welch_errors_q1);
	qcd_music_errors = (music_errors_q3-music_errors_q1)./(music_errors_q3+music_errors_q1);
	qcd_esprit_errors = (esprit_errors_q3-esprit_errors_q1)./(esprit_errors_q3+esprit_errors_q1);
	qcd_burg_errors = (burg_errors_q3-burg_errors_q1)./(burg_errors_q3+burg_errors_q1);
	qcd_mem_errors = (mem_errors_q3-mem_errors_q1)./(mem_errors_q3+mem_errors_q1);
	qcd_fft_errors(isnan(qcd_fft_errors)) = 0;
	qcd_welch_errors(isnan(qcd_welch_errors)) = 0;
	qcd_med_welch_errors(isnan(qcd_welch_errors)) = 0;
	qcd_music_errors(isnan(qcd_music_errors)) = 0;
	qcd_esprit_errors(isnan(qcd_esprit_errors)) = 0;
	qcd_burg_errors(isnan(qcd_burg_errors)) = 0;
	qcd_mem_errors(isnan(qcd_mem_errors)) = 0;
	plot(log(dataLengthSecs),qcd_fft_errors, 'b-o')
	plot(log(dataLengthSecs),qcd_welch_errors, 'r-+')
	plot(log(dataLengthSecs),qcd_med_welch_errors, 'c-+')
	plot(log(dataLengthSecs),qcd_music_errors, 'k:v')
	plot(log(dataLengthSecs),qcd_esprit_errors, 'y:v')
	plot(log(dataLengthSecs),qcd_burg_errors, 'm--')
	plot(log(dataLengthSecs),qcd_mem_errors, 'g--')
	legend('FFT','Welch', 'Med Welch', 'MUSIC', 'esprit', 'Burg', 'Max Ent')
	title('Quartile Coeff of Dispersioon')
	
	% CV
	figure; hold on;
	cv_fft_errors = std_fft_errors./mean_fft_errors;
	cv_welch_errors = std_welch_errors./mean_welch_errors;
	cv_med_welch_errors = std_med_welch_errors./mean_med_welch_errors;
	cv_music_errors = std_music_errors./mean_music_errors;
	cv_esprit_errors = std_esprit_errors./mean_esprit_errors;
	cv_burg_errors = std_burg_errors./mean_burg_errors;
	cv_mem_errors = std_mem_errors./mean_mem_errors;
	cv_fft_errors(isnan(cv_fft_errors)) = 0;
	cv_welch_errors(isnan(cv_welch_errors)) = 0;
	cv_med_welch_errors(isnan(cv_welch_errors)) = 0;
	cv_music_errors(isnan(cv_music_errors)) = 0;
	cv_esprit_errors(isnan(cv_esprit_errors)) = 0;
	cv_burg_errors(isnan(cv_burg_errors)) = 0;
	cv_mem_errors(isnan(cv_mem_errors)) = 0;
	plot(log(dataLengthSecs),cv_fft_errors, 'b-o')
	plot(log(dataLengthSecs),cv_welch_errors, 'r-+')
	plot(log(dataLengthSecs),cv_med_welch_errors, 'c-+')
	plot(log(dataLengthSecs),cv_music_errors, 'k:v')
	plot(log(dataLengthSecs),cv_esprit_errors, 'y:v')
	plot(log(dataLengthSecs),cv_burg_errors, 'm--')
	plot(log(dataLengthSecs),cv_mem_errors, 'g--')
	legend('FFT','Welch', 'Med Welch', 'MUSIC', 'esprit', 'Burg', 'Max Ent')
	title('Coeff of Variation')
end
