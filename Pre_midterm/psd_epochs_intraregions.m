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

for Rat=26:27
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


else
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

 
    
 clearvars -except nFF iii labelconditions inter granger Rat ro label1 label2 coher selectripples acer mergebaseline nr_27 nr_26 co_26 co_27 nrem notch

myColorMap = jet(3);


 for level=1:1

for iii=1:length(nFF)
  

% colormap(myColorMap);
% NCount=nan(length(nFF),1);

   
if acer==0
    cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))
else
    cd(strcat('D:\internship\',num2str(Rat)))
end

    
    cd(nFF{iii})
    %Get averaged time signal.
for w=1:3
 %error('stop')
%[sig1,sig2,ripple,carajo,veamos,CHTM,RipFreq2,timeasleep]=newest_only_ripple_level(level);    
if Rat==26
[sig1,sig2,ripple,carajo,veamos,CHTM,RipFreq2,timeasleep]=nrem_newest_only_ripple_level(level,nrem,notch,w);    
else
 [sig1,sig2,ripple,carajo,veamos,CHTM,RipFreq2,timeasleep]=newest_only_ripple_level(level);     
end

%%
% for w=1:3
f_signal=sig2{2*w-1};
[NC]=epocher(f_signal,2);
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
[NC] = ft_notch(NC.', Fsample,Fline);
NC=NC.';
end

if Rat==26 %Noise peak was only observed in Rat 26
    if w==4  % Reference 
     Fline=[208 209];

    [NC] = ft_notch(NC.', Fsample,Fline);
    NC=NC.';
    end
end
%Equal number of epochs. 
%NC=NC(:,end-1845+1:end);
if  Rat==26
    NC=NC(:,end-1845+1:end);
else
    NC=NC(:,end-2500+1:end);
end

 [pxx,f]= periodogram(NC,hann(size(NC,1)),size(NC,1),1000);
%[pxx,f]=pwelch(NC,[],[],[],1000);

%hann(length(NC))
px=mean(pxx,2);

%plot(f,10*log10(px),'Color',myColorMap(w,:),'LineWidth',1.5)
semilogy(f,(px)/sum(px),'Color',myColorMap(w,:),'LineWidth',1.5)

hold on
xlim([0 300])
% if w==1
%  xlim([0 300])
% else
%  xlim([0 300])  
% end

%ylim([-40 30])
grid minor
xlabel('Frequency (Hz)')
%ylabel('10 Log(x)')
ylabel('Normalized Power')

%end
%legend('HPC','PAR','PFC')
title(strcat('Power in NREM',{' '} ,label1{2*w-1} ,{' '},'signals'))
%%
% error('stop')

%%

% [f,Y] = freqlog(NC);
% Ym=mean(Y,2);
% plot(f*(1000/2),Ym)

% [~,F]=frequency(f_signal{1});  
% F=F*0;
% 
% for kk=1:length(f_signal)
%   [~,F_c]=frequency(f_signal{kk});  
%   F=F+F_c;
% end


%
% % [p,q,timecell,~,~,~]=getwin2(carajo{:,:,1},veamos{1},sig1,sig2,label1,label2,ro,ripple(1),CHTM(level+1));
% % 
% %  [~,F]=frequency(p{1}(w,:));  
% %   F=F*0;
% % for kk=1:length(p)
% %   [f,F_c]=frequency(p{kk}(w,:));  
% %   F=F+F_c;
% % end
% % F=F./length(p);

% % % % % % % % % % % plot(f,F);
% % figure()
% % stem(f,2*abs(Y(1:NFFT/2+1)))
% % % % % % % % % % % % % % % % % grid minor;
% % % % % % % % % % % % % % % % % title(strcat('Power Spectrum of',{' '},label1{2*w-1}))
% % % % % % % % % % % % % % % % % xlabel('Frequency (Hz)')
% % % % % % % % % % % % % % % % % ylabel('|Y(f)|')
% % % % % % % % % % % % % % % % % xlim([0 300])



%error('stop')


% % % % string=strcat('Power_Spectrum_',label1{2*w-1},'_',num2str(level),'.png');
% % % % 
% % % %     cd(strcat('/home/raleman/Dropbox/Power_plots/',num2str(Rat)))
% % % % if exist(labelconditions{iii})~=7
% % % % (mkdir(labelconditions{iii}))
% % % % end
% % % % cd((labelconditions{iii}))
% % % % 
% % % % saveas(gcf,string)
% % % % close all
labelconditions{iii};
end

L = line(nan(3), nan(3),'LineStyle','none'); % 'nan' creates 'invisible' data
set(L, {'MarkerEdgeColor'}, num2cell(myColorMap, 2),...
    {'MarkerFaceColor'},num2cell(myColorMap, 2),... % setting the markers to filled squares
    'Marker','s'); 
legend(L, label1(1:2:5))
%         set(gca,'Color','w')
grid on
set(gca,'Color','k')
ax=gca;
ax.GridColor=[ 1,1,1];

if acer==0
    cd(strcat('/home/raleman/Dropbox/Power_notch/',num2str(Rat)))
else
      cd(strcat('C:\Users\Welt Meister\Dropbox\Power_notch\',num2str(Rat)))   
end


%    cd(strcat('/home/raleman/Dropbox/Power_notch/',num2str(Rat)))
% if exist(labelconditions{iii})~=7
% (mkdir(labelconditions{iii}))
% end
% cd((labelconditions{iii}))
fig=gcf;
fig.InvertHardcopy='off';
string=strcat('300hz_intra_',labelconditions{iii},'.png');
saveas(gcf,string)
string=strcat('300hz_intra_',labelconditions{iii},'.fig');
saveas(gcf,string)


xlim([0 50]);
string=strcat('50hz_intra_',labelconditions{iii},'.png');
saveas(gcf,string)
string=strcat('50hz_intra_',labelconditions{iii},'.figs');
saveas(gcf,string)

close all




end


end
%%
end
%end