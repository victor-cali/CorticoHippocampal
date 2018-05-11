acer=1;

%%
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
     'PlusMaze'
                }
     
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
    %'Baseline_1'}
    %'Baseline_2'
    %'Baseline_3'
    'PlusMaze_1'} 
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
ro=[200];
coher=0;
selectripples=0;
mergebaseline=0;
notch=1;
nrem=3;
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

for iii=4:length(nFF)

    
 clearvars -except nFF iii labelconditions inter granger Rat ro label1 label2 coher selectripples acer mergebaseline nr_27 nr_26 co_26 co_27 nrem notch



%for level=1:length(ripple)-1;    
 for level=1:1
     
for w=2:3

if acer==0
    cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))
else
    cd(strcat('D:\internship\',num2str(Rat)))
end
%     error('stop')
cd(nFF{iii})
lepoch=2;
%  error('stop')   
%Get averaged time signal.
% [sig1,sig2,ripple,carajo,veamos,CHTM,RipFreq2,timeasleep]=newest_only_ripple_level(level);    
[sig1,sig2,ripple,carajo,veamos,CHTM,~,~]=nrem_newest_only_ripple_level_backup(level,nrem,notch,w,lepoch);
[~,q,~,~,~,~]=getwin2(carajo{:,:,1},veamos{1},sig1,sig2,label1,label2,ro,ripple(1),CHTM(level+1));
clear sig1 sig2 carajo
[p_h,p_par]=ps_rip2(q,w);%Should always be bandpassed. Thus q. 

p_h=(p_h)-median(p_h);
p_par=(p_par)-median(p_par);

scatter(p_h,p_par,'filled','r');
hold on

ajalas=Isoutlier(p_h);
ajalas=not(ajalas);
P_h=p_h(ajalas);
P_par=p_par(ajalas);

clear p_h p_par q


%GET NO Learning 1
if acer==0
cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))
else
% cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))    
cd(strcat('D:\internship\',num2str(Rat)))
end
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                            
cd(nFF{1})
%[sig1,sig2,ripple,carajo,veamos,CHTM,RipFreq2,timeasleep]=newest_only_ripple_level(level);    
[sig1,sig2,ripple,carajo,veamos,CHTM,~,~]=nrem_newest_only_ripple_level_backup(level,nrem,notch,w,lepoch);
[~,q_1,~,~,~,~]=getwin2(carajo{:,:,1},veamos{1},sig1,sig2,label1,label2,ro,ripple(1),CHTM(level+1));

clear sig1 sig2 carajo veamos
[p1_h,p1_par]=ps_rip2(q_1,w);%Should always be bandpassed. Thus q. 

p1_h=(p1_h)-median(p1_h);
p1_par=(p1_par)-median(p1_par);

scatter(p1_h,p1_par,'filled','b');
hold on

ajalas=Isoutlier(p1_h);
ajalas=not(ajalas);
P1_h=p1_h(ajalas);
P1_par=p1_par(ajalas);

clear p1_h p1_par q_1




%GET NO Learning 2
if acer==0
cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))
else
% cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))    
cd(strcat('D:\internship\',num2str(Rat)))
end

%cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))
cd(nFF{2})
%[sig1,sig2,ripple,carajo,veamos,CHTM,RipFreq2,timeasleep]=newest_only_ripple_level(level);    
[sig1,sig2,ripple,carajo,veamos,CHTM,RipFreq2,timeasleep]=nrem_newest_only_ripple_level_backup(level,nrem,notch,w,lepoch);

[~,q_2,~,~,~,~]=getwin2(carajo{:,:,1},veamos{1},sig1,sig2,label1,label2,ro,ripple(1),CHTM(level+1));

clear sig1 sig2 carajo veamos
[p2_h,p2_par]=ps_rip2(q_2,w);%Should always be bandpassed. Thus q. 

p2_h=(p2_h)-median(p2_h);
p2_par=(p2_par)-median(p2_par);

hold on
scatter(p2_h,p2_par,'filled','g');

