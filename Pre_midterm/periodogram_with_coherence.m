acer=0;
%
if acer==0
addpath('/home/raleman/Documents/MATLAB/analysis-tools-master'); %Open Ephys data loader. 
addpath('/home/raleman/Documents/GitHub/CorticoHippocampal')
addpath('/home/raleman/Documents/internship')
else
addpath('D:\internship\analysis-tools-master'); %Open Ephys data loader.
addpath('C:\Users\Welt Meister\Documents\Donders\CorticoHippocampal\CorticoHippocampal')   
end

%%
%Rat=26;

for Rat=3:3
rats=[26 27 21];
Rat=rats(Rat);    
if Rat==26
nFF=[
%    {'rat26_Base_II_2016-03-24'                         }
%    {'rat26_Base_II_2016-03-24_09-47-13'                }
%    {'rat26_Base_II_2016-03-24_12-55-58'                }
%    {'rat26_Base_II_2016-03-24_12-57-57'                }
    
   
    {'rat26_nl_base_III_2016-03-30_10-32-57'            }
    {'rat26_nl_base_II_2016-03-28_10-40-19'             }
    {'rat26_nl_baseline2016-03-01_11-01-55'             }
    {'rat26_plusmaze_base_2016-03-08_10-24-41'}
    
    
    
    {'rat26_novelty_I_2016-04-12_10-05-55'          }
    {'rat26_novelty_II_2016-04-13_10-23-29'             }
    {'rat26_for_2016-03-21_10-38-54'                    }
    {'rat26_for_II_2016-03-23_10-49-50'                 }
    
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
    
    'Baseline_1'}
    'Baseline_2'
    'Baseline_3'
     'PlusMaze'    
     'Novelty_1'
     'Novelty_2'
     'Foraging_1'
     'Foraging_2'
    ];


end
if Rat==27
nFF=[
    {'rat27_nl_base_2016-03-28_15-01-17'                   }
    {'rat27_NL_baseline_2016-02-26_12-50-26'               }
    {'rat27_nl_base_III_2016-03-30_14-36-57'               }
    
    {'rat27_plusmaze_base_2016-03-14_14-52-48'             }
    {'rat27_plusmaze_base_II_2016-03-24_14-10-08'          }
    
    {'rat27_for_2016-03-21_15-03-05'                       }
    {'Rat27_for_II_2016-03-23_15-06-59'                    }
    
    %{'rat27_novelty_II_2016-04-13_14-37-58'                }  %NO .MAT files found. 
    %{'rat27_novelty_II_2016-04-13_16-29-42'                } %No (complete).MAT files found.
    {'rat27_novelty_I_2016-04-11_14-34-55'                 }
  
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
    'Baseline_1'}
    'Baseline_2'
    'Baseline_3'
    'PlusMaze_1'
    'PlusMaze_2'
    
    'Foraging_1'
    
     'Foraging_2'
     'Novelty_1'
    
    
     
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
 


%% Go to main directory
if acer==0
    cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))
    addpath /home/raleman/Documents/internship/fieldtrip-master/
cd /home/raleman/Documents/internship/fieldtrip-master

    InitFieldtrip()

    cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))
    clc
else
    cd(strcat('D:\internship\',num2str(Rat)))
    addpath D:\internship\fieldtrip-master
    cd D:\internship\fieldtrip-master
    InitFieldtrip()

    % cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))
    cd(strcat('D:\internship\',num2str(Rat)))
    clc
end
%% Select experiment to perform. 
inter=1;
granger=0;
%Select length of window in seconds:
ro=[1200];
coher=0;
selectripples=1;
mergebaseline=1;
nrem=3;
notch=0;
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

 
    
 %clearvars -except nFF iii labelconditions inter granger Rat ro label1 label2 coher selectripples acer mergebaseline nr_27 nr_26 co_26 co_27 nrem notch


%  for level=1:1
     
%for w=2:2

if Rat==21
myColorMap = jet(5);
else
myColorMap = jet(8);    
end
% colormap(myColorMap);
NCount=nan(length(nFF),1);


for iii=1:length(nFF)
for level=2:2
myColorMap = jet(9);    
    
if acer==0
    cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))
