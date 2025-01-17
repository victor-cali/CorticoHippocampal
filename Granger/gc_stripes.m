close all
clear all
acer=1;
% rat24base=1;
DUR{1}='1sec';
DUR{2}='10sec';
Block{1}='complete';
Block{2}='block1';
Block{3}='block2';
mergebaseline=0; %Make sure base's while loop condition is never equal to 2.
FiveHun=2; % Options: 0 all, 1 current, 2 1000?
%meth=1;
rat26session3=0; %Swaps session 1 for session 3 on Rat 26.
rat27session3=0; %Swaps session 1 for session 3 on Rat 26.
rippletable=0;
sanity=0;
ripdur=1; % Duration of ripples. 
%%
if acer==0
addpath('/home/raleman/Documents/MATLAB/analysis-tools-master'); %Open Ephys data loader. 
addpath(genpath('/home/raleman/Documents/GitHub/CorticoHippocampal'))
addpath(genpath('/home/raleman/Documents/GitHub/ADRITOOLS'))
addpath('/home/raleman/Documents/internship')
else
addpath('D:\internship\analysis-tools-master'); %Open Ephys data loader.
addpath(genpath('C:\Users\addri\Documents\internship\CorticoHippocampal'))
addpath(genpath('C:\Users\addri\Documents\GitHub\ADRITOOLS'))
%addpath(('C:\Users\addri\Documents\internship\CorticoHippocampal'))
   
end
%%
%Rat=26;
for meth=4:4
for RAT=2:2
 if meth==4
    s=struct; 
 end  
  base=1; %This should be 1  
% for base=1:2 %Baseline numeration.     
while base<=1 %Should be 1 for MERGEDBASELINES otherwise 2.
riptable=zeros(4,3);        
for rat24base=1:1
 
  if RAT~=3 && rat24base==2
      break
  end

for dura=1:1 %Starts with 1
    
rats=[26 27 24 21];
Rat=rats(RAT);    
    
% for Rat=26:26
if Rat==26
nFF=[
%    {'rat26_Base_II_2016-03-24'                         }
%    {'rat26_Base_II_2016-03-24_09-47-13'                }
%    {'rat26_Base_II_2016-03-24_12-55-58'                }
%    {'rat26_Base_II_2016-03-24_12-57-57'                }
    
   
%   {'rat26_nl_base_III_2016-03-30_10-32-57'            }
 %    {'rat26_nl_base_II_2016-03-28_10-40-19'             }
     {'rat26_nl_baseline2016-03-01_11-01-55'             }
    {'rat26_plusmaze_base_2016-03-08_10-24-41'}
    
    
    
    {'rat26_novelty_I_2016-04-12_10-05-55'          }
%     {'rat26_novelty_II_2016-04-13_10-23-29'             }
    {'rat26_for_2016-03-21_10-38-54'                    }
%     {'rat26_for_II_2016-03-23_10-49-50'                 }
    
    ];

if strcmp(nFF{1},'rat26_nl_baseline2016-03-01_11-01-55')
NFF=[ {'rat26_nl_base_II_2016-03-28_10-40-19'             }];    
end
if strcmp(nFF{1},'rat26_nl_base_II_2016-03-28_10-40-19')
NFF=[ {'rat26_nl_baseline2016-03-01_11-01-55'             }];
end

% xo
if strcmp(nFF{1},'rat26_nl_baseline2016-03-01_11-01-55') && rat26session3==1
   nFF{1}='rat26_nl_base_III_2016-03-30_10-32-57'; 
end
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
    
    'Baseline'}
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
     {'rat27_nl_base_2016-03-28_15-01-17'                   } %Baseline 2: Use this one. 
   % {'rat27_NL_baseline_2016-02-26_12-50-26'               }
   % {'rat27_nl_base_III_2016-03-30_14-36-57'               }
    
   {'rat27_plusmaze_base_2016-03-14_14-52-48'             }
   %{'rat27_plusmaze_base_II_2016-03-24_14-10-08'          }
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
%NFF=[{'rat27_NL_baseline_2016-02-26_12-50-26'               }];
if strcmp(nFF{1},'rat27_NL_baseline_2016-02-26_12-50-26')
NFF=[ {  'rat27_nl_base_2016-03-28_15-01-17'           }];    
end
if strcmp(nFF{1}, 'rat27_nl_base_2016-03-28_15-01-17')
NFF=[ {'rat27_NL_baseline_2016-02-26_12-50-26'   }];
end
if rat27session3==1
    if strcmp(nFF{1}, 'rat27_nl_base_2016-03-28_15-01-17')
    NFF=[ {'rat27_nl_base_III_2016-03-30_14-36-57'   }];
    end
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
    {'Baseline1'}
