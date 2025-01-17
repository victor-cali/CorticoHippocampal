%% Figures for Lisa's experiment.  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%STUDENT: Ramiro Adrian Aleman Zapata. Master Student @ TU Eindhoven. 
%ADVISOR: Francesco Battaglia. Donders Institute of Brain, Cognition and
%Behaviour. Radboud University. 
%2017
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% INPUT DATA:
% 32 Channels of brain signals were recorded over a period of 4 hours with a sampling frequency of
% 20kHz for different tasks that involved learning, memory and sleep. Each of the channels
% corresponded to a different brain area, of which we are mainly interested in the Prefrontal Cortex
% (PFC), the Parietal lobe and the Hippocampus (Channels 9, 12 and 17 for Rat #26).


% REQUIRED FUNCTIONS:
%load_open_ephys_data_faster()
%And more to come
%% LOADING DATA OF 2 MAIN CHANNELS AND REFERENCE
fs=20000; %Sampling frequency of acquisition.  
addingpath(1);
% addpath('/home/raleman/Documents/MATLAB/analysis-tools-master')  
% addpath('/home/raleman/Documents/GitHub/CorticoHippocampal')  
% addpath('/home/raleman/Documents/internship')  
acer=1;
%%
num=1;
data_lisa(num,acer)
%%
num=2;
data_lisa(num,acer)
%%
num=3;
data_lisa(num,acer)
%%
num=4;
data_lisa(num,acer)
%%
% num=5;
% data_lisa(num,acer)

%%


%%
if acer~=1
cd('/media/raleman/My Book/ObjectSpace/rat_1/study_day_2_OR/post_trial1_2017-09-25_11-26-43');
else
cd('F:/ObjectSpace/rat_1/study_day_2_OR/post_trial1_2017-09-25_11-26-43');    
end

[data9m, ~, ~] = load_open_ephys_data_faster('100_CH14.continuous');
[data17m, ~, ~] = load_open_ephys_data_faster('100_CH46.continuous');
% Loading accelerometer data
[ax1, ~, ~] = load_open_ephys_data_faster('100_AUX1.continuous');
[ax2, ~, ~] = load_open_ephys_data_faster('100_AUX2.continuous');
[ax3, ~, ~] = load_open_ephys_data_faster('100_AUX3.continuous');

% Verifying time
 l=length(ax1); %samples
% t=l*(1/fs); %  2.7276e+03  seconds
% Equivalent to 45.4596 minutes
t=1:l;
t=t*(1/fs);

sos=ax1.^2+ax2.^2+ax3.^2;
clear ax1 ax2 ax3 

%%
% close all
%[vtr]=findsleep(sos,0.006,t); %post_trial2
[vtr]=findsleep(sos,0.006,t); %post_trial3

%%
vin=find(vtr~=1);
tvin=vin*(1/fs);

C9=data9m(vin).*(0.195);
C17=data17m(vin).*(0.195);

clear data17m data9m
%%
if acer~=1
cd('/home/raleman/Documents/internship/Lisa_files/data/PT1')
else
cd('G:/Lisa_files/data/PT1')
end
save('C9.mat','C9')
save('C17.mat','C17')


%% FINITO

downsamp(1,acer);
downsamp(2,acer);
downsamp(3,acer);
downsamp(4,acer);
%%
load('V9.mat')
load('V17.mat')

V9n=outlier(V9);
V17n=outlier(V17);

probad=isoutlier(V9,'quartile');
%%
load('V9.mat')
load('V17.mat')

%%
V9n=outlier(V9,1.5);
V17n=outlier(V17,1.5);

fn=1000; % New sampling frequency. 
Wn1=[100/(fn/2) 300/(fn/2)]; % Cutoff=500 Hz
[b1,a1] = butter(3,Wn1,'bandpass'); %Filter coefficients for LPF

Mono17=filtfilt(b1,a1,V17n);
Mono9=filtfilt(b1,a1,V9n);


%% SWR detection 

signal=Mono17*(1/0.195);

thr=60;
t=(0:length(signal)-1)*(1/fn); %IN SECONDS
[S, E, M] = findRipplesLisa(signal, t, thr , thr*(1/3), []);

%%
% label1='PFC';
% label2= strcat('Thr:',num2str(thr));
num=500;

label1='Hippocampus';
label2=strcat('Thr:',num2str(thr));
Mono17=Mono17*(1/0.195);
V17n=V17n*(1/0.195);


[cellx,cellr]=winL(M,Mono17,V17n,num);
[cellx,cellr]=clean(cellx,cellr);

allscreen
[p3 ,p4]=eta(cellx,cellr,num);
mtit(strcat(label1),'fontsize',14,'color',[1 0 0],'position',[.5 1 ])
mtit(strcat(' (',label2,')'),'fontsize',14,'color',[1 0 0],'position',[.5 0.8 ])

barplot2(p4,p3,num)

[cfs,f]=barplot3(p4,p3,num);
%%
saveas(gcf,'Barchart.png')
%%

[cellx,cellr]=winL(M,Mono17,V17n,500);
[cellx,cellr]=clean(cellx,cellr);

%
[p3 ,p4]=eta(cellx,cellr,500);

%%
barplot2(p4,p3)
[cfs,f]=barplot3(p4,p3);

%%

%%

[cellx,cellr]=winL(M,Mono17,V17n);

[p3 ,p4]=eta(cellx,cellr);
barplot2(p4,p3)
[cfs,f]=barplot3(p4,p3);
%%
% tn=t(max1s:max2s);
% sn=signal(max1s:max2s);
% sn1=signalwave(max1s:max2s);    
%end


%% Downsampling x20 for Session 5

Wn=[500/(fs/2) ]; % Cutoff=500 Hz
[b,a] = butter(3,Wn); %Filter coefficients for LPF
% V9=cell(length(C12),1);
% V17=cell(length(C12),1);
V9=filtfilt(b,a,C9);
V9=decimator(V9,20);

V17=filtfilt(b,a,C17);
V17=decimator(V17,20);
fn=1000; %New sampling frequency

%%
st=30*(60)*(fn);
    V9m=cell(6,1);
    V9m{1,1}=V9(1:st);
    V9m{2,1}=V9(st+1:2*st);
    V9m{3,1}=V9(2*st+1:3*st);
    V9m{4,1}=V9(3*st+1:4*st);
    V9m{5,1}=V9(4*st+1:5*st);
    V9m{6,1}=V9(5*st+1:end);
%%
fn=1000;
st=30*(60)*(fn);
    V17m=cell(6,1);
    V17m{1,1}=V17(1:st);
    V17m{2,1}=V17(st+1:2*st);
    V17m{3,1}=V17(2*st+1:3*st);
    V17m{4,1}=V17(3*st+1:4*st);
    V17m{5,1}=V17(4*st+1:5*st);
    V17m{6,1}=V17(5*st+1:end);
%% Finito 2 

    
    
%%
% [ax4, ~, ~] = load_open_ephys_data_faster('100_AUX4.continuous');
% [ax5, ~, ~] = load_open_ephys_data_faster('100_AUX5.continuous');
% [ax6, ~, ~] = load_open_ephys_data_faster('100_AUX6.continuous');
%% Shorten
% ax1=ax1(1:10000000);
% ax2=ax2(1:10000000);
% ax3=ax3(1:10000000);
%%
% close all
% findsleep(ax3,0.006,t)

%%
% plot(t,ax1)
% hold on
% plot(t,ax1d)
% legend('AUX1','AUX1 (detrended)')
% 
% xlabel('Time(sec)')
% ylabel('Magnitude')
% grid minor
% title('Comparison between original and detrended data')

%%
plot(t,thr,'Color','k')
% plot(t,eax1(1:end))
% plot(t,ax3(1:end))

xlabel('Time(sec)')
ylabel('Magnitude')
grid minor
title('Accelerometer data')
%xlim([100 110])
%legend('AUX1','AUX2','AUX3')
% %%
% di=da(1:20);
% area(1:length(di),di)
% %%
% hist(da,1000)

%%
plot(t,ax1(1:end))
hold on
plot(t,ax2(1:end))
plot(t,ax3(1:end))

xlabel('Time(sec)')
ylabel('Magnitude')
grid minor
title('Accelerometer data')
legend('AUX1','AUX2','AUX3')
%%
plot(t,ax4(1:end))
hold on
plot(t,ax5(1:end))
plot(t,ax6(1:end))

xlabel('Time(sec)')
ylabel('Magnitude')
grid minor
title('Accelerometer data')
legend('AUX4','AUX5','AUX6')

%%
sos=ax1.^2+ax2.^2+ax3.^2;
clear ax1 ax2 ax3 

%%
% close all
%[vtr]=findsleep(sos,0.006,t); %post_trial2
[vtr]=findsleep(sos,0.006,t); %post_trial3

%%
vin=find(vtr~=1);
tvin=vin*(1/fs);

C9=data9m(vin).*(0.195); %Sleep+Correction factor
C17=data17m(vin).*(0.195); %Sleep+Correction factor

clear data17m data9m
%%
cd('/home/raleman/Documents/internship/Lisa_files/data/PT3')
save('C9.mat','C9')
save('C17.mat','C17')

%%
% so=ax4.^2+ax5.^2+ax6.^2;
%%
plot(t,sos(1:end))
hold on
plot(t,so(1:end))

xlabel('Time(sec)')
ylabel('Magnitude')
grid minor
title('Resulting Vector for Accelerometer data')
legend('AUX1,AUX2,AUX3', 'AUX4,AUX5,AUX6')
%%
plot(t,sos(1:end),'Color',[1 0.3 0])

xlabel('Time(sec)')
ylabel('Magnitude')
grid minor
title('Resultant Vector for Accelerometer data')
%%
plot(t,(sos(1:end)),'Color',[1 0.3 0])

xlabel('Time(sec)')
ylabel('Magnitude')
grid minor
title('Resultant Vector for Accelerometer data')
  

%%
plot(signal)
hold on
plot([ones(1,length(signal))]*200,'Linewidth',2)
xlabel('Samples')
ylabel('Magnitude')
grid minor
title('Threshold for Ripple detection')
%%

veamos=find(s17~=0);  %Epochs with ripples detected
carajo=swr17(veamos,:);
