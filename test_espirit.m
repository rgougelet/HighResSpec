clear all
dataLengthSec = 100;
sampleRate = 1000;
nyq = sampleRate/2;
sampleSpacing = 1/sampleRate;
oscCenter1 = 11;
o1 = oscCenter1*2*pi*sampleSpacing;
oscCenter2 = 10;
o2 = oscCenter2*2*pi*sampleSpacing;
diffo = mean([oscCenter1,oscCenter2]);
dataLengthSamples = dataLengthSec*sampleRate;
[osc1, t, instAmp, instPhase, instFreq, instNoise] = chan_osc(dataLengthSamples, sampleRate,oscCenter1, 'isNoisy', 1, 'snr', 1000);
% osc2 = chan_osc(dataLengthSamples, sampleRate,oscCenter2);
% data = osc1+osc2;
act_osc = osc1-instNoise;
% close all
% plot(osc1(1:1000),'b'); hold on;
% plot(instNoise(1:1000),'g')
% plot(act_osc(1:1000),'g'); hold on;
% plot((instNoise(1:1000)))
% plot(diff(instNoise(1:1000)))
% plot(diff(act_osc(1:1000)),'r');
nfft = 100*sampleRate;

fft_freqs = linspace(0,nyq,floor(nfft/2)+1);

dataX = fft(diff(osc1),nfft)/dataLengthSamples;
dataX = dataX(1:length(fft_freqs)); %keep only positive frequencies
amp = 2*abs(dataX); hold on;
% n = 4;
% m = 50;
% w=esprit(data,n,m);

% th=linspace(0,2*pi,nfft);
% freqs = (th(1:nfft/2)/sampleSpacing)/(2*pi);
% 
% %%
% spec = (w/sampleSpacing)/(2*pi);
plot(fft_freqs,amp, 'r')

% [S,freqs] = pmusic(diff(osc1),2,nfft,sampleRate, 'onesided');
% plot(freqs,S)

% = (w/samplingInterval)/(2*pi)
%%
% thetamid=diffo*2*pi*samplingInterval;
% th=linspace(0,2*pi,nfft);
% hz = (th/samplingInterval)/(2*pi);
% focal_hz = hz(1000:1100);
% %%
% % [A,B]=cjordan(5,0.88*exp(thetamid*1i));
% [A,B]=cjordan(4,0.99*exp(thetamid*1i));
% R=dlsim_complex(A,B,data); %needs row vector
% rhohalf=envlp(R,A,B,th);
% rho = rhohalf.^2;
% 
% 
% %%
% close all
% figure; hold on;
% line([oscCenter1 oscCenter1],[0,60], 'Color', 'b');
% line([oscCenter2 oscCenter2],[0,60], 'Color', 'b');
% plot(hz,rho)
% % axis([o1*0.9 o2*1.1 0 2.5]);