ajalas=Isoutlier(p2_h);
ajalas=not(ajalas);
P2_h=p2_h(ajalas);
P2_par=p2_par(ajalas);

clear p2_h p2_par q_2



%GET NO Learning 3
%cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))
if acer==0
cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))
else
% cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))    
cd(strcat('D:\internship\',num2str(Rat)))
end

cd(nFF{3})
%[sig1,sig2,ripple,carajo,veamos,CHTM,RipFreq2,timeasleep]=newest_only_ripple_level(level);    
[sig1,sig2,ripple,carajo,veamos,CHTM,RipFreq2,timeasleep]=nrem_newest_only_ripple_level_backup(level,nrem,notch,w,lepoch);

[~,q_3,~,~,~,~]=getwin2(carajo{:,:,1},veamos{1},sig1,sig2,label1,label2,ro,ripple(1),CHTM(level+1));

clear sig1 sig2 carajo veamos
[p3_h,p3_par]=ps_rip2(q_3,w);%Should always be bandpassed. Thus q. 

p3_h=(p3_h)-median(p3_h);
p3_par=(p3_par)-median(p3_par);

hold on
scatter(p3_h,p3_par,'filled','y');

ajalas=Isoutlier(p3_h);
ajalas=not(ajalas);
P3_h=p3_h(ajalas);
P3_par=p3_par(ajalas);

clear p3_h p3_par q_3



h1=lsline;

L(:,:) = [h1(1).XData.' h1(1).YData.'];
plot(L(:,1),L(:,2),'r')

L(:,:) = [h1(2).XData.' h1(2).YData.'];
plot(L(:,1),L(:,2),'b')

L(:,:) = [h1(3).XData.' h1(3).YData.'];
plot(L(:,1),L(:,2),'g')

L(:,:) = [h1(4).XData.' h1(4).YData.'];
plot(L(:,1),L(:,2),'y')

legend(labelconditions{iii-3},'Baseline 1','Baseline 2','Baseline 3')

%Slopes
ve1=(h1(1).YData(2)-h1(1).YData(1))/(h1(1).XData(2)-h1(1).XData(1));
ve1=num2str(ve1);

ve2=(h1(2).YData(2)-h1(2).YData(1))/(h1(2).XData(2)-h1(2).XData(1));
ve2=num2str(ve2);

ve3=(h1(3).YData(2)-h1(3).YData(1))/(h1(3).XData(2)-h1(3).XData(1));
ve3=num2str(ve3);

ve4=(h1(4).YData(2)-h1(4).YData(1))/(h1(4).XData(2)-h1(4).XData(1));
ve4=num2str(ve4);

ve1=strcat(labelconditions{iii-3},{':  '},ve1);
ve2=strcat('Baseline_1',{':  '},ve2);
ve3=strcat('Baseline_2',{':  '},ve3);
ve4=strcat('Baseline_3',{':  '},ve4);

txt1=[ve1;ve2;ve3;ve4];

dim = [.6 .5 .3 .22];
% str = strcat('Rate of occurence for',{' '},'Baseline 3',':',{' '},num2str(RipFreq2),{' '});
str=txt1;
annotation('textbox',dim,'String',str)
%End of slopes

set(gca,'Color','k')

xlabel('Hippocampal Power')
ylabel(strcat(label1{2*w-1},{' '},'Power'))
grid minor
 alpha(.5)

title('Bandpassed signals')


%%
string=strcat('Scatter_',label1{2*w-1},'_',num2str(level),'.png');

    cd(strcat('/home/raleman/Dropbox/New_Scatter200/',num2str(Rat)))
if exist(labelconditions{iii-3})~=7
(mkdir(labelconditions{iii-3}))
end
cd((labelconditions{iii-3}))

saveas(gcf,string)
string=strcat('Scatter_',label1{2*w-1},'_',num2str(level),'.fig');
saveas(gcf,string)

close all

%% WITHOUT OUTLIERS
% ajalas=Isoutlier(p_h);
% ajalas=not(ajalas);
% P_h=p_h(ajalas);
% P_par=p_par(ajalas);


% ajalas=Isoutlier(p1_h);
% ajalas=not(ajalas);
% P1_h=p1_h(ajalas);
% P1_par=p1_par(ajalas);

% ajalas=Isoutlier(p2_h);
% ajalas=not(ajalas);
% P2_h=p2_h(ajalas);
% P2_par=p2_par(ajalas);

% ajalas=Isoutlier(p3_h);
% ajalas=not(ajalas);
% P3_h=p3_h(ajalas);
% P3_par=p3_par(ajalas);
%% Median normalization 

P_h=(P_h)-median(P_h);
P1_h=(P1_h)-median(P1_h);
P2_h=(P2_h)-median(P2_h);
P3_h=(P3_h)-median(P3_h);

P_par=(P_par)-median(P_par);
P1_par=(P1_par)-median(P1_par);
P2_par=(P2_par)-median(P2_par);
P3_par=(P3_par)-median(P3_par);
%%
%%
 scatter(P_h,P_par,'filled','r');
%scatter(P_h,P_par,'r');

hold on
 scatter(P1_h,P1_par,'filled','b');
%scatter(P1_h,P1_par,'b');
% 
scatter(P2_h,P2_par,'filled','g');

%scatter(P2_h,P2_par,'g');

 scatter(P3_h,P3_par,'filled','y');
%scatter(P3_h,P3_par,'y');

h1=lsline;

L(:,:) = [h1(1).XData.' h1(1).YData.'];
plot(L(:,1),L(:,2),'r')

L(:,:) = [h1(2).XData.' h1(2).YData.'];
plot(L(:,1),L(:,2),'b')

L(:,:) = [h1(3).XData.' h1(3).YData.'];
plot(L(:,1),L(:,2),'g')

L(:,:) = [h1(4).XData.' h1(4).YData.'];
plot(L(:,1),L(:,2),'y')
legend(labelconditions{iii-3},'Baseline 1','Baseline 2','Baseline 3')

%Slopes
ve1=(h1(1).YData(2)-h1(1).YData(1))/(h1(1).XData(2)-h1(1).XData(1));
ve1=num2str(ve1);

ve2=(h1(2).YData(2)-h1(2).YData(1))/(h1(2).XData(2)-h1(2).XData(1));
ve2=num2str(ve2);

ve3=(h1(3).YData(2)-h1(3).YData(1))/(h1(3).XData(2)-h1(3).XData(1));
ve3=num2str(ve3);

ve4=(h1(4).YData(2)-h1(4).YData(1))/(h1(4).XData(2)-h1(4).XData(1));
ve4=num2str(ve4);

ve1=strcat(labelconditions{iii-3},{':  '},ve1);
ve2=strcat('Baseline_1',{':  '},ve2);
ve3=strcat('Baseline_2',{':  '},ve3);
ve4=strcat('Baseline_3',{':  '},ve4);

txt1=[ve1;ve2;ve3;ve4];

dim = [.6 .5 .3 .22];
% str = strcat('Rate of occurence for',{' '},'Baseline 3',':',{' '},num2str(RipFreq2),{' '});
str=txt1;
annotation('textbox',dim,'String',str)
%End of slopes

set(gca,'Color','k')

xlabel('Hippocampal Power')
ylabel(strcat(label1{2*w-1},{' '},'Power'))
grid minor
 alpha(.5)

title('Bandpassed signals')
%%
string=strcat('Scatter_No_Outlier_',label1{2*w-1},'_',num2str(level),'.png');

    cd(strcat('/home/raleman/Dropbox/New_Scatter200/',num2str(Rat)))
if exist(labelconditions{iii-3})~=7
(mkdir(labelconditions{iii-3}))
end
cd((labelconditions{iii-3}))

saveas(gcf,string)
string=strcat('Scatter_No_Outlier_',label1{2*w-1},'_',num2str(level),'.fig');
saveas(gcf,string)

close all




end

end


end
%%
end
%end