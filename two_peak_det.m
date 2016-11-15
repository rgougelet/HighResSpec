clear
clc
close all

% two oscillation's frequency parameters
oscCenter1 = 10.54; % hard coded 
oscCenter2 = 10.56; % hard coded
sampleRate = 1000; % hard coded
nyq = sampleRate/2;
sampleSpacing = 1/sampleRate;
phaseOffsets = 0:(pi/8):2*pi; % hard coded
nPhaseOffsets = length(phaseOffsets);
dataLengthGens = 1:0.5:11;
dataLengthSecs = round((0.05*2.^dataLengthGens),2); % in seconds hard coded
nDataLengths = length(dataLengthSecs);
nfft = 100*sampleRate;
diffo = oscCenter1;
thetamid=diffo*2*pi*sampleSpacing;
th=linspace(0,2*pi,nfft);
focal_th = th(1000:1100);
freqs = (th(1:nfft/2)/sampleSpacing)/(2*pi);
focal_freqs = freqs(1000:1100);
windowLengthPercs = (5:10:75)./100;
overlapPercs = (10:10:70)./100;

%% Run params
run_fft = 0;
run_welch = 0;
run_med_welch = 0;
run_music = 1;
run_esprit = 1;
run_envlp = 1;
run_burg = 1;
run_mem = 1;

%% FFT
if run_fft
	dataLength_errors = [];
	dataLength_rts = [];
	for dataLengthSec = dataLengthSecs;
		dataLengthSamples = dataLengthSec*sampleRate;
		phaseOffset_errors = [];
		phaseOffset_rts = [];
		for phaseOffset = phaseOffsets;
			osc1 = chan_osc(dataLengthSamples, sampleRate,oscCenter1,'phaseOffset',phaseOffset);
            osc2 = chan_osc(dataLengthSamples, sampleRate,oscCenter2);
            data = osc1+osc2;
			fft_freqs = linspace(0,nyq,floor(nfft/2)+1);

			tic
			dataX = fft(data,nfft)/dataLengthSamples;
			dataX = dataX(1:length(fft_freqs)); %keep only positive frequencies
			phaseOffset_rt = toc;
			amp = 2*abs(dataX);
			phaseOffset_error = peak_det_mse(fft_freqs,amp,[oscCenter1,oscCenter2], [1000,1100]);

			phaseOffset_errors = [phaseOffset_errors phaseOffset_error];
			phaseOffset_rts = [phaseOffset_rts phaseOffset_rt];
		end

		% (length(dataLength_errors)) x (length(phaseOffsets)) matrix
		dataLength_errors = [dataLength_errors; phaseOffset_errors];
		dataLength_rts = [dataLength_rts; phaseOffset_rts];
	end

	fft_errors = dataLength_errors;
	fft_rts = dataLength_rts;
	save('fft_errors_two.mat','fft_errors');
	save('fft_rts_two.mat','fft_rts');
end

%% Welch
if run_welch
	start_welch = tic;
	dataLength_errors = zeros(length(dataLengthSecs),length(overlapPercs), ...
        length(phaseOffsets),length(windowLengthPercs));
	dataLength_rts = zeros(length(dataLengthSecs),length(overlapPercs), ...
        length(phaseOffsets),length(windowLengthPercs));

	parfor dataLengthSecInd = 1:length(dataLengthSecs) % defined for all methods at the top
        dataLengthSec = dataLengthSecs(dataLengthSecInd);
		dataLengthSamples = dataLengthSec*sampleRate
		windowLength_errors = []; % length equal to length(dls_wls)
		windowLength_rts = []; % length equal to length(dls_wls)
		windowLengthsSamples = round(windowLengthPercs*dataLengthSamples);

		for windowLengthSamples = windowLengthsSamples;
			phaseOffset_errors = [];
			phaseOffset_rts = [];
			nOverlaps = round(overlapPercs.*windowLengthSamples);
			for phaseOffset = phaseOffsets % defined for all methods at the top
				nOverlap_errors = [];
				nOverlap_rts = [];
				osc1 = chan_osc(dataLengthSamples, sampleRate,oscCenter1,'phaseOffset',phaseOffset);
                osc2 = chan_osc(dataLengthSamples, sampleRate,oscCenter2);
                data = osc1+osc2;
				for nOverlap = nOverlaps
					tic
					[pow, welch_f] = pwelch(data,windowLengthSamples,nOverlap,nfft,sampleRate, 'power', 'onesided');
					nOverlap_rt = toc;
					amp = sqrt(pow);
					nOverlap_error = peak_det_mse(welch_f,amp,[oscCenter1,oscCenter2], [1000,1100]);
					nOverlap_errors = cat(1,nOverlap_errors, nOverlap_error);
					nOverlap_rts= cat(1,nOverlap_rts, nOverlap_rt);
				end
				phaseOffset_errors = cat(2,phaseOffset_errors, nOverlap_errors);
				phaseOffset_rts = cat(2,phaseOffset_rts, nOverlap_rts);
			end
			windowLength_errors = cat(3,windowLength_errors, phaseOffset_errors);
			windowLength_rts = cat(3,windowLength_rts, phaseOffset_rts);
		end
		
		dataLength_errors(dataLengthSecInd,:,:,:) = windowLength_errors;
		dataLength_rts(dataLengthSecInd,:,:,:) =  windowLength_rts;
	end
	welch_errors = dataLength_errors;
	welch_rts = dataLength_rts;

	save('welch_errors_two.mat','welch_errors');
	save('welch_rts_two.mat','welch_rts');
	welch_run = toc(start_welch);
	['Welch runtime:', num2str(welch_run)]
