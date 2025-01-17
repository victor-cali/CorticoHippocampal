%gui_threshold_ripples
%% Find location
close all
dname=uigetdir([],'Select folder with Matlab data containing all rats.');
cd(dname)
%%
z= zeros(length(label1),length(rats));
[T]=gui_table_channels(z,rats,label1,'Threholds');

%%
%Select rat number
opts.Resize = 'on';
opts.WindowStyle = 'modal';
opts.Interpreter = 'tex';
prompt=strcat('\bf Select a rat#. Options:','{ }',num2str(rats));
answer = inputdlg(prompt,'Input',[2 30],{''},opts);
Rat=str2num(answer{1});
cd(num2str(Rat))
tr=getfield(T,strcat('Rat',num2str(Rat)));%Thresholds 
%%
        % Ask for brain area.
% xx = inputdlg({'Cortical Brain area'},...
%               'Type your selection', [1 30]); 
xx={'PAR'};
fn=1000;
%%
gg=getfolder;
gg=gg.';
if size(label1,1)~=3  % IF not Plusmaze
    gg(ismember(gg,'OR_N'))=[];
    gg(ismember(gg,'OD_N(incomplete)'))=[];
    gg=sort(gg); %Sort alphabetically.
    labelconditions2=gg;
    gg(ismember(gg,'CN'))={'CON'};
end
labelconditions=gg;

%% Select experiment to perform. 
inter=1;
%Select length of window in seconds:
ro=[1200];
coher=0;
selectripples=1;
notch=0; %Might need to be 1.
nrem=3;
level=1;

multiplets=[{'singlets'} {'doublets'} {'triplets'} {'quatruplets'} {'pentuplets'} {'sextuplets'} {'septuplets'} {'octuplets'} {'nonuplets'}];
%%
iii=1;
%for iii=1:length(labelconditions) 

    if size(label1,1)~=3  % IF not Plusmaze

        cd( labelconditions2{iii})
        g=getfolder;

        if iii==1
            answer = questdlg('Should we use all trials?', ...
                'Trial selection', ...
                'Use all','Select trials','Select trials');

            % Handle response
            switch answer
                case 'Use all'
                    disp(['Using all.'])
                    an=[];
                case 'Select trials'
                    prompt = {['Enter trials name common word without index:' sprintf('\n') '(Use commas for multiple names)']};
                    dlgtitle = 'Input';
                    dims = [1 35];
                    %definput = {'20','hsv'};
                    an = inputdlg(prompt,dlgtitle,dims);
                    %an=char(an);
            %        g=g(contains(g,{'PT'}));
            end

        end

        if ~isempty(an)
        g=g(contains(g,strsplit(an{1},',')));
        end
  
    else
      g=gg;  
    end
  %% Colormap
       % n=length(g);
myColorMap=jet(length(g));  
%xo
%%
%%
    %Center figure.
    f=figure();
    movegui(gcf,'center');

    %Checkboxes
    Boxcheck = cell(1,4);
    for h1=1:length(labelconditions)
    boxcheck = uicontrol(f,'Style','checkbox','String',labelconditions{h1},'Position',[10 f.Position(4)-30*h1 400 20]);
    boxcheck.FontSize=11;
    boxcheck.Value=1;
    Boxcheck{h1}=boxcheck;   
    end

    set(f, 'NumberTitle', 'off', ...
        'Name', 'Select conditions');

    %Push button
    c = uicontrol;
    c.String = 'Continue';
    c.FontSize=10;
    c.Position=[f.Position(1)/3.5 c.Position(2)-10 f.Position(3)/2 c.Position(4)];

    %Callback
    c.Callback='uiresume(gcbf)';
    uiwait(gcf); 
    boxch=cellfun(@(x) get(x,'Value'),Boxcheck);
    clear Boxcheck
%     labelconditions=labelconditions(find(boxch~=0));
%     labelconditions2=labelconditions2(find(boxch~=0));
% xo
    close(f);
g={g{logical(boxch)}};    

if sum(cell2mat(cellfun(@(equis1) contains(equis1,'nl'),g,'UniformOutput',false)))==1
%     if  find(cell2mat(cellfun(@(equis1) contains(equis1,'nl'),g,'UniformOutput',false))==1)~=1
%         g=flip(g);
%     end
g=g([find(cell2mat(cellfun(@(equis1) contains(equis1,labelconditions2{1}),g,'UniformOutput',false)))...
 find(cell2mat(cellfun(@(equis1) contains(equis1,labelconditions2{2}),g,'UniformOutput',false)))...
 find(cell2mat(cellfun(@(equis1) contains(equis1,labelconditions2{3}),g,'UniformOutput',false)))...
 find(cell2mat(cellfun(@(equis1) contains(equis1,labelconditions2{4}),g,'UniformOutput',false)))]);

else
    error('Name issue')
end

%xo
%%
f=waitbar(0,'Please wait...');
    for k=1:length(g)
        cd(g{k})
%(level,nrem,notch,w,lepoch)
%xo
CORTEX=dir(strcat('*',xx{1},'*.mat'));
if isempty(CORTEX)
    g=g(~contains(g,g{k}));
    cd ..
    progress_bar(k,length(g),f)
    break
end
CORTEX=CORTEX.name;
CORTEX=load(CORTEX);
%CORTEX=CORTEX.CORTEX;
CORTEX=getfield(CORTEX,xx{1});
CORTEX=CORTEX.*(0.195);

A = dir('*states*.mat');
A={A.name};

if  ~isempty(A)
       cellfun(@load,A);
else
      error('No Scoring found')    
end
 %xo
[ripple,RipFreq,rip_duration,Mx_cortex,timeasleep,sig_cortex,Ex_cortex,Sx_cortex,...
  ripple_multiplets_cortex,RipFreq_multiplets_cortex,rip_duration_multiplets_cortex,sig_multiplets_cortex,~,Mr ...
  ]=gui_findripples_random(CORTEX,states,xx,tr,multiplets,fn);

si=sig_cortex(~cellfun('isempty',sig_cortex));
si=[si{:}];
%xo
% plot_hfo(si,Mx_cortex,Sx_cortex,label1{2})
% title(['HFO Cortex  ' strrep(g{k},'_','-')])
% cd ..
% printing(['HFO Cortex  ' strrep(g{k},'_','-')])
% close all
% cd(g{k})
All_Par.( strrep(g{k},'-','_'))=si;
% All_timeasleep.( strrep(g{k},'-','_'))=timeasleep;
%xo
[x,y,z,~,~,~,l,p,si_mixed,th]=hfo_specs(si,timeasleep,0,Rat,tr);
% cd ..
% printing(['Histograms_Cortex_Count_' g{k}]);
% close all
% cd(g{k})

% fi_cortex(k)=x;
% fa_cortex(k)=y;
% amp_cortex(k)=z;
% auc_cortex(k)=l;
% p2p_cortex(k)=p;
%xo
% TH(k)=th;
%% Cortical HFOs
    hfos_cortex(k)=ripple;
    hfos_cortex_rate(k)=RipFreq;
    hfos_cortex_duration(k)=rip_duration;
    clear ripple RipFreq

