%read_ratdata.
%Load .continuous files, extract NREM, downsample to 1kHz and save channels as .mat
%files. 

selpath = uigetdir([],'Select folder with .continuous data')
cd(selpath)

%Channel mapping
%HPC,REFERENCE,PFC,PARIETAL.
channels.Rat26 = [17 6 9 12];
channels.Rat27 = [13 22 9 12];
channels.Rat24 = [17 22 11 12];
channels.Rat21 = [13 25 9 12];

%Select rat number
opts.Resize = 'on';
opts.WindowStyle = 'modal';
opts.Interpreter = 'tex';
prompt='\bf Which rat number?';
answer = inputdlg(prompt,'Input',[2 30],{''},opts);
Rat=str2num(answer{1});

%Channels corresponding to rat.
vr=getfield(channels,strcat('Rat',num2str(Rat)));%Electrode channels. 

%% Find folder names
d = dir(cd);
isub = [d(:).isdir]; %# returns logical vector
nF = {d(isub).name}';
nF(ismember(nF,{'.','..'})) = [];

%%
selpath2 = uigetdir([],'Select folder to save data')
%cd('/home/raleman/Documents/internship/26')
cd(selpath2)
answer = questdlg('Would you like to create a folder?', ...
	'Yes','No');
switch answer
    case 'Yes'
        create_fold=1;
    case 'No'
        create_fold=0;
    otherwise
        create_fold=0;
        xo
end

        if create_fold==1

        %% Create folders 
        for i=1:length(nF)
            mkdir([nF{i}])
        end
        %%
        % d = dir(cd);
        % isub = [d(:).isdir]; %# returns logical vector
        % isub=not(isub);
        % nameFolds = {d(isub).name}';
        % % nameFolds(ismember(nameFolds,{'.','..'})) = [];

        %%
        nFF=[
           % {'rat26_Base_II_2016-03-24'                         }
           % {'rat26_Base_II_2016-03-24_09-47-13'                }
           % {'rat26_Base_II_2016-03-24_12-55-58'                }
           % {'rat26_Base_II_2016-03-24_12-57-57'                }

        %     {'rat26_nl_base_III_2016-03-30_10-32-57'            }
        %     {'rat26_nl_base_II_2016-03-28_10-40-19'             }
        %     {'rat26_nl_baseline2016-03-01_11-01-55'             }
        %     

            {'rat26_novelty_II_2016-04-13_10-23-29'             }
            {'rat26_novelty_I_2016-04-12_10-05-55'              }
            {'rat26_for_2016-03-21_10-38-54'                    }
            {'rat26_for_II_2016-03-23_10-49-50'                 }

            ]
        %%
        for i=1:length(nFF)
            mkdir([nFF{i}])
        end
         %%
         Files=dir(fullfile(cd,'*.mat')) 
        end

 %% Get data 
% cd('/media/raleman/My Book/SWRDisruptionPlusMaze/rat_26')
cd(selpath)

if create_fold==1
iii=1
%for iii=1:length(nFF)
cd(nFF{iii})
end

    %LOAD MATLAB FILES.
    %Find .mat files
    Files=dir(fullfile(cd,'*.mat'));
    for ii=1:length(Files)
    load(Files(ii).name)
    end
    
    
    'Reference'
%     [V6,~]=save_samples('100_CH6_merged.continuous',transitions);
    [V6,~]=save_samples(strcat('100_CH',num2str(vr(2)),'_merged.continuous')...
,transitions);


    cd(selpath2)
    if create_fold==1
    cd(nFF{iii})
    end
    save('V6.mat','V6')
    clear V6
    
    %
    cd(selpath)
    if create_fold==1
    cd(nFF{iii})
    end

    'PFC'
    
    [V9,~]=save_samples(strcat('100_CH',num2str(vr(3)),'_merged.continuous')...
    ,transitions);

    cd(selpath2)
    if create_fold==1
    cd(nFF{iii})
    end
    save('V9.mat','V9')
    clear V9
%
    cd(selpath)
    if create_fold==1
    cd(nFF{iii})
    end
    
    'Parietal'
    
    [V12,tiempo]=save_samples(strcat('100_CH',num2str(vr(4)),'_merged.continuous')...
    ,transitions);
    
    cd(selpath2)
    if create_fold==1
    cd(nFF{iii})
    end
    save('V12.mat','V12')
    clear V12
    
cd(selpath)
if create_fold==1
cd(nFF{iii})
end

'HPC'

[V17,~]=save_samples(strcat('100_CH',num2str(vr(1)),'_merged.continuous')...
,transitions);

cd(selpath2)
if create_fold==1
cd(nFF{iii})
end
save('V17.mat','V17')
clear V17

