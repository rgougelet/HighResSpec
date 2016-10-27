clear all
close all
%% MUSIC

Fs = 1000;      %sampline frequency
T = 1/Fs;       %sampling period
L = 1000;       %length of the signal
t = (0:L-1)*T;  %time vector
Signal = sin(2*pi*t);
alpha = linspace(0,2*pi,2000);
alphaWave = sin(10*pi*alpha);
fou = fft(alphaWave);
fftsignal = fftshift(fou);
% frequency = length(transpose(aplha))/2*linspace(-1,1,2000);
pmusic(alphaWave,2)
% w = 57.2958*pi*w;
% S = pi*S;

% figure(1);
% plot(w,S);
% title('MUSIC Algorithm');
% xlabel('Normalized Frequency ( x pi rad/sample)');
% ylabel('Power Spectral Density (PSD)');
% 
% figure(2);
% plot(1000*linspace(-1,1,2000),abs(fftsignal));
% plot(alphaWave);

%% Example
%{
%Define number of samples to take
fs = 8000;
f = 400; %Hz

%Define signal
t = 0:1/fs:1-1/fs;
signal = sin(2*pi*f*t);

%Plot to illustrate that it is a sine wave
plot(t, signal);
title('Time-Domain signal');

%Take fourier transform
fftSignal = fft(signal);

%apply fftshift to put it in the form we are used to (see documentation)
fftSignal = fftshift(fftSignal);

%Next, calculate the frequency axis, which is defined by the sampling rate
f = fs/2*linspace(-1,1,fs);

%Since the signal is complex, we need to plot the magnitude to get it to
%look right, so we use abs (absolute value)
figure;
plot(f, abs(fftSignal));
title('magnitude FFT of sine');
xlabel('Frequency (Hz)');
ylabel('magnitude');

%noise
noise = 2*randn(size(signal));
figure, plot(t,noise), title('Time-Domain Noise');
fftNoise = fft(noise);
fftNoise = fftshift(fftNoise);
figure, plot(f,abs(fftNoise)), title('Magnitude FFT of noise');
xlabel('Frequency (Hz)');
ylabel('magnitude');

%noisy signal
noisySignal = signal + noise;
figure, plot(t,noisySignal), title('Time-Domain Noisy Signal');
fftNoisySignal = fft(noisySignal);
fftNoisySignal = fftshift(fftNoisySignal);
figure, plot(f,abs(fftNoisySignal)), title('Magnitude FFT of noisy signal');
xlabel('Frequency (Hz)');
ylabel('magnitude');
%}

%% MUSIC example

% Complex Signal Example
n=0:99;   
s=exp(1i*pi/2*n)+2*exp(1i*pi/4*n)+exp(1i*pi/3*n)+randn(1,100);  
X=corrmtx(s,12,'mod');   % Estimate the correlation matrix using the modified covariance method.
pmusic(X,3,'whole')      % Uses the default NFFT of 256.

% Real Signal Example
n=0:99; figure;
s2=sin(pi/3*n)+2*sin(pi/4*n)+randn(1,100);
plot(n, s2), xlabel('Time'), ylabel('Amplitude'), title('Real Signal');
X2=corrmtx(s2,20,'cov'); % Estimate the correlation matrix using the covariance method.   
figure;
pmusic(X2,4,'whole')     % Use twice the signal space dimension for real sinusoids.
  

% %% Real Signal Modified - only works until 2.0
% n=0:500; figure;
% s2=sin(pi*1.8*n);
% plot(n, s2), xlabel('Time'), ylabel('Amplitude'), title('Real Signal');
% X2=corrmtx(s2,20,'cov'); % Estimate the correlation matrix using the covariance method.   
% figure;
% pmusic(X2,4,'whole')     % Use twice the signal space dimension for real sinusoids.
  