%Multiplets    
% for ll=1:3
%    eval(['hfos_cortex_' multiplets{ll} '(k)=ripple_multiplets_cortex.' multiplets{ll} ';']) 
%    eval(['hfos_cortex_rate_' multiplets{ll} '(k)=RipFreq_multiplets_cortex.' multiplets{ll} ';']) 
%    eval(['hfos_cortex_duration_' multiplets{ll} '(k)=rip_duration_multiplets_cortex.' multiplets{ll} ';'])    
% end
    
    
%     C = cellfun(@minus,Ex_pfc,Sx_pfc,'UniformOutput',false);
%     CC=([C{:}]);
%     hfos_pfc_duration(k)=median(CC);
%% HPC     
HPC=dir(strcat('*','HPC','*.mat'));
HPC=HPC.name;
HPC=load(HPC);
%HPC=HPC.HPC;
HPC=getfield(HPC,'HPC');
HPC=HPC.*(0.195);
%xo
[ripple,RipFreq,rip_duration,Mx_hpc,timeasleep,sig_hpc,Ex_hpc,Sx_hpc,...
  ripple_multiplets_hpc,RipFreq_multiplets_hpc,rip_duration_multiplets_hpc,sig_multiplets_hpc,Mx_multiplets_hpc...    
  ]=gui_findripples(HPC,states,{'HPC'},tr,multiplets,fn);


si=sig_hpc(~cellfun('isempty',sig_hpc));
si=[si{:}];

% plot_hfo(si,Mx_hpc,Sx_hpc,label1{1})
% title(['HFO HPC  ' strrep(g{k},'_','-')])
% cd ..
% printing(['HFO HPC  ' strrep(g{k},'_','-')])
% close all
% cd(g{k})
% xo
All_HPC.( strrep(g{k},'-','_'))=si;
% [x,y,z,~,~,~,l,p]=hfo_specs_hpc(si,timeasleep,0);
% cd ..
% printing(['Histograms_HPC_Probability_' g{k}]);
% close all
% cd(g{k})

% fi_hpc(k)=x;
% fa_hpc(k)=y;
% amp_hpc(k)=z;
% auc_hpc(k)=l;
% p2p_hpc(k)=p;
% %Instantaneous frequency.
% x=cellfun(@(equis) mean(instfreq(equis,1000)) ,si,'UniformOutput',false);
% x=cell2mat(x);
% x=median(x);
% fi_hpc(k)=x;
% %Average frequency
% y=cellfun(@(equis) (meanfreq(equis,1000)) ,si,'UniformOutput',false);
% y=cell2mat(y);
% y=median(y);
% fa_hpc(k)=y;
% 
% %Amplitude
% z=cellfun(@(equis) max(abs(hilbert(equis))) ,si,'UniformOutput',false);
% z=cell2mat(z);
% z=median(z);
% amp_hpc(k)=z;

% Mx_cortex(~cellfun('isempty',Mx_cortex))
%% HFC HFOs
hfos_hpc(k)=ripple;
hfos_hpc_rate(k)=RipFreq;
hfos_hpc_duration(k)=rip_duration;

%Multiplets    
% for ll=1:length(multiplets)
%    eval(['hfos_hpc_' multiplets{ll} '(k)=ripple_multiplets_hpc.' multiplets{ll} ';']) 
%    eval(['hfos_hpc_rate_' multiplets{ll} '(k)=RipFreq_multiplets_hpc.' multiplets{ll} ';']) 
%    eval(['hfos_hpc_duration_' multiplets{ll} '(k)=rip_duration_multiplets_hpc.' multiplets{ll} ';'])    
% end
% xo
%% Coocurent hfos
[cohfos1,cohfos2]=cellfun(@(equis1,equis2) co_hfo(equis1,equis2),Mx_hpc,Mx_cortex,'UniformOutput',false);
%cohfos1: HPC.
%cohfos2: Cortex.
%Common values:
cohfos_count(k)=sum(cellfun('length',cohfos1));
cohfos_rate(k)=sum(cellfun('length',cohfos1))/(timeasleep*(60));

M_cortex.(labelconditions2{k})=Mx_cortex;
M_hpc.(labelconditions2{k})=Mx_hpc;
% CONTROL 1000 PERMUTATIONS

% for r=1:1000
% [dum_cohfos1,~]=cellfun(@(equis1,equis2) co_hfo(equis1,equis2),Mx_hpc,Mr.(['Field_' num2str(r)]),'UniformOutput',false);
% random_cohfos_count(k,r)=sum(cellfun('length',dum_cohfos1));
% end




