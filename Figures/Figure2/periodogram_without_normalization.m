clc
clear variables

acer=1;
rat24base=2;
pw_meth='no_welsh';
datapath='C:\Users\addri\Documents\internship\downsampled_NREM_data';

%%
%Select rat number
opts.Resize = 'on';
opts.WindowStyle = 'modal';
opts.Interpreter = 'tex';
prompt='\bf Which rat number?';
answer = inputdlg(prompt,'Input',[2 30],{''},opts);
Rat=str2num(answer{1});
%xo
%Uncomment for Loop.
% %for Rat=1:1
% rats=[26 27 24 21];
% Rat=rats(RAT);
%%
if Rat==26
nFF=[
%    {'rat26_Base_II_2016-03-24'                         }
%    {'rat26_Base_II_2016-03-24_09-47-13'                }
%    {'rat26_Base_II_2016-03-24_12-55-58'                }
%    {'rat26_Base_II_2016-03-24_12-57-57'                }
    
   
%    {'rat26_nl_base_III_2016-03-30_10-32-57'            }
     {'rat26_nl_base_II_2016-03-28_10-40-19'             }
%     {'rat26_nl_baseline2016-03-01_11-01-55'             }
    {'rat26_plusmaze_base_2016-03-08_10-24-41'}
    
    
    
    {'rat26_novelty_I_2016-04-12_10-05-55'          }
%     {'rat26_novelty_II_2016-04-13_10-23-29'             }
    {'rat26_for_2016-03-21_10-38-54'                    }
%     {'rat26_for_II_2016-03-23_10-49-50'                 }
    
    ];

% labelconditions=[
%     {'Baseline_1' 
%      'Baseline_2'}
%      'Baseline_3'
%      'PlusMaze'
%      'Novelty_1'
%      'Novelty_2'
%      'Foraging_1'
%      'Foraging_2'
%     ];

labelconditions=[
    { 
    
%    'Baseline'}
    'Control'}
 
%     'Baseline_2'
%     'Baseline_3'
     'PlusMaze'    
     'Novelty'
%      'Novelty_2'
     'Foraging'
%      'Foraging_2'
    ];


end
if Rat==27
nFF=[
    {'rat27_nl_base_2016-03-28_15-01-17'                   } %Baseline 2
   % {'rat27_NL_baseline_2016-02-26_12-50-26'               } %Baseline 1
   % {'rat27_nl_base_III_2016-03-30_14-36-57'               }
    
    {'rat27_plusmaze_base_2016-03-14_14-52-48'             }
%     {'rat27_plusmaze_base_II_2016-03-24_14-10-08'          }
    {'rat27_novelty_I_2016-04-11_14-34-55'                 } 
    {'rat27_for_2016-03-21_15-03-05'                       }
    %{'Rat27_for_II_2016-03-23_15-06-59'                    }
    
    %{'rat27_novelty_II_2016-04-13_14-37-58'                }  %NO .MAT files found. 
    %{'rat27_novelty_II_2016-04-13_16-29-42'                } %No (complete).MAT files found.
   
  
%     {'rat27_plusmaze_dis_2016-03-10_14-35-18'              }
%     {'rat27_plusmaze_dis_II_2016-03-16_14-36-07'           }
%     {'rat27_plusmaze_dis_II_2016-03-18_14-46-24'           }
%     {'rat27_plusmaze_jit_2016-03-08_14-46-31'              }
%     {'rat27_plusmaze_jit_II_2016-03-16_15-02-27'           }
%     {'rat27_plusmaze_swrd_qPCR_2016-04-15_14-28-41'        }
%     {'rat27_watermaze_dis_morning_2016-04-06_10-18-36'     }
%     {'rat27_watermaze_jitter_afternoon_2016-04-06_15-41-51'}  
    ]

labelconditions=[
    { 
%    'Baseline'}
    'Control'}
%     'Baseline_2'
%     'Baseline_3'
    'PlusMaze'
%     'PlusMaze_2'
    'Novelty'
    'Foraging'
    
  %   'Foraging_2'
     
    
    
     
    ];

    
end

if Rat==21
 
 nFF=[  
    {'2015-11-27_13-50-07 5h baseline'             }
    {'rat21 baselin2015-12-11_12-52-58'            }
    {'rat21_learningbaseline2_2015-12-10_15-24-17' }
    {'rat21with45minlearning_2015-12-02_14-25-12'  }
    %{'rat21t_maze_2015-12-14_13-29-07'             }
    {'rat21 post t-maze 2015-12-14_13-30-52'       }
    
];

%%
labelconditions=[
    {    
     'Learning Baseline'
                }
     
     '45minLearning'
     'Novelty_2'
     't-maze'
     'Post t-maze'
    ];
    
end

if Rat==24
   
nFF=[  
  %  {'Baseline1'}
    {'Baseline2'}
  %  {'Baseline3'}
  %  {'Baseline4'}
    {'Plusmaze1'}
  %  {'Plusmaze2'}
   {'Novelty1'}
   {'Foraging1'}
        
];      
if  rat24base==2
  nFF{1,:}='Baseline2'; 
