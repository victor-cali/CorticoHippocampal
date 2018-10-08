

function granger_paper4_row(g,g_f,labelconditions,freqrange,wd)
allscreen()
 
F= [1 2; 1 3; 2 3] ;

lab=cell(6,1);

lab{1}='HPC -> Parietal';
lab{2}='Parietal -> HPC';

lab{3}='HPC -> PFC';
lab{4}='PFC -> HPC';

lab{5}='Parietal -> PFC';
lab{6}='PFC -> Parietal';
% 
%  k=1; %Condition 1.  
 for j=wd:wd
     
 f=F(j,:);

 mmax1=max([max(squeeze(g{1}(f(1),f(2),:))) max(squeeze(g{2}(f(1),f(2),:))) ...
     max(squeeze(g{3}(f(1),f(2),:))) max(squeeze(g{4}(f(1),f(2),:)))]);

 mmax2=max([max(squeeze(g{1}(f(2),f(1),:))) max(squeeze(g{2}(f(2),f(1),:))) ...
     max(squeeze(g{3}(f(2),f(1),:))) max(squeeze(g{4}(f(2),f(1),:)))]);
 
 mmax=max([mmax1 mmax2]);
%

 subplot(3,2,2*j-1)
%  plot(granger1.freq, squeeze(granger1.grangerspctrm(f(1),f(2),:)),'Color',[1 0 0])
% hold on
 plot(g_f, squeeze(g{1}(f(1),f(2),:)),'LineWidth',2)
 hold on
 plot(g_f, squeeze(g{2}(f(1),f(2),:)),'LineWidth',2)
 plot(g_f, squeeze(g{3}(f(1),f(2),:)),'LineWidth',2)
 plot(g_f, squeeze(g{4}(f(1),f(2),:)),'LineWidth',2)
 
 xlim(freqrange)
 ylim([0 mmax])
 
 %grid minor
%  xlabel('Frequency (Hz)')
%  ylabel('G-causality')
 
  ho=xlabel('Frequency (Hz)');
 ho.FontSize=20;
 ho=ylabel('G-causality');
 ho.FontSize=20;
 tp=title(lab{2*j-1}); 
tp.FontSize=20;
% legend('Parametric: AR(10)','Non-P:Multitaper')
%if j==1
% legend(labelconditions)
%end

set(gca,'FontSize',16)

 subplot(3,2,2*j)
%  plot(granger1.freq, squeeze(granger1.grangerspctrm(f(2),f(1),:)),'Color',[1 0 0])
%  hold on
 plot(g_f, squeeze(g{1}(f(2),f(1),:)),'LineWidth',2)
 hold on
 plot(g_f, squeeze(g{2}(f(2),f(1),:)),'LineWidth',2)
 plot(g_f, squeeze(g{3}(f(2),f(1),:)),'LineWidth',2)
 plot(g_f, squeeze(g{4}(f(2),f(1),:)),'LineWidth',2)

 
 xlim(freqrange)
 %grid minor
 ho=xlabel('Frequency (Hz)');
 ho.FontSize=20;
 ho=ylabel('G-causality');
 ho.FontSize=20;
%legend('Parametric: AR(10)','Non-P:Multitaper')
if j==1
lgd=legend(labelconditions) %Might have to change to default. 
lgd.FontSize = 14;
end
tp=title(lab{2*j});
tp.FontSize=20;
 ylim([0 mmax])
 
set(gca,'FontSize',16)
 end
 
end