%Multiplet cohfos
% for ll=1:length(multiplets)
% [cohfos1_multiplets.(multiplets{ll}),cohfos2_multiplets.(multiplets{ll})]=cellfun(@(equis1,equis2) co_hfo(equis1,equis2),Mx_multiplets_hpc.(multiplets{ll}).',Mx_cortex,'UniformOutput',false);
% cohfos_count_multiplets.(multiplets{ll})(k)=sum(cellfun('length',cohfos1_multiplets.(multiplets{ll})));
% cohfos_rate_multiplets.(multiplets{ll})(k)=sum(cellfun('length',cohfos1_multiplets.(multiplets{ll})))/(timeasleep*(60));
% end
% xo
%% Mixed distribution (Average freq) coHFOs
Mx_cortex_g1=Mx_cortex;
Mx_cortex_g2=Mx_cortex;

row=si_mixed.i1;
cont=0;
for ll=1:length(Mx_cortex)
% cont=cont+length(Mx_cortex{ll});

    if ~isempty(Mx_cortex{ll})

        for lll=1:length(Mx_cortex{ll})
            cont=cont+1;
    %         xo

            if ~ismember(cont,row)
                Mx_cortex_g1{ll}(lll)=NaN;
            else
                Mx_cortex_g2{ll}(lll)=NaN;
            end

        end
         Mx_cortex_g1{ll}=Mx_cortex_g1{ll}(~isnan(Mx_cortex_g1{ll}));
         Mx_cortex_g2{ll}=Mx_cortex_g2{ll}(~isnan(Mx_cortex_g2{ll}));

    end

end

M_cortex_g1.(labelconditions2{k})=Mx_cortex_g1;
M_cortex_g2.(labelconditions2{k})=Mx_cortex_g2;

%%
[cohfos1_g1,cohfos2_g1]=cellfun(@(equis1,equis2) co_hfo(equis1,equis2),Mx_hpc,Mx_cortex_g1,'UniformOutput',false);
[cohfos1_g2,cohfos2_g2]=cellfun(@(equis1,equis2) co_hfo(equis1,equis2),Mx_hpc,Mx_cortex_g2,'UniformOutput',false);

cohfos_count_g1(k)=sum(cellfun('length',cohfos1_g1));
cohfos_rate_g1(k)=sum(cellfun('length',cohfos1_g1))/(timeasleep*(60));

cohfos_count_g2(k)=sum(cellfun('length',cohfos1_g2));
cohfos_rate_g2(k)=sum(cellfun('length',cohfos1_g2))/(timeasleep*(60));
%xo

v2_g1=cellfun(@(equis1,equis2) single_hfo_get_sample(equis1,equis2),Mx_cortex_g1,cohfos2_g1,'UniformOutput',false);
singles_count_g1(k)=sum(cellfun('length',v2_g1));
singles_rate_g1(k)=sum(cellfun('length',v2_g1))/(timeasleep*(60));


v2_g2=cellfun(@(equis1,equis2) single_hfo_get_sample(equis1,equis2),Mx_cortex_g2,cohfos2_g2,'UniformOutput',false);
singles_count_g2(k)=sum(cellfun('length',v2_g2));
singles_rate_g2(k)=sum(cellfun('length',v2_g2))/(timeasleep*(60));


%%


%HPC COHFOS
cohf_mx_hpc=Mx_hpc(~cellfun('isempty',cohfos1));%Peak values cells where HPC cohfos were found.
cohf_sx_hpc=Sx_hpc(~cellfun('isempty',cohfos1));%Peak values cells where HPC cohfos were found.
cohf_ex_hpc=Ex_hpc(~cellfun('isempty',cohfos1));%Peak values cells where HPC cohfos were found.

Cohfos1=cohfos1(~cellfun('isempty',cohfos1));

%Locate sample per cohfos
coh_samp_hpc= cellfun(@(equis1,equis2) co_hfo_get_sample(equis1,equis2),cohf_mx_hpc,Cohfos1,'UniformOutput',false);

cohf_sx_hpc_val=cellfun(@(equis1,equis2) equis1(equis2),cohf_sx_hpc,coh_samp_hpc,'UniformOutput',false);
cohf_sx_hpc_val=[cohf_sx_hpc_val{:}];

cohf_mx_hpc_val=cellfun(@(equis1,equis2) equis1(equis2),cohf_mx_hpc,coh_samp_hpc,'UniformOutput',false);
cohf_mx_hpc_val=[cohf_mx_hpc_val{:}];

cohf_ex_hpc_val=cellfun(@(equis1,equis2) equis1(equis2),cohf_ex_hpc,coh_samp_hpc,'UniformOutput',false);
cohf_ex_hpc_val=[cohf_ex_hpc_val{:}];

cohf_hpc_dura=cohf_ex_hpc_val-cohf_sx_hpc_val;
cohf_hpc_dura=median(cohf_hpc_dura);
Cohf_hpc_dura(k)=cohf_hpc_dura;
%xo
Sig_hpc=sig_hpc(~cellfun('isempty',cohfos1));
Sig_hpc=cellfun(@(equis1,equis2) equis1(equis2),Sig_hpc,coh_samp_hpc,'UniformOutput',false);
Sig_hpc=[Sig_hpc{:}];
%xo

% plot_hfo(Sig_hpc,{cohf_mx_hpc_val},{cohf_sx_hpc_val},label1{1})
% title(['coHFO HPC envelope  ' strrep(g{k},'_','-')])
% cd ..
% printing(['coHFO HPC envelope ' strrep(g{k},'_','-')])
% close all
% cd(g{k})


% 
% [x,y,z,w,h,q,l,p]=hfo_specs(Sig_hpc,timeasleep,0,Rat,tr);
% fi_cohfo_hpc(k)=x;
% fa_cohfo_hpc(k)=y;
% amp_cohfo_hpc(k)=z;
% count_cohfo_hpc(k)=w;
% rate_cohfo_hpc(k)=h;
% dura_cohfo_hpc(k)=q;
% auc_cohfo_hpc(k)=l;
% p2p_cohfo_hpc(k)=p;
%Single HFOs HPC
%[v2]=single_hfo_get_sample(Mx_hpc{1},cohfos1{1});
v2=cellfun(@(equis1,equis2) single_hfo_get_sample(equis1,equis2),Mx_hpc,cohfos1,'UniformOutput',false);

Sig_hpc_single=cellfun(@(equis1,equis2) equis1(equis2),sig_hpc,v2,'UniformOutput',false);
Sig_hpc_single=[Sig_hpc_single{:}];


[single_mx_hpc_val,single_sx_hpc_val]=cellfun(@(equis1,equis2,equis3) single_hfos_mx(equis1,equis2,equis3),cohfos1,Mx_hpc,Sx_hpc,'UniformOutput',false);
single_mx_hpc_val=[single_mx_hpc_val{:}];
single_sx_hpc_val=[single_sx_hpc_val{:}];
% xo


% plot_hfo(Sig_hpc_single,{single_mx_hpc_val},{single_sx_hpc_val},label1{1})
% title(['Single HPC envelope ' strrep(g{k},'_','-')])
% cd ..
% printing(['Single HPC envelope ' strrep(g{k},'_','-')])
% close all
% cd(g{k})

% [x,y,z,w,h,q,l,p]=hfo_specs(Sig_hpc_single,timeasleep,0,Rat,tr);
% fi_single_hpc(k)=x;
% fa_single_hpc(k)=y;
% amp_single_hpc(k)=z;
% count_single_hpc(k)=w;
% rate_single_hpc(k)=h;
% dura_single_hpc(k)=q;
% auc_single_hpc(k)=l;
% p2p_single_hpc(k)=p;


%%%%
%Cortical COHFOS
cohf_mx_cortex=Mx_cortex(~cellfun('isempty',cohfos2));%Peak values cells where cortex cohfos were found.
cohf_sx_cortex=Sx_cortex(~cellfun('isempty',cohfos2));%Peak values cells where cortex cohfos were found.
cohf_ex_cortex=Ex_cortex(~cellfun('isempty',cohfos2));%Peak values cells where cortex cohfos were found.

Cohfos2=cohfos2(~cellfun('isempty',cohfos2));

%Locate sample per cohfos
coh_samp_cortex= cellfun(@(equis1,equis2) co_hfo_get_sample(equis1,equis2),cohf_mx_cortex,Cohfos2,'UniformOutput',false);
cohf_sx_cortex_val=cellfun(@(equis1,equis2) equis1(equis2),cohf_sx_cortex,coh_samp_cortex,'UniformOutput',false);
cohf_sx_cortex_val=[cohf_sx_cortex_val{:}];

cohf_mx_cortex_val=cellfun(@(equis1,equis2) equis1(equis2),cohf_mx_cortex,coh_samp_cortex,'UniformOutput',false);
cohf_mx_cortex_val=[cohf_mx_cortex_val{:}];

cohf_ex_cortex_val=cellfun(@(equis1,equis2) equis1(equis2),cohf_ex_cortex,coh_samp_cortex,'UniformOutput',false);
cohf_ex_cortex_val=[cohf_ex_cortex_val{:}];
cohf_cortex_dura=cohf_ex_cortex_val-cohf_sx_cortex_val;
cohf_cortex_dura=median(cohf_cortex_dura);
Cohf_cortex_dura(k)=cohf_cortex_dura;

Sig_cortex=sig_cortex(~cellfun('isempty',cohfos2));
Sig_cortex=cellfun(@(equis1,equis2) equis1(equis2),Sig_cortex,coh_samp_cortex,'UniformOutput',false);
Sig_cortex=[Sig_cortex{:}];
% xo

% plot_hfo(Sig_cortex,{cohf_mx_cortex_val},{cohf_sx_cortex_val},label1{2})
% title(['coHFO cortex envelope ' strrep(g{k},'_','-')])
% cd ..
% printing(['coHFO cortex envelope ' strrep(g{k},'_','-')])
% close all
% cd(g{k})


% [x,y,z,w,h,q,l,p]=hfo_specs(Sig_cortex,timeasleep,0,Rat,tr);
% fi_cohfo_cortex(k)=x;
% fa_cohfo_cortex(k)=y;
% amp_cohfo_cortex(k)=z;
% count_cohfo_cortex(k)=w;
% rate_cohfo_cortex(k)=h;
% dura_cohfo_cortex(k)=q;
% auc_cohfo_cortex(k)=l;
% p2p_cohfo_cortex(k)=p;
%Single HFOs Cortex
%[v2]=single_hfo_get_sample(Mx_hpc{1},cohfos1{1});
v2=cellfun(@(equis1,equis2) single_hfo_get_sample(equis1,equis2),Mx_cortex,cohfos2,'UniformOutput',false);

Sig_cortex_single=cellfun(@(equis1,equis2) equis1(equis2),sig_cortex,v2,'UniformOutput',false);
Sig_cortex_single=[Sig_cortex_single{:}];
%xo
[single_mx_cortex_val,single_sx_cortex_val]=cellfun(@(equis1,equis2,equis3) single_hfos_mx(equis1,equis2,equis3),cohfos2,Mx_cortex,Sx_cortex,'UniformOutput',false);
single_mx_cortex_val=[single_mx_cortex_val{:}];
single_sx_cortex_val=[single_sx_cortex_val{:}];



% plot_hfo(Sig_cortex_single,{single_mx_cortex_val},{single_sx_cortex_val},label1{2})
% title(['Single cortex envelope ' strrep(g{k},'_','-')])
% cd ..
% printing(['Single cortex envelope ' strrep(g{k},'_','-')])
% close all
% cd(g{k})

% [x,y,z,w,h,q,l,p]=hfo_specs(Sig_cortex_single,timeasleep,0,Rat,tr);
% fi_single_cortex(k)=x;
% fa_single_cortex(k)=y;
% amp_single_cortex(k)=z;
% count_single_cortex(k)=w;
% rate_single_cortex(k)=h;
% dura_single_cortex(k)=q;
% auc_single_cortex(k)=l;
% p2p_single_cortex(k)=p;
% xo
progress_bar(k,length(g),f)
    cd ..    
    end
  xo
  
%   [a1,a2]=ttest(random_cohfos_count(3,:),cohfos_count(3),0.05)
%% All PAR hfos. 

M=sum(cellfun('length', M_cortex.('plusmaze'))); %Plusmaze

%n=2;
for n=2:4

N=sum(cellfun('length', M_cortex.(labelconditions2{n}))); %Condition B

for t=1:1000
r=randperm(M,N);
cont=0;
M_cortex_dummy=M_cortex;
    for i=1:size(M_cortex.('plusmaze'),1) %EPOCHS
    vec=M_cortex.('plusmaze'){i};

        for j=1:length(vec) %Detections
            cont=cont+1;
            if ~ismember(cont,r)
                M_cortex_dummy.(labelconditions2{1}){i}(j)=NaN;
            end

        end
        
        vec2=M_cortex_dummy.('plusmaze'){i};
     M_cortex_dummy.('plusmaze'){i}=vec2(~isnan(vec2));
    end

    
    
[c1,~]=cellfun(@(equis1,equis2) co_hfo(equis1,equis2),M_hpc.('plusmaze'),M_cortex_dummy.('plusmaze'),'UniformOutput',false);

random_count(t)=sum(cellfun('length',c1));
t
end

histogram(random_count)
%     histogram(random_cohfos_count(n,:),15)
    ylabel('Frequency')
    xlabel('Count')
    Y1 = prctile(random_count,5)
    Y2 = prctile(random_count,95)
    Y3 = prctile(random_count,2.5)
    Y4 = prctile(random_count,97.5)
% 
    xline(Y1, '-.k','LineWidth',2)
    xline(Y2, '-.k','LineWidth',2)
    xline(Y3, '--k','LineWidth',2)
    xline(Y4, '--k','LineWidth',2)
% 
xline(cohfos_count(n), '-r','LineWidth',2)
% 
    printing(['Control_Fed_' labelconditions2{n}])
    close all
end
%% Slow ripples only.
M=sum(cellfun('length', M_cortex_g1.('plusmaze'))); %Plusmaze

%n=2;
for n=2:4

N=sum(cellfun('length', M_cortex_g1.(labelconditions2{n}))); %Condition B

for t=1:1000
r=randperm(M,N);
cont=0;
M_cortex_g1_dummy=M_cortex_g1;
    for i=1:size(M_cortex_g1.('plusmaze'),1) %EPOCHS
    vec=M_cortex_g1.('plusmaze'){i};

        for j=1:length(vec) %Detections
            cont=cont+1;
            if ~ismember(cont,r)
                M_cortex_g1_dummy.(labelconditions2{1}){i}(j)=NaN;
            end

        end
        
        vec2=M_cortex_g1_dummy.('plusmaze'){i};
     M_cortex_g1_dummy.('plusmaze'){i}=vec2(~isnan(vec2));
    end

    
    
[c1,~]=cellfun(@(equis1,equis2) co_hfo(equis1,equis2),M_hpc.('plusmaze'),M_cortex_g1_dummy.('plusmaze'),'UniformOutput',false);

random_count(t)=sum(cellfun('length',c1));
t
end

histogram(random_count)
%     histogram(random_cohfos_count(n,:),15)
    ylabel('Frequency')
    xlabel('Count')
    Y1 = prctile(random_count,5)
    Y2 = prctile(random_count,95)
    Y3 = prctile(random_count,2.5)
    Y4 = prctile(random_count,97.5)
% 
    xline(Y1, '-.k','LineWidth',2)
    xline(Y2, '-.k','LineWidth',2)
    xline(Y3, '--k','LineWidth',2)
    xline(Y4, '--k','LineWidth',2)
% 
xline(cohfos_count_g1(n), '-r','LineWidth',2)
% 
    printing(['Control_Fed_Slow_' labelconditions2{n}])
    close all
end
%%
%% FAST ripples only.
M=sum(cellfun('length', M_cortex_g2.('plusmaze'))); %Plusmaze

%n=2;
for n=2:4

N=sum(cellfun('length', M_cortex_g2.(labelconditions2{n}))); %Condition B

for t=1:1000
r=randperm(M,N);
cont=0;
M_cortex_g2_dummy=M_cortex_g2;
    for i=1:size(M_cortex_g2.('plusmaze'),1) %EPOCHS
    vec=M_cortex_g2.('plusmaze'){i};

        for j=1:length(vec) %Detections
            cont=cont+1;
            if ~ismember(cont,r)
                M_cortex_g2_dummy.(labelconditions2{1}){i}(j)=NaN;
            end

        end
        
        vec2=M_cortex_g2_dummy.('plusmaze'){i};
     M_cortex_g2_dummy.('plusmaze'){i}=vec2(~isnan(vec2));
    end

    
    
[c1,~]=cellfun(@(equis1,equis2) co_hfo(equis1,equis2),M_hpc.('plusmaze'),M_cortex_g2_dummy.('plusmaze'),'UniformOutput',false);

random_count(t)=sum(cellfun('length',c1));
t
end

histogram(random_count)
%     histogram(random_cohfos_count(n,:),15)
    ylabel('Frequency')
    xlabel('Count')
    Y1 = prctile(random_count,5)
    Y2 = prctile(random_count,95)
    Y3 = prctile(random_count,2.5)
    Y4 = prctile(random_count,97.5)
% 
    xline(Y1, '-.k','LineWidth',2)
    xline(Y2, '-.k','LineWidth',2)
    xline(Y3, '--k','LineWidth',2)
    xline(Y4, '--k','LineWidth',2)
% 
xline(cohfos_count_g2(n), '-r','LineWidth',2)
% 
    printing(['Control_Fed_Fast_' labelconditions2{n}])
    close all
end
%% Normalized distribution.
%% Slow ripples only.
M=sum(cellfun('length', M_cortex_g1.('plusmaze'))); %Plusmaze

%n=2;
clear aj
for n=2:4
N=sum(cellfun('length', M_cortex_g1.(labelconditions2{n}))); %Condition B
clear random_count
for t=1:1000
r=randperm(M,N);
cont=0;
M_cortex_g1_dummy=M_cortex_g1;
    for i=1:size(M_cortex_g1.('plusmaze'),1) %EPOCHS
    vec=M_cortex_g1.('plusmaze'){i};

        for j=1:length(vec) %Detections
            cont=cont+1;
            if ~ismember(cont,r)
                M_cortex_g1_dummy.(labelconditions2{1}){i}(j)=NaN;
            end

        end
        
        vec2=M_cortex_g1_dummy.('plusmaze'){i};
     M_cortex_g1_dummy.('plusmaze'){i}=vec2(~isnan(vec2));
    end

    
    
[c1,~]=cellfun(@(equis1,equis2) co_hfo(equis1,equis2),M_hpc.('plusmaze'),M_cortex_g1_dummy.('plusmaze'),'UniformOutput',false);

random_count(t)=sum(cellfun('length',c1));
t
end
%xo
%
clear r_count
r_count=(random_count-cohfos_count_g1(n))/std(random_count);
Fed_slow_24(n-1,:)=r_count;
set(0,'defaultAxesFontName', 'Arial')
set(0,'defaultTextFontName', 'Arial')

histogram(r_count,[-10.5:1:10.5],'FaceColor',[0 0 0])
%     histogram(random_cohfos_count(n,:),15)
    ylabel('Frequency','FontSize',10,'FontName','Arial')
    xlabel('Count','FontSize',10,'FontName','Arial')
    Y1 = prctile(r_count,5)
    Y2 = prctile(r_count,95)
%     Y3 = prctile(random_count,2.5)
%     Y4 = prctile(random_count,97.5)
% 
    xline(Y1, '-.k','LineWidth',2)
    xline(Y2, '-.k','LineWidth',2)
%     xline(Y3, '--k','LineWidth',2)
%     xline(Y4, '--k','LineWidth',2)
% % 
xline(0, '-r','LineWidth',2)
xlim([-10 10])
xticks([-10:2:10])

aj(n)=(1+sum(r_count >=0))/(length(r_count)+1)

set(gca,'FontName','Arial')
set(gca,'FontSize',10)
ax = gca;
ax.YAxis.FontSize = 18 %for y-axis 
ax.XAxis.FontSize = 18 %for y-axis 
ax.XAxis.FontName='Arial';
ax.XAxis.FontName='Arial';

     printing(['Control_Fed_Slow_' num2str(Rat) '_' labelconditions2{n}])
    close all
end

%%
%% FAST ripples only.
M=sum(cellfun('length', M_cortex_g2.('plusmaze'))); %Plusmaze

%n=2;
clear aj
for n=2:4
% clear aj
N=sum(cellfun('length', M_cortex_g2.(labelconditions2{n}))); %Condition B
clear random_count
for t=1:1000
r=randperm(M,N);
cont=0;
M_cortex_g2_dummy=M_cortex_g2;
    for i=1:size(M_cortex_g2.('plusmaze'),1) %EPOCHS
    vec=M_cortex_g2.('plusmaze'){i};

        for j=1:length(vec) %Detections
            cont=cont+1;
            if ~ismember(cont,r)
                M_cortex_g2_dummy.(labelconditions2{1}){i}(j)=NaN;
            end

        end
        
        vec2=M_cortex_g2_dummy.('plusmaze'){i};
     M_cortex_g2_dummy.('plusmaze'){i}=vec2(~isnan(vec2));
    end

    
    
[c1,~]=cellfun(@(equis1,equis2) co_hfo(equis1,equis2),M_hpc.('plusmaze'),M_cortex_g2_dummy.('plusmaze'),'UniformOutput',false);

random_count(t)=sum(cellfun('length',c1));
t
end
%xo
%
clear r_count
r_count=(random_count-cohfos_count_g2(n))/std(random_count);
Fed_Fast_24(n-1,:)=r_count;
set(0,'defaultAxesFontName', 'Arial')
set(0,'defaultTextFontName', 'Arial')

histogram(r_count,[-10.5:1:10.5],'FaceColor',[0 0 0])
%     histogram(random_cohfos_count(n,:),15)
    ylabel('Frequency','FontSize',10,'FontName','Arial')
    xlabel('Count','FontSize',10,'FontName','Arial')
    Y1 = prctile(r_count,5)
    Y2 = prctile(r_count,95)
%     Y3 = prctile(random_count,2.5)
%     Y4 = prctile(random_count,97.5)
% 
    xline(Y1, '-.k','LineWidth',2)
    xline(Y2, '-.k','LineWidth',2)
%     xline(Y3, '--k','LineWidth',2)
%     xline(Y4, '--k','LineWidth',2)
% % 
xline(0, '-r','LineWidth',2)
xlim([-10 10])
xticks([-10:2:10])

aj(n)=(1+sum(r_count >=0))/(length(r_count)+1)

set(gca,'FontName','Arial')
set(gca,'FontSize',10)
ax = gca;
ax.YAxis.FontSize = 18 %for y-axis 
ax.XAxis.FontSize = 18 %for y-axis 
ax.XAxis.FontName='Arial';
ax.XAxis.FontName='Arial';

     printing(['Control_Fed_Fast_' num2str(Rat) '_' labelconditions2{n}])
    close all
end

%%
vec=Fed_Fast_24;
vec=vec(:);

(1+sum(vec >=0))/(length(vec)+1)
%%

for n=1:3
%w=1;
a_26=Fed_Fast_26(n,:);
a_27=Fed_Fast_27(n,:);
a_24=Fed_Fast_24(n,:);

% a_26=All_norm_post_26(n,:);
% a_27=All_norm_post_27(n,:);
% a_24=All_norm_post_24(n,:);

% a_26=All_norm_post_26(n,:);
% a_27=All_norm_post_27(n,:);
% a_24=All_norm_post_24(n,:);

vec=[a_26 a_27 a_24];

aj(n)=(1+sum(vec >=0))/(length(vec)+1);
end
%%
a_26=Fed_Fast_26(:,:);
a_26=a_26(:);
a_27=Fed_Fast_27(:,:);
a_27=a_27(:);
a_24=Fed_Fast_24(:,:);
a_24=a_24(:);

vec=[a_26; a_27; a_24]; %a_26; a_27; a_24
vec=vec(:);
(1+sum(vec >=0))/(length(vec)+1)
%%
  [a1,a2]=kstest(random_cohfos_count(3,:),'CDF',cohfos_count(3),'Alpha',0.05);
    
% All_timeasleep
% All_Par
% A_cell = struct2cell(All_Par);
% All_Par_24_35=[A_cell{:}];
% %%
% All_40=[All_Par_26 All_Par_27 All_Par_24_40];
% All_35=[All_Par_26 All_Par_27 All_Par_24_35];
% %%
% 
% si=All_40;
% hfo_specs(si,1,1)
% %printing('Histogram_All_Par_40_probability')
% printing('Histogram_All_Par_40_count')
% 
% %%
% si=All_35;
% hfo_specs(si,1,1)
% % printing('Histogram_All_Par_35_probability')
% printing('Histogram_All_Par_35_count')

%AUC
TT=table;
TT.Variables=    [[{'All_cortex'};{'All_HPC'};{'Cohfo_cortex'};{'Cohfo_hpc'};{'Single_cortex'};{'Single_HPC'}] num2cell([auc_cortex;auc_hpc;auc_cohfo_cortex;auc_cohfo_hpc;auc_single_cortex;auc_single_hpc])];
TT.Properties.VariableNames=['HFO Type';cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false)].';
writetable(TT,strcat('AUC_',num2str(tr(1)),'_',num2str(tr(2)),'.xls'),'Sheet',1,'Range','A2:L10')    

