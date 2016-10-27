clear
close all

%% frequency parameters
dataLength_dls = 5;
med_welch_dls = 5;
pll_dls = 5;
music_dls = 5;
espirit_dls = 5;
max_ent_dls = 5;
burg_dls = 5;
spec_env_dls = 5;

oscCenter1 = 10.52; % hard coded 
oscCenter2 = 10.54; % hard coded
sampleRate = 1000; % hard coded
nyq = sampleRate/2;
sampleSpacing = 1/sampleRate;
phaseOffsets = 0:0.1:2*pi; % hard coded
dataLengthGens = 1:11;
dataLengths = (0.05*2.^dataLengthGens); % in seconds hard coded
plot(dataLengths)
nfft = 100*sampleRate;

%% FFT
dataLength_errors= [];
dataLength_rts = [];
for dataLengthSecs = dataLengths;
	phaseOffset_errors = [];
	phaseOffset_dls = [];
	for phaseOffset = phaseOffsets;
		dataLengthSamples = dataLengthSecs*sampleRate;
		osc1 = chan_osc(dataLengthSamples, sampleRate,oscCenter1,'phaseOffset',phaseOffset);
		osc2 = chan_osc(dataLengthSamples, sampleRate,oscCenter2);
		data = osc1+osc2;
		t = 0:sampleSpacing:(dataLengthSecs-sampleSpacing);
		fft_freqs = linspace(0,nyq,floor(nfft/2)+1);
		
		tic
		dataX = fft(data,nfft)/dataLengthSamples;
		dataX = dataX(1:length(fft_freqs)); %keep only positive frequencies
		phaseOffset_rt = toc;
		amp = 2*abs(dataX);
		phaseOffset_error = peak_det_mse(fft_freqs,amp,[oscCenter1,oscCenter2]);
		
		phaseOffset_errors = [phaseOffset_errors phaseOffset_error];
		phaseOffset_dls = [phaseOffset_dls phaseOffset_rt];
		
		%     plot(fft_f,2*abs(dataX))
		%     xlim([10.5 10.56])
		%     ylabel('Amplitude')
		%     title(['Data Length = ', num2str(fft_dls),' sec'])
		%     pause(0.5)
	end
	
	% (length(fft_dls)) x (length(phaseOffsets)) matrix
	dataLength_errors = [dataLength_errors; mean(phaseOffset_errors)];
	dataLength_rts = [dataLength_rts; mean(phaseOffset_dls)];
end

% REGINA Save output matrix, fft_errors and fft_rts
save('fft_errors.mat','fft_errors');
save('fft_rts.mat','fft_rts');


close all
figure;
plot(fft_dls,dataLength_errors);
% figure;
% plot(fft_dls,fft_rts);

%% Welch
% figure;
dataLength_errors = []; % length is equal to length(welch_dls)
dataLength_rts = []; % length is equal to length(welch_dls)
dataLength_wls = []; % length is equal to length(welch_dls)
nfft = 100*sampleRate; %hard coded

% For each data length
	% For each windowlength
		% For each nOverlap
			% For each phaseoffset
			% Store error for each phaseoffset
		% Store error for each nOverlap
	% Store error for each windowlength
% Store error for data length

for dataLengthSecs = dataLengths % defined for all methods at the top
	dataLengthSamples = dataLengthSecs*sampleRate;
	windowLength_errors = []; % length equal to length(dls_wls)
	windowLength_rts = []; % length equal to length(dls_wls)
	nWindowLengths = 1:128:dataLengthSamples;
	
	for nWindowLength = nWindowLengths;
		phaseOffset_errors = [];
		phaseOffset_rts = [];
		for phaseOffset = phaseOffsets % defined for all methods at the top
			nOverlap_errors = [];
			nOverlap_rts = [];
			osc1 = chan_osc(dataLengthSamples, sampleRate,oscCenter1,'phaseOffset',phaseOffset);
			osc2 = chan_osc(dataLengthSamples, sampleRate,oscCenter2);
			data = osc1+osc2;
			for nOverlap = nOverlaps
				tic
				[pow, welch_f] = pwelch(data,nWindowLength,nOverlap,nfft,sampleRate, 'power', 'onesided');
				nOverlap_rt = toc;
				amp = sqrt(pow);
				nOverlap_error = peak_det_mse(welch_f,amp,[oscCenter1,oscCenter2]);
				nOverlap_errors = [nOverlap_errors nOverlap_error];
				nOverlap_rts= [nOverlap_rts nOverlap_rt];
			end
			phaseOffset_errors = [phaseOffset_errors mean(nOverlap_errors)];
			phaseOffset_rts = [phaseOffset_rts mean(nOverlap_rts)];
		end
		windowLength_errors = [windowLength_errors mean(phaseOffset_errors)];
		windowLength_rts = [windowLength_rts mean(phaseOffset_rts)];
	end
	dataLength_errors = [dataLength_errors mean(windowLength_errors)];
	dataLength_rts= [dataLength_rts mean(windowLength_rts)];
end

save('dataLength_errors.mat','dataLength_errors');
save('dataLength_rts.mat','dataLength_rts');
close all
figure;
plot(dataLengths,dataLength_errors);
%%
close all
figure;
% plot(fft_errors);
%plot(fft_dls,fft_errors);
%hold on; plot(welch_dls,welch_errors);


% legend('FFT','Welch')
% figure;
% plot(welch_rts);

%% Regina
% plot FFT vs Welch on the same plot, save the figures, use full range of
% values, 1:0.25:200. Also plot wls for welch, or figure out trend.

%%
% pmusic(data,4,nfft,sampleRate)
%             FFTX = [];
%             for olp=overlapPercent
%                 stepsize = (1-olp)*windowLengthSamples;
%                 maxK=dataLengthSamples/stepsize-1;
%                 for K = 0:maxK-1
%                     U = sum(hamming(nfft))/nfft;
%                     startwin = stepsize*K + 1;
%                     endwin = stepsize*K + windowLengthSamples;
%                     FFTK = fft(hamming(nfft)'.*data(startwin:endwin));
%                     magFFTK = (1/(windowLengthSamples*U))*abs(FFTK).^2; %Normalize
%                     phaFFTK = angle(FFTK);
%                     dbFFTK = 20*log10(magFFTK);
%                     dbFFTK = dbFFTK - max(dbFFTK);
%                     dbFFTK = dbFFTK./maxK; %Average
%                     FFTX = [FFTX dbFFTK];
%                 end
%             end
%             welch_f= linspace(-.5,.5,nfft);
%overlapSecs = 0;
%nOverlap = overlapSecs*sampleRate;
%             amp = sqrt(FFTX);

				%     plot(welch_f,amp);
				%     xlim([10.5 10.56])
				%     ylabel('Amplitude')
				%     title(['Data Length = ', num2str(welch_dls),' sec'])
				%     pause(0.25)