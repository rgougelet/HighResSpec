%% demo: compares fft-based estimation with high resolution
%               1) spectral envelopes, 
%               2) subspace methods, and
%               3) maximum entropy
%
% the term "high resolution" refers to a "tuned-analog" of
% modern nonlinear methods (Capon, subspace, ME) where the
% covariance information used consists of the state-covariance
% of suitably selected "bandpass-like" input-to-state filter


%% SIGNAL = sinusoids + noise
%  Setting up the signal parameters and time history
    close all, clear, clc
    f1=10.52;
    f2=10.56;
    srate=1024; 
    o1 = f1*(2*pi)/srate;
    o2 = f2*(2*pi)/srate;
    N=1024*10;
    mag0=1.8;
    mag1=1.5; 
    mag2=2;
    t=0:N-1; t=t(:);
%     y=mag1*sin(o1*t)+mag2*sin(o2*t);
    osc1 = chan_osc(N,srate,f1,'isNoisy', 0);
    osc2 = chan_osc(N,srate,f2);
    y = (osc1+osc2);
%     y = y';
%     y=mag0*randn(N,1)+mag1*sin(o1*t+2*pi*rand)+mag2*sin(o2*t+2*pi*rand);
%     plot(y);
    
%     y = hilbert(y);
    diffo = mean([o1,o2]);
%     y = y';

%% Original demo
%% SIGNAL = sinusoids + noise
%  Setting up the signal parameters and time history
      N=100;
      mag0=1.8;mag1=1.5; o1=1.3; mag2=2; o2=1.35;
      t=0:N-1; t=t(:);
      y=mag0*randn(N,1)+mag1*exp(1i*(o1*t+2*pi*rand))+mag2*exp(1i*(o2*t+2*pi*rand));
      diffo = mean([o1,o2]);
%% plotting the fft-based spectra
NN=2048; th=linspace(0,2*pi,NN);
Y =abs(fft(y,NN))/sqrt(N);
Y =Y.^2;
Y = Y/max(Y)*1.3;
figure(1);
subplot(1,2,1),hold on
                plot(o1, mag1, 'r^','MarkerSize',12);
                plot(th,Y,'Color',[0,0.6,0],'LineWidth',1.2),
                legend('true spectral line', 'FFT-based');
                plot(o2, mag2, 'r^','MarkerSize',12);
                line([o1 o1],[0,mag1]);
                line([o2 o2],[0,mag2]);
                Arrow([o1 0],[o1,mag1]);
                set(gca,'xlim',[0 2*pi]);
                set(gca,'ylim',[0 2.5]);              
                set(gca,'YTick',[]);
                xlabel('frequency','FontSize',14);

subplot(1,2,2),hold on
               plot(o1, mag1, 'r^','MarkerSize',12);
               plot(th,Y,'Color',[0,0.6,0],'LineWidth',1.2),
               legend('true spectral line', 'FFT-based');
               plot(o2, mag2, 'r^','MarkerSize',12);
               line([o1 o1],[0,mag1]);
               line([o2 o2],[0,mag2]);
               axis([o1*0.9 o2*1.1 0 2.5]);
               set(gca,'YTick',[]);
               xlabel('frequency','FontSize',14);

%% plotting the fft-based spectra
NN=N; th=linspace(0,2*pi,N);
Y =abs(fft(y,NN))/sqrt(N);
Y =Y.^2;
Y = Y/max(Y)*1.3;
figure(1);
subplot(1,2,1),hold on
                plot(o1, mag1, 'r^','MarkerSize',12);
                plot(th,Y,'Color',[0,0.6,0],'LineWidth',1.2),
                legend('true spectral line', 'FFT-based');
                plot(o2, mag2, 'r^','MarkerSize',12);
                line([o1 o1],[0,mag1]);
                line([o2 o2],[0,mag2]);
                %Arrow([o1 0],[o1,mag1]);
                set(gca,'xlim',[0 2*pi]);
                set(gca,'ylim',[0 2.5]);              
                set(gca,'YTick',[]);
                xlabel('frequency','FontSize',14);

subplot(1,2,2),hold on
               plot(o1, mag1, 'r^','MarkerSize',12);
               plot(th,Y,'Color',[0,0.6,0],'LineWidth',1.2),
               legend('true spectral line', 'FFT-based');
               plot(o2, mag2, 'r^','MarkerSize',12);
               line([o1 o1],[0,mag1]);
               line([o2 o2],[0,mag2]);
               axis([o1*0.9 o2*1.1 0 2.5]);
               set(gca,'YTick',[]);
               xlabel('frequency','FontSize',14);