xo
%% Bipolar recordings
cd(selpath2)

a=dir(fullfile(cd,'*.mat'))

for ii=1:length(a)
load(a(ii).name)
end

'Bipolar recordings'
for j=1:length(V9)
S9{j,1}=V9{j,1}-V6{j,1};
S12{j,1}=V12{j,1}-V6{j,1};
S17{j,1}=V17{j,1}-V6{j,1};
end

save('S9.mat','S9')
save('S12.mat','S12')
save('S17.mat','S17')


%end
% END OF CODE

%% Reading data
cd('/home/raleman/Documents/internship/26')
i=1;
cd(nFF{i})


S17=load('S17.mat');
S17=S17.S17;

S12=load('S12.mat');
S12=S12.S12;

S9=load('S9.mat');
S9=S9.S9;

V17=load('V17.mat');
V17=V17.V17;

V12=load('V12.mat');
V12=V12.V12;

V9=load('V9.mat');
V9=V9.V9;

V6=load('V6.mat');
V6=V6.V6;
%%
% %% Band pass design 
% fn=1000; % New sampling frequency. 
% Wn1=[100/(fn/2) 300/(fn/2)]; % Cutoff=500 Hz
% [b1,a1] = butter(3,Wn1,'bandpass'); %Filter coefficients for LPF
% % Bandpass filter 
% fn=1000;
% 
% Mono6=cell(length(S9),1);
% Mono9=cell(length(S9),1);
% Mono12=cell(length(S9),1);
% Mono17=cell(length(S9),1);
% 
% Bip9=cell(length(S9),1);
% Bip12=cell(length(S9),1);
% Bip17=cell(length(S9),1);
% 
% 
% for i=1:length(S9)
%     
% Bip9{i}=filtfilt(b1,a1,S9{i});    
% Bip12{i}=filtfilt(b1,a1,S12{i});
% Bip17{i}=filtfilt(b1,a1,S17{i});
% 
% Mono6{i}=filtfilt(b1,a1,V6{i});
% Mono9{i}=filtfilt(b1,a1,V9{i});
% Mono12{i}=filtfilt(b1,a1,V12{i});
% Mono17{i}=filtfilt(b1,a1,V17{i});
% 
% end

%%
% s17=nan(length(S9),1);
% swr17=cell(length(S9),3);
% %thr=140;
% thr=200;
% %thr=180;
% 
% 
% for i=1:length(S9)
%     
% signal=Bip17{i}*(1/0.195);
% signal2=Mono17{i}*(1/0.195);
% 
% ti=(0:length(signal)-1)*(1/fn); %IN SECONDS
% [S, E, M] = findRipplesLisa(signal, ti.', thr , (thr)*(1/3), []);
% s17(i)=length(M);
% swr17{i,1}=S;
% swr17{i,2}=E;
% swr17{i,3}=M;
% 
% ti=(0:length(signal2)-1)*(1/fn); %IN SECONDS
% [S2, E2, M2] = findRipplesLisa(signal2, ti.', thr , (thr)*(1/3), []);
% s217(i)=length(M2);
% swr217{i,1}=S2;
% swr217{i,2}=E2;
% swr217{i,3}=M2;
% 
% 
% i/length(S9)
% end
% 
% % Windowing
% veamos=find(s17~=0);  %Epochs with ripples detected
% carajo=swr17(veamos,:);
% 
% %Proceed to rearrange.m
% %  Windowing using Monopolar
% 
% veamos2=find(s217~=0);  %Epochs with ripples detected
% carajo2=swr217(veamos2,:);
% 
% 
% %%
% cd('/media/raleman/My Book/SWRDisruptionPlusMaze/rat_26')
% cd(nFF{1})
% 
% [V17,tiempo]=save_samples('100_CH17_merged.continuous',transitions);
% 
% cd('/home/raleman/Documents/internship/26')
% cd(nFF{1})
% save('V17.mat','V17')
% clear V17
% %%
% clear all
% a=dir(fullfile(cd,'*.mat'))
% 
% for ii=1:length(a)
% load(a(ii).name)
% end
% 
% for j=1:length(V9)
% S9{j,1}=V9{j,1}-V6{j,1};
% S12{j,1}=V12{j,1}-V6{j,1};
% S17{j,1}=V17{j,1}-V6{j,1};
% end
% 
% save('S9.mat','S9')
% save('S12.mat','S12')
% save('S17.mat','S17')


% %%
% %Reference
% [data6m, ~, ~] = load_open_ephys_data_faster('100_CH6_merged.continuous');
% %%
% [C6,tiempo]=reduce_data(data6m,transitions);
% clear data6m
% [V6]=downsampling(C6);
% clear C6


