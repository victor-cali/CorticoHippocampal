close all
clear all
%Plot CFC BASELINE and PLUSMAZE side by side
acer=1


for RAT=1:2
for ej=1:9 %Number of combinations
combo=[
  1 1;
  1 2;
  1 3;
  2 1;
  2 2;
  2 3;
  3 1;
  3 2;
  3 3;
];

n1=combo(ej,1);
n2=combo(ej,2);
    

    
    
rats=[26 27 24 21];
Rat=rats(RAT);    
    
%Rat=26;


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


%Make labels
label1=cell(7,1);
label1{1}='HPC';
label1{2}='HPC';
label1{3}='PAR';
label1{4}='PAR';
label1{5}='PFC';
label1{6}='PFC';
label1{7}='Reference';


if acer==0
    cd(strcat('/home/raleman/Dropbox/Figures/CrossFreqCoupling/',num2str(Rat)))
else
      %cd(strcat('C:\Users\Welt Meister\Dropbox\Figures\Figure2\',num2str(Rat)))   
      cd(strcat('C:\Users\addri\Dropbox\Figures\CrossFreqCoupling\',num2str(Rat)))   
end
% 
% n1=1;
% n2=1;

av1=strcat('CFC_',labelconditions{1},'_',label1{n1*2},'_vs_',label1{n2*2},'.fig'); %Baseline. 
av2=strcat('CFC_',labelconditions{2},'_',label1{n1*2},'_vs_',label1{n2*2},'.fig'); %Plusmaze.
%%
 openfig(av1)
 %Extract data
 e1=ex; 
h = gcf; %current figure handle
a1 = get(h, 'Children');  %axes handles
d1 = get(a1, 'Children'); %handles to low-level graphics objects in axes
a1=a1(1).Limits(2);
close all
 %
 open(av2)
 %Extract data
e2=ex; 
h = gcf; %current figure handle
a2 = get(h, 'Children');  %axes handles
d2 = get(a2, 'Children'); %handles to low-level graphics objects in axes
a2=a2(1).Limits(2)
close all
a=max([a1 a2]);
%%
allscreen()
subplot(1,2,1)
J=imagesc(30:1:100,0.5:0.5:15,e1);colormap(jet(256));
set(gca,'YDir','normal')
c=colorbar();
% c.Limits(2)=0.0001;
c.Limits(2)=a;
set(J,'AlphaData',~isnan(e1))
ti=title('Baseline')
ti.FontSize=14;
caxis([0 a]);

y=ylabel({'Freq (Hz)',label1{2*n1}})
x=xlabel({label1{2*n2},'Freq (Hz)'})
 x.FontSize=12;
y.FontSize=12;
%%
subplot(1,2,2)
J=imagesc(30:1:100,0.5:0.5:15,e2);
set(gca,'YDir','normal')
c=colorbar();
% c.Limits(2)=0.0001;
c.Limits(2)=a;
set(J,'AlphaData',~isnan(e2))
colormap(jet(256));
ti=title('Plusmaze')
caxis([0 a]);
ti.FontSize=14;
y=ylabel({'Freq (Hz)',label1{2*n1}})
x=xlabel({label1{2*n2},'Freq (Hz)'})
x.FontSize=12;
y.FontSize=12;
%%
HI=mtit(strcat(label1{2*n1},'_\delta','_,','_\theta','{ }','vs','{ }',label1{2*n2},'_\gamma'));
 HI.th.FontSize=18;
HI.th.Color=[1 0 0]
%%
printing( strcat('CFC_','Comparison_',label1{n1*2},'_vs_',label1{n2*2}))
close all
end
end