%% setting up filter parameters and the svd of the input-to-state response
thetamid=diffo; 
% [A,B]=cjordan(5,0.88*exp(thetamid*1i));
[A,B]=cjordan(8,0.9*exp(thetamid*1i));
sv=Rsigma(A,B,th);
figure(2);
plot(th(:),sv(:),'r','LineWidth',1.3); hold on;
[svmax, maxind]=max(sv);
sv3db=svmax*sqrt(2)/2; % -3db value
[vmin, th_min_ind]=min(abs(sv(1:maxind)-sv3db));
thmin=th(th_min_ind);
[vmax, th_max_ind]=min(abs(sv(maxind+1:end)-sv3db));
th_max_ind=th_max_ind+maxind;
thmax=th(th_max_ind);
plot([thmin thmin], [0 sv3db],'k','LineWidth',1.3);
plot([thmax thmax], [0 sv3db],'k','LineWidth',1.3);

for v=0:.4:sv3db
    h1 = thmin;
    h2 = thmax;
    if(v<h1)
        plot([h1-v h1],[0 v],'Color',[.5,.5,.5]);
    else
        plot([0 h1],[v-h1 v],'Color',[.5,.5,.5]);
    end
    if(v+h2<2*pi)
        plot([h2 h2+v],[v 0],'Color',[.5,.5,.5]);
    else
        plot([h2 2*pi],[v v+h2-2*pi],'Color',[.5,.5,.5]);
    end
end
axis([0 2*pi 0 svmax+1])
set(gca,'YTick',[]);
xlabel('$\|G(e^{i\theta})\|$ v.s. $\theta$', 'Interpreter', 'Latex','FontSize', 16);

%% obtaining state statistics
R=dlsim_complex(A,B,y); %needs row vector
%% maximum entropy
figure(3);
spectrum=me(R,A,B,th);
me_burg = pburg(y,5,th); %needs row vector
me_burg = me_burg/max(me_burg)*1.2;
spectrum=spectrum/max(spectrum)*1.2;
subplot(1,2,1),hold on
                plot(o1, mag1, 'r^','MarkerSize',12);
                plot(th,Y,'Color','c','LineWidth',1.2);
                plot(th, spectrum,'b','LineWidth',1.2);
                plot(th, me_burg,'Color',[0,0.6,0],'LineWidth',1.2);
                legend('true spectral line', 'fft', 'maximum entropy spectrum', 'Burg method');
                
                plot(o2, mag2, 'r^','MarkerSize',12);
                line([o1 o1],[0,mag1]);
                line([o2 o2],[0,mag2]);
                set(gca,'xlim',[0 2*pi]);
                set(gca,'ylim',[0 2.5]);
                k=15;
                windowspec=max(spectrum)/2;
                plot([thmin thmin], [0 windowspec],'k','LineWidth',1.3);
                plot([thmax thmax], [0 windowspec],'k','LineWidth',1.3);
                for v=0:windowspec/10:windowspec
                    h1 = thmin;
                    h2 = thmax;
                    if(k*v<h1)
                        plot([h1-k*v h1],[0 v],'Color',[.5,.5,.5]);
                    else
                        plot([0 h1],[v-h1/k v],'Color',[.5,.5,.5]);
                    end
                    if(k*v+h2<2*pi)
                        plot([h2 h2+k*v],[v 0],'Color',[.5,.5,.5]);
                    else
                        plot([h2 2*pi],[v v-(-h2+2*pi)/k],'Color',[.5,.5,.5]);
                    end
                end
                
                set(gca,'YTick',[]);
                xlabel('frequency','FontSize',14);
                

subplot(1,2,2),hold on
                plot(o1, mag1, 'r^','MarkerSize',12);
                plot(th,Y,'Color','c','LineWidth',1.2);
                plot(th,spectrum,'b','LineWidth',1.2);
                plot(th, me_burg,'Color',[0,0.6,0],'LineWidth',1.2);
                legend('true spectral line', 'fft', 'maximum entropy spectrum', 'Burg method');
                plot(o2, mag2, 'r^','MarkerSize',12);
                line([o1 o1],[0,mag1]);
                line([o2 o2],[0,mag2]);
                axis([o1*0.9 o2*1.1 0 2.5]);
                set(gca,'YTick',[]);
                xlabel('frequency','FontSize',14);
  
              
