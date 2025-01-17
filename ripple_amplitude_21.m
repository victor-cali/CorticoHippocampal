acer=0;

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

for Rat=21:21
if Rat==21
%% 21
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

for iii=3:length(nFF)

    
 clearvars -except nFF iii labelconditions inter granger Rat ro label1 label2 coher selectripples acer mergebaseline nr_27 nr_26 co_26 co_27 nrem notch



%for level=1:length(ripple)-1;    
 for level=1:1
     
for w=1:1

if acer==0
    cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))
else
    cd(strcat('D:\internship\',num2str(Rat)))
end

    
cd(nFF{iii})
lepoch=2;
% error('stop')
%Get averaged time signal.
% [sig1,sig2,ripple,carajo,veamos,CHTM,RipFreq2,timeasleep]=newest_only_ripple_level(level);    
[sig1,sig2,ripple,carajo,veamos,CHTM,RIPFREQ2,~]=nrem_newest_only_ripple_level_backup(level,nrem,notch,w,lepoch);
[~,q,~,~,~,~]=getwin2(carajo{:,:,1},veamos{1},sig1,sig2,label1,label2,ro,ripple(1),CHTM(level+1));
clear sig1 sig2 ripple carajo veamos
% error('stop')

[ran]=rip_select(q);
q=q(ran);

    for j=1:length(q)
        FF(j,1) = (max(q{j}(1,:))-median(q{j}(1,:)))/std(q{j}(1,:));         
    end
clear q
histogram(FF(not(Isoutlier(FF))),'Normalization','probability','BinWidth',0.5)
xlim([0 20])
grid minor
hold on

pd = fitdist(FF(not(Isoutlier(FF))),'Normal');
y = pdf(pd,0:0.5:30);
plot(0:0.5:30,y/2,'LineWidth',1.5,'Color','k','LineStyle','--')

clear q p sig1 sig2 timecell pd


%GET NO Learning 1
if acer==0
cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))
else
% cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))    
cd(strcat('D:\internship\',num2str(Rat)))
end

cd(nFF{1})
%[sig1,sig2,ripple,carajo,veamos,CHTM,RipFreq2,timeasleep]=newest_only_ripple_level(level);    
[sig1,sig2,ripple,carajo,veamos,CHTM,RipFreq2,timeasleep]=nrem_newest_only_ripple_level_backup(level,nrem,notch,w,lepoch);

[~,q,~,~,~,~]=getwin2(carajo{:,:,1},veamos{1},sig1,sig2,label1,label2,ro,ripple(1),CHTM(level+1));

clear  p sig1 sig2 timecell

% error('stop')

[ran]=rip_select(q);
q=q(ran);

    for j=1:length(q)
        F(j,1) = (max(q{j}(1,:))-median(q{j}(1,:)))/std(q{j}(1,:));         
    end
clear q

histogram(F(not(Isoutlier(F))),'Normalization','probability','BinWidth',0.5)
pd = fitdist(F(not(Isoutlier(F))),'Normal');
y = pdf(pd,0:0.5:30);
plot(0:0.5:30,y/2,'LineWidth',1.5,'Color','k','LineStyle','-')

clear q p sig1 sig2 timecell pd

% consig=carajo{1};
% consig=consig(:,2);
% aver=cellfun(@(x) diff(x), consig,'UniformOutput',false);
% aver=[aver{:}];

% histogram(aver,'Normalization','probability','BinWidth',0.1); xlim([0 4])
alpha(0.4)
% legend(labelconditions{iii-3},'Baseline 1')
legend(labelconditions{iii-3},strcat(labelconditions{iii-3},' (fit)'),'Baseline 1','Baseline 1 (fit)')

xlabel('Number of Standard Deviations wrt. Amplitude Median')
ylabel('Probability of occurence')
title('Histogram of Ripple amplitude')
% 
% dim = [.6 .5 .3 .1];
% str = strcat('Rate of occurence for',{' '},labelconditions{iii-3},':',{' '},num2str(RIPFREQ2),{' '});
% annotation('textbox',dim,'String',str)
% 
% dim = [.6 .6 .3 .1];
% str = strcat('Rate of occurence for',{' '},'Baseline 1',':',{' '},num2str(RipFreq2),{' '});
% annotation('textbox',dim,'String',str)


string=strcat('Histograms_Amp_',label1{2*w-1},'_','Baseline1','.png');

if acer==0
    cd(strcat('/home/raleman/Dropbox/Histograms_Amp2/',num2str(Rat)))
else    
    cd(strcat('C:\Users\Welt Meister\Dropbox\Histograms_Amp2/',num2str(Rat)))
end


if exist(labelconditions{iii-3})~=7
(mkdir(labelconditions{iii-3}))
end
cd((labelconditions{iii-3}))

saveas(gcf,string)

string=strcat('Histograms_',label1{2*w-1},'_','Baseline1','.fig');
saveas(gcf,string)

close all


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

[~,q,~,~,~,~]=getwin2(carajo{:,:,1},veamos{1},sig1,sig2,label1,label2,ro,ripple(1),CHTM(level+1));
% error('stop')

clear sig1 sig2 timecell 

[ran]=rip_select(q);
q=q(ran);

    for j=1:length(q)
        F(j,1) = (max(q{j}(1,:))-median(q{j}(1,:)))/std(q{j}(1,:));         
    end
clear q    
histogram(FF(not(Isoutlier(FF))),'Normalization','probability','BinWidth',0.5)
xlim([0 20])
grid minor
hold on
pd = fitdist(FF(not(Isoutlier(FF))),'Normal');
y = pdf(pd,0:0.5:30);
plot(0:0.5:30,y/2,'LineWidth',1.5,'Color','k','LineStyle','--')
clear y pd

histogram(F(not(Isoutlier(F))),'Normalization','probability','BinWidth',0.5)
pd = fitdist(F(not(Isoutlier(F))),'Normal');
y = pdf(pd,0:0.5:30);
plot(0:0.5:30,y/2,'LineWidth',1.5,'Color','k','LineStyle','-')

alpha(0.4)

legend(labelconditions{iii-3},strcat(labelconditions{iii-3},' (fit)'),'Baseline 2','Baseline 2 (fit)')
xlabel('Number of Standard Deviations wrt. Amplitude Median')
ylabel('Probability of occurence')
title('Histogram of Ripple amplitude')

% dim = [.6 .5 .3 .1];
% str = strcat('Rate of occurence for',{' '},labelconditions{iii-3},':',{' '},num2str(RIPFREQ2),{' '});
% annotation('textbox',dim,'String',str)

% dim = [.6 .6 .3 .1];
% str = strcat('Rate of occurence for',{' '},'Baseline 2',':',{' '},num2str(RipFreq2),{' '});
% annotation('textbox',dim,'String',str)


string=strcat('Histograms_Amp_',label1{2*w-1},'_','Baseline2','.png');

if acer==0
    cd(strcat('/home/raleman/Dropbox/Histograms_Amp2/',num2str(Rat)))
else    
    cd(strcat('C:\Users\Welt Meister\Dropbox\Histograms_Amp2/',num2str(Rat)))
end


if exist(labelconditions{iii-3})~=7
(mkdir(labelconditions{iii-3}))
end
cd((labelconditions{iii-3}))

saveas(gcf,string)

string=strcat('Histograms_Amp',label1{2*w-1},'_','Baseline2','.fig');
saveas(gcf,string)

close all




end

end


end
%%
end
%end