end

%% Med Welch
if run_med_welch
	start_med_welch = tic;
	dataLength_errors = zeros(length(dataLengthSecs),length(overlapPercs), ...
        length(phaseOffsets),length(windowLengthPercs));
	dataLength_rts = zeros(length(dataLengthSecs),length(overlapPercs), ...
        length(phaseOffsets),length(windowLengthPercs));

	parfor dataLengthSecInd = 1:length(dataLengthSecs)
        dataLengthSec = dataLengthSecs(dataLengthSecInd);
		dataLengthSamples = dataLengthSec*sampleRate
		windowLength_errors = [];
		windowLength_rts = [];
		windowLengthsSamples = round(windowLengthPercs*dataLengthSamples);
		for windowLengthSamples = windowLengthsSamples;
			phaseOffset_errors = [];
			phaseOffset_rts = [];
			nOverlaps = round(overlapPercs.*windowLengthSamples);
			for phaseOffset = phaseOffsets
				nOverlap_errors = [];
				nOverlap_rts = [];
                osc1 = chan_osc(dataLengthSamples, sampleRate,oscCenter1,'phaseOffset',phaseOffset);
                osc2 = chan_osc(dataLengthSamples, sampleRate,oscCenter2);
                data = osc1+osc2;
				for nOverlap = nOverlaps
					tic
					[pow, welch_f] = med_pwelch(data,windowLengthSamples,nOverlap,nfft,sampleRate);
					nOverlap_rt = toc;
					amp = sqrt(pow);
					nOverlap_error = peak_det_mse(welch_f,amp,[oscCenter1,oscCenter2],[1000,1100]);
					nOverlap_errors = cat(1,nOverlap_errors, nOverlap_error);
					nOverlap_rts= cat(1,nOverlap_rts, nOverlap_rt);
				end
				phaseOffset_errors = cat(2,phaseOffset_errors, nOverlap_errors);
				phaseOffset_rts = cat(2,phaseOffset_rts, nOverlap_rts);
			end
			windowLength_errors = cat(3,windowLength_errors, phaseOffset_errors);
			windowLength_rts = cat(3,windowLength_rts, phaseOffset_rts);
		end
		dataLength_errors(dataLengthSecInd,:,:,:) = windowLength_errors;
		dataLength_rts(dataLengthSecInd,:,:,:) =  windowLength_rts;
	end
	med_welch_errors = dataLength_errors;
	med_welch_rts = dataLength_rts;

	save('med_welch_errors_two.mat','med_welch_errors');
	save('med_welch_rts_two.mat','med_welch_rts');
	med_welch_run = toc(start_med_welch);
	['Med Welch runtime:', num2str(med_welch_run)]
end

%% MUSIC
if run_music
	start_music = tic;
	dataLength_errors = [];
	dataLength_rts = [];
	for dataLengthSec = dataLengthSecs;
		dataLengthSamples = dataLengthSec*sampleRate
		phaseOffset_errors = [];
		phaseOffset_rts = [];
		for phaseOffset = phaseOffsets;
			osc1 = chan_osc(dataLengthSamples, sampleRate,oscCenter1,'phaseOffset',phaseOffset);
            osc2 = chan_osc(dataLengthSamples, sampleRate,oscCenter2);
            data = osc1+osc2;
			tic
			[S,freqs] = pmusic(data,4,nfft,sampleRate, 'onesided');
			phaseOffset_rt = toc;
			phaseOffset_error = peak_det_mse(freqs,S,[oscCenter1,oscCenter2],[1000,1100]);
			
			phaseOffset_errors = [phaseOffset_errors phaseOffset_error];
			phaseOffset_rts = [phaseOffset_rts phaseOffset_rt];
        end
		dataLength_errors = [dataLength_errors; phaseOffset_errors];
		dataLength_rts = [dataLength_rts; phaseOffset_rts];
	end
	music_errors = dataLength_errors;
	music_rts = dataLength_rts;
	
	save('music_errors_two.mat','music_errors');
	save('music_rts_two.mat','music_rts');
	music_run = toc(start_music);
	['Music runtime:', num2str(music_run)]