%% subspace method
figure(4);
[omegas,residues]=sm(R,A,B,2);
Ac=compan(eye(1,6));
Bc=eye(5,1);
That=dlsim_complex(Ac,Bc,y); % expects row vector
[w_esprit,r_esprit]=sm(That,Ac,Bc,2);
residues=residues*1.6;
r_esprit=r_esprit*.65;
subplot(1,2,1),hold on
               plot(o1, mag1, 'r^','MarkerSize',12);
               plot(omegas(1), residues(1), 'b^','MarkerSize',12);
               plot(w_esprit(1), r_esprit(1),'g^','Color',[0,0.6,0],'MarkerSize',12);
               
               legend('true spectral line', 'subspace method spectral line', 'ESPRIT spectral line');

               plot(o2, mag2, 'r^','MarkerSize',12);
               plot(omegas(2), residues(2), 'b^','MarkerSize',12);
               plot(w_esprit(2), r_esprit(2),'g^','Color',[0,0.6,0],'MarkerSize',12);
               
               
               line([o1 o1],[0,mag1], 'Color', 'r');
               line([omegas(1) omegas(1)], [0 residues(1)], 'Color', 'b')
               line([w_esprit(1) w_esprit(1)], [0 r_esprit(1)], 'Color', 'g')
               
               line([o2 o2],[0,mag2], 'Color', 'r');
               line([omegas(2) omegas(2)], [0 residues(2)], 'Color', 'b')
               line([w_esprit(2) w_esprit(2)], [0 r_esprit(2)], 'Color', 'g')  
               
                k=15;
                windowspec=max(spectrum)/2;
                plot([thmin thmin], [0 windowspec],'k','LineWidth',1.3);
                plot([thmax thmax], [0 windowspec],'k','LineWidth',1.3);
                for v=0:windowspec/10:windowspec
                    h1 = thmin;
                    h2 = thmax;
                    if(k*v<h1)
                        plot([h1-k*v h1],[0 v],'Color',[.5,.5,.5]);
                    else
                        plot([0 h1],[v-h1/k v],'Color',[.5,.5,.5]);
                    end
                    if(k*v+h2<2*pi)
                        plot([h2 h2+k*v],[v 0],'Color',[.5,.5,.5]);
                    else
                        plot([h2 2*pi],[v v-(-h2+2*pi)/k],'Color',[.5,.5,.5]);
                    end
                end
               set(gca,'xlim',[0 2*pi]);
               set(gca,'ylim',[0 2.5]),
               set(gca,'YTick',[]);
               xlabel('frequency','FontSize',14);

subplot(1,2,2),hold on
               plot(o1, mag1, 'r^','MarkerSize',12);
               plot(omegas(1), residues(1), 'b^','MarkerSize',12);
               plot(w_esprit(1), r_esprit(1),'g^','Color',[0,0.6,0],'MarkerSize',12);
               
               legend('true spectral line', 'subspace method spectral line', 'ESPRIT spectral line');

               plot(o2, mag2, 'r^','MarkerSize',12);
               plot(omegas(2), residues(2), 'b^','MarkerSize',12);
               plot(w_esprit(2), r_esprit(2),'g^','Color',[0,0.6,0],'MarkerSize',12);
               
               
               line([o1 o1],[0,mag1], 'Color', 'r');
               line([omegas(1) omegas(1)], [0 residues(1)], 'Color', 'b')
               line([w_esprit(1) w_esprit(1)], [0 r_esprit(1)], 'Color', 'g')
               
               line([o2 o2],[0,mag2], 'Color', 'r');
               line([omegas(2) omegas(2)], [0 residues(2)], 'Color', 'b')
               line([w_esprit(2) w_esprit(2)], [0 r_esprit(2)], 'Color', 'g')  
               
               axis([o1*0.9 o2*1.1 0 2.5]);
               set(gca,'YTick',[]);
               xlabel('frequency','FontSize',14);
               
 %% spectral evelop% sqrtrho=envlp(P,Ah,bh,th,.2);
