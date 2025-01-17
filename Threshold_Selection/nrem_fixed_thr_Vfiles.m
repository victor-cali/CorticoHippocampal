function [sig1,sig2,ripple2,cara,veamos,RipFreq2,timeasleep,ti,vec_nrem, vec_trans ,vec_rem,vec_wake,labels,transitions,transitions2,ripples_times]=nrem_fixed_thr_Vfiles(vq,notch,w)
%{
LOAD DATA, easy and quick. 

The V signals are the monopolar recordings of the 4 channels. 

The S signals are the bipolar recordings which have been substracted the
reference signal (V6)
%}

% % %Load Bipolar signals
% % S17=load('S17.mat');
% % S17=S17.S17;
% % 
% % S12=load('S12.mat');
% % S12=S12.S12;
% % 
% % S9=load('S9.mat');
% % S9=S9.S9;
%Band pass filter design:
fn=1000; % New sampling frequency. 
Wn1=[100/(fn/2) 300/(fn/2)]; % Cutoff=500 Hz
[b1,a1] = butter(3,Wn1,'bandpass'); %Filter coefficients

%LPF 300 Hz:
fn=1000; % New sampling frequency. 
Wn1=[320/(fn/2)]; % Cutoff=500 Hz
[b2,a2] = butter(3,Wn1); %Filter coefficients

%Load Sleeping stage classification
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%load('transitions.mat')
%Load Monopolar signals
% Fline=[50 100 150 200 250 300];

%Reference
% V6=load('data6m.mat');
% V6=V6.data6m;
V6=load('V6.mat');
V6=V6.V6;
% V6=filtfilt(b2,a2,V6);
V6=cellfun(@(equis) filtfilt(b2,a2,equis), V6 ,'UniformOutput',false);
%if w==4 && notch==1
if notch==1
Fline=[50 100 150 207.5 250.5 300];

