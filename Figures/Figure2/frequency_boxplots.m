close all
clear variables

%Rat numbers
rats=[26 27 24 21]; 

%Variables used for different segments of time.
DUR{1}='1sec';
DUR{2}='10sec';
Block{1}='complete';
Block{2}='block1';
Block{3}='block2';

%Calls GUI to select analysis and parameters;
gui_parameters

%Method of Ripple selection. Method 4 gives best results.
prompt = {'Select SWR detection Method'};
dlgtitle = 'Detection';
definput = {'4'};
opts.Interpreter = 'tex';
answer = inputdlg(prompt,dlgtitle,[1 40],definput,opts);
meth=str2num(answer{1});

s=struct;
%In case of Method 5, which cortical area?
if meth==5
    w='PAR';
else
    w='HPC'
end

%Data location
%datapath='D:\internship\';
datapath='C:\Users\addri\Documents\internship\downsampled_NREM_data';


ripdur=1; % Duration of ripples. 
%%
Rat=rats(RAT);  %Rat number to use. 

%for RAT=3:3
 
 switch RAT   
    case 1
         base=2;
    case 2
         base=1; %Base 1 actually calls baseline 2.
    case 3
        %xo
        base=2; %Should be 2
    otherwise
        disp('Rat 21 not available')
        xo
 end

%While loop previously used for merging baselines.  
while base<=2-mergebaseline %Should be 1 for MERGEDBASELINES otherwise 2.

    riptable=zeros(4,3);% Variable used to save number of ripples.        

    if RAT==3
        rat24base=2;
    else
        rat24base=1;
    end

    if RAT~=3 && rat24base==2
          break
    end

for dura=1:1 %Starts with 1
        
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
% xo
%% Check if experiment has been run before.
if acer==0
    cd(strcat('/home/adrian/Dropbox/Figures/Figure3/',num2str(Rat)))