else
    cd(strcat('D:\internship\',num2str(Rat)))
end

    cd(nFF{iii})
    %Get averaged time signal.
  %error('stop')   

lepoch=2;
%[sig1,sig2,ripple,carajo,veamos,CHTM,RipFreq2,timeasleep]=newest_only_ripple_level(level);    

% error('stop')
%[Sig22]=nrem_newest_power(nrem,notch);

%if Rat==26
% [sig1,sig2,ripple,carajo,veamos,CHTM,RipFreq2,timeasleep]=nrem_newest_only_ripple_level(level,nrem,notch,w,lepoch);    
%else
% [sig1,sig2,ripple,carajo,veamos,CHTM,RipFreq2,timeasleep]=newest_only_ripple_level(level,lepoch);     
%end
[Sig22]=nrem_newest_power(nrem,notch);

% error('stop')
% [sig1,sig2,ripple,carajo,veamos,CHTM,RipFreq2,timeasleep]=NORIPPLE_nrem_newest_only_ripple_level(level,nrem,notch,w,lepoch);    
tic
[sig1,sig2,ripple2,carajo,veamos,CHTM,RipFreq2,timeasleep]=REMOVE_RIPPLES(level,nrem,notch,[],lepoch);
toc
% error('stop')
for w=2:3
[PPx,F,~]=generate_periodogram(Sig22,w,Rat,iii);
[px,f,~]=generate_periodogram(sig2,w,Rat,iii);

[NC]=generate_nc(Sig22,w,Rat,iii);
[nc]=generate_nc(sig2,w,Rat,iii);

if w==2
save('powercoh2.mat','PPx','F','px','f','NC','nc');
end

if w==3
save('powercoh3.mat','PPx','F','px','f','NC','nc');
end

clear PPx F px f NC nc
end
 
% [va, fa]=mscohere(NC,nc,[],[],[],1000);


% if w==1
% save('powercoh.mat','PPx','F','px','f','NC','nc');
% end


% if w==3
% save('powercoh3.mat','PPx','F','px','f','NC','nc');
% end
%%
% for w=1:3
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % f_signal=sig2{2*w-1};
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %Amplitude normalization
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %f_signal=median(f_signal);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % [NC]=epocher(f_signal,2);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % av=mean(NC,1);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % av=artifacts(av,10);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %Limits artifacts to a maximum of 10
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % if sum(av)>=10
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % av=artifacts(av,20);    
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % av=not(av);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %Removing artifacts.
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % NC=NC(:,av);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % NCount(iii,1)=size(NC,2);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %Notch filter
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % Fsample=1000;
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % Fline=[50 100 150 200 250 300 66.5 133.5 266.5];
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % if w~=1 && w~=4  %Dont filter Hippocampus nor Reference 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % [NC] = ft_notch(NC.', Fsample,Fline,0.5,0.5);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % NC=NC.';
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % if Rat==26 %Noise peak was only observed in Rat 26
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     if w==4  % Reference 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %      Fline=[208 209];
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     [NC] = ft_notch(NC.', Fsample,Fline,0.5,0.5);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     NC=NC.';
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %Equal number of epochs.
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % if  Rat==26
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     NC=NC(:,end-1845+1:end);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % else
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %     NC=NC(:,end-2500+1:end);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % end
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % NC=zscore(NC);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % NC=NC(:,end-1845+1:end);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %  [pxx,f]= periodogram(NC,hann(size(NC,1)),size(NC,1),1000);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %[pxx,f]=pwelch(NC,[],[],[],1000);
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % %hann(length(NC))
% % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % % px=mean(pxx,2);
% error('stop')
%plot(f,10*log10(px),'Color',myColorMap(iii,:),'LineWidth',1.5)

%semilogy(f,(px)/sum(px),'Color',myColorMap(level,:),'LineWidth',1.5)

%IF YOU WANT TO PLOT , UNCOMMENT THIS:
% % % % % % % % % % % figure(1)
% % % % % % % % % % % handaxes1 = axes('Position', [0.12 0.12 0.8 0.8]);
% % % % % % % % % % % 
% % % % % % % % % % % semilogy(F,(PPx/sum(PPx)),'Color',[0 0 1],'LineWidth',2)
% % % % % % % % % % % 
% % % % % % % % % % % hold on
% % % % % % % % % % % %plot(f,(px)/sum(px),'Color',myColorMap(level*3,:),'LineWidth',1.5)
% % % % % % % % % % % semilogy(f,(px/sum(px)),'Color',[1 0 0],'LineWidth',2)
% % % % % % % % % % % grid on
% % % % % % % % % % % ax=gca;
% % % % % % % % % % % ax.GridColor=[ 1,1,1];
% % % % % % % % % % % AX=legend('With Ripples','No Ripples (THR 2)');
% % % % % % % % % % % AX.Location= 'southwest';
% % % % % % % % % % % 
% % % % % % % % % % % 
% % % % % % % % % % % 
% % % % % % % % % % % xlim([0 250])
% % % % % % % % % % % grid minor
% % % % % % % % % % % xlabel('Frequency (Hz)')
% % % % % % % % % % % %ylabel('10 Log(x)')
% % % % % % % % % % % %ylabel('Normalized Power')
% % % % % % % % % % % ylabel('Normalized Power')
% % % % % % % % % % % 
% % % % % % % % % % % %end
% % % % % % % % % % % %legend('HPC','PAR','PFC')
% % % % % % % % % % % title(strcat('Power and Coherence in NREM',{' '} ,label1{2*w-1} ,{' '},'signals'))
% % % % % % % % % % % set(handaxes1, 'Box', 'off')
% % % % % % % % % % % 
% % % % % % % % % % % handxlabel1 = get(gca, 'XLabel');
% % % % % % % % % % % set(handxlabel1, 'FontSize', 12, 'FontWeight', 'bold')
% % % % % % % % % % % handylabel1 = get(gca, 'ylabel');
% % % % % % % % % % % set(handylabel1, 'FontSize', 12, 'FontWeight', 'bold')
% % % % % % % % % % % set(gca,'Color','k')
% % % % % % % % % % % 
% % % % % % % % % % % 
% % % % % % % % % % % handaxes2 = axes('Position', [0.6 0.6 0.3 0.3]);
% % % % % % % % % % % 
% % % % % % % % % % % 
% % % % % % % % % % % G=area(fa,mean(va,2));
% % % % % % % % % % % G.FaceColor=[1 1 0];
% % % % % % % % % % % grid minor
% % % % % % % % % % % 
% % % % % % % % % % % %ylim([min(mean(va,2)) 1])
% % % % % % % % % % % ylim([0.5 1])
% % % % % % % % % % % xlim([0 250])
% % % % % % % % % % % % xlabel('Frequency (Hz)')
% % % % % % % % % % % % ylabel('Coherence')
% % % % % % % % % % % xlabel('Frequency (Hz)','Color','w')
% % % % % % % % % % % ylabel('Coherence','Color','w')
% % % % % % % % % % % % title('With Ripples vs No Ripples (THR 2)')
% % % % % % % % % % % set(gca,'xcolor','w') 
% % % % % % % % % % % set(gca,'ycolor','w') 
% % % % % % % % % % %  xticks([0 50 100 150 200])
% % % % % % % % % % % 
% % % % % % % % % % % 
% % % % % % % % % % % 
% % % % % % % % % % % 
% % % % % % % % % % % if acer==0
% % % % % % % % % % %     cd(strcat('/home/raleman/Dropbox/Power_Coh/',num2str(Rat)))
% % % % % % % % % % % else
% % % % % % % % % % %       cd(strcat('C:\Users\Welt Meister\Dropbox\Power_Coh\',num2str(Rat)))   
% % % % % % % % % % % end
% % % % % % % % % % % 
% % % % % % % % % % % fig=gcf;
% % % % % % % % % % % fig.InvertHardcopy='off';
% % % % % % % % % % % 
% % % % % % % % % % % % string=strcat('300hz_intra_',label1{2*w-1},'.png');
% % % % % % % % % % % string=strcat('NoRipples_',labelconditions{iii},'.png');
% % % % % % % % % % % saveas(gcf,string)
% % % % % % % % % % % 
% % % % % % % % % % % string=strcat('NoRipples_',labelconditions{iii},'.fig');
% % % % % % % % % % % saveas(gcf,string)
% % % % % % % % % % % 
% % % % % % % % % % % close all

end
% error('stop')

%string=strcat('Power_50B_1850_NOTCH_NREM_',label1{2*w-1},'.png');


end


%end
%%
end
%end