%     {'Baseline2'}
%     {'Baseline3'}
%     {'Baseline4'}
    {'Plusmaze1'}
%     {'Plusmaze2'}
   {'Novelty1'}
   {'Foraging1'}
     
]; 
if  rat24base==2
  nFF{1,:}='Baseline2'; 
end

%labelconditions=nFF;
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



end

%% Check if experiment has been run before.
if acer==0
    cd(strcat('/home/raleman/Dropbox/Figures/Figure3/',num2str(Rat)))
else
      %cd(strcat('C:\Users\Welt Meister\Dropbox\Figures\Figure2\',num2str(Rat)))   
      cd(strcat('C:\Users\addri\Dropbox\Figures\Figure3\',num2str(Rat)))   
end

if Rat==24
    cd(nFF{1})
end

if dura==2
    cd('10sec')
end
%xo
% 
% %Ignore this for a moment
% FolderRip=[{'all_ripples'} {'500'} {'1000'}];
% if Rat==26
% Base=[{'Baseline1'} {'Baseline2'}];
% end
% 
% if Rat==26 && rat26session3==1
% Base=[{'Baseline3'} {'Baseline2'}];
% end
% 
% if Rat==27 
% Base=[{'Baseline2'} {'Baseline1'}];% We run Baseline 2 first, cause it is the one we prefer.
% end
% 
% if meth==1
% Folder=strcat(Base{base},'_',FolderRip{FiveHun+1});
% else
% Method=[{'Method2' 'Method3' 'Method4'}];
% Folder=strcat(Base{base},'_',FolderRip{FiveHun+1},'_',Method{meth-1});    
% end
% 
% if exist(Folder)==7 && base==1
% base=base+1;
% end
%%
% Use other baseline, beware when using mergebaseline
if base==2
    nFF{1}=NFF{1};
end

if base==3
    break
end


%% Go to main directory
if acer==0
    cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))
    addpath /home/raleman/Documents/internship/fieldtrip-master/
    InitFieldtrip()

    cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))
    clc