end

%% eSPRIT
if run_esprit
    orders = 16:4:48;
	start_esprit = tic;
	dataLength_errors = zeros(length(dataLengthSecs),length(phaseOffsets), ...
        length(orders));
	dataLength_rts = zeros(length(dataLengthSecs),length(phaseOffsets), ...
        length(orders));

	parfor dataLengthSecInd = 1:length(dataLengthSecs) % defined for all methods at the top
        dataLengthSec = dataLengthSecs(dataLengthSecInd);
		dataLengthSamples = dataLengthSec*sampleRate
		phaseOffset_errors = [];
		phaseOffset_rts = [];
		for phaseOffset = phaseOffsets;
			osc1 = chan_osc(dataLengthSamples, sampleRate,oscCenter1,'phaseOffset',phaseOffset);
            osc2 = chan_osc(dataLengthSamples, sampleRate,oscCenter2);
            data = osc1+osc2;
			order_errors = [];
			order_rts = [];
			for order = orders
				tic
				w=esprit(data,4,order);
				sorted_w = sort((w/sampleSpacing)/(2*pi),'descend');
				freqs = sorted_w(1:2);
				order_rt = toc;

				order_error = peak_det_mse(freqs,[1 1],[oscCenter1,oscCenter2],[1 2]);
				order_errors = cat(2,order_errors, order_error);
				order_rts = cat(2,order_rts, order_rt);
			end
			phaseOffset_errors = cat(1,phaseOffset_errors, order_errors);
			phaseOffset_rts = cat(1,phaseOffset_rts, order_rts);
        end
        dataLength_errors(dataLengthSecInd,:,:) = phaseOffset_errors;
		dataLength_rts(dataLengthSecInd,:,:) =  phaseOffset_rts;
	end
	esprit_errors = dataLength_errors;
	esprit_rts = dataLength_rts;
	
	save('esprit_errors_two.mat','esprit_errors');
	save('esprit_rts_two.mat','esprit_rts');
	epsrit_run = toc(start_esprit);
	['eSPRIT runtime: ', num2str(epsrit_run)]
end

%% Spectral envelope
if run_envlp
    radii = 0.9:0.01:0.99;
    nneigs = 8:16;
	start_envl = tic;
	dataLength_errors = zeros(length(dataLengthSecs),length(phaseOffsets), ...
        length(nneigs),length(radii));
	dataLength_rts = zeros(length(dataLengthSecs),length(phaseOffsets), ...
        length(nneigs),length(radii));
	parfor dataLengthSecInd = 1:length(dataLengthSecs)
        dataLengthSec = dataLengthSecs(dataLengthSecInd);
        dataLengthSamples = dataLengthSec*sampleRate
		phaseOffset_errors = [];
		phaseOffset_rts = [];
		for phaseOffset = phaseOffsets;
			phaseOffset
			osc1 = chan_osc(dataLengthSamples, sampleRate,oscCenter1,'phaseOffset',phaseOffset);
            osc2 = chan_osc(dataLengthSamples, sampleRate,oscCenter2);
            data = osc1+osc2;
            neigs_errors = [];
			neigs_rts = [];
			for neigs = nneigs
				radius_errors = [];
				radius_rts = [];
				for radius = radii
					tic
					[A,B] = cjordan(neigs,radius*exp(thetamid*1i));
					R = dlsim_complex(A,B,data); %needs row vector
					rhofull = envlp(R,A,B,focal_th);
 					rhohalf = rhofull;
 					rho = rhohalf.^2; %if actually want power, do this
					radius_rt = toc;
					radius_error = peak_det_mse(focal_freqs,rho,[oscCenter1,oscCenter2], [1,length(focal_th)]);
					radius_errors = cat(4,radius_errors, radius_error);
					radius_rts = cat(4,radius_rts, radius_rt);
				end
				neigs_errors = cat(3,neigs_errors, radius_errors);
				neigs_rts = cat(3,neigs_rts, radius_rts);
			end
			phaseOffset_errors = cat(2,phaseOffset_errors, neigs_errors);
			phaseOffset_rts = cat(2,phaseOffset_rts, neigs_rts);
		end
		dataLength_errors(dataLengthSecInd,:,:,:) = phaseOffset_errors;
		dataLength_rts(dataLengthSecInd,:,:,:) =  phaseOffset_rts;
	end
	envl_errors = dataLength_errors;
	envl_rts = dataLength_rts;
	save('envl_errors_two.mat','envl_errors');
	save('envl_rts_two.mat','envl_rts');
	envl_run = toc(start_envl);
	['Spectral Envl runtime: ', num2str(envl_run)]