end


labelconditions=[
    { 
    'Baseline'}
%     'Baseline_2'
%     'Baseline_3'
    'PlusMaze'
%     'PlusMaze_2'
    'Novelty'
    'Foraging'
    
  %   'Foraging_2'
     
    
    
     
    ];
%labelconditions=nFF;
end
 
%% Select experiment to perform. 
nrem=3;
notch=0;
normalizeperiod=0;
block_time=0; %Should be 0 for whole recording. 
Score=1;
%%
%Make labels
label1=cell(7,1);
label1{1}='Hippocampus';
label1{2}='Hippocampus';
label1{3}='Parietal';
label1{4}='Parietal';
label1{5}='PFC';
label1{6}='PFC';
label1{7}='Reference';

label2=cell(7,1);
label2{1}='Monopolar';
label2{2}='Bipolar';
label2{3}='Monopolar';
label2{4}='Bipolar';
label2{5}='Monopolar';
label2{6}='Bipolar';
label2{7}='Monopolar';

%%
%Method of Ripple selection. Method 4 gives best results.
prompt = {'Select brain area (HPC:1, PAR:2, PFC:3)'};
dlgtitle = 'Area';
definput = {'1'};
opts.Interpreter = 'tex';
answer = inputdlg(prompt,dlgtitle,[1 40],definput,opts);
w=str2num(answer{1});

% w=1 %Hippocampus


% 
% if Rat==21
% myColorMap = jet(5);
% else
% myColorMap = jet(8);    
% end
% colormap(myColorMap);
myColorMap = jet(8);                                                                                                                                                                                    
myColorMap =myColorMap([2 4 5 7],:);
% myColorMap(2,:); %Baseline
% myColorMap(4,:); %PlusMaze
% myColorMap(5,:); %Novelty
% myColorMap(7,:);%Foraging

% myColorMap(3,:)=[1 0 1];
myColorMap(2,:)=[0, 204/255, 0];
myColorMap(3,:)=[0.9290, 0.6940, 0.1250];



% myColorMap(1,:)=[0.65, 0.65, 0.65]; %GREY CONTROL
% myColorMap(2,:)=[0, 0, 0]; %Black plusmaze
% myColorMap(3,:)=[0.9290, 0.6940, 0.1250]; %Yellow Novelty
% myColorMap(4,:)=[0.49, 0.18, 0.56]; %Foraging Violet. 
 [myColorMap]=StandardColors;

%New Colors
% myColorMap(1,:)=[127, 131, 135]./255;
% myColorMap(2,:)=[0,0,0];
% myColorMap(4,:)=[212, 11, 226]./255;

%RAT 24
% if Rat==24
%     myColorMap = jet(6);                                                                                                                                                                                    
% end

NCount=nan(length(nFF),1);
Block{1}='complete';
Block{2}='block1';
Block{3}='block2';
Block{4}='block3';


for block_time=0:0

    for iii=1:length(nFF)

if acer==0
    cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))
else
    cd(strcat(datapath,'/',num2str(Rat)))
end

    cd(nFF{iii})  
%  xo
if strcmp(labelconditions{iii},'Baseline') || strcmp(labelconditions{iii},'PlusMaze')
 [sig2]=nrem_newest_power_vx(nrem,notch,Score);
else
  [sig2]=nrem_newest_power_vx(nrem,notch,1);  
end
%%
f_signal=sig2{2*w-1};
%Amplitude normalization
[NC]=epocher(f_signal,2);

%If not complete recording, pick time block. 
if block_time~=0
    switch block_time
        case 1
               NC=NC(:,[1:round(size(NC,2)/3)]);    
        case 2
               NC=NC(:,[round(size(NC,2)/3)+1: round(size(NC,2)/3*2)]);
        case 3
               NC=NC(:,[round(size(NC,2)/3*2)+1: size(NC,2)]);
        otherwise
            xo
    end
end

%ARTIFACT REMOVAL
av=mean(NC,1);
av=artifacts(av,10);
%Limits artifacts to a maximum of 10
if sum(av)>=10
av=artifacts(av,20);    
end
av=not(av);
%Removing artifacts.
NC=NC(:,av);

NCount(iii,1)=size(NC,2);

%Notch filter
Fsample=1000;
Fline=[50 100 150 200 250 300 66.5 133.5 266.5];