%%
% n = 0:199;
% x = cos(0.257*pi*n) + sin(0.2*pi*n) + 0.01*randn(size(n));
clc
close all
dataLengthSecs = 0.01; % plot error as function of this
sampleRate = 1000;
dataLengthSamples = dataLengthSecs*sampleRate; % hard coded 
nfft = 100*sampleRate; % hard coded 
osc1Center = 10.52;
osc2Center = 10.54;
phaseOffset = pi/2;
osc1 = chan_osc(dataLengthSamples, sampleRate,osc1Center,'phaseOffset',phaseOffset, 'isNoisy', 0.005);
osc2 = chan_osc(dataLengthSamples, sampleRate,osc2Center,'phaseOffset',phaseOffset, 'isNoisy', 0.005);
data = osc1+osc2;
plot(1:dataLengthSamples, data), xlabel('Time'), ylabel('Amplitude'), title('Real Signal');
figure;
[S, f] = pmusic(data, 4, nfft, 1000, 'onesided');      % Set p to 4 because there are two real inputs
plot(f,S)
[mse, maxFreqs] = performanceMat(f,S,[osc1Center,osc2Center])



%% Graph MUSIC MSE Over Data Length Seconds
clc
close all

dataLengthSecs = [0.01 0.02 0.03 0.04 0.05 0.06 0.07 0.08 0.09 0.1];
sampleRate = 1000;
osc1Center = 10.52;
osc2Center = 10.54;
phaseOffset = pi/2;
nfft = 100*sampleRate; % hard coded 
    
music_errors = [];


for i = 1:numel(dataLengthSecs)
    sec = dataLengthSecs(i);
    dataLengthSamples = sec*sampleRate;
    osc1 = chan_osc(dataLengthSamples, sampleRate,osc1Center,'phaseOffset',phaseOffset);
    osc2 = chan_osc(dataLengthSamples, sampleRate,osc2Center,'phaseOffset',phaseOffset);
    data = osc1+osc2;
    [S, f] = pmusic(data, 4, nfft, 1000, 'onesided');      % Set p to 4 because there are two real inputs
    [mse, maxFreqs] = performanceMat(f,S,[osc1Center,osc2Center]);
    music_errors(end+1) = mse;
end

plot(dataLengthSecs,music_errors), xlabel('Data Length Seconds'), ylabel('Mean Square Error'), title('MUSIC MSE Over Data Length Seconds');


% REGINA Save output matrix for mse
% save('music_errors.mat','music_errors');


% rng default
% n = 0:199;
% x = cos(0.257*pi*n) + sin(0.2*pi*n) + 0.01*randn(size(n));
% [P,f] = pmusic(x,[Inf,1.1],[],8000,7); % Window length = 7
% plot(f,20*log10(abs(P)))
% xlabel 'Frequency (Hz)', ylabel 'Power (dB)'
% title 'Pseudospectrum Estimate via MUSIC', grid on
% 

% figure;
% Fs = 10;      %sampline frequency
% T = 1/Fs;       %sampling period
% L = 1000;       %length of the signal
% t = (0:L-1)*T;  %time vector
% alpha = linspace(0,2*pi,2000);
% alphaWave = sin(10*pi*alpha);
% X3=corrmtx(alphaWave,6,'mod');   % Estimate the correlation matrix using
% pmusic(alphaWave,2, 'whole')

 
%% ESPRIT example - only works for theta1 <=6.2 for some reason

%  SIGNAL = sinusoids + noise
%  Setting up the signal parameters and time history
N=100;
a0=1.8; a1=1.5; theta1=6.2; a2=2; theta2=1.35;
k=1:N; k=k(:);
% ESPRIT is translational invariant since the phase change (+2*pi*rand)
% does not affect the parameter estimation
% y=a0*randn(N,1)+a1*exp(1i*(theta1*k+2*pi*rand))+a2*exp(1i*(theta2*k+2*pi*rand));
y=exp(1i*(theta1*k));

% subspace method
thetamid=1.325;

[A,B]=cjordan(5,0.88*exp(thetamid*1i));

R=dlsim_complex(A,B,y');


[thetas,residues]=sm(R,A,B,2);
% Arrowb(thetas,residues); hold on;
Ac=compan(eye(1,6));
Bc=eye(5,1);
That=dlsim_complex(Ac,Bc,y'); 
[th_esprit,r_esprit]=sm(That,Ac,Bc,2); % ESPRIT spectral lines
Arrowg(th_esprit,r_esprit);