%Peak-to-Peak distance
TT=table;
TT.Variables=    [[{'All_cortex'};{'All_HPC'};{'Cohfo_cortex'};{'Cohfo_hpc'};{'Single_cortex'};{'Single_HPC'}] num2cell([p2p_cortex;p2p_hpc;p2p_cohfo_cortex;p2p_cohfo_hpc;p2p_single_cortex;p2p_single_hpc])];
TT.Properties.VariableNames=['HFO Type';cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false)].';
writetable(TT,strcat('P2P_',num2str(tr(1)),'_',num2str(tr(2)),'.xls'),'Sheet',1,'Range','A2:L10')    
%xo


%Cortex
c = categorical(cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false)); 
bar(c,hfos_cortex)
ylabel('Number of HFOs')
title(xx{1})

    if size(label1,1)~=3  % IF not Plusmaze 
      string=strcat('HFOs_counts_',xx{1},'_Rat',num2str(Rat),'_',labelconditions{iii}); 
    else
%         if strcmp(xx{1},'HPC')
%                   string=strcat('HFOs_counts_',xx{1},'_Rat',num2str(Rat),'_',num2str(tr(1)));         
%         else
                  string=strcat('HFOs_counts_',xx{1},'_Rat',num2str(Rat),'_',num2str(tr(2)));         