figure(5);
rhohalf=envlp(R,A,B,th);
rho = rhohalf.^2;
subplot(1,2,1),hold on
               plot(o1, mag1, 'r^','MarkerSize',12);
               plot(th,rho,'b','LineWidth',1.2),
               legend('true spectral line', 'spectral envelop');
               plot(o2, mag2, 'r^','MarkerSize',12);
               
               line([o1 o1],[0,mag1], 'Color', 'r');
               line([o2 o2],[0,mag2], 'Color', 'r');
               k=1;
                windowspec=max(rho);
                plot([thmin thmin], [0 windowspec],'k','LineWidth',1.3);
                plot([thmax thmax], [0 windowspec],'k','LineWidth',1.3);
                for v=0:windowspec/20:windowspec
                    h1 = thmin;
                    h2 = thmax;
                    if(k*v<h1)
                        plot([h1-k*v h1],[0 v],'Color',[.5,.5,.5]);
                    else
                        plot([0 h1],[v-h1/k v],'Color',[.5,.5,.5]);
                    end
                    if(k*v+h2<2*pi)
                        plot([h2 h2+k*v],[v 0],'Color',[.5,.5,.5]);
                    else
                        plot([h2 2*pi],[v v-(-h2+2*pi)/k],'Color',[.5,.5,.5]);
                    end
                end
               set(gca,'xlim',[0 2*pi]),
               set(gca,'ylim',[0 max(rho)+10]),
               set(gca,'YTick',[]);
               xlabel('frequency','FontSize',14);
               
subplot(1,2,2),hold on
               plot(o1, mag1, 'r^','MarkerSize',12);
               plot(th,rho,'b','LineWidth',1.2),
               legend('true spectral line', 'spectral envelop');
               plot(o2, mag2, 'r^','MarkerSize',12);
               
               line([o1 o1],[0,mag1], 'Color', 'r');
               line([o2 o2],[0,mag2], 'Color', 'r');

               axis([o1*0.9 o2*1.1 0 2.5]);
               set(gca,'YTick',[]);
               xlabel('frequency','FontSize',14);
%% moving average decomposition
% T=ToepProj(That);
% [Ts, Tma]=MA_decomp(T,1);
% r_ma=[fliplr(Tma(1,:)) Tma(1,2:end)];
% p_ma=abs(fft(r_ma,length(th)));
% [w_s,r_s]=sm(Ts,Ac,Bc,rank(Ts,0.001));
% figure(6);clf
% 
% subplot(1,2,1),hold on
%                plot(o1, mag1, 'r^','MarkerSize',12);
%                plot(w_s(1), r_s(1), 'b^','MarkerSize',12);
%                plot(th,p_ma,'Color',[0,0.6,0],'LineWidth',1.2);
%                legend('true spectral line', 'estimated spectral line', 'MA spectrum');
%                
%                line([o1 o1],[0,mag1], 'Color', 'r');
%                line([o2 o2],[0,mag2], 'Color', 'r');
%                
%                line([w_s(1) r_s(1)], [0 residues(1)], 'Color', 'b')
%                line([th th], [0 p_ma], 'Color', 'g')
%                
%                k=15;
%                windowspec=max(spectrum)/2;
%                plot([thmin thmin], [0 windowspec],'k','LineWidth',1.3);
%                plot([thmax thmax], [0 windowspec],'k','LineWidth',1.3);
%                for v=0:windowspec/10:windowspec
%                     h1 = thmin;
%                     h2 = thmax;
%                     if(k*v<h1)
%                         plot([h1-k*v h1],[0 v],'Color',[.5,.5,.5]);
%                     else
%                         plot([0 h1],[v-h1/k v],'Color',[.5,.5,.5]);
%                     end
%                     if(k*v+h2<2*pi)
%                         plot([h2 h2+k*v],[v 0],'Color',[.5,.5,.5]);
%                     else
%                         plot([h2 2*pi],[v v-(-h2+2*pi)/k],'Color',[.5,.5,.5]);
%                     end
%                 end
%                set(gca,'xlim',[0 2*pi]);
%                set(gca,'ylim',[0 5]),
%                set(gca,'YTick',[]);
%                xlabel('frequency','FontSize',14);
% 
% subplot(1,2,2),hold on
%                plot(o1, mag1, 'r^','MarkerSize',12);
%                plot(w_s(1), r_s(1), 'b^','MarkerSize',12);
%                legend('true spectral line', 'estimated spectral line');
%                arrow([o1 o2], [mag1 mag2],12);
%                arrowb(w_s,r_s,12);
%                axis([thmin thmax 0 3]);
%                set(gca,'YTick',[]);
%                XLabel('frequency','FontSize',14);