[V6] = ft_notch(V6.', fn,Fline,1,2);
V6=V6.';

    %    [V6] = ft_preproc_dftfilter(V6.',fn,Fline); 
%    V6=V6.';
 %V6=flipud(filter(H100,flipud(filter(H100,V6))));
end
% Mono6=filtfilt(b1,a1,V6); 
Mono6=cellfun(@(equis) filtfilt(b1,a1,equis), V6 ,'UniformOutput',false);

% V17=load('data17m.mat');
% %Monopolar
% V17=V17.data17m;
V17=load('V17.mat');
V17=V17.V17;
% V17=filtfilt(b2,a2,V17);
V17=cellfun(@(equis) filtfilt(b2,a2,equis), V17 ,'UniformOutput',false);
%NO NEED OF NOTCH FILTER FOR HIPPOCAMPUS
%UPDATE: Actually does need one!
%V17=flipud(filter(Hcas,flipud(filter(Hcas,V17))));

if notch==1
Fline=[50 100 150 200 250.5 300];

[V17] = ft_notch(V17.', fn,Fline,1,2);
V17=V17.';
end

%Bipolar
% S17=V17-V6;

S17=load('S17.mat');
S17=S17.S17;

%Bandpassed versions
% Mono17=filtfilt(b1,a1,V17); 
Mono17=cellfun(@(equis) filtfilt(b1,a1,equis), V17 ,'UniformOutput',false);
% Bip17=filtfilt(b1,a1,S17);
Bip17=cellfun(@(equis) filtfilt(b1,a1,equis), S17 ,'UniformOutput',false);

%NREM extraction
% [V17,~]=reduce_data(V17,transitions,1000,nrem);
% [S17,~]=reduce_data(S17,transitions,1000,3);
% [Mono17,~]=reduce_data(Mono17,transitions,1000,nrem);
% [Bip17,~]=reduce_data(Bip17,transitions,1000,3);


% V12=load('data12m.mat');
% V12=V12.data12m;

V12=load('V12.mat');
V12=V12.V12;
% V12=filtfilt(b2,a2,V12);
V12=cellfun(@(equis) filtfilt(b2,a2,equis), V12 ,'UniformOutput',false);

%if w==2 && notch==1
if  notch==1
Fline=[50 100 149 150 200 249.5 250 300 66.5 133.5 266.5];
 
[V12] = ft_notch(V12.', fn,Fline,1,2);
V12=V12.';
    %      [V12] = ft_preproc_dftfilter(V12.',fn,Fline); 
%      V12=V12.'; 
%V12=flipud(filter(Hcas2,flipud(filter(Hcas2,V12))));
end
% S12=V12-V6;
S12=load('S12.mat');
S12=S12.S12;
% Mono12=filtfilt(b1,a1,V12);
Mono12=cellfun(@(equis) filtfilt(b1,a1,equis), V12 ,'UniformOutput',false);
% Bip12=filtfilt(b1,a1,S12);
Bip12=cellfun(@(equis) filtfilt(b1,a1,equis), S12 ,'UniformOutput',false);

% [V12,~]=reduce_data(V12,transitions,1000,nrem);
% [S12,~]=reduce_data(S12,transitions,1000,3);
% [Mono12,~]=reduce_data(Mono12,transitions,1000,nrem);
% [Bip12,~]=reduce_data(Bip12,transitions,1000,3);


% V9=load('data9m.mat');
% V9=V9.data9m;
V9=load('V9.mat');
V9=V9.V9;
%V9=filtfilt(b2,a2,V9);
V9=cellfun(@(equis) filtfilt(b2,a2,equis), V9 ,'UniformOutput',false);

%if w==3 && notch==1
if notch==1
%V9=flipud(filter(Hcas2,flipud(filter(Hcas2,V9))));
Fline=[49.5 50 100 150 200 250 300 66.5 133.5 266.5];

[V9] = ft_notch(V9.', fn,Fline,1,2);
V9=V9.';

end
%S9=V9-V6;
S9=load('S9.mat');
S9=S9.S9;
% Mono9=filtfilt(b1,a1,V9);
% Bip9=filtfilt(b1,a1,S9);
Mono9=cellfun(@(equis) filtfilt(b1,a1,equis), V9 ,'UniformOutput',false);
Bip9=cellfun(@(equis) filtfilt(b1,a1,equis), S9 ,'UniformOutput',false);

% [V9,~]=reduce_data(V9,transitions,1000,nrem);
% [S9,~]=reduce_data(S9,transitions,1000,3);
% [Mono9,~]=reduce_data(Mono9,transitions,1000,nrem);
% [Bip9,~]=reduce_data(Bip9,transitions,1000,3);


% [V6,~]=reduce_data(V6,transitions,1000,nrem);
% [Mono6,~]=reduce_data(Mono6,transitions,1000,nrem);

% V12=load('V12.mat');
% V12=V12.V12;
% 
% V9=load('V9.mat');
% V9=V9.V9;
% 
% V6=load('V6.mat');
% V6=V6.V6;

%Load accelerometer data in case it was saved. 
fileList = dir('sos.mat');
if size(fileList,1)==1
load(fileList.name) 
else
    sos=[];
end

'Loaded channels'

%Total amount of time spent sleeping:
timeasleep=sum(cellfun('length',V9))*(1/1000)/60; % In minutes
%save('timeasleep.mat','timeasleep')


% Bandpass filtering:

%
% % % Mono6=cellfun(@(equis) filtfilt(b1,a1,equis), V6 ,'UniformOutput',false);
% % % Mono9=cellfun(@(equis) filtfilt(b1,a1,equis), V9 ,'UniformOutput',false);
% % % Mono12=cellfun(@(equis) filtfilt(b1,a1,equis), V12 ,'UniformOutput',false);
% % % Mono17=cellfun(@(equis) filtfilt(b1,a1,equis), V17 ,'UniformOutput',false);
% % % 
% % % 
% % % Bip9=cellfun(@(equis) filtfilt(b1,a1,equis), S9 ,'UniformOutput',false);
% % % Bip12=cellfun(@(equis) filtfilt(b1,a1,equis), S12 ,'UniformOutput',false);
% % % Bip17=cellfun(@(equis) filtfilt(b1,a1,equis), S17 ,'UniformOutput',false);



'Bandpass performed'

% % % % % % % 
% % % % % % % rep=5; %Number of thresholds+1
% % % % % % % 
% % % % % % % %%
% % % % % % % [NC]=epocher(Mono17,lepoch);
% % % % % % % % ncmax=max(NC)*(1/0.195);
% % % % % % % % chtm=median(ncmax);
% % % % % % % 
% % % % % % % %ncmax=quantile(NC,0.999)*(1/0.195);
% % % % % % % ncmax=max(NC)*(1/0.195);
% % % % % % % 
% % % % % % % chtm=median(ncmax);
% % % % % % % 
% % % % % % % 
% % % % % % % %chtm=median(cellfun(@max,Bip17))*(1/0.195); %Minimum maximum value among epochs.
% % % % % % % %Median is used to account for any artifact/outlier. 
% % % % % % % 
% % % % % % % % chtm2=min(cellfun(@max,Mono17))*(1/0.195); %Minimum maximum value among epochs.
% % % % % % % CHTM=floor([chtm chtm/2 chtm/4 chtm/8 chtm/16]);
A = dir('*states*.mat');
        A={A.name};
     
        if  ~isempty(A)
               cellfun(@load,A);
                   [transitions2]=sort_scoring(transitions); %NREM
                   [vec_nrem, vec_trans ,vec_rem,vec_wake,labels]=stages_stripes(transitions2);
             transitions=transitions((find(transitions(:,1)==3)),:);
             transitions2=transitions2((find(transitions2(:,1)==3)),:);

        else
            errordlg('No scoring found','File Error');
            xo
        end

%Area used for ripple detection.
if strcmp(w,'PFC')
    Mono=Mono9;
end
if strcmp(w,'HPC')
    Mono=Mono17;
end
if strcmp(w,'PAR')
    Mono=Mono12;
end


%Scale magnitude,create time vector
% signal=cellfun(@(equis) times((1/0.195), equis)  ,Bip17,'UniformOutput',false);
signal2=cellfun(@(x) times((1/0.195), x)  ,Mono,'UniformOutput',false);
% ti=cellfun(@(x) linspace(0, length(x)-1,length(x))*(1/fn) ,signal2,'UniformOutput',false);

for kk=1:size(signal2,1)
   % ti2{kk,1}=(transitions(kk,2):1/1000:transitions(kk,3));
     ti{kk,1}=linspace(transitions(kk,2),transitions(kk,3),length(signal2{kk}));
end

%ti2=cellfun(@(x) linspace(0, length(x)-1,length(x))*(1/fn) ,signal2,'UniformOutput',false);

%Find ripples
% for k=1:rep-1
% for k=1:rep-2

%Find times when ripples occured.
%S:Start, E:Ending, M:Main peak.

[S2x,E2x,M2x] =cellfun(@(equis1,equis2) findRipplesLisa(equis1, equis2.', vq, (vq)*(1/2), [] ), signal2,ti,'UniformOutput',false);    
rip_times(:,:,1)=[S2x E2x M2x]; %Stack them

ti=cellfun(@(x) linspace(0, length(x)-1,length(x))*(1/fn) ,signal2,'UniformOutput',false);
[S2x,E2x,M2x] =cellfun(@(equis1,equis2) findRipplesLisa(equis1, equis2.', vq, (vq)*(1/2), [] ), signal2,ti,'UniformOutput',false);    
swr172(:,:,1)=[S2x E2x M2x]; %Stack them
s172(:,1)=cellfun('length',S2x);

% end

RipFreq2=sum(s172)/(timeasleep*(60));%Ripples per second.

%To display number of events use:
ripple2=sum(s172); %When using same threshold per epoch.
%ripple when using different threshold per epoch. 

%to display thresholds use CHTM 
% to display rate of occurence use RipFreq2. 
%%
%error('Stop here please')

% Windowing
for ind=1:size(s172,2)
veamos{:,ind}=find(s172(:,ind)~=0);  %Epochs with ripples detected
cara{:,:,ind}=swr172(veamos{:,ind},:,ind);
ripples_times{:,:,ind}=rip_times(veamos{:,ind},:,ind);

% veamos2{:,ind}=find(s217(:,ind)~=0);  %Epochs with ripples detected
% cara2{:,:,ind}=swr217(veamos2{:,ind},:,ind);
end


sig1=cell(7,1);

sig1{1}=Mono17;
sig1{2}=Bip17;
sig1{3}=Mono12;
sig1{4}=Bip12;
sig1{5}=Mono9;
sig1{6}=Bip9;
sig1{7}=Mono6;


sig2=cell(7,1);

% sig2{1}=V17;
% sig2{2}=S17;
% sig2{3}=V12;
% % sig2{4}=R12;
% sig2{4}=S12;
% %sig2{6}=SSS12;
% sig2{5}=V9;
% % sig2{7}=R9;
% sig2{6}=S9;
% %sig2{10}=SSS9;
% sig2{7}=V6;
sig2{1}=V17;
sig2{2}=sos; % Accelerometer data. 
sig2{3}=V12;
% sig2{4}=R12;
sig2{4}=[];
%sig2{6}=SSS12;
sig2{5}=V9;
% sig2{7}=R9;
sig2{6}=[];
%sig2{10}=SSS9;
sig2{7}=V6;
 
% ripple=length(M);
% ripple=sum(s172);
end