%         end
    end

    printing(string)
    close all
%rate
c = categorical(cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false)); 
bar(c,hfos_cortex_rate)
ylabel('HFOs per second')
title(xx{1})


    if size(label1,1)~=3  % IF not Plusmaze 
      string=strcat('HFOs_rate_',xx{1},'_Rat',num2str(Rat),'_',labelconditions{iii}); 
    else
%         if strcmp(xx{1},'HPC')
%                   string=strcat('HFOs_rate_',xx{1},'_Rat',num2str(Rat),'_',num2str(tr(1)));         
%         else
                  string=strcat('HFOs_rate_',xx{1},'_Rat',num2str(Rat),'_',num2str(tr(2)));         
%         end
        
    end

    printing(string)
    close all
    
%Average Frequency
c = categorical(cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false)); 
bar(c,fa_cortex)
ylabel('Average frequency')
title(xx{1})
ylim([100 300])

    if size(label1,1)~=3  % IF not Plusmaze 
      string=strcat('HFOs_counts_',xx{1},'_Rat',num2str(Rat),'_',labelconditions{iii}); 
    else
%         if strcmp(xx{1},'HPC')
%                   string=strcat('HFOs_counts_',xx{1},'_Rat',num2str(Rat),'_',num2str(tr(1)));         
%         else
                  string=strcat('HFOs_average_frequency_',xx{1},'_Rat',num2str(Rat),'_',num2str(tr(2)));         