end

%% Burg
if run_burg
    orders = 3:2:25;
	dataLength_errors = zeros(length(dataLengthSecs),length(orders), ...
        length(phaseOffsets));
	dataLength_rts = zeros(length(dataLengthSecs),length(orders), ...
        length(phaseOffsets));
	start_burg = tic;
	parfor dataLengthSecInd = 1:length(dataLengthSecs)
        dataLengthSec = dataLengthSecs(dataLengthSecInd);
        dataLengthSamples = dataLengthSec*sampleRate;
		order_errors = [];
		order_rts = [];
		for order = orders
			phaseOffset_errors = [];
			phaseOffset_rts = [];
			for phaseOffset = phaseOffsets;
				dataLengthSamples = dataLengthSec*sampleRate;
				osc1 = chan_osc(dataLengthSamples, sampleRate,oscCenter1,'phaseOffset',phaseOffset);
                osc2 = chan_osc(dataLengthSamples, sampleRate,oscCenter2);
                data = osc1+osc2;
                tic
				[S,freqs] = pburg(data,order,nfft,sampleRate, 'onesided');
				phaseOffset_rt = toc;
				phaseOffset_error = peak_det_mse(freqs,S,[oscCenter1,oscCenter2], [1000,1100]);
				phaseOffset_errors = cat(3,phaseOffset_errors,phaseOffset_error);
				phaseOffset_rts = cat(3,phaseOffset_rts, phaseOffset_rt);
			end
			order_errors = cat(2,order_errors,phaseOffset_errors);
			order_rts = cat(2,order_rts, phaseOffset_rts);
        end
        dataLength_errors(dataLengthSecInd,:,:) = order_errors;
		dataLength_rts(dataLengthSecInd,:,:) =  order_rts;
	end
	burg_errors = dataLength_errors;
	burg_rts = dataLength_rts;
	
	save('burg_errors_two.mat','burg_errors');
	save('burg_rts_two.mat','burg_rts');
	burg_run = toc(start_burg);
	['Burg runtime: ', num2str(burg_run)]
end

%% Maximum Entropy Method
if run_mem
	start_mem = tic;
	dataLength_errors = [];
	dataLength_rts = [];
	for dataLengthSec = dataLengthSecs
		dataLengthSamples = dataLengthSec*sampleRate
		order_errors = [];
		order_rts = [];
		orders = 2:10;
		for order = orders
			phaseOffset_errors = [];
			phaseOffset_rts = [];
			for phaseOffset = phaseOffsets;
				osc1 = chan_osc(dataLengthSamples, sampleRate,oscCenter1,'phaseOffset',phaseOffset);
                osc2 = chan_osc(dataLengthSamples, sampleRate,oscCenter2);
                data = osc1+osc2;
                tic
				[S,freqs] = pmem(data,order,nfft,sampleRate, 'onesided');
				phaseOffset_rt = toc;
				phaseOffset_error = peak_det_mse(freqs,S,[oscCenter1,oscCenter2], [1000,1100]);
				phaseOffset_errors = cat(1,phaseOffset_errors,phaseOffset_error);
				phaseOffset_rts = cat(1,phaseOffset_rts, phaseOffset_rt);
			end
			order_errors = cat(2,order_errors,phaseOffset_errors);
			order_rts = cat(2,order_rts, phaseOffset_rts);
		end
		dataLength_errors = cat(3,dataLength_errors, order_errors);
		dataLength_rts = cat(3,dataLength_rts, order_rts);
	end
	mem_errors = dataLength_errors;
	mem_rts = dataLength_rts;
	
	save('mem_errors_two.mat','mem_errors');
	save('mem_rts_two.mat','mem_rts');
	mem_run = toc(start_mem);
	['MEM runtime: ', num2str(mem_run)]
end