else
      %cd(strcat('C:\Users\Welt Meister\Dropbox\Figures\Figure2\',num2str(Rat)))   
      cd(strcat('C:\Users\addri\Dropbox\Figures\Figure3\',num2str(Rat)))   
end

% if Rat==24
%     cd(nFF{1})
% end

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
if base==2 && Rat~=24
    nFF{1}=NFF{1};
end

if base==3
    break
end


%% Go to main directory
if acer==0
    cd(strcat('/home/adrian/Documents/downsampled_NREM_data/',num2str(Rat)))
%     addpath /home/adrian/Documents/internship/fieldtrip-master/
    InitFieldtrip()

%     cd(strcat('/home/adrian/Documents/internship/',num2str(Rat)))
    clc
else
%     cd(strcat('D:\internship\',num2str(Rat)))
%     addpath D:\internship\fieldtrip-master
%     InitFieldtrip()

    % cd(strcat('/home/adrian/Documents/internship/',num2str(Rat)))
    cd(strcat(datapath,'\',num2str(Rat)))
    
    clc
end

%% Select experiment to perform. 
% inter=1;
%Select length of window in seconds:
if dura==1
ro=[1200];
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
for iii=1:length(nFF) %Should start with 2!
%for iii=1:1 %Should start with 2!
%for vert=2:length(nFF)
    %xo
if acer==0
    cd(strcat('/home/adrian/Dropbox/Figures/Figure3/',num2str(Rat)))
else
      %cd(strcat('C:\Users\Welt Meister\Dropbox\Figures\Figure2\',num2str(Rat)))   
      cd(strcat('C:\Users\addri\Dropbox\Figures\Figure3\',num2str(Rat)))   
end

% if Rat==24
%     cd(nFF{1})
% end

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
    cd(strcat('/home/adrian/Documents/downsampled_NREM_data/',num2str(Rat)))
else
    cd(strcat(datapath,'\',num2str(Rat)))
end

cd(nFF{iii})
lepoch=2;

 level=1;
 
%Get averaged time signal.
% [sig1,sig2,ripple,cara,veamos,CHTM,RipFreq2,timeasleep]=newest_only_ripple_level(level);
% if strcmp(labelconditions{iii},'Baseline') || strcmp(labelconditions{iii},'PlusMaze')
% [ripple,timeasleep,DEMAIS,y1]=NREM_newest_only_ripple_level(level,nrem,notch,w,lepoch,Score);
% else
%  xo
%[sig1,sig2,ripple,cara,veamos,CHTM,RipFreq2,timeasleep]=NREM_get_ripples(level,nrem,notch,w,lepoch,Score)
% [Sig1,Sig2,Ripple,cara,Veamos,CHTM2,RipFreq22,Timeasleep]=newest_only_ripple_level(level,lepoch)
switch meth

        case 1
            [sig1,sig2,ripple,cara,veamos,CHTM,RipFreq2,timeasleep]=newest_only_ripple_level_ERASETHIS(level);
        %     [Nsig1,Nsig2,Nripple,Ncara,Nveamos,NCHTM,NRipFreq2,Ntimeasleep]=newest_only_ripple_nl_level(level);
        

        case 2
            [sig1,sig2,ripple,cara,veamos,CHTM,RipFreq2,timeasleep]=median_std;    
        

        case 3
        chtm=load('vq_loop2.mat');
        chtm=chtm.vq;
            [sig1,sig2,ripple,cara,veamos,RipFreq2,timeasleep,~]=nrem_fixed_thr_Vfiles(chtm,notch);
        CHTM=[chtm chtm];
        
        %%
        case 4   
            if acer==0
                cd(strcat('/home/adrian/Documents/downsampled_NREM_data/',num2str(Rat)))
            else
                cd(strcat(datapath,'\',num2str(Rat)))
            end

        cd(nFF{1})

        [timeasleep]=find_thr_base;
        ror=2000/timeasleep;

            if acer==0
                cd(strcat('/home/adrian/Dropbox/Figures/Figure2/',num2str(Rat)))
            else
                  %cd(strcat('C:\Users\Welt Meister\Dropbox\Figures\Figure2\',num2str(Rat)))   
                  cd(strcat('C:\Users\addri\Dropbox\Figures\Figure2\',num2str(Rat)))   
            end


        if Rat==26 || Rat==24
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
            cd(strcat('/home/adrian/Documents/downsampled_NREM_data/',num2str(Rat)))
        else
            cd(strcat(datapath,'\',num2str(Rat)))
        end

        cd(nFF{iii})
            [sig1,sig2,ripple,cara,veamos,RipFreq2,timeasleep,~]=nrem_fixed_thr_Vfiles(chtm,notch,w);
        CHTM=[chtm chtm];
        riptable(iii,1)=ripple;
        riptable(iii,2)=timeasleep;
        riptable(iii,3)=RipFreq2;
        
    case 5
        
        chtm=30;
        if acer==0
            cd(strcat('/home/adrian/Documents/internship/',num2str(Rat)))
        else
            cd(strcat(datapath,'/',num2str(Rat)))
        end

        cd(nFF{iii})
        
        [sig1,sig2,ripple,cara,veamos,RipFreq2,timeasleep,ti,vec_nrem, vec_trans ,vec_rem,vec_wake,labels,transitions,transitions2,cara_times]=nrem_fixed_thr_Vfiles(chtm,notch,w);      
        CHTM=[chtm chtm]; %Threshold
        
        %Fill table with ripple information.
        riptable(iii,1)=ripple; %Number of ripples.
        riptable(iii,2)=timeasleep;
        riptable(iii,3)=RipFreq2;

end
        

%Nose=[Nose RipFreq2];
%  xo

%% Select time block 
if block_time==1
[cara,veamos]=equal_time2(sig1,sig2,cara,veamos,30,0);
ripple=sum(cellfun('length',cara{1}(:,1))); %Number of ripples after equal times.
end

if block_time==2
[cara,veamos]=equal_time2(sig1,sig2,cara,veamos,60,30);
ripple=sum(cellfun('length',cara{1}(:,1))); %Number of ripples after equal times.
end

%%

%%
%xo
[p,q,~,~,]=getwin2_new(cara{:,:,level},veamos{level},sig1,sig2,label1,label2,ro);    
xq=0:0.5:500;
%xo

% [ran]=select_rip(p,FiveHun);
% % 
% p=p([ran]);
% q=q([ran]);

if iii~=4 && sanity==1 %4 is Plusmaze!
 p=p(randrip);
 q=q(randrip);
end

%Q=Q([ran]);
%timecell=timecell([ran]);
[q]=filter_ripples_new(q,[66.67 100 150 266.7 133.3 200 300 333.3 266.7 233.3 250 166.7 133.3],.5,.5);
%[p]=filter_ripples(q,[66.67 100 150 266.7 133.3 200 300 333.3 266.7 233.3 250 166.7 133.3],.5,.5);

%%
clear U VQ MU
bar_init=waitbar(0,'Please wait...');
messbox(labelconditions{iii},'Current condition')
for k=1:length(q)
% plot(q{k})   
%  hold on
% [fi,am]=periodogram(q{6});

% % % %Old approach
[pxx,f]= periodogram(q{k},hann(length(q{k})),length(q{k}),1000);
% % % %  semilogy(f,(pxx))
% % %  vq1 = interp1(f,pxx,xq,'PCHIP');
% % %  VQ(k,:)=vq1;
% % % %  U(k)=interp1(VQ(k,:),xq,max(VQ(k,:)));
% % %  U(k)=interp1(VQ(k,:),xq,mean(VQ(k,:)));
% % % MU(k)=interp1(VQ(k,:),xq,max(VQ(k,:)));
U(k)=meanfreq(pxx,f);

 %%
%  semilogy(f,(pxx))
%  hold on
%  semilogy(xq,(vq1))
 progress_bar(k,length(q),bar_init)
end
UU{iii}=U;
% MUU{iii}=MU;
%%

consig=cara{1};

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
    cd(strcat('/home/adrian/Dropbox/Figures/Figure3/',num2str(Rat)))
else
      %cd(strcat('C:\Users\Welt Meister\Dropbox\Figures\Figure2\',num2str(Rat)))   
      cd(strcat('C:\Users\addri\Dropbox\Figures\Figure3\',num2str(Rat)))   
end
%%
if sanity==1

string=strcat('Control_Peak_Frequency_','Allconditions','_',Block{block_time+1},'_');
printing(string);

else
string=strcat('Peak_Frequency_','Allconditions','_',Block{block_time+1},'_');
printing(string);
    

string=strcat('Peak_Frequency_Violin_','Allconditions','_',Block{block_time+1},'_');
printing(string);
end
%%
if sanity==1

string=strcat('Control_Average_Frequency_','Allconditions','_',Block{block_time+1},'_');
printing(string);

else
string=strcat('Average_Frequency_','Allconditions','_',Block{block_time+1},'_');
printing(string);

string=strcat('Average_Frequency_Violin_','Allconditions','_',Block{block_time+1},'_');
printing(string);

end
%%
%%
xo
%%
string=strcat('Control_RippleDuration_','Allconditions','_',Block{block_time+1},'_');
printing(string);
%%
%%
%histogram(aver,'Normalization','probability','BinWidth',0.1); xlim([0 4])

end
end
xo
if iii==length(nFF)
   break 
end

%end

end

%%
%clearvars -except acer Rat
%end
xo

%end