%         end
    end

    printing(string)
    close all
    
%Instantaneous Frequency
c = categorical(cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false)); 
bar(c,fi_cortex)
ylabel('Average instantaneous frequency')
title(xx{1})
ylim([100 300])

    if size(label1,1)~=3  % IF not Plusmaze 
      string=strcat('HFOs_counts_',xx{1},'_Rat',num2str(Rat),'_',labelconditions{iii}); 
    else
%         if strcmp(xx{1},'HPC')
%                   string=strcat('HFOs_counts_',xx{1},'_Rat',num2str(Rat),'_',num2str(tr(1)));         
%         else
                  string=strcat('HFOs_instantaneous_frequency_',xx{1},'_Rat',num2str(Rat),'_',num2str(tr(2)));         
%         end
    end

    printing(string)
    close all
    
%Amplitude    
c = categorical(cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false)); 
bar(c,amp_cortex)
ylabel('Amplitude (uV)')
title(xx{1})
%ylim([100 300])

    if size(label1,1)~=3  % IF not Plusmaze 
      string=strcat('HFOs_counts_',xx{1},'_Rat',num2str(Rat),'_',labelconditions{iii}); 
    else
%         if strcmp(xx{1},'HPC')
%                   string=strcat('HFOs_counts_',xx{1},'_Rat',num2str(Rat),'_',num2str(tr(1)));         
%         else
                  string=strcat('HFOs_amplitude_',xx{1},'_Rat',num2str(Rat),'_',num2str(tr(2)));         
%         end
    end

    printing(string)
    close all
    
    
%     xo
    TT=table;
    TT.Variables=    [[{'Count'};{'Rate'};{'Duration'};{'Average Frequency'};{'Instantaneous Frequency'};{'Amplitude'}] num2cell([hfos_cortex;hfos_cortex_rate;hfos_cortex_duration;fa_cortex;fi_cortex; amp_cortex])];
%     TT.Variables=    [[{'Count'};{'Rate'};{'Duration'}] num2cell([hfos_hpc;hfos_hpc_rate;hfos_hpc_duration])];
    
    TT.Properties.VariableNames=['Metric';cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false)].';
    
%     if strcmp(xx{1},'HPC')
%             writetable(TT,strcat(xx{1},'_',num2str(tr(1)),'.xls'),'Sheet',1,'Range','A2:L6')    
%     else
            writetable(TT,strcat(xx{1},'_',num2str(tr(2)),'.xls'),'Sheet',1,'Range','A2:L10')    
%     end
%%
%Multiplets
t1=repmat({'x'},[1 length(g)+2]);

for ll=1:3
    TT=table;
%     strcat('TT.Variables=    [[','{' ,'''','Count','''','};','{' ,'''','Rate','''','};','{' ,'''','Duration','''','};',']')
    eval(strcat('TT.Variables=    [','[','{' ,'''',multiplets{ll},'''','};','{' ,'''','x','''','};','{' ,'''','x','''','}',']'," ",'[','{' ,'''','Count','''','};','{' ,'''','Rate','''','};','{' ,'''','Duration','''','}',']',...
    ' num2cell([hfos_cortex_',multiplets{ll},';hfos_cortex_rate_',multiplets{ll},';hfos_cortex_duration_',multiplets{ll},'])];'))
    TT.Properties.VariableNames=['Event';'Metric';cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false)].';

    tab.(multiplets{ll})=TT;