if w~=1 && w~=4  %Dont filter Hippocampus nor Reference 
[NC] = ft_notch(NC.', Fsample,Fline,0.5,0.5);
NC=NC.';
end

if Rat==26 %Noise peak was only observed in Rat 26
    if w==4  % Reference 
     Fline=[208 209];

    [NC] = ft_notch(NC.', Fsample,Fline,0.5,0.5);
    NC=NC.';
    end
end

if Rat==24 %Noise peak was only observed in Rat 26
    if w==1  % Reference 
        if strcmp(nFF{iii},'Plusmaze1') || strcmp(nFF{iii},'Baseline1') || strcmp(nFF{iii},'Foraging1')
     Fline=[50 66.5 100 200 133.5 299.5 300];

    [NC] = ft_notch(NC.', Fsample,Fline,0.5,0.5);
%     [NC] = ft_notch(NC.', Fsample,Fline,0.5,0.25);

    NC=NC.';
        end
    end
end

%Equal number of epochs.

% if  Rat==26
%     NC=NC(:,end-1845+1:end);
% else
%     NC=NC(:,end-2500+1:end);
% end
% NC=zscore(NC);
% % % % % % NC=NC(:,end-1845+1:end);
%xo
if strcmp(pw_meth,'welsh')
[pxx,f]=pwelch(NC,[],[],[],1000);
else
[pxx,f]= periodogram(NC,hann(size(NC,1)),size(NC,1),1000);    
end
PXX{iii}=pxx;
%hann(length(NC))
px=mean(pxx,2);
PX{iii}=px;
%  error('stop')
% xo
 if normalizeperiod==1
%plot(f,10*log10(px),'Color',myColorMap(iii,:),'LineWidth',1.5)
semilogy(f,(px)/sum(px),'Color',myColorMap(iii,:),'LineWidth',1.5)
hold on
semilogy(f, [(px.' - 1*std(pxx.')/sqrt(length(pxx.')))/sum(px); (px.'+1*std(pxx.')/sqrt(length(pxx.')))/sum(px)], 'Color',myColorMap(iii,:),'LineWidth',1.5,'LineStyle','-');
 else
s=semilogy(f,(px.*f),'Color',myColorMap(iii,:),'LineWidth',2);
s.Color(4) = 0.8;
hold on
% semilogy(f, [(px.' - 1*std(pxx.')/sqrt(length(pxx.')))/sum(px); (px.'+1*std(pxx.')/sqrt(length(pxx.')))/sum(px)], 'Color',myColorMap(iii,:),'LineWidth',1.5,'LineStyle','-');
%      
 end
 
 
 
xlim([0 300])

grid minor
xlabel('Frequency (Hz)')
%ylabel('10 Log(x)')
ylabel('Power x Frequency')

title(strcat('Power in NREM',{' '} ,label1{2*w-1} ,{' '},'signals'))

%%
%Print to track 
labelconditions{iii};
    end

L = line(nan(length(labelconditions)), nan(length(labelconditions)),'LineStyle','none'); % 'nan' creates 'invisible' data
set(L, {'MarkerEdgeColor'}, num2cell(myColorMap, 2),...
    {'MarkerFaceColor'},num2cell(myColorMap, 2),... % setting the markers to filled squares
    'Marker','s'); 

legend(L, labelconditions)
%         set(gca,'Color','w')
% grid on
% %set(gca,'Color','k')
% ax=gca;
% ax.GridColor=[ 0,0,0];
% xo
%string=strcat('Power_50B_1850_NOTCH_NREM_',label1{2*w-1},'.png');
if acer==0
    cd(strcat('/home/raleman/Dropbox/Figures/Figure2/',num2str(Rat)))
else
      %cd(strcat('C:\Users\Welt Meister\Dropbox\Figures\Figure2\',num2str(Rat)))   
      cd(strcat('C:\Users\addri\Dropbox\Figures\Figure2\',num2str(Rat)))   
end

if Score==2
    cd('new_scoring')
end
% if exist(labelconditions{iii})~=7
% (mkdir(labelconditions{iii}))
% end
% cd((labelconditions{iii}))
% fig=gcf;
% fig.InvertHardcopy='off';
% xo
if Rat~=24
string=strcat('300Hz_',Block{block_time+1},'_',label1{2*w-1},'_x_Freq');
printing(string);

else
    if strcmp(pw_meth,'welsh')
        string=strcat('300Hz_Welsh_',nFF{1},'_',label1{2*w-1},'_x_Freq');
    else
        string=strcat('300Hz_Per_',nFF{1},'_',label1{2*w-1},'_x_Freq');
    end
printing(string);
    
end
% string=strcat('300hz_intra_',label1{2*w-1},'.png');
% saveas(gcf,string)
% 
% string=strcat('300hz_intra_',label1{2*w-1},'.fig');
% saveas(gcf,string)

%string=strcat('300Hz_',Block{block_time+1},'_',label1{2*w-1},'.pdf');

% % % string=strcat('300Hz_',Block{block_time+1},'_',label1{2*w-1},'.fig');
% % % saveas(gcf,string)

xlim([0 30])
if Rat~=24
string=strcat('30Hz_',Block{block_time+1},'_',label1{2*w-1},'_x_Freq');
printing(string);
else
    if strcmp(pw_meth,'welsh')
        string=strcat('30Hz_Welsh_',nFF{1},'_',label1{2*w-1},'_x_Freq');
    else
        string=strcat('30Hz_Per_',nFF{1},'_',label1{2*w-1},'_x_Freq');
    end
printing(string);
end
    
% % % string=strcat('30Hz_',Block{block_time+1},'_',label1{2*w-1},'.fig');
% % % saveas(gcf,string)


% 
% xlim([0 50]);
% string=strcat('50hz_intra_',label1{2*w-1},'.png');
% saveas(gcf,string)

close all

end
%%
clearvars -except acer Rat
%end
%end