else
    cd(strcat('D:\internship\',num2str(Rat)))
    addpath D:\internship\fieldtrip-master
    InitFieldtrip()

    % cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))
    cd(strcat('D:\internship\',num2str(Rat)))
    clc
end

%% Select experiment to perform. 
% inter=1;
%Select length of window in seconds:
if dura==1
ro=[1200];
%ro=[250];
else
ro=[10200];    
end
% coher=0;
% selectripples=1;
notch=0;
nrem=3;
myColorMap = jet(8);
% Score=1;
%%

%Make labels
label1=cell(7,1);
label1{1}='Hippo';
label1{2}='Hippo';
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


lab=cell(6,1);

lab{1}='HPC -> Parietal';
lab{2}='Parietal -> HPC';

lab{3}='HPC -> PFC';
lab{4}='PFC -> HPC';

lab{5}='Parietal -> PFC';
lab{6}='PFC -> Parietal';
%%
myColorMap = jet(8);                                                                                                                                                                                    
myColorMap =myColorMap([2 4 5 7],:);
myColorMap(2,:)=[0, 204/255, 0];
myColorMap(3,:)=[0.9290, 0.6940, 0.1250];

nFF=nFF([1 4 3 2]);
labelconditions=labelconditions([1 4 3 2]);


%Rat 24
% if Rat==24
%     myColorMap = jet(length(nFF));                                                                                                                                                                                    
% end

 
for block_time=0:0 %Should start with 0
%for iii=1:length(nFF) %Should be 1 for Granger. 4 is faster though. Good for debugging. 
for iii=1:1 %Should be 1 for Granger. 4 is faster though. Good for debugging. 
    
%for iii=1:1 %Should start with 2!
%for vert=2:length(nFF)
    %xo
if acer==0
    cd(strcat('/home/raleman/Dropbox/Figures/Figure3/',num2str(Rat)))
else
      %cd(strcat('C:\Users\Welt Meister\Dropbox\Figures\Figure2\',num2str(Rat)))   
      cd(strcat('C:\Users\addri\Dropbox\Figures\Figure3\',num2str(Rat)))   
end

if Rat==24
    cd(nFF{1})
end

if dura==2
    cd('10sec')
end

if iii==1 && sanity==1
%Get number of ripples
FolderRip=[{'all_ripples'} {'500'} {'1000'}];
            Method=[{'Method2' 'Method3' 'Method4'}];
if Rat==26
Base=[{'Baseline1'} {'Baseline2'} {'Baseline3'}];
end
%             else
%             Base=[{'Baseline2'} {'Baseline1'} {'Baseline3'}];    
%             end
if Rat==26 && rat26session3==1
Base=[{'Baseline3'} {'Baseline2'}];
end

if Rat==27 
Base=[{'Baseline2'} {'Baseline1'}];% We run Baseline 2 first, cause it is the one we prefer.
end

if Rat==27 && rat27session3==1
Base=[{'Baseline2'} {'Baseline3'}];% We run Baseline 2 first, cause it is the one we prefer.    
end

            folder=strcat(Base{base},'_',FolderRip{FiveHun+1},'_',Method{meth-1});
%xo
cd(folder)
%look for randrip.
b=struct2cell(dir)

if ~any(ismember(b(1,:),'randrip.mat'))

load('NumberRipples.mat')
vr=getfield(s,Base{base});
vr=min(vr(:,1));
    
randrip=randi(1000,[1,vr]);
save('randrip.mat','randrip');

%xo
else
 load('randrip.mat')   
end
cd('..')
end
% xo
% 
% string1=strcat('Spec_',labelconditions{iii},'_',label1{2*2-1},'_',Block{block_time+1},'_',DUR{dura},'.pdf');
% string2=strcat('Spec_',labelconditions{iii},'_',label1{2*3-1},'_',Block{block_time+1},'_',DUR{dura},'.pdf');
% 
% 
% while exist(string1, 'file')==2 && exist(string2, 'file')==2
% iii=iii+1;
% 
% if iii>length(nFF)
%     break
% end
%    string1=strcat('Spec_',labelconditions{iii},'_',label1{2*2-1},'_',Block{block_time+1},'_',DUR{dura},'.pdf');
%    string2=strcat('Spec_',labelconditions{iii},'_',label1{2*3-1},'_',Block{block_time+1},'_',DUR{dura},'.pdf');
% 
% end

if iii>length(nFF)
    break
end

% string=strcat('Spec_',labelconditions{iii},'_',label1{2*2-1},'_',Block{block_time+1},'_',DUR{dura},'.pdf');
% if exist(string, 'file') == 2
% string=strcat('Spec_',labelconditions{iii},'_',label1{2*3-1},'_',Block{block_time+1},'_',DUR{dura},'.pdf');    
%       if exist(string, 'file') == 2
%            iii=iii+1;
%       end
% end
%  clearvars -except nFF iii labelconditions inter granger Rat ro label1 label2 coher selectripples acer mergebaseline nr_27 nr_26 co_26 co_27 nrem notch myColorMap



%for level=1:length(ripple)-1;    
 %for level=1:1
     

 
if acer==0
    cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))
else
    cd(strcat('D:\internship\',num2str(Rat)))
end

cd(nFF{iii})
lepoch=2;

 level=1;
 
%Get averaged time signal.
% [sig1,sig2,ripple,carajo,veamos,CHTM,RipFreq2,timeasleep]=newest_only_ripple_level(level);
% if strcmp(labelconditions{iii},'Baseline') || strcmp(labelconditions{iii},'PlusMaze')
% [ripple,timeasleep,DEMAIS,y1]=NREM_newest_only_ripple_level(level,nrem,notch,w,lepoch,Score);
% else
%xo
%[sig1,sig2,ripple,carajo,veamos,CHTM,RipFreq2,timeasleep]=NREM_get_ripples(level,nrem,notch,w,lepoch,Score)
% [Sig1,Sig2,Ripple,Carajo,Veamos,CHTM2,RipFreq22,Timeasleep]=newest_only_ripple_level(level,lepoch)
if meth==1
    [sig1,sig2,ripple,carajo,veamos,CHTM,RipFreq2,timeasleep]=newest_only_ripple_level_ERASETHIS(level);
%     [Nsig1,Nsig2,Nripple,Ncarajo,Nveamos,NCHTM,NRipFreq2,Ntimeasleep]=newest_only_ripple_nl_level(level);
end

if meth==2
    [sig1,sig2,ripple,carajo,veamos,CHTM,RipFreq2,timeasleep]=median_std;    
end

if meth==3
chtm=load('vq_loop2.mat');
chtm=chtm.vq;
    [sig1,sig2,ripple,carajo,veamos,RipFreq2,timeasleep,~]=nrem_fixed_thr_Vfiles(chtm,notch);
CHTM=[chtm chtm];
end
%%
if meth==4   
if acer==0
    cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))
else
    cd(strcat('D:\internship\',num2str(Rat)))
end

cd(nFF{1})

[timeasleep]=find_thr_base;
ror=2000/timeasleep;

    if acer==0
        cd(strcat('/home/raleman/Dropbox/Figures/Figure2/',num2str(Rat)))
    else
          %cd(strcat('C:\Users\Welt Meister\Dropbox\Figures\Figure2\',num2str(Rat)))   
          cd(strcat('C:\Users\addri\Dropbox\Figures\Figure2\',num2str(Rat)))   
    end
    

if Rat==26
Base=[{'Baseline1'} {'Baseline2'}];
end
if Rat==26 && rat26session3==1
Base=[{'Baseline3'} {'Baseline2'}];
end

if Rat==27 
Base=[{'Baseline2'} {'Baseline1'}];% We run Baseline 2 first, cause it is the one we prefer.
end

if Rat==27 && rat27session3==1
Base=[{'Baseline2'} {'Baseline3'}];% We run Baseline 2 first, cause it is the one we prefer.    
end
%openfig('Ripples_per_condition_best.fig')
openfig(strcat('Ripples_per_condition_',Base{base},'.fig'))

h = figure(1); %current figure handle
axesObjs = get(h, 'Children');  %axes handles
dataObjs = get(axesObjs, 'Children'); %handles to low-level graphics objects in axes

ydata=dataObjs{2}(8).YData;
xdata=dataObjs{2}(8).XData;
% figure()
% plot(xdata,ydata)
chtm = interp1(ydata,xdata,ror);
close

%xo
if acer==0
    cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))
else
    cd(strcat('D:\internship\',num2str(Rat)))
end

cd(nFF{iii})
    [sig1,sig2,ripple,carajo,veamos,RipFreq2,timeasleep,~]=nrem_fixed_thr_Vfiles(chtm,notch);
CHTM=[chtm chtm];
riptable(iii,1)=ripple;
riptable(iii,2)=timeasleep;
riptable(iii,3)=RipFreq2;

end

%Nose=[Nose RipFreq2];


%% Select time block 
if block_time==1
[carajo,veamos]=equal_time2(sig1,sig2,carajo,veamos,30,0);
ripple=sum(cellfun('length',carajo{1}(:,1))); %Number of ripples after equal times.
end

if block_time==2
[carajo,veamos]=equal_time2(sig1,sig2,carajo,veamos,60,30);
ripple=sum(cellfun('length',carajo{1}(:,1))); %Number of ripples after equal times.
end

%%

%%
%xo

end

%Plot 
%%
if acer==0
    cd(strcat('/home/raleman/Dropbox/Figures/Figure4/',num2str(Rat)))
else
      %cd(strcat('C:\Users\Welt Meister\Dropbox\Figures\Figure2\',num2str(Rat)))   
      cd(strcat('C:\Users\addri\Dropbox\Figures\Figure4\',num2str(Rat)))   
end

load('gees.mat') %BFNP
load('gcs_all.mat') %BFNP  %Granger per ripples. 

%Use data used to generate statistics and average trials for plotting. 
FP_prom=cellfun(@(v) mean(v,4),FP,'UniformOutput',0);%BFNP
FNP_prom=cellfun(@(v) mean(v,4),FNP,'UniformOutput',0);
MVGC_prom=cellfun(@(v) mean(v,4),MVGC,'UniformOutput',0);

%Load the stripes. Significant difference between BASELINE and Plusmaze. 
FP_aver=load('FP_aver.mat');
FNP_aver=load('FNP_aver.mat');
MVGC_aver=load('MVGC_aver.mat');

%P value less than  0.01
FP_aver.Xaver=convert_pvalue(FP_aver.Xaver2,0.01);
FP_aver.aver=convert_pvalue(FP_aver.aver2,0.01);

FNP_aver.Xaver=convert_pvalue(FNP_aver.Xaver2,0.01);
FNP_aver.aver=convert_pvalue(FNP_aver.aver2,0.01);

MVGC_aver.Xaver=convert_pvalue(MVGC_aver.Xaver2,0.01);
MVGC_aver.aver=convert_pvalue(MVGC_aver.aver2,0.01);

 %% Generate figures and save
% %Regenerate binary and confirm
% figure_binary(FP_aver.aver,FP_aver.Xaver,lab,0.01)
% printing_image('FP_binary_0.01')
% close all
% 
% figure_pval(FP_aver.aver2,FP_aver.Xaver2,lab,0.01)
% printing_image('FP_pval_0.01')
% close all
% 
% figure_binary(FNP_aver.aver,FNP_aver.Xaver,lab,0.01)
% printing_image('FNP_binary_0.01')
% close all
% 
% figure_pval(FNP_aver.aver2,FNP_aver.Xaver2,lab,0.01)
% printing_image('FNP_pval_0.01')
% close all
% 
% figure_binary(MVGC_aver.aver,MVGC_aver.Xaver,lab,0.01)
% printing_image('MVGC_binary_0.01')
% close all
% 
% figure_pval(MVGC_aver.aver2,MVGC_aver.Xaver2,lab,0.01)
% printing_image('MVGC_pval_0.01')
% close all
%%

FP_mult=FP_aver.Xaver.*FP_aver.aver;
FP_multinv1=FP_aver.Xaver.*not(FP_aver.aver);
FP_multinv2=FP_aver.aver.*not(FP_aver.Xaver);


FNP_mult=FNP_aver.Xaver.*FNP_aver.aver;
MVGC_mult=MVGC_aver.Xaver.*MVGC_aver.aver;


xo
%Widepass
granger_paper4_stripes(g1,g1_f,labelconditions,[0 300],FP_aver.Xaver,FP_aver.aver) %Parametric (501 samples due to fs/2+1)


granger_paper4_stripes_two_conditions(g1,g1_f,labelconditions,[0 300],FP_aver.aver,FP_aver.Xaver) %Parametric (501 samples due to fs/2+1)

granger_paper4_stripes_two_conditions(FP_prom,g1_f,labelconditions,[0 300],FP_aver.aver,FP_aver.Xaver) %Parametric (501 samples due to fs/2+1)


granger_paper4_stripes_two_conditions(FP_prom,g1_f,labelconditions,[0 300],FP_mult,FP_mult) %Parametric (501 samples due to fs/2+1)
granger_paper4_stripes_two_conditions(g1,g1_f,labelconditions,[0 300],FP_mult,FP_mult) %Parametric (501 samples due to fs/2+1)


granger_paper4_stripes_two_conditions(FP_prom,g1_f,labelconditions,[0 300],FP_multinv1,FP_multinv1) %Parametric (501 samples due to fs/2+1)


granger_paper4_stripes_two_conditions(g1,g1_f,labelconditions,[0 300],MVGC_aver.aver,MVGC_aver.Xaver) %Parametric (501 samples due to fs/2+1)


granger_paper4_stripes_two_conditions(g,g_f,labelconditions,[0 300],FNP_aver.aver,FNP_aver.Xaver) %Parametric (501 samples due to fs/2+1)

granger_paper4_stripes_two_conditions(g,g_f,labelconditions,[0 300],FNP_aver.Xaver,FNP_aver.aver) %Parametric (501 samples due to fs/2+1)



% printing_image('GC_P_Widepass_1sec')
%printing_image('GC_P_Widepass_0.5sec')
% printing_image('GC_P_Widepass_0.25sec')
close all

xo
% granger_2D_testall(g1,g1_f,labelconditions,[0 300]) %g1 looks better due to higher number of samples. 
% printing_image('GC2D_P_Widepass_1sec')
% close all



granger_paper4(g,g_f,labelconditions,[0 300])
%printing_image('GC_NP_Widepass_1sec')
%printing_image('GC_NP_Widepass_0.5sec')
% printing_image('GC_NP_Widepass_0.25sec')
close all

granger_2D_testall(g,g_f,labelconditions,[0 300]) %g1 looks better due to higher number of samples. 
printing_image('GC2D_NP_Widepass_1sec')
close all


%Bandpass
granger_paper4(G,G_f,labelconditions,[100 300])
% printing_image('GC_NP_Bandpass_1sec')
% printing_image('GC_NP_Bandpass_0.5sec')
% printing_image('GC_NP_Bandpass_0.25sec')
close all

granger_2D_testall(G,G_f,labelconditions,[100 300]) %g1 looks better due to higher number of samples. 
printing_image('GC2D_NP_Bandpass_1sec')
close all


granger_paper4(G1,G1_f,labelconditions,[100 300])
% printing_image('GC_P_Bandpass_1sec')
% printing_image('GC_P_Bandpass_0.5sec')
% printing_image('GC_P_Bandpass_0.25sec')
close all

granger_2D_testall(G1,G1_f,labelconditions,[100 300]) %g1 looks better due to higher number of samples. 
printing_image('GC2D_P_Bandpass_1sec')
close all

%%
granger_2D_testall_nostats(g,g_f,labelconditions,[0 300]) %g1 looks better due to higher number of samples. 
printing_image('GC2D_ns_NP_Widepass_1sec')
close all

granger_2D_testall_nostats(g1,g1_f,labelconditions,[0 300]) %g1 looks better due to higher number of samples. 
printing_image('GC2D_ns_P_Widepass_1sec')
close all

granger_2D_testall_nostats(G,G_f,labelconditions,[100 300]) %g1 looks better due to higher number of samples. 
printing_image('GC2D_ns_NP_Bandpass_1sec')
close all

granger_2D_testall_nostats(G1,G1_f,labelconditions,[100 300]) %g1 looks better due to higher number of samples. 
printing_image('GC2D_ns_P_Bandpass_1sec')
close all

%% Stats among conditions
F= [1 2; 1 3; 2 3] ;

lab{1}='HPC -> Parietal';
lab{2}='Parietal -> HPC';

lab{3}='HPC -> PFC';
lab{4}='PFC -> HPC';

lab{5}='Parietal -> PFC';
lab{6}='PFC -> Parietal';


lab2{1}='HPC_Parietal';
lab2{2}='Parietal_HPC';
lab2{3}='HPC_PFC';
lab2{4}='PFC_HPC';
lab2{5}='Parietal_PFC';
lab2{6}='PFC_Parietal';


for nv=1:3
f=F(nv,:); %Pair

%First direction
granger_2D_stats_conditions(g,g_f,labelconditions,[0 300],f)
mtit(lab{2*nv-1})
printing_image(strcat('Stat_',lab2{2*nv-1},'_','NP_Widepass_1sec'))
close all
%Opposite direction
granger_2D_stats_conditions(g,g_f,labelconditions,[0 300],flip(f))
mtit(lab{2*nv})
printing_image(strcat('Stat_',lab2{2*nv},'_','NP_Widepass_1sec'))
close all

%First direction
granger_2D_stats_conditions(g1,g1_f,labelconditions,[0 300],f)
mtit(lab{2*nv-1})
printing_image(strcat('Stat_',lab2{2*nv-1},'_','P_Widepass_1sec'))
close all

%Opposite direction
granger_2D_stats_conditions(g1,g1_f,labelconditions,[0 300],flip(f))
mtit(lab{2*nv})
printing_image(strcat('Stat_',lab2{2*nv},'_','P_Widepass_1sec'))
close all

% % % 
% % % %First direction
% % % granger_2D_stats_conditions(G,G_f,labelconditions,[100 300],f)
% % % mtit(lab{2*nv-1})
% % % printing_image(strcat('Stat_',lab2{2*nv-1},'_','NP_Bandpass_1sec'))
% % % close all
% % % 
% % % 
% % % %Opposite direction
% % % granger_2D_stats_conditions(G,G_f,labelconditions,[100 300],flip(f))
% % % mtit(lab{2*nv})
% % % printing_image(strcat('Stat_',lab2{2*nv},'_','NP_Bandpass_1sec'))
% % % close all
% % % 
% % % %First direction
% % % granger_2D_stats_conditions(G1,G1_f,labelconditions,[100 300],f)
% % % mtit(lab{2*nv-1})
% % % printing_image(strcat('Stat_',lab2{2*nv-1},'_','P_Bandpass_1sec'))
% % % close all
% % % 
% % % %Opposite direction
% % % granger_2D_stats_conditions(G1,G1_f,labelconditions,[100 300],flip(f))
% % % mtit(lab{2*nv})
% % % printing_image(strcat('Stat_',lab2{2*nv},'_','P_Bandpass_1sec'))
% % % close all

end

%%

% 
% %Non-parametric
% granger_paper2(gran,labelconditions{iii})
% hold on
% %Parametric
% granger_paper2(gran1,labelconditions{iii})
% hold on

%END 
%%
xo

xq=0:0.5:500;



%Q=Q([ran]);
%timecell=timecell([ran]);
%[p]=filter_ripples(q,[66.67 100 150 266.7 133.3 200 300 333.3 266.7 233.3 250 166.7 133.3],.5,.5);

%%
clear U VQ MU

for k=1:length(q)
% plot(q{k})   
%  hold on
% [fi,am]=periodogram(q{6});
 [pxx,f]= periodogram(q{k},hann(length(q{k})),length(q{k}),1000);
%  semilogy(f,(pxx))
 vq1 = interp1(f,pxx,xq,'PCHIP');
 VQ(k,:)=vq1;
%  U(k)=interp1(VQ(k,:),xq,max(VQ(k,:)));
 U(k)=interp1(VQ(k,:),xq,mean(VQ(k,:)));
MU(k)=interp1(VQ(k,:),xq,max(VQ(k,:)));
 %%
%  semilogy(f,(pxx))
%  hold on
%  semilogy(xq,(vq1))
 k/length(q)*100
end
UU{iii}=U;
MUU{iii}=MU;
%%

consig=carajo{1};

bon=consig(:,1:2);
C = cellfun(@minus,bon(:,2),bon(:,1),'UniformOutput',false);
C=cell2mat(C.');
data_SEM = std(C)/sqrt( length(C));       % SEM Across Columns
CC{iii,:}=C;
%xo
c=median(C)*1000; %Miliseconds
ccc=mean(C)*1000;
% c=median(c)*1000; %Miliseconds
cc(iii)=c;
cccc(iii)=ccc;

consig=consig(:,3);

aver=cellfun(@(x) diff(x), consig,'UniformOutput',false);
aver=[aver{:}];
Aver{iii,:}=aver;
Sem(iii,:)=data_SEM;

%lq(iii,:)=cellfun('length',q)/1000; %sec
lq{iii}=cellfun('length',q)/1000; %sec
end
%%
 xo
%%

if ripdur==1
LQ = [lq(1,:) lq(2,:)  lq(3,:)  lq(4,:)];
    
grp = [zeros(1,size(lq,2)),ones(1,size(lq,2)),2*ones(1,size(lq,2)),3*ones(1,size(lq,2))];

bb=boxplot(LQ*1000,grp,'Notch','on' );
%ylim([0 0.10*1000])
ylim([0 160])
set(bb(7,:),'Visible','off');
ave=gca;
ave.XTickLabel=labelconditions;
ylabel('Time (ms)')
   
    
end
%% 
UM = [UU{1} UU{2}  UU{3}  UU{4}];
grp = [zeros(1,length(UU{1})),ones(1,length(UU{2})),2*ones(1,length(UU{3})),3*ones(1,length(UU{4}))];
bb=boxplot(UM,grp,'Notch','on' );
%set(bb(7,:),'Visible','off');
ave=gca;
ave.XTickLabel=labelconditions;
ylabel('Frequency (Hz)')
%ylim([60 300])
%%
UM = [MUU{1} MUU{2}  MUU{3}  MUU{4}];
grp = [zeros(1,length(UU{1})),ones(1,length(UU{2})),2*ones(1,length(UU{3})),3*ones(1,length(UU{4}))];
bb=boxplot(UM,grp,'Notch','on' );
set(bb(7,:),'Visible','off');
ave=gca;
ave.XTickLabel=labelconditions;
ylabel('Frequency (Hz)')
%ylim([90 220])
ylim([90 230])
%% Violin
violin(UU,[9 9 9 9],'facecolor',[[180/256 180/256 180/256];[38/256 43/256 226/256];[1 1 0];[0 0 0]],'medc','k','mc','')
ave=gca;
ylabel('Frequency (Hz)')
ave.XTickLabel=[' '; labelconditions(1);' '; labelconditions(2);' '; labelconditions(3);' '; labelconditions(4);' ';];
legend off
%%
violin(MUU,[5 5 5 5],'facecolor',[[180/256 180/256 180/256];[38/256 43/256 226/256];[1 1 0];[0 0 0]],'medc','k','mc','')
ave=gca;
ylabel('Frequency (Hz)')
ave.XTickLabel=[' '; labelconditions(1);' '; labelconditions(2);' '; labelconditions(3);' '; labelconditions(4);' ';];
legend off

%%
if acer==0
    cd(strcat('/home/raleman/Dropbox/Figures/Figure3/',num2str(Rat)))
else
      %cd(strcat('C:\Users\Welt Meister\Dropbox\Figures\Figure2\',num2str(Rat)))   
      cd(strcat('C:\Users\addri\Dropbox\Figures\Figure3\',num2str(Rat)))   
end
%%
if sanity==1

string=strcat('Control_Peak_Frequency_','Allconditions','_',Block{block_time+1},'_','.pdf');
figure_function(gcf,[],string,[]);
string=strcat('Control_Peak_Frequency_','Allconditions','_',Block{block_time+1},'_','.eps');
print(string,'-depsc')
string=strcat('Control_Peak_Frequency_','Allconditions','_',Block{block_time+1},'_','.fig');
saveas(gcf,string)

else
string=strcat('Peak_Frequency_','Allconditions','_',Block{block_time+1},'_','.pdf');
figure_function(gcf,[],string,[]);
string=strcat('Peak_Frequency_','Allconditions','_',Block{block_time+1},'_','.eps');
print(string,'-depsc')
string=strcat('Peak_Frequency_','Allconditions','_',Block{block_time+1},'_','.fig');
saveas(gcf,string)
    

string=strcat('Peak_Frequency_Violin_','Allconditions','_',Block{block_time+1},'_','.pdf');
figure_function(gcf,[],string,[]);
string=strcat('Peak_Frequency_Violin_','Allconditions','_',Block{block_time+1},'_','.eps');
print(string,'-depsc')
string=strcat('Peak_Frequency_Violin_','Allconditions','_',Block{block_time+1},'_','.fig');
saveas(gcf,string)
end
%%
if sanity==1

string=strcat('Control_Average_Frequency_','Allconditions','_',Block{block_time+1},'_','.pdf');
figure_function(gcf,[],string,[]);
string=strcat('Control_Average_Frequency_','Allconditions','_',Block{block_time+1},'_','.eps');
print(string,'-depsc')
string=strcat('Control_Average_Frequency_','Allconditions','_',Block{block_time+1},'_','.fig');
saveas(gcf,string)

else
string=strcat('Average_Frequency_','Allconditions','_',Block{block_time+1},'_','.pdf');
figure_function(gcf,[],string,[]);
string=strcat('Average_Frequency_','Allconditions','_',Block{block_time+1},'_','.eps');
print(string,'-depsc')
string=strcat('Average_Frequency_','Allconditions','_',Block{block_time+1},'_','.fig');
saveas(gcf,string)

string=strcat('Average_Frequency_Violin_','Allconditions','_',Block{block_time+1},'_','.pdf');
figure_function(gcf,[],string,[]);
string=strcat('Average_Frequency_Violin_','Allconditions','_',Block{block_time+1},'_','.eps');
print(string,'-depsc')
string=strcat('Average_Frequency_Violin_','Allconditions','_',Block{block_time+1},'_','.fig');
saveas(gcf,string)

end
%%
%%
xo
%%
string=strcat('Control_RippleDuration_','Allconditions','_',Block{block_time+1},'_','.pdf');
figure_function(gcf,[],string,[]);
string=strcat('Control_RippleDuration_','Allconditions','_',Block{block_time+1},'_','.eps');
print(string,'-depsc')
string=strcat('Control_RippleDuration_','Allconditions','_',Block{block_time+1},'_','.fig');
saveas(gcf,string)

%%
%%
%histogram(aver,'Normalization','probability','BinWidth',0.1); xlim([0 4])

end
end
xo
if iii==length(nFF)
   break 
end

end

end

%%
%clearvars -except acer Rat
end
xo

%end
%xo