%   eval(strcat('writetable(TT,strcat(''','HPC','''',',','''','_','''',',','num2str(tr(1)),''_',multiplets{ll},'''',',','''','.xls','''','),',...
%       '''','Sheet','''',',1,','''','Range','''',',','''','A2:L10','''',')'))
    if ll==1
        Tab=tab.(multiplets{ll});
    else
        Tab=[Tab;t1;tab.(multiplets{ll})];
    end

end

writetable(Tab,strcat(xx{1},'_',num2str(tr(2)),'_multiplets','.xls'),'Sheet',1,'Range','A1:Z50')

%%
%Cortex cohfos
    TT=table;
    TT.Variables=    [[{'Count'};{'Rate'};{'Duration'};{'Average Frequency'};{'Instantaneous Frequency'};{'Amplitude'}] num2cell([count_cohfo_cortex;rate_cohfo_cortex;dura_cohfo_cortex;fa_cohfo_cortex;fi_cohfo_cortex; amp_cohfo_cortex])];
%     TT.Variables=    [[{'Count'};{'Rate'};{'Duration'}] num2cell([hfos_hpc;hfos_hpc_rate;hfos_hpc_duration])];
    
    TT.Properties.VariableNames=['Metric';cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false)].';
    
%     if strcmp(xx{1},'HPC')
%             writetable(TT,strcat(xx{1},'_',num2str(tr(1)),'.xls'),'Sheet',1,'Range','A2:L6')    
%     else
            writetable(TT,strcat(xx{1},'_',num2str(tr(2)),'_cohfos','.xls'),'Sheet',1,'Range','A2:L10')    

%Cortex singles
    TT=table;
    TT.Variables=    [[{'Count'};{'Rate'};{'Duration'};{'Average Frequency'};{'Instantaneous Frequency'};{'Amplitude'}] num2cell([count_single_cortex;rate_single_cortex;dura_single_cortex;fa_single_cortex;fi_single_cortex; amp_single_cortex])];
%     TT.Variables=    [[{'Count'};{'Rate'};{'Duration'}] num2cell([hfos_hpc;hfos_hpc_rate;hfos_hpc_duration])];
    
    TT.Properties.VariableNames=['Metric';cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false)].';
    
%     if strcmp(xx{1},'HPC')
%             writetable(TT,strcat(xx{1},'_',num2str(tr(1)),'.xls'),'Sheet',1,'Range','A2:L6')    
%     else
            writetable(TT,strcat(xx{1},'_',num2str(tr(2)),'_singles','.xls'),'Sheet',1,'Range','A2:L10')    

  %%          

%HPC
c = categorical(cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false)); 
bar(c,hfos_hpc)
ylabel('Number of HFOs')
title('HPC')

    if size(label1,1)~=3  % IF not Plusmaze 
      string=strcat('HFOs_counts_',xx{1},'_Rat',num2str(Rat),'_',labelconditions{iii}); 
    else
%         if strcmp(xx{1},'HPC')
%                   string=strcat('HFOs_counts_',xx{1},'_Rat',num2str(Rat),'_',num2str(tr(1)));         
%         else
                  string=strcat('HFOs_counts_','HPC','_Rat',num2str(Rat),'_',num2str(tr(1)));         
%         end
    end

    printing(string)
    close all
%rate
c = categorical(cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false)); 
bar(c,hfos_hpc_rate)
ylabel('HFOs per second')
title('HPC')


    if size(label1,1)~=3  % IF not Plusmaze 
      string=strcat('HFOs_rate_',xx{1},'_Rat',num2str(Rat),'_',labelconditions{iii}); 
    else
%         if strcmp(xx{1},'HPC')
%                   string=strcat('HFOs_rate_',xx{1},'_Rat',num2str(Rat),'_',num2str(tr(1)));         
%         else
                  string=strcat('HFOs_rate_','HPC','_Rat',num2str(Rat),'_',num2str(tr(1)));         
%         end
        
    end

    printing(string)
    close all
%    xo


%Average Frequency
c = categorical(cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false)); 
bar(c,fa_hpc)
ylabel('Average frequency')
title('HPC')
ylim([100 300])

    if size(label1,1)~=3  % IF not Plusmaze 
      string=strcat('HFOs_counts_',xx{1},'_Rat',num2str(Rat),'_',labelconditions{iii}); 
    else
%         if strcmp(xx{1},'HPC')
%                   string=strcat('HFOs_counts_',xx{1},'_Rat',num2str(Rat),'_',num2str(tr(1)));         
%         else
                  string=strcat('HFOs_average_frequency_','HPC','_Rat',num2str(Rat),'_',num2str(tr(1)));         
%         end
    end

    printing(string)
    close all
    
%Instantaneous Frequency
c = categorical(cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false)); 
bar(c,fi_hpc)
ylabel('Average instantaneous frequency')
title('HPC')
ylim([100 300])

    if size(label1,1)~=3  % IF not Plusmaze 
      string=strcat('HFOs_counts_',xx{1},'_Rat',num2str(Rat),'_',labelconditions{iii}); 
    else
%         if strcmp(xx{1},'HPC')
%                   string=strcat('HFOs_counts_',xx{1},'_Rat',num2str(Rat),'_',num2str(tr(1)));         
%         else
                  string=strcat('HFOs_instantaneous_frequency_','HPC','_Rat',num2str(Rat),'_',num2str(tr(1)));         
%         end
    end

    printing(string)
    close all

%Amplitude    
c = categorical(cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false)); 
bar(c,amp_hpc)
ylabel('Amplitude (uV)')
title('HPC')
%ylim([100 300])

    if size(label1,1)~=3  % IF not Plusmaze 
      string=strcat('HFOs_counts_',xx{1},'_Rat',num2str(Rat),'_',labelconditions{iii}); 
    else
%         if strcmp(xx{1},'HPC')
%                   string=strcat('HFOs_counts_',xx{1},'_Rat',num2str(Rat),'_',num2str(tr(1)));         
%         else
                  string=strcat('HFOs_amplitude_','HPC','_Rat',num2str(Rat),'_',num2str(tr(1)));         
%         end
    end

    printing(string)
    close all


    TT=table;
    TT.Variables=    [[{'Count'};{'Rate'};{'Duration'};{'Average Frequency'};{'Instantaneous Frequency'};{'Amplitude'}] num2cell([hfos_hpc;hfos_hpc_rate;hfos_hpc_duration;fa_hpc;fi_hpc;amp_hpc])];        
%    TT.Properties.VariableNames=['Metric';g];
    TT.Properties.VariableNames=['Metric';cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false)].';
    
%     if strcmp(xx{1},'HPC')
%             writetable(TT,strcat(xx{1},'_',num2str(tr(1)),'.xls'),'Sheet',1,'Range','A2:L6')    
%     else
            writetable(TT,strcat('HPC','_',num2str(tr(1)),'.xls'),'Sheet',1,'Range','A2:L10')    
%     end
%%
%Multiplets
t1=repmat({'x'},[1 length(g)+2]);

for ll=1:length(multiplets)
    TT=table;
%     strcat('TT.Variables=    [[','{' ,'''','Count','''','};','{' ,'''','Rate','''','};','{' ,'''','Duration','''','};',']')
    eval(strcat('TT.Variables=    [','[','{' ,'''',multiplets{ll},'''','};','{' ,'''','x','''','};','{' ,'''','x','''','}',']'," ",'[','{' ,'''','Count','''','};','{' ,'''','Rate','''','};','{' ,'''','Duration','''','}',']',...
    ' num2cell([hfos_hpc_',multiplets{ll},';hfos_hpc_rate_',multiplets{ll},';hfos_hpc_duration_',multiplets{ll},'])];'))
    TT.Properties.VariableNames=['Event';'Metric';cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false)].';

    tab.(multiplets{ll})=TT;
