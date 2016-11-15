function [medianSpectrum , freqs] = med_pwelch(x,winLengthSamples,nOverlap,nfft,Fs )
	stepIndex = 0;
    winStart = 1;
	winStop = winLengthSamples;
	nyquist = Fs/2;
	freqs = linspace(0,nyquist,floor(nfft/2)+1);
	winSpectra = [];
	while (winStart+winLengthSamples-1) < length(x)
		
		win = x(winStart:winStop);

		% detrend
		win = detrend(win, 'linear');

		% window window
		windowedWin = win.*hanning(winLengthSamples)';

		% compute fft
		fftx = fft(windowedWin,nfft);
		amp = abs(fftx(1:length(freqs)));
		winSpectra = [winSpectra;amp];
		
		stepIndex = stepIndex+1;
		winStart = stepIndex*nOverlap+1;
		winStop = winStart + winLengthSamples-1;
		
	end
	medianSpectrum = median(winSpectra,1);
end