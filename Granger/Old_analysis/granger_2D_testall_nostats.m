function granger_2D_testall_nostats(g1,g1_f,labelconditions,freqrange,logarithmic)
allscreen()
F= [1 2; 1 3; 2 3] ;

lab=cell(6,1);

lab{1}='HPC -> Parietal';
lab{2}='Parietal -> HPC';
%lab{3}='Parietal -> HPC vs HPC -> Parietal';

lab{3}='HPC -> PFC';
lab{4}='PFC -> HPC';
%lab{6}='PFC -> HPC vs HPC -> PFC';

lab{5}='Parietal -> PFC';
lab{6}='PFC -> Parietal';
% lab{9}='PFC -> Parietal vs Parietal -> PFC';

%% Get range
for jj=1:3
ff=F(jj,:);
%Max
mmax1=max([max(squeeze(g1{1}(ff(1),ff(2),:))) max(squeeze(g1{2}(ff(1),ff(2),:))) ...
     max(squeeze(g1{3}(ff(1),ff(2),:))) max(squeeze(g1{4}(ff(1),ff(2),:)))]);

mmax2=max([max(squeeze(g1{1}(ff(2),ff(1),:))) max(squeeze(g1{2}(ff(2),ff(1),:))) ...
     max(squeeze(g1{3}(ff(2),ff(1),:))) max(squeeze(g1{4}(ff(2),ff(1),:)))]);

mmax=max([mmax1 mmax2]);

%Min
mmin1=min([min(squeeze(g1{1}(ff(1),ff(2),:))) min(squeeze(g1{2}(ff(1),ff(2),:))) ...
     min(squeeze(g1{3}(ff(1),ff(2),:))) min(squeeze(g1{4}(ff(1),ff(2),:)))]);

mmin2=min([min(squeeze(g1{1}(ff(2),ff(1),:))) min(squeeze(g1{2}(ff(2),ff(1),:))) ...
     min(squeeze(g1{3}(ff(2),ff(1),:))) min(squeeze(g1{4}(ff(2),ff(1),:)))]);

mmin=min([mmin1 mmin2]);

if strcmp(logarithmic,'yes')
mrange(jj,:)=log([mmin mmax]);    
else
mrange(jj,:)=([mmin mmax]);    
end
end
Mrange=[min(min(mrange)) max(max(mrange))];
%%

for j=1:3
f=F(j,:);
I=subplot(3,2,2*j-1)
turnim=[squeeze(g1{1}(f(1),f(2),:)).'; squeeze(g1{2}(f(1),f(2),:)).' ;squeeze(g1{3}(f(1),f(2),:)).' ;squeeze(g1{4}(f(1),f(2),:)).'];
if strcmp(logarithmic,'yes')
imagesc(g1_f,[1:4],log(turnim));    
else
imagesc(g1_f,[1:4],(turnim));    
end
colormap(jet(256))


cc=colorbar();
cc.Limits=Mrange;
caxis([Mrange])
%narrow_colorbar()
xlabel('Frequency (Hz)')
%I=gca;
% I.YTickLabel=[{} labelconditions{1} {} labelconditions{2} {} labelconditions{3} {} labelconditions{4} {}];
%I.YTickLabel=[{' '} labelconditions{1} {' '} labelconditions{2} {' '} labelconditions{3} {' '} labelconditions{4} {' '} ];
I.YTickLabel=labelconditions;
xlim(freqrange)
title(lab{2*j-1})

%Opposite direction
I=subplot(3,2,2*j)
turnim2=[squeeze(g1{1}(f(2),f(1),:)).'; squeeze(g1{2}(f(2),f(1),:)).' ;squeeze(g1{3}(f(2),f(1),:)).' ;squeeze(g1{4}(f(2),f(1),:)).'];
if strcmp(logarithmic,'yes')
imagesc(g1_f,[1:4],log(turnim2));
else
imagesc(g1_f,[1:4],(turnim2));    
end
colormap(jet(256))
% colorbar()
cc=colorbar();
cc.Limits=Mrange;
caxis([Mrange])
%narrow_colorbar()
xlabel('Frequency (Hz)')
%I=gca;
% I.YTickLabel=[{} labelconditions{1} {} labelconditions{2} {} labelconditions{3} {} labelconditions{4} {}];
% I.YTickLabel=[{' '} labelconditions{1} {' '} labelconditions{2} {' '} labelconditions{3} {' '} labelconditions{4} {' '} ];
I.YTickLabel=labelconditions;
xlim(freqrange)
title(lab{2*j})

end
end