%   eval(strcat('writetable(TT,strcat(''','HPC','''',',','''','_','''',',','num2str(tr(1)),''_',multiplets{ll},'''',',','''','.xls','''','),',...
%       '''','Sheet','''',',1,','''','Range','''',',','''','A2:L10','''',')'))
    if ll==1
        Tab=tab.(multiplets{ll});
    else
        Tab=[Tab;t1;tab.(multiplets{ll})];
    end

end

writetable(Tab,strcat('HPC','_',num2str(tr(1)),'_multiplets','.xls'),'Sheet',1,'Range','A1:Z50')


%%
%hpc cohfos
    TT=table;
    TT.Variables=    [[{'Count'};{'Rate'};{'Duration'};{'Average Frequency'};{'Instantaneous Frequency'};{'Amplitude'}] num2cell([count_cohfo_hpc;rate_cohfo_hpc;dura_cohfo_hpc;fa_cohfo_hpc;fi_cohfo_hpc; amp_cohfo_hpc])];
%     TT.Variables=    [[{'Count'};{'Rate'};{'Duration'}] num2cell([hfos_hpc;hfos_hpc_rate;hfos_hpc_duration])];
    
    TT.Properties.VariableNames=['Metric';cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false)].';
    
%     if strcmp(xx{1},'HPC')
%             writetable(TT,strcat(xx{1},'_',num2str(tr(1)),'.xls'),'Sheet',1,'Range','A2:L6')    
%     else
            writetable(TT,strcat('HPC','_',num2str(tr(1)),'_',num2str(tr(2)),'_cohfos','.xls'),'Sheet',1,'Range','A2:L10')    

%hpc singles
    TT=table;
    TT.Variables=    [[{'Count'};{'Rate'};{'Duration'};{'Average Frequency'};{'Instantaneous Frequency'};{'Amplitude'}] num2cell([count_single_hpc;rate_single_hpc;dura_single_hpc;fa_single_hpc;fi_single_hpc; amp_single_hpc])];
%     TT.Variables=    [[{'Count'};{'Rate'};{'Duration'}] num2cell([hfos_hpc;hfos_hpc_rate;hfos_hpc_duration])];
    
    TT.Properties.VariableNames=['Metric';cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false)].';
    
%     if strcmp(xx{1},'HPC')
%             writetable(TT,strcat(xx{1},'_',num2str(tr(1)),'.xls'),'Sheet',1,'Range','A2:L6')    
%     else
            writetable(TT,strcat('HPC','_',num2str(tr(1)),'_',num2str(tr(2)),'_singles','.xls'),'Sheet',1,'Range','A2:L10')    



%%
%COHFOS
c = categorical(cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false)); 
bar(c,cohfos_count)
ylabel('Number of coHFOs')
title('Both areas')

    if size(label1,1)~=3  % IF not Plusmaze 
      string=strcat('coHFOs_counts_',xx{1},'_Rat',num2str(Rat),'_',labelconditions{iii}); 
    else
%         if strcmp(xx{1},'HPC')
%                   string=strcat('HFOs_counts_',xx{1},'_Rat',num2str(Rat),'_',num2str(tr(1)));         
%         else
                  string=strcat('coHFOs_counts_','Rat',num2str(Rat),'_',num2str(tr(1)),'_',num2str(tr(2)));         
%         end
    end

    printing(string)
    close all
    
    
c = categorical(cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false)); 
bar(c,cohfos_rate)
ylabel('coHFOs per second')
title('Both areas')    

    if size(label1,1)~=3  % IF not Plusmaze 
      string=strcat('coHFOs_counts_',xx{1},'_Rat',num2str(Rat),'_',labelconditions{iii}); 
    else
%         if strcmp(xx{1},'HPC')
%                   string=strcat('HFOs_counts_',xx{1},'_Rat',num2str(Rat),'_',num2str(tr(1)));         
%         else
                  string=strcat('coHFOs_rate_','Rat',num2str(Rat),'_',num2str(tr(1)),'_',num2str(tr(2)));         
%         end
    end

    printing(string)
    close all

    TT=table;
    TT.Variables=    [[{'Count'};{'Rate'}] num2cell([cohfos_count;cohfos_rate;])];
    TT.Properties.VariableNames=['Metric';g];    
    writetable(TT,strcat('coHFOs_',num2str(tr(2)),'.xls'),'Sheet',1,'Range','A2:L6')    
    
%%
%Multiplet cohfos
t1=repmat({'x'},[1 length(g)+2]);
for ll=1:length(multiplets)

    TT=table;
    TT.Variables=    [[{multiplets{ll}};{'x'}] [{'Count'};{'Rate'}] num2cell([cohfos_count_multiplets.(multiplets{ll});cohfos_rate_multiplets.(multiplets{ll});])];
  
    TT.Properties.VariableNames=['Event';'Metric';g];
    tab_cohfos.(multiplets{ll})=TT;
        if ll==1
            Tab_cohfos=tab_cohfos.(multiplets{ll});
        else
            Tab_cohfos=[Tab_cohfos;t1;tab_cohfos.(multiplets{ll})];
        end

%     writetable(TT,strcat('coHFOs_',num2str(tr(2)),'.xls'),'Sheet',1,'Range','A2:L6')
end


writetable(Tab_cohfos,strcat('coHFOs','_multiplets_',num2str(tr(1)),'_',num2str(tr(2)),'.xls'),'Sheet',1,'Range','A1:Z50')

%% Demixed Gaussians 

%coHFOs
    TT=table;
%    TT.Variables=    [[{'Slower'};{'x'}] [{'Count'};{'Rate'}] num2cell([cohfos_count_g1;cohfos_rate_g1;])];
    TT.Variables=    [[{'Slower'};{'x'};{'Faster'};{'x'}] [{'Count'};{'Rate'};{'Count'};{'Rate'}] num2cell([cohfos_count_g1;cohfos_rate_g1;cohfos_count_g2;cohfos_rate_g2])];

    TT.Properties.VariableNames=['Events';'Metric';g];


writetable(TT,strcat('slower_faster_cohfos_',num2str(tr(1)),'_',num2str(tr(2)),'.xls'),'Sheet',1,'Range','A1:Z50')

%Singles
    TT=table;
%    TT.Variables=    [[{'Slower'};{'x'}] [{'Count'};{'Rate'}] num2cell([cohfos_count_g1;cohfos_rate_g1;])];
    TT.Variables=    [[{'Slower'};{'x'};{'Faster'};{'x'}] [{'Count'};{'Rate'};{'Count'};{'Rate'}] num2cell([singles_count_g1;singles_rate_g1;singles_count_g2;singles_rate_g2])];

    TT.Properties.VariableNames=['Events';'Metric';g];


writetable(TT,strcat('slower_faster_singles_',num2str(tr(1)),'_',num2str(tr(2)),'.xls'),'Sheet',1,'Range','A1:Z50')

%%

%     if size(label1,1)==3 %If Plusmaze
% %        xo
%         break;
%     end
%xo    
%end
xo