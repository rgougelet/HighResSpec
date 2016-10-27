% demo: scatter plots comparing sm with music and espirit
%       it shows that the variance of the sm-estimates is
%       superior to the other two.
%
% simulation example from sesha2 page 38

clear, close all

f1=10.52;
f2=10.56;
srate=1024; 
o1 = f1*(2*pi)/srate;
o2 = f2*(2*pi)/srate;
N=srate*10;

% old way of creating signal
% k=0:N-1; k=k(:);
% mag1=1; mag2=1;
% y=mag1*sin(o1*k)+mag2*sin(o2*k);
% figure;
% plot(y);

% drawing the target frequency1 vs frequency2 for the subsequently generated
% scatter diagrams
figure(1);
subplot(3,1,1), plot(o1,o2,'rx','MarkerSize',12),  hold on,
subplot(3,1,2), plot(o1,o2,'rx','MarkerSize',12),  hold on,
subplot(3,1,3), plot(o1,o2,'rx','MarkerSize',12),  hold on,

% calculate error boundaries
o1min = o1-0.1*o1;
o2min = o2-0.1*o2;
o1max = o1+0.1*o1;
o2max = o2+0.1*o2;

n=4; % predicted number of lines in spectra + 2
m=30; % model order for music and epsirit
neigs = 16; % num of eig vals for IS method
eigv_mag = 0.99; % mag of eig vals for IS method

IS_count=0;
MUSIC_count=0;
ESPRIT_count=0;
for i=1%:100
    
    % new way of creating signal
%     osc1 = chan_osc(N,srate,10.52,'isNoisy', 1);
    osc1 = chan_osc(N,srate,f1,'isNoisy', 0);
    osc2 = chan_osc(N,srate,f2);
    y = (osc1+osc2);
    y = y';
%     y = hilbert(y);
    % figure;
    % plot(y);
    
    warning('off','all')
    
    % estimating sinusoids per music
    omusic=music(y,n,m); % expects col vector
    omusic=omusic(omusic>=0);
    omusic=sort(omusic);
    omusic=omusic(end-1:end);
    if(omusic(1)>o1min && omusic(1)<o1max && omusic(2)>o2min && omusic(2)<o2max)
        MUSIC_count=MUSIC_count+1;
    end
    o1_music_error = omusic(1)-o1;
    o2_music_error = omusic(2)-o2;
    music_mse = (o1_music_error^2 + o2_music_error^2)/2;
    
    % estimating sinusoids per espirit
    oespirit=esprit(y,n,m); % expects col vector
    oespirit=oespirit(oespirit>=0);
    oespirit=sort(oespirit);
    oespirit=oespirit(end-1:end);
    if(oespirit(1)>o1min && oespirit(1)<o1max && oespirit(2)>o2min && oespirit(2)<o2max)
        ESPRIT_count=ESPRIT_count+1;
    end
    o1_espirit_error = oespirit(1)-o1;
    o2_espirit_error = oespirit(2)-o2;
    espirit_mse = (o1_espirit_error^2 + o2_espirit_error^2)/2;
    
    % IS-based estimation
    diff = abs(o2-o1);
    thetamid=(min(o1,o2)+diff/2);
    [Ah,bh]=cjordan(neigs,eigv_mag*exp(thetamid*1j));
    P=dlsim_complex(Ah,bh,y'); % expects row vector
    [omega_ss,residues_ss]=sm(P,Ah,bh,n);
    omega_ss=omega_ss(omega_ss<pi);
    omega_ss=sort(omega_ss);omega_ss=omega_ss(end-1:end);
    if(omega_ss(1)>o1min && omega_ss(1)<o1max && omega_ss(2)>o2min && omega_ss(2)<o2max)
        IS_count=IS_count+1;
    end
    o1_ss_error = omega_ss(1)-o1;
    o2_ss_error = omega_ss(2)-o2;
    ss_mse = (o1_ss_error^2 + o2_ss_error^2)/2;
    
    % maximum entropy spectrum and Burg spectrum
%     NN=1024*10; 
%     th=linspace(0,2*pi,NN);
%     th = 0:round(diff,4):2*pi;
    th = 0:0.01:2*pi;
    NN = length(th);
    me_spectrum=me(P,Ah,bh,th);
    figure;
%      me_shifted = fftshift(me_spectrum);
%      plot(th,me_shifted);
    plot(th,me_spectrum);
%     me_burg=pburg(y,5,th);
%     hold on;
%     figure;
%     plot(th,me_burg);
   
    figure(1)
    subplot(3,1,1), plot(omega_ss(1),omega_ss(2),'o'),
    subplot(3,1,2), plot(omusic(1),omusic(2),'o'),
    subplot(3,1,3), plot(oespirit(1),oespirit(2),'o'),
    
    [music_mse, espirit_mse, ss_mse]
end

figure(1)
subplot(3,1,1), axis([o1min o1max o2min o2max]); hold on,  legend('sm')
subplot(3,1,2), axis([o1min o1max o2min o2max]); hold on,  legend('music')
subplot(3,1,3), axis([o1min o1max o2min o2max]); hold on,  legend('espirit')