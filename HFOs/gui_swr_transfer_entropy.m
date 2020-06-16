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
fn=1000; %Sampling frequency after downsampling.
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

%%
f=waitbar(0,'Please wait...');
    for k=1:length(g)
        cd(g{k})
% Load signals
CORTEX=dir(strcat('*',xx{1},'*.mat'));
if isempty(CORTEX)
    g=g(~contains(g,g{k}));
    cd ..
    progress_bar(k,length(g),f)
    break
end

%PARIETAL
CORTEX=CORTEX.name;
CORTEX=load(CORTEX);
%CORTEX=CORTEX.CORTEX;
CORTEX=getfield(CORTEX,xx{1});
CORTEX=CORTEX.*(0.195);

%HPC
HPC=dir(strcat('*','HPC','*.mat'));
HPC=HPC.name;
HPC=load(HPC);
%HPC=HPC.HPC;
HPC=getfield(HPC,'HPC');
HPC=HPC.*(0.195);

%PFC
PFC=dir(strcat('*','PFC','*.mat'));
PFC=PFC.name;
PFC=load(PFC);
%PFC=PFC.PFC;
PFC=getfield(PFC,'PFC');
PFC=PFC.*(0.195);



A = dir('*states*.mat');
A={A.name};

if  ~isempty(A)
       cellfun(@load,A);
else
      error('No Scoring found')    
end
 xo
 ro=1200;
[ripple,RipFreq,rip_duration,Mx_cortex,timeasleep,sig_cortex,Ex_cortex,Sx_cortex,...
  p_cortex,q_cortex,cont_cortex,sig_pq_cortex ...
  ]=gui_findripples_spec(CORTEX,states,xx,tr,PFC,HPC,fn,ro);
%xo

si=sig_cortex(~cellfun('isempty',sig_cortex));
si=[si{:}];

si_pq=sig_pq_cortex(~cellfun('isempty',sig_pq_cortex));
si_pq=[si_pq{:}];

Q_cortex=q_cortex(~cellfun('isempty',q_cortex));
Q_cortex=[Q_cortex{:}];

[~,~,~,~,~,~,~,~,si_mixed,~]=hfo_specs(si,timeasleep,0,Rat,tr);

void_index=find(cellfun('isempty',Q_cortex));

%All par HFOS splitted in slow and fast.
Q_cortex_g1=Q_cortex(si_mixed.i1(~ismember(si_mixed.i1,void_index)));
Q_cortex_g2=Q_cortex(si_mixed.i2(~ismember(si_mixed.i2,void_index)));

%% HPC     

[ripple,RipFreq,rip_duration,Mx_hpc,timeasleep,sig_hpc,Ex_hpc,Sx_hpc,...
  p_hpc,q_hpc,cont_hpc ...
]=gui_findripples_spec(HPC,states,{'HPC'},tr,PFC,CORTEX,fn,ro);

si=sig_hpc(~cellfun('isempty',sig_hpc));
si=[si{:}];

%% Coocurent hfos
[cohfos1,cohfos2]=cellfun(@(equis1,equis2) co_hfo(equis1,equis2),Mx_hpc,Mx_cortex,'UniformOutput',false);
%cohfos1: HPC.
%cohfos2: Cortex.

%%

%HPC COHFOS
cohf_mx_hpc=Mx_hpc(~cellfun('isempty',cohfos1));%Peak values cells where HPC cohfos were found.
cohf_sx_hpc=Sx_hpc(~cellfun('isempty',cohfos1));%Start values cells where HPC cohfos were found.
cohf_ex_hpc=Ex_hpc(~cellfun('isempty',cohfos1));%End values cells where HPC cohfos were found.

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

%COHFOS windows
p_cohfos_hpc=p_hpc(~cellfun('isempty',cohfos1));
p_cohfos_hpc=cellfun(@(equis1,equis2) equis1(equis2),p_cohfos_hpc,coh_samp_hpc,'UniformOutput',false);
p_cohfos_hpc=[p_cohfos_hpc{:}];
q_cohfos_hpc=q_hpc(~cellfun('isempty',cohfos1));
q_cohfos_hpc=cellfun(@(equis1,equis2) equis1(equis2),q_cohfos_hpc,coh_samp_hpc,'UniformOutput',false);
q_cohfos_hpc=[q_cohfos_hpc{:}];
p_cohfos_hpc=p_cohfos_hpc(~cellfun('isempty',p_cohfos_hpc));
q_cohfos_hpc=q_cohfos_hpc(~cellfun('isempty',q_cohfos_hpc));



%Single HFOs HPC
%[v2]=single_hfo_get_sample(Mx_hpc{1},cohfos1{1});
v2=cellfun(@(equis1,equis2) single_hfo_get_sample(equis1,equis2),Mx_hpc,cohfos1,'UniformOutput',false);

Sig_hpc_single=cellfun(@(equis1,equis2) equis1(equis2),sig_hpc,v2,'UniformOutput',false);
Sig_hpc_single=[Sig_hpc_single{:}];

%single windows
p_single_hpc=cellfun(@(equis1,equis2) equis1(equis2),p_hpc,v2,'UniformOutput',false);
p_single_hpc=[p_single_hpc{:}];
q_single_hpc=cellfun(@(equis1,equis2) equis1(equis2),q_hpc,v2,'UniformOutput',false);
q_single_hpc=[q_single_hpc{:}];
p_single_hpc=p_single_hpc(~cellfun('isempty',p_single_hpc));
q_single_hpc=q_single_hpc(~cellfun('isempty',q_single_hpc));


[single_mx_hpc_val,single_sx_hpc_val]=cellfun(@(equis1,equis2,equis3) single_hfos_mx(equis1,equis2,equis3),cohfos1,Mx_hpc,Sx_hpc,'UniformOutput',false);
single_mx_hpc_val=[single_mx_hpc_val{:}];
single_sx_hpc_val=[single_sx_hpc_val{:}];
% xo


%%%%
%Cortical COHFOS
cohf_mx_cortex=Mx_cortex(~cellfun('isempty',cohfos2));%Peak values cells where cortex cohfos were found.
cohf_sx_cortex=Sx_cortex(~cellfun('isempty',cohfos2));%Start values cells where cortex cohfos were found.
cohf_ex_cortex=Ex_cortex(~cellfun('isempty',cohfos2));%End values cells where cortex cohfos were found.

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

%COHFOS windows
p_cohfos_cortex=p_cortex(~cellfun('isempty',cohfos2));
p_cohfos_cortex=cellfun(@(equis1,equis2) equis1(equis2),p_cohfos_cortex,coh_samp_cortex,'UniformOutput',false);
p_cohfos_cortex=[p_cohfos_cortex{:}];
q_cohfos_cortex=q_cortex(~cellfun('isempty',cohfos2));
q_cohfos_cortex=cellfun(@(equis1,equis2) equis1(equis2),q_cohfos_cortex,coh_samp_cortex,'UniformOutput',false);
q_cohfos_cortex=[q_cohfos_cortex{:}];
p_cohfos_cortex=p_cohfos_cortex(~cellfun('isempty',p_cohfos_cortex));
q_cohfos_cortex=q_cohfos_cortex(~cellfun('isempty',q_cohfos_cortex));

%Single HFOs Cortex
%[v2]=single_hfo_get_sample(Mx_hpc{1},cohfos1{1});
v2=cellfun(@(equis1,equis2) single_hfo_get_sample(equis1,equis2),Mx_cortex,cohfos2,'UniformOutput',false);

Sig_cortex_single=cellfun(@(equis1,equis2) equis1(equis2),sig_cortex,v2,'UniformOutput',false);
Sig_cortex_single=[Sig_cortex_single{:}];

%Single cortex windows
p_single_cortex=cellfun(@(equis1,equis2) equis1(equis2),p_cortex,v2,'UniformOutput',false);
p_single_cortex=[p_single_cortex{:}];
q_single_cortex=cellfun(@(equis1,equis2) equis1(equis2),q_cortex,v2,'UniformOutput',false);
q_single_cortex=[q_single_cortex{:}];
p_single_cortex=p_single_cortex(~cellfun('isempty',p_single_cortex));
q_single_cortex=q_single_cortex(~cellfun('isempty',q_single_cortex));


%xo
[single_mx_cortex_val,single_sx_cortex_val]=cellfun(@(equis1,equis2,equis3) single_hfos_mx(equis1,equis2,equis3),cohfos2,Mx_cortex,Sx_cortex,'UniformOutput',false);
single_mx_cortex_val=[single_mx_cortex_val{:}];
single_sx_cortex_val=[single_sx_cortex_val{:}];


 p_hpc=p_hpc(~cellfun('isempty',p_hpc));
 p_hpc=[p_hpc{:}];
 q_hpc=q_hpc(~cellfun('isempty',q_hpc));
 q_hpc=[q_hpc{:}];
 p_hpc=p_hpc(~cellfun('isempty',p_hpc));
 q_hpc=q_hpc(~cellfun('isempty',q_hpc));
 

% xo
%% Mixed distribution (Average freq) coHFOs
Mx_cortex_g1=Mx_cortex;
Mx_cortex_g2=Mx_cortex;
Ex_cortex_g1=Ex_cortex;
Ex_cortex_g2=Ex_cortex;
Sx_cortex_g1=Sx_cortex;
Sx_cortex_g2=Sx_cortex;

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
                Ex_cortex_g1{ll}(lll)=NaN;
                Sx_cortex_g1{ll}(lll)=NaN;
                
            else
                Mx_cortex_g2{ll}(lll)=NaN;
                Ex_cortex_g2{ll}(lll)=NaN;
                Sx_cortex_g2{ll}(lll)=NaN;

            end

        end
         Mx_cortex_g1{ll}=Mx_cortex_g1{ll}(~isnan(Mx_cortex_g1{ll}));
         Mx_cortex_g2{ll}=Mx_cortex_g2{ll}(~isnan(Mx_cortex_g2{ll}));

         Ex_cortex_g1{ll}=Ex_cortex_g1{ll}(~isnan(Ex_cortex_g1{ll}));
         Ex_cortex_g2{ll}=Ex_cortex_g2{ll}(~isnan(Ex_cortex_g2{ll}));
         Sx_cortex_g1{ll}=Sx_cortex_g1{ll}(~isnan(Sx_cortex_g1{ll}));
         Sx_cortex_g2{ll}=Sx_cortex_g2{ll}(~isnan(Sx_cortex_g2{ll}));
         
         
    end

end

[~,cohfos2_g1]=cellfun(@(equis1,equis2) co_hfo(equis1,equis2),Mx_hpc,Mx_cortex_g1,'UniformOutput',false);
[~,cohfos2_g2]=cellfun(@(equis1,equis2) co_hfo(equis1,equis2),Mx_hpc,Mx_cortex_g2,'UniformOutput',false);

%Single HFOs Cortex
v2_g1=cellfun(@(equis1,equis2) single_hfo_get_sample(equis1,equis2),Mx_cortex_g1,cohfos2_g1,'UniformOutput',false);
%Single HFOs Cortex
v2_g2=cellfun(@(equis1,equis2) single_hfo_get_sample(equis1,equis2),Mx_cortex_g2,cohfos2_g2,'UniformOutput',false);


[p_cohfos_cortex_g1,q_cohfos_cortex_g1,p_single_cortex_g1,q_single_cortex_g1]=get_window_slowfast(Mx_cortex,Sx_cortex,Ex_cortex, cohfos2_g1,p_cortex,q_cortex,v2_g1);
[p_cohfos_cortex_g2,q_cohfos_cortex_g2,p_single_cortex_g2,q_single_cortex_g2]=get_window_slowfast(Mx_cortex,Sx_cortex,Ex_cortex, cohfos2_g2,p_cortex,q_cortex,v2_g2);

%%
  p_cortex=p_cortex(~cellfun('isempty',p_cortex));
 p_cortex=[p_cortex{:}];
 q_cortex=q_cortex(~cellfun('isempty',q_cortex));
 q_cortex=[q_cortex{:}];
 p_cortex=p_cortex(~cellfun('isempty',p_cortex));
 q_cortex=q_cortex(~cellfun('isempty',q_cortex));

%%
%  if k==1 %No Learning
%      P.nl.('hpc')={p_hpc;p_cohfos_hpc;p_single_hpc};
%      P.nl.('pfc')={p_cortex;p_cohfos_cortex;p_single_cortex};
%     
%      Q.nl.('hpc')={q_hpc;q_cohfos_hpc;q_single_hpc};
%      Q.nl.('pfc')={q_cortex;q_cohfos_cortex;q_single_cortex};
%      
%  else
%      P.plusmaze.('hpc')={p_hpc;p_cohfos_hpc;p_single_hpc};
%      P.plusmaze.('pfc')={p_cortex;p_cohfos_cortex;p_single_cortex};
%     
%      Q.plusmaze.('hpc')={q_hpc;q_cohfos_hpc;q_single_hpc};
%      Q.plusmaze.('pfc')={q_cortex;q_cohfos_cortex;q_single_cortex};
%  end
%      P.(strrep(labelconditions2{k},'-','_')).(label1{1})={p_hpc;p_cohfos_hpc;p_single_hpc};
%      P.(strrep(labelconditions2{k},'-','_')).(label1{3})={p_cortex;p_cohfos_cortex;p_single_cortex};
%     
%      Q.(strrep(labelconditions2{k},'-','_')).(label1{1})={q_hpc;q_cohfos_hpc;q_single_hpc};
%      Q.(strrep(labelconditions2{k},'-','_')).(label1{3})={q_cortex;q_cohfos_cortex;q_single_cortex};
     P.(strrep(labelconditions2{k},'-','_')).(label1{1})={p_cohfos_hpc;p_single_hpc;p_hpc};
     P.(strrep(labelconditions2{k},'-','_')).(label1{3})={p_cohfos_cortex;p_single_cortex;p_cortex};
    
     Q.(strrep(labelconditions2{k},'-','_')).(label1{1})={q_cohfos_hpc;q_single_hpc;q_hpc};
     Q.(strrep(labelconditions2{k},'-','_')).(label1{3})={q_cohfos_cortex;q_single_cortex;q_cortex};
     
     
     %Slow/Fast
     
     SP.(strrep(labelconditions2{k},'-','_')).(label1{3})={p_cohfos_cortex_g1;p_single_cortex_g1};
     SQ.(strrep(labelconditions2{k},'-','_')).(label1{3})={q_cohfos_cortex_g1;q_single_cortex_g1};
     
     FP.(strrep(labelconditions2{k},'-','_')).(label1{3})={p_cohfos_cortex_g2;p_single_cortex_g2};
     FQ.(strrep(labelconditions2{k},'-','_')).(label1{3})={q_cohfos_cortex_g2;q_single_cortex_g2};
% p_cohfos_cortex_g1,q_cohfos_cortex_g1,p_single_cortex_g1,q_single_cortex_g1

 %xo
progress_bar(k,length(g),f)
    cd ..    
    end
 xo
%% Transfer entropy analysis.


    labelconditions3{1}='nl';
    labelconditions3{2}='plusmaze';
    labelconditions3{3}='novelty';
    labelconditions3{4}='for';
    labelconditions3=labelconditions3.';

  
%-------------
s=1; %Slow Cohfos
w=3;

[n1]=getval_n(SP,SQ,labelconditions3,label1,s,w,fn);


s=2; %Slow Single
w=3;

[n2]=getval_n(SP,SQ,labelconditions3,label1,s,w,fn);


s=1; %Fast Cohfos
w=3;

[n3]=getval_n(FP,FQ,labelconditions3,label1,s,w,fn);

s=2; %FAST Single
w=3;

[n4]=getval_n(FP,FQ,labelconditions3,label1,s,w,fn);


s=2; % singles
w=1;%HPC
[n5]=getval_n(P,Q,labelconditions3,label1,s,w,fn);

min_amount_trials=min([n1 n2 n3 n4 n5]);

%%
s=1; %Slow Cohfos
w=3;

[TGA1]=getval_transfer_entropy(SP,SQ,labelconditions3,label1,s,w,fn,min_amount_trials);


s=2; %Slow Single
w=3;
[TGA2]=getval_transfer_entropy(SP,SQ,labelconditions3,label1,s,w,fn,min_amount_trials);


s=1; %Fast Cohfos
w=3;
[TGA3]=getval_transfer_entropy(FP,FQ,labelconditions3,label1,s,w,fn,min_amount_trials);



s=2; %FAST Single
w=3;
[TGA4]=getval_transfer_entropy(FP,FQ,labelconditions3,label1,s,w,fn,min_amount_trials);



s=2; % singles
w=1;%HPC

[TGA5]=getval_transfer_entropy(P,Q,labelconditions3,label1,s,w,fn,min_amount_trials);

% TGA_results.TEpermvalues(:,4);
% TGA_results.TEbyU

%     {'PAR'}    {'PFC'}
%     {'PAR'}    {'HPC'}
%     {'PFC'}    {'PAR'}
%     {'PFC'}    {'HPC'}
%     {'HPC'}    {'PAR'}
%     {'HPC'}    {'PFC'}
%%
TT1=table;
TT1.Variables=    [[{'PAR->PFC'};{'PFC->PAR'};{'PAR->HPC'};{'HPC->PAR'};{'PFC->HPC'};{'HPC->PFC'}] num2cell([TGA1.nl.TEpermvalues(:,4) TGA1.plusmaze.TEpermvalues(:,4) TGA1.novelty.TEpermvalues(:,4) TGA1.for.TEpermvalues(:,4)])];
TT1.Properties.VariableNames=[{'Direction'};{'baseline'};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    

TT2=table;
TT2.Variables=    [[{'PAR->PFC'};{'PFC->PAR'};{'PAR->HPC'};{'HPC->PAR'};{'PFC->HPC'};{'HPC->PFC'}] num2cell([TGA2.nl.TEpermvalues(:,4) TGA2.plusmaze.TEpermvalues(:,4) TGA2.novelty.TEpermvalues(:,4) TGA2.for.TEpermvalues(:,4)])];
TT2.Properties.VariableNames=[{'Direction'};{'baseline'};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    

TT3=table;
TT3.Variables=    [[{'PAR->PFC'};{'PFC->PAR'};{'PAR->HPC'};{'HPC->PAR'};{'PFC->HPC'};{'HPC->PFC'}] num2cell([TGA3.nl.TEpermvalues(:,4) TGA3.plusmaze.TEpermvalues(:,4) TGA3.novelty.TEpermvalues(:,4) TGA3.for.TEpermvalues(:,4)])];
TT3.Properties.VariableNames=[{'Direction'};{'baseline'};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    

TT4=table;
TT4.Variables=    [[{'PAR->PFC'};{'PFC->PAR'};{'PAR->HPC'};{'HPC->PAR'};{'PFC->HPC'};{'HPC->PFC'}] num2cell([TGA4.nl.TEpermvalues(:,4) TGA4.plusmaze.TEpermvalues(:,4) TGA4.novelty.TEpermvalues(:,4) TGA4.for.TEpermvalues(:,4)])];
TT4.Properties.VariableNames=[{'Direction'};{'baseline'};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    

TT5=table;
TT5.Variables=    [[{'PAR->PFC'};{'PFC->PAR'};{'PAR->HPC'};{'HPC->PAR'};{'PFC->HPC'};{'HPC->PFC'}] num2cell([TGA5.nl.TEpermvalues(:,4) TGA5.plusmaze.TEpermvalues(:,4) TGA5.novelty.TEpermvalues(:,4) TGA5.for.TEpermvalues(:,4)])];
TT5.Properties.VariableNames=[{'Direction'};{'baseline'};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    


t1=repmat({'x'},[1 5]);

tab=[TT1;t1;TT2;t1;TT3;t1;TT4;t1;TT5];
writetable(tab,strcat('TransferEntropy_300_rat_', num2str(Rat),'_' ,num2str(tr(2)),'.xls'),'Sheet',1,'Range','A2:Z50')  
%%

TT1=table;
TT1.Variables=    [[{'Prediction Time'};{'Tau'};{'Dim'};{'Max ACT'};{'repPred'}] num2cell([ TGA1.nl.TEprepare.u_in_ms(1);  TGA1.nl.TEprepare.opttau; TGA1.nl.TEprepare.optdim; TGA1.nl.TEprepare.maxact; TGA1.nl.cfg.repPred]) num2cell([ TGA1.plusmaze.TEprepare.u_in_ms(1); TGA1.plusmaze.TEprepare.opttau; TGA1.plusmaze.TEprepare.optdim; TGA1.plusmaze.TEprepare.maxact; TGA1.plusmaze.cfg.repPred]) num2cell([ TGA1.novelty.TEprepare.u_in_ms(1);  TGA1.novelty.TEprepare.opttau; TGA1.novelty.TEprepare.optdim; TGA1.novelty.TEprepare.maxact; TGA1.novelty.cfg.repPred]) num2cell([ TGA1.for.TEprepare.u_in_ms(1);  TGA1.for.TEprepare.opttau; TGA1.for.TEprepare.optdim; TGA1.for.TEprepare.maxact; TGA1.for.cfg.repPred])];
TT1.Properties.VariableNames=[{'Parameter'};{'baseline'};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    

TT2=table;
TT2.Variables=    [[{'Prediction Time'};{'Tau'};{'Dim'};{'Max ACT'};{'repPred'}] num2cell([ TGA2.nl.TEprepare.u_in_ms(1); TGA2.nl.TEprepare.opttau; TGA2.nl.TEprepare.optdim; TGA2.nl.TEprepare.maxact; TGA2.nl.cfg.repPred]) num2cell([ TGA2.plusmaze.TEprepare.u_in_ms(1); TGA2.plusmaze.TEprepare.opttau; TGA2.plusmaze.TEprepare.optdim; TGA2.plusmaze.TEprepare.maxact; TGA2.plusmaze.cfg.repPred]) num2cell([ TGA2.novelty.TEprepare.u_in_ms(1);  TGA2.novelty.TEprepare.opttau; TGA2.novelty.TEprepare.optdim; TGA2.novelty.TEprepare.maxact; TGA2.novelty.cfg.repPred]) num2cell([ TGA2.for.TEprepare.u_in_ms(1);  TGA2.for.TEprepare.opttau; TGA2.for.TEprepare.optdim; TGA2.for.TEprepare.maxact; TGA2.for.cfg.repPred])];
TT2.Properties.VariableNames=[{'Parameter'};{'baseline'};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    

TT3=table;
TT3.Variables=    [[{'Prediction Time'};{'Tau'};{'Dim'};{'Max ACT'};{'repPred'}] num2cell([ TGA3.nl.TEprepare.u_in_ms(1);  TGA3.nl.TEprepare.opttau; TGA3.nl.TEprepare.optdim; TGA3.nl.TEprepare.maxact; TGA3.nl.cfg.repPred]) num2cell([ TGA3.plusmaze.TEprepare.u_in_ms(1); TGA3.plusmaze.TEprepare.opttau; TGA3.plusmaze.TEprepare.optdim; TGA3.plusmaze.TEprepare.maxact; TGA3.plusmaze.cfg.repPred]) num2cell([ TGA3.novelty.TEprepare.u_in_ms(1);  TGA3.novelty.TEprepare.opttau; TGA3.novelty.TEprepare.optdim; TGA3.novelty.TEprepare.maxact; TGA3.novelty.cfg.repPred]) num2cell([ TGA3.for.TEprepare.u_in_ms(1);  TGA3.for.TEprepare.opttau; TGA3.for.TEprepare.optdim; TGA3.for.TEprepare.maxact; TGA3.for.cfg.repPred])];
TT3.Properties.VariableNames=[{'Parameter'};{'baseline'};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    

TT4=table;
TT4.Variables=    [[{'Prediction Time'};{'Tau'};{'Dim'};{'Max ACT'};{'repPred'}] num2cell([ TGA4.nl.TEprepare.u_in_ms(1); TGA4.nl.TEprepare.opttau; TGA4.nl.TEprepare.optdim; TGA4.nl.TEprepare.maxact; TGA4.nl.cfg.repPred]) num2cell([ TGA4.plusmaze.TEprepare.u_in_ms(1);  TGA4.plusmaze.TEprepare.opttau; TGA4.plusmaze.TEprepare.optdim; TGA4.plusmaze.TEprepare.maxact; TGA4.plusmaze.cfg.repPred]) num2cell([ TGA4.novelty.TEprepare.u_in_ms(1); TGA4.novelty.TEprepare.opttau; TGA4.novelty.TEprepare.optdim; TGA4.novelty.TEprepare.maxact; TGA4.novelty.cfg.repPred]) num2cell([ TGA4.for.TEprepare.u_in_ms(1);  TGA4.for.TEprepare.opttau; TGA4.for.TEprepare.optdim; TGA4.for.TEprepare.maxact; TGA4.for.cfg.repPred])];
TT4.Properties.VariableNames=[{'Parameter'};{'baseline'};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    

TT5=table;
TT5.Variables=    [[{'Prediction Time'};{'Tau'};{'Dim'};{'Max ACT'};{'repPred'}] num2cell([ TGA5.nl.TEprepare.u_in_ms(1);  TGA5.nl.TEprepare.opttau; TGA5.nl.TEprepare.optdim; TGA5.nl.TEprepare.maxact; TGA5.nl.cfg.repPred]) num2cell([ TGA5.plusmaze.TEprepare.u_in_ms(1);  TGA5.plusmaze.TEprepare.opttau; TGA5.plusmaze.TEprepare.optdim; TGA5.plusmaze.TEprepare.maxact; TGA5.plusmaze.cfg.repPred]) num2cell([ TGA5.novelty.TEprepare.u_in_ms(1);  TGA5.novelty.TEprepare.opttau; TGA5.novelty.TEprepare.optdim; TGA5.novelty.TEprepare.maxact; TGA5.novelty.cfg.repPred]) num2cell([ TGA5.for.TEprepare.u_in_ms(1);  TGA5.for.TEprepare.opttau; TGA5.for.TEprepare.optdim; TGA5.for.TEprepare.maxact; TGA5.for.cfg.repPred])];
TT5.Properties.VariableNames=[{'Parameter'};{'baseline'};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    

t1=repmat({'x'},[1 5]);

tab=[TT1;t1;TT2;t1;TT3;t1;TT4;t1;TT5];
writetable(tab,strcat('TransferEntropyParameters_300_rat_', num2str(Rat),'_' ,num2str(tr(2)),'.xls'),'Sheet',1,'Range','A2:Z50')  
xo
%% prepare configuration structure for TEprepare.m

cfgTEP = [];

% data
cfgTEP.toi     = [data.time{1}(1) data.time{1}(end)]; % time of interest
cfgTEP.channel = data.label;                          % channels to be analyzed

% ensemble methode
cfgTEP.ensemblemethod = 'no';

% scanning of interaction delays u
cfgTEP.predicttimemin_u    = 10;      % minimum u to be scanned
cfgTEP.predicttimemax_u    = 300;	  % maximum u to be scanned
cfgTEP.predicttimestepsize = 10; 	  % time steps between u's to be scanned

% estimator
cfgTEP.TEcalctype  = 'VW_ds';         % use the new TE estimator (Wibral, 2013)

% ACT estimation and constraints on allowed ACT(autocorelation time)
cfgTEP.maxlag      = 1000;  % max. lag for the calculation of the ACT
cfgTEP.actthrvalue = 100;   % threshold for ACT
cfgTEP.minnrtrials = 15;    % minimum acceptable number of trials

% optimizing embedding
cfgTEP.optimizemethod ='ragwitz';  % criterion used
cfgTEP.ragdim         = 2:9;       % dimensions d to be used
cfgTEP.ragtaurange    = [0.2 0.4]; % tau range to be used
cfgTEP.ragtausteps    = 3;         % steps for ragwitz tau
cfgTEP.repPred        = 100;       % no. local prediction/points used for the Ragwitz criterion

% kernel-based TE estimation
cfgTEP.flagNei = 'Mass' ;           % type of neigbour search (knn)
cfgTEP.sizeNei = 4;                 % number of neighbours in the mass/knn search

% set the level of verbosity of console outputs
cfgTEP.verbosity = 'info_minor';
%% define cfg for TEsurrogatestats.m

cfgTESS = [];

% use individual dimensions for embedding
cfgTESS.optdimusage = 'indivdim';
cfgTESS.embedsource = 'no';

% statistical testing
cfgTESS.tail           = 1;
%cfgTESS.numpermutation = 5e4;
cfgTESS.numpermutation = 1000;

cfgTESS.surrogatetype  = 'trialshuffling';

% shift test
cfgTESS.shifttest      = 'no';      % don't test for volume conduction

% prefix for output data
cfgTESS.fileidout  = fullfile(outputpath, 'plusmaze_bandpassed');

%% TE analysis 

TGA_results = InteractionDelayReconstruction_calculate(cfgTEP,cfgTESS,data);
%%

cfgGA = [];

cfgGA.threshold = 4;    % use a threshold/error tolerance of 4 ms
cfgGA.cmc       = 1;    % use links after correction for multiple comparison

TGA_results_GA = TEgraphanalysis(cfgGA,TGA_results);

save([cfgTESS.fileidout '_CPU_TGA_results_GA.mat'],'TGA_results','TGA_results_GA');
%%
%% get data and results
load('lorenz_3_layout.mat');  % load layout file

lay_Lorenz.label=flip(label1);

cd(outputpath)
files = dir(fullfile(outputpath, 'plusmaze_bandpassed*TGA_results_GA.mat'));
load(fullfile(outputpath, files(1).name));

%% cfg structure for plotting

cfgPLOT = [];

cfgPLOT.layout        = lay_Lorenz;   	% layout structure, see fieldtrip's ft_prepare_layout.m

cfgPLOT.statstype     = 1;              % 1: corrected; 2:uncorrected; 3: 1-pval; 4:rawdistance; 5:graph analysis
cfgPLOT.alpha         = 0.05;
cfgPLOT.arrowpos      = 2;              % plot arrowheads in the middle
cfgPLOT.arrowcolorpos = [0 0.5 0.8];    % arrow color

cfgPLOT.electrodes    = 'on';           % plot markers for nodes
cfgPLOT.hlmarker      = 'o';            % maker type
cfgPLOT.hlcolor       = [0 0 0];        % marker color
cfgPLOT.hlmarkersize  = 4;              % maerker size

cfgPLOT.showlabels    = 'yes';          % node labels
cfgPLOT.efontsize     = 20;             % text size for node labels

cfgPLOT.plothead      = 0;

% plot TE results

figure;
TEplot2D(cfgPLOT,TGA_results);

%% plot TE results after correction for multivariate effects

cfgPLOT.arrowcolor   = [0 0.5 0.8];
cfgPLOT.plottype     = 'graphanalysis';
cfgPLOT.statstype    = 'corrected';
cfgPLOT.linktype     = 'graphres';
cfgPLOT.head         = 'off';
cfgPLOT.electrodes   = 'labels';

figure;
TEplot2D_beta(cfgPLOT,TGA_results_GA);

%%
[g1,g1_f,G,g_f,FB,FB1,n2]=getval_granger(SP,SQ,labelconditions3,label1,s,w,fn);

labelconditions3{1}='baseline';
granger_paper4(g1,g1_f,labelconditions3,[0 300]) %All
printing(['Parametric_Slow_Cohfos' '_' num2str(tr(2))])
close all

granger_paper4(G,g_f,labelconditions3,[0 300]) %All
printing(['Non_parametric_Slow_Cohfos' '_' num2str(tr(2))])
close all


TT1_20_np=table;
TT1_20_np.Variables=    [[{'PAR->PFC'};{'PFC->PAR'};{'PAR->HPC'};{'HPC->PAR'};{'PFC->HPC'};{'HPC->PFC'}] num2cell([FB{1}(:,12) FB{2}(:,12) FB{3}(:,12) FB{4}(:,12)])];
% TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    
TT1_20_np.Properties.VariableNames=[{'Direction'};{labelconditions3{1}};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    
   
TT1_20_p=table;
TT1_20_p.Variables=    [[{'PAR->PFC'};{'PFC->PAR'};{'PAR->HPC'};{'HPC->PAR'};{'PFC->HPC'};{'HPC->PFC'}] num2cell([FB1{1}(:,12) FB1{2}(:,12) FB1{3}(:,12) FB1{4}(:,12)])];
% TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    
TT1_20_p.Properties.VariableNames=[{'Direction'};{labelconditions3{1}};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    


TT1_300_np=table;
TT1_300_np.Variables=    [[{'PAR->PFC'};{'PFC->PAR'};{'PAR->HPC'};{'HPC->PAR'};{'PFC->HPC'};{'HPC->PFC'}] num2cell([FB{1}(:,13) FB{2}(:,13) FB{3}(:,13) FB{4}(:,13)])];
% TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    
TT1_300_np.Properties.VariableNames=[{'Direction'};{labelconditions3{1}};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    
   
TT1_300_p=table;
TT1_300_p.Variables=    [[{'PAR->PFC'};{'PFC->PAR'};{'PAR->HPC'};{'HPC->PAR'};{'PFC->HPC'};{'HPC->PFC'}] num2cell([FB1{1}(:,13) FB1{2}(:,13) FB1{3}(:,13) FB1{4}(:,13)])];
% TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    
TT1_300_p.Properties.VariableNames=[{'Direction'};{labelconditions3{1}};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    



%-------------
labelconditions3{1}='nl';
s=2; %Slow singles
w=3;
[g1,g1_f,G,g_f,FB,FB1,n2]=getval_granger(SP,SQ,labelconditions3,label1,s,w,fn);

labelconditions3{1}='baseline';
granger_paper4(g1,g1_f,labelconditions3,[0 300]) %All
printing(['Parametric_Slow_Singles' '_' num2str(tr(2))])
close all

granger_paper4(G,g_f,labelconditions3,[0 300]) %All
printing(['Non_parametric_Slow_Singles' '_' num2str(tr(2))])
close all    

TT2_20_np=table;
TT2_20_np.Variables=    [[{'PAR->PFC'};{'PFC->PAR'};{'PAR->HPC'};{'HPC->PAR'};{'PFC->HPC'};{'HPC->PFC'}] num2cell([FB{1}(:,12) FB{2}(:,12) FB{3}(:,12) FB{4}(:,12)])];
% TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    
TT2_20_np.Properties.VariableNames=[{'Direction'};{labelconditions3{1}};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    
   
TT2_20_p=table;
TT2_20_p.Variables=    [[{'PAR->PFC'};{'PFC->PAR'};{'PAR->HPC'};{'HPC->PAR'};{'PFC->HPC'};{'HPC->PFC'}] num2cell([FB1{1}(:,12) FB1{2}(:,12) FB1{3}(:,12) FB1{4}(:,12)])];
% TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    
TT2_20_p.Properties.VariableNames=[{'Direction'};{labelconditions3{1}};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    


TT2_300_np=table;
TT2_300_np.Variables=    [[{'PAR->PFC'};{'PFC->PAR'};{'PAR->HPC'};{'HPC->PAR'};{'PFC->HPC'};{'HPC->PFC'}] num2cell([FB{1}(:,13) FB{2}(:,13) FB{3}(:,13) FB{4}(:,13)])];
% TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    
TT2_300_np.Properties.VariableNames=[{'Direction'};{labelconditions3{1}};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    
   
TT2_300_p=table;
TT2_300_p.Variables=    [[{'PAR->PFC'};{'PFC->PAR'};{'PAR->HPC'};{'HPC->PAR'};{'PFC->HPC'};{'HPC->PFC'}] num2cell([FB1{1}(:,13) FB1{2}(:,13) FB1{3}(:,13) FB1{4}(:,13)])];
% TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    
TT2_300_p.Properties.VariableNames=[{'Direction'};{labelconditions3{1}};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    




%-------------    
labelconditions3{1}='nl';
s=1; %Fast Cohfos
w=3;
[g1,g1_f,G,g_f,FB,FB1,n2]=getval_granger(FP,FQ,labelconditions3,label1,s,w,fn);

labelconditions3{1}='baseline';
granger_paper4(g1,g1_f,labelconditions3,[0 300]) %All
printing(['Parametric_Fast_Cohfos' '_' num2str(tr(2))])
close all

granger_paper4(G,g_f,labelconditions3,[0 300]) %All
printing(['Non_parametric_Fast_Cohfos' '_' num2str(tr(2))])
close all

TT3_20_np=table;
TT3_20_np.Variables=    [[{'PAR->PFC'};{'PFC->PAR'};{'PAR->HPC'};{'HPC->PAR'};{'PFC->HPC'};{'HPC->PFC'}] num2cell([FB{1}(:,12) FB{2}(:,12) FB{3}(:,12) FB{4}(:,12)])];
% TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    
TT3_20_np.Properties.VariableNames=[{'Direction'};{labelconditions3{1}};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    
   
TT3_20_p=table;
TT3_20_p.Variables=    [[{'PAR->PFC'};{'PFC->PAR'};{'PAR->HPC'};{'HPC->PAR'};{'PFC->HPC'};{'HPC->PFC'}] num2cell([FB1{1}(:,12) FB1{2}(:,12) FB1{3}(:,12) FB1{4}(:,12)])];
% TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    
TT3_20_p.Properties.VariableNames=[{'Direction'};{labelconditions3{1}};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    


TT3_300_np=table;
TT3_300_np.Variables=    [[{'PAR->PFC'};{'PFC->PAR'};{'PAR->HPC'};{'HPC->PAR'};{'PFC->HPC'};{'HPC->PFC'}] num2cell([FB{1}(:,13) FB{2}(:,13) FB{3}(:,13) FB{4}(:,13)])];
% TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    
TT3_300_np.Properties.VariableNames=[{'Direction'};{labelconditions3{1}};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    
   
TT3_300_p=table;
TT3_300_p.Variables=    [[{'PAR->PFC'};{'PFC->PAR'};{'PAR->HPC'};{'HPC->PAR'};{'PFC->HPC'};{'HPC->PFC'}] num2cell([FB1{1}(:,13) FB1{2}(:,13) FB1{3}(:,13) FB1{4}(:,13)])];
% TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    
TT3_300_p.Properties.VariableNames=[{'Direction'};{labelconditions3{1}};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    

    
%-------------    


labelconditions3{1}='nl';    
s=2; %Fast Singles
w=3;
[g1,g1_f,G,g_f,FB,FB1,n1]=getval_granger(FP,FQ,labelconditions3,label1,s,w,fn);
labelconditions3{1}='baseline';

granger_paper4(g1,g1_f,labelconditions3,[0 300]) %All
printing(['Parametric_Fast_Singles' '_' num2str(tr(2))])
close all

granger_paper4(G,g_f,labelconditions3,[0 300]) %All
printing(['Non_parametric_Fast_Singles' '_' num2str(tr(2))])
close all

TT4_20_np=table;
TT4_20_np.Variables=    [[{'PAR->PFC'};{'PFC->PAR'};{'PAR->HPC'};{'HPC->PAR'};{'PFC->HPC'};{'HPC->PFC'}] num2cell([FB{1}(:,12) FB{2}(:,12) FB{3}(:,12) FB{4}(:,12)])];
% TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    
TT4_20_np.Properties.VariableNames=[{'Direction'};{labelconditions3{1}};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    
   
TT4_20_p=table;
TT4_20_p.Variables=    [[{'PAR->PFC'};{'PFC->PAR'};{'PAR->HPC'};{'HPC->PAR'};{'PFC->HPC'};{'HPC->PFC'}] num2cell([FB1{1}(:,12) FB1{2}(:,12) FB1{3}(:,12) FB1{4}(:,12)])];
% TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    
TT4_20_p.Properties.VariableNames=[{'Direction'};{labelconditions3{1}};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    


TT4_300_np=table;
TT4_300_np.Variables=    [[{'PAR->PFC'};{'PFC->PAR'};{'PAR->HPC'};{'HPC->PAR'};{'PFC->HPC'};{'HPC->PFC'}] num2cell([FB{1}(:,13) FB{2}(:,13) FB{3}(:,13) FB{4}(:,13)])];
% TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    
TT4_300_np.Properties.VariableNames=[{'Direction'};{labelconditions3{1}};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    
   
TT4_300_p=table;
TT4_300_p.Variables=    [[{'PAR->PFC'};{'PFC->PAR'};{'PAR->HPC'};{'HPC->PAR'};{'PFC->HPC'};{'HPC->PFC'}] num2cell([FB1{1}(:,13) FB1{2}(:,13) FB1{3}(:,13) FB1{4}(:,13)])];
% TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    
TT4_300_p.Properties.VariableNames=[{'Direction'};{labelconditions3{1}};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    

%-------------    


%hpc singles

labelconditions3{1}='nl';
s=2; %Slow singles
w=1;%HPC
[g1,g1_f,G,g_f,FB,FB1,n2]=getval_granger(P,Q,labelconditions3,label1,s,w,fn);

labelconditions3{1}='baseline';
granger_paper4(g1,g1_f,labelconditions3,[0 300]) %All
printing(['Parametric_HPC_Singles' '_' num2str(tr(2))])
close all

granger_paper4(G,g_f,labelconditions3,[0 300]) %All
printing(['Non_parametric_HPC_Singles' '_' num2str(tr(2))])
close all

TT5_20_np=table;
TT5_20_np.Variables=    [[{'PAR->PFC'};{'PFC->PAR'};{'PAR->HPC'};{'HPC->PAR'};{'PFC->HPC'};{'HPC->PFC'}] num2cell([FB{1}(:,12) FB{2}(:,12) FB{3}(:,12) FB{4}(:,12)])];
% TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    
TT5_20_np.Properties.VariableNames=[{'Direction'};{labelconditions3{1}};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    
   
TT5_20_p=table;
TT5_20_p.Variables=    [[{'PAR->PFC'};{'PFC->PAR'};{'PAR->HPC'};{'HPC->PAR'};{'PFC->HPC'};{'HPC->PFC'}] num2cell([FB1{1}(:,12) FB1{2}(:,12) FB1{3}(:,12) FB1{4}(:,12)])];
% TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    
TT5_20_p.Properties.VariableNames=[{'Direction'};{labelconditions3{1}};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    


TT5_300_np=table;
TT5_300_np.Variables=    [[{'PAR->PFC'};{'PFC->PAR'};{'PAR->HPC'};{'HPC->PAR'};{'PFC->HPC'};{'HPC->PFC'}] num2cell([FB{1}(:,13) FB{2}(:,13) FB{3}(:,13) FB{4}(:,13)])];
% TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    
TT5_300_np.Properties.VariableNames=[{'Direction'};{labelconditions3{1}};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    
   
TT5_300_p=table;
TT5_300_p.Variables=    [[{'PAR->PFC'};{'PFC->PAR'};{'PAR->HPC'};{'HPC->PAR'};{'PFC->HPC'};{'HPC->PFC'}] num2cell([FB1{1}(:,13) FB1{2}(:,13) FB1{3}(:,13) FB1{4}(:,13)])];
% TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    
TT5_300_p.Properties.VariableNames=[{'Direction'};{labelconditions3{1}};{labelconditions3{2}};{labelconditions3{3}};{labelconditions3{4}}];    
%%

t1=repmat({'x'},[1 5]);

tab=[TT1_20_p;t1;TT2_20_p;t1;TT3_20_p;t1;TT4_20_p;t1;TT5_20_p];
writetable(tab,strcat('Granger_20_Parametric_rat_', num2str(Rat),'_' ,num2str(tr(2)),'.xls'),'Sheet',1,'Range','A2:Z50')  

tab2=[TT1_20_np;t1;TT2_20_np;t1;TT3_20_np;t1;TT4_20_np;t1;TT5_20_np];
writetable(tab2,strcat('Granger_20_NonParametric_rat_', num2str(Rat),'_' ,num2str(tr(2)),'.xls'),'Sheet',1,'Range','A2:Z50')  

tab3=[TT1_300_np;t1;TT2_300_np;t1;TT3_300_np;t1;TT4_300_np;t1;TT5_300_np];
writetable(tab3,strcat('Granger_300_NonParametric_rat_', num2str(Rat),'_' ,num2str(tr(2)),'.xls'),'Sheet',1,'Range','A2:Z50')  

tab4=[TT1_300_p;t1;TT2_300_p;t1;TT3_300_p;t1;TT4_300_p;t1;TT5_300_p];
writetable(tab4,strcat('Granger_300_Parametric_rat_', num2str(Rat),'_' ,num2str(tr(2)),'.xls'),'Sheet',1,'Range','A2:Z50')  



%%
[FB{iii}]=gc_freqbands(gran,0);

[FB1{iii}]=gc_freqbands(gran1,0);
% [FB2{iii}]=gc_freqbands(grangercon,1);

%%

    ro=1200;

    labelconditions3{1}='Baseline';
    labelconditions3{2}='Plusmaze';
    labelconditions3{3}='Novelty';
    labelconditions3{4}='Foraging';
    labelconditions3=labelconditions3.';
    
% FP 
    %Singles
    
    p=FP.nl.PAR{2};
    [gran,gran1,grangercon]=gc_paper(p,create_timecell(ro,length(p)),'Wideband',ro,10,[0:1:300],fn);
    
    G{1}=gran.grangerspctrm;%Non-parametric (Pairwise)
    g1{1}=gran1.grangerspctrm;%Parametric
    g2{1}=grangercon.grangerspctrm;%Non-parametric (Conditional)

    
    
    p=FP.plusmaze.PAR{2};
    [gran,gran1,grangercon,grangercon_multi]=gc_paper(p,create_timecell(ro,length(p)),'Wideband',ro,10,[0:1:300],fn);
        
    G{2}=gran.grangerspctrm;%Non-parametric (Pairwise)
    g1{2}=gran1.grangerspctrm;%Parametric
    g2{2}=grangercon.grangerspctrm;%Non-parametric (Conditional)

    p=FP.novelty.PAR{2};
    [gran,gran1,grangercon]=gc_paper(p,create_timecell(ro,length(p)),'Wideband',ro,10,[0:1:300],fn);
    
    G{3}=gran.grangerspctrm;%Non-parametric (Pairwise)
    g1{3}=gran1.grangerspctrm;%Parametric
    g2{3}=grangercon.grangerspctrm;%Non-parametric (Conditional)
    
    
    
    p=FP.for.PAR{2};
    [gran,gran1,grangercon]=gc_paper(p,create_timecell(ro,length(p)),'Wideband',ro,10,[0:1:300],fn);
    
    G{4}=gran.grangerspctrm;%Non-parametric (Pairwise)
    g1{4}=gran1.grangerspctrm;%Parametric
    g2{4}=grangercon.grangerspctrm;%Non-parametric (Conditional)

g_f=gran.freq;
g1_f=gran1.freq;

granger_paper4(G,g_f,labelconditions3,[0 300]) %All
    %%
granger_paper4(g1,g1_f,labelconditions3,[0 300]) %All
    

    %%
cfg           = [];
cfg.parameter = 'grangerspctrm';
cfg.zlim      = [0 1];
ft_connectivityplot(cfg, gran);
figure()
cfg           = [];
cfg.parameter = 'grangerspctrm';
cfg.zlim      = [0 1];
ft_connectivityplot(cfg, gran1);
% figure()
% cfg           = [];
% cfg.parameter = 'grangerspctrm';
% cfg.zlim      = [0 1];
% ft_connectivityplot(cfg, grangercon_multi);
g2{1}=grangercon.grangerspctrm;
g2{2}=grangercon.grangerspctrm;
g2{3}=grangercon.grangerspctrm;
g2{4}=grangercon.grangerspctrm;

granger_paper4_cond(g2,g_f,labelconditions2,[0 300]) %Non-Parametric (Conditional)

G{1}=gran.grangerspctrm;
G{2}=gran.grangerspctrm;
G{3}=gran.grangerspctrm;
G{4}=gran.grangerspctrm;
figure()
granger_paper4(G,g_f,labelconditions2,[0 300]) %All

%%


    
    
    G{1}=gran.grangerspctrm;%Non-parametric (Pairwise)
    g1{1}=gran1.grangerspctrm;%Parametric
    g2{1}=grangercon.grangerspctrm;%Non-parametric (Conditional)

    p=FP.nl.PAR{2};
    [gran,gran1,grangercon]=gc_paper(p,create_timecell(ro,length(p)),'Wideband',ro,10,[0:1:300],fn);
    
    G{2}=gran.grangerspctrm;%Non-parametric (Pairwise)
    g1{2}=gran1.grangerspctrm;%Parametric
    g2{2}=grangercon.grangerspctrm;%Non-parametric (Conditional)

    p=FP.for.PAR{2};
    [gran,gran1,grangercon]=gc_paper(p,create_timecell(ro,length(p)),'Wideband',ro,10,[0:1:300],fn);
    
    G{3}=gran.grangerspctrm;%Non-parametric (Pairwise)
    g1{3}=gran1.grangerspctrm;%Parametric
    g2{3}=grangercon.grangerspctrm;%Non-parametric (Conditional)

    p=FP.novelty.PAR{2};
    [gran,gran1,grangercon]=gc_paper(p,create_timecell(ro,length(p)),'Wideband',ro,10,[0:1:300],fn);
    
    G{4}=gran.grangerspctrm;%Non-parametric (Pairwise)
    g1{4}=gran1.grangerspctrm;%Parametric
    g2{4}=grangercon.grangerspctrm;%Non-parametric (Conditional)
    
    %%
%     g{iii}=gran.grangerspctrm;%Non-parametric (Pairwise)
%     g1{iii}=gran1.grangerspctrm;%Parametric
%     g2{iii}=grangercon.grangerspctrm;%Non-parametric (Conditional)

%Frequency bands.
% [FB{iii}]=gc_freqbands(gran,0);
% [FB1{iii}]=gc_freqbands(gran1,0);
% [FB2{iii}]=gc_freqbands(grangercon,1);
%Frequency ranges. 
g_f=gran.freq;
g1_f=gran1.freq;

% G=gran.grangerspctrm;
% g1=gran1.grangerspctrm;%Parametric

%Non-parametric (Pairwise)
granger_paper4(G,g_f,labelconditions,[0 300]) %All

 granger_2D_testall_nostats(G,g_f,labelconditions,[0 300],'yes') %g1 looks better due to higher number of samples. 
% printing('GC2D_NP')
% close all

granger_paper4(g1,g1_f,labelconditions2,[0 300]) %Parametric (501 samples due to fs/2+1)
% printing('Parametric')
% close all

granger_2D_testall_nostats(g1,g1_f,labelconditions,[0 300],'yes') %g1 looks better due to higher number of samples. 
% printing('GC2D_P')
% close all



% granger_paper4(C,g_f,labelconditions,[0 300]) %Non-Parametric (Conditional)
granger_paper4_cond(g2,g_f,labelconditions,[0 300]) %Non-Parametric (Conditional)
% printing('Non_parametric_Conditional')
% close all


%% Find values for slow/fast PAR hfos
random_hfo=0;


win_size=50;
rand_first_run=0; %If you run for the first time.
same_nr_types=0; %Same N number across types

if same_nr_types==0
    N=[];
end

%SLOW
%PAR COHFOS
s=1;
w=3;
[values_spec,n1]=getval_spectra(SP,SQ,labelconditions2,label1,s,w,win_size,same_nr_types,N,random_hfo,rand_first_run,tr);
TT1=table;
% TT1.Variables=    [[{'100-250Hz'};{'100-150Hz'};{'150-200Hz'};{'200-250Hz'}] num2cell([values_spec.nl values_spec.plusmaze values_spec.novelty values_spec.for])];
% TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'PFC Baseline'};{'PAR Baseline'};{'HPC Plusmaze'};{'PFC Plusmaze'};{'PAR Plusmaze'};{'HPC Novelty'};{'PFC Novelty'};{'PAR Novelty'};{'HPC Foraging'};{'PFC Foraging'};{'PAR Foraging'}];    
TT1.Variables=    [[{'100-250Hz'};{'100-150Hz'};{'150-200Hz'};{'200-250Hz'}] num2cell([values_spec.nl(:,1) values_spec.plusmaze(:,1) values_spec.novelty(:,1) values_spec.for(:,1) values_spec.nl(:,2) values_spec.plusmaze(:,2) values_spec.novelty(:,2) values_spec.for(:,2) values_spec.nl(:,3) values_spec.plusmaze(:,3) values_spec.novelty(:,3) values_spec.for(:,3)])];
TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    

 
%PAR singles
s=2;
w=3;
[values_spec,n2]=getval_spectra(SP,SQ,labelconditions2,label1,s,w,win_size,same_nr_types,N,random_hfo,rand_first_run,tr);
TT2=table;
% TT1.Variables=    [[{'100-250Hz'};{'100-150Hz'};{'150-200Hz'};{'200-250Hz'}] num2cell([values_spec.nl values_spec.plusmaze values_spec.novelty values_spec.for])];
% TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'PFC Baseline'};{'PAR Baseline'};{'HPC Plusmaze'};{'PFC Plusmaze'};{'PAR Plusmaze'};{'HPC Novelty'};{'PFC Novelty'};{'PAR Novelty'};{'HPC Foraging'};{'PFC Foraging'};{'PAR Foraging'}];    
TT2.Variables=    [[{'100-250Hz'};{'100-150Hz'};{'150-200Hz'};{'200-250Hz'}] num2cell([values_spec.nl(:,1) values_spec.plusmaze(:,1) values_spec.novelty(:,1) values_spec.for(:,1) values_spec.nl(:,2) values_spec.plusmaze(:,2) values_spec.novelty(:,2) values_spec.for(:,2) values_spec.nl(:,3) values_spec.plusmaze(:,3) values_spec.novelty(:,3) values_spec.for(:,3)])];
TT2.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    
 
%FAST
%PAR COHFOS
s=1;
w=3;
[values_spec,n3]=getval_spectra(FP,FQ,labelconditions2,label1,s,w,win_size,same_nr_types,N,random_hfo,rand_first_run,tr);
TT3=table;
% TT1.Variables=    [[{'100-250Hz'};{'100-150Hz'};{'150-200Hz'};{'200-250Hz'}] num2cell([values_spec.nl values_spec.plusmaze values_spec.novelty values_spec.for])];
% TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'PFC Baseline'};{'PAR Baseline'};{'HPC Plusmaze'};{'PFC Plusmaze'};{'PAR Plusmaze'};{'HPC Novelty'};{'PFC Novelty'};{'PAR Novelty'};{'HPC Foraging'};{'PFC Foraging'};{'PAR Foraging'}];    
TT3.Variables=    [[{'100-250Hz'};{'100-150Hz'};{'150-200Hz'};{'200-250Hz'}] num2cell([values_spec.nl(:,1) values_spec.plusmaze(:,1) values_spec.novelty(:,1) values_spec.for(:,1) values_spec.nl(:,2) values_spec.plusmaze(:,2) values_spec.novelty(:,2) values_spec.for(:,2) values_spec.nl(:,3) values_spec.plusmaze(:,3) values_spec.novelty(:,3) values_spec.for(:,3)])];
TT3.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    

 
%PAR singles
s=2;
w=3;
[values_spec,n4]=getval_spectra(FP,FQ,labelconditions2,label1,s,w,win_size,same_nr_types,N,random_hfo,rand_first_run,tr);
TT4=table;
% TT1.Variables=    [[{'100-250Hz'};{'100-150Hz'};{'150-200Hz'};{'200-250Hz'}] num2cell([values_spec.nl values_spec.plusmaze values_spec.novelty values_spec.for])];
% TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'PFC Baseline'};{'PAR Baseline'};{'HPC Plusmaze'};{'PFC Plusmaze'};{'PAR Plusmaze'};{'HPC Novelty'};{'PFC Novelty'};{'PAR Novelty'};{'HPC Foraging'};{'PFC Foraging'};{'PAR Foraging'}];    
TT4.Variables=    [[{'100-250Hz'};{'100-150Hz'};{'150-200Hz'};{'200-250Hz'}] num2cell([values_spec.nl(:,1) values_spec.plusmaze(:,1) values_spec.novelty(:,1) values_spec.for(:,1) values_spec.nl(:,2) values_spec.plusmaze(:,2) values_spec.novelty(:,2) values_spec.for(:,2) values_spec.nl(:,3) values_spec.plusmaze(:,3) values_spec.novelty(:,3) values_spec.for(:,3)])];
TT4.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    

t1=repmat({'x'},[1 13]);

tab=[TT1;t1;TT2;t1;TT3;t1;TT4];

if win_size== 25
writetable(tab,strcat('spec_SLOWFAST_values_25_rat_', num2str(Rat),'_' ,num2str(tr(2)),'.xls'),'Sheet',1,'Range','A2:Z50')  
end

if win_size== 50
writetable(tab,strcat('spec_SLOWFAST_values_rat_', num2str(Rat),'_' ,num2str(tr(2)),'.xls'),'Sheet',1,'Range','A2:Z50')  
end

%% 
% GET ALL RIPPLES.
win_size=50;
%HPC COHFOS
s=1;
w=1;
[values_spec,n1]=getval_spectra_All(P,Q,labelconditions2,label1,s,w,win_size);
TT=table;
% TT.Variables=    [[{'100-250Hz'};{'100-150Hz'};{'150-200Hz'};{'200-250Hz'}] num2cell([values_spec.nl values_spec.plusmaze values_spec.novelty values_spec.for])];
% TT.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'PFC Baseline'};{'PAR Baseline'};{'HPC Plusmaze'};{'PFC Plusmaze'};{'PAR Plusmaze'};{'HPC Novelty'};{'PFC Novelty'};{'PAR Novelty'};{'HPC Foraging'};{'PFC Foraging'};{'PAR Foraging'}];    
TT.Variables=    [[{'100-250Hz'};{'100-150Hz'};{'150-200Hz'};{'200-250Hz'}] num2cell([values_spec.nl(:,1) values_spec.plusmaze(:,1) values_spec.novelty(:,1) values_spec.for(:,1) values_spec.nl(:,2) values_spec.plusmaze(:,2) values_spec.novelty(:,2) values_spec.for(:,2) values_spec.nl(:,3) values_spec.plusmaze(:,3) values_spec.novelty(:,3) values_spec.for(:,3)])];
TT.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    

% % %PAR COHFOS
s=1;
w=3;
[values_spec,n2]=getval_spectra_All(P,Q,labelconditions2,label1,s,w,win_size);
TT1=table;
% TT1.Variables=    [[{'100-250Hz'};{'100-150Hz'};{'150-200Hz'};{'200-250Hz'}] num2cell([values_spec.nl values_spec.plusmaze values_spec.novelty values_spec.for])];
% TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'PFC Baseline'};{'PAR Baseline'};{'HPC Plusmaze'};{'PFC Plusmaze'};{'PAR Plusmaze'};{'HPC Novelty'};{'PFC Novelty'};{'PAR Novelty'};{'HPC Foraging'};{'PFC Foraging'};{'PAR Foraging'}];    
TT1.Variables=    [[{'100-250Hz'};{'100-150Hz'};{'150-200Hz'};{'200-250Hz'}] num2cell([values_spec.nl(:,1) values_spec.plusmaze(:,1) values_spec.novelty(:,1) values_spec.for(:,1) values_spec.nl(:,2) values_spec.plusmaze(:,2) values_spec.novelty(:,2) values_spec.for(:,2) values_spec.nl(:,3) values_spec.plusmaze(:,3) values_spec.novelty(:,3) values_spec.for(:,3)])];
TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    

%HPC singles
s=2;
w=1;
[values_spec,n3]=getval_spectra_All(P,Q,labelconditions2,label1,s,w,win_size);
TT2=table;
% TT2.Variables=    [[{'100-250Hz'};{'100-150Hz'};{'150-200Hz'};{'200-250Hz'}] num2cell([values_spec.nl values_spec.plusmaze values_spec.novelty values_spec.for])];
% TT2.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'PFC Baseline'};{'PAR Baseline'};{'HPC Plusmaze'};{'PFC Plusmaze'};{'PAR Plusmaze'};{'HPC Novelty'};{'PFC Novelty'};{'PAR Novelty'};{'HPC Foraging'};{'PFC Foraging'};{'PAR Foraging'}];    
TT2.Variables=    [[{'100-250Hz'};{'100-150Hz'};{'150-200Hz'};{'200-250Hz'}] num2cell([values_spec.nl(:,1) values_spec.plusmaze(:,1) values_spec.novelty(:,1) values_spec.for(:,1) values_spec.nl(:,2) values_spec.plusmaze(:,2) values_spec.novelty(:,2) values_spec.for(:,2) values_spec.nl(:,3) values_spec.plusmaze(:,3) values_spec.novelty(:,3) values_spec.for(:,3)])];
TT2.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    

%PAR singles
s=2;
w=3;
[values_spec,n4]=getval_spectra_All(P,Q,labelconditions2,label1,s,w,win_size);
TT3=table;
% TT3.Variables=    [[{'100-250Hz'};{'100-150Hz'};{'150-200Hz'};{'200-250Hz'}] num2cell([values_spec.nl values_spec.plusmaze values_spec.novelty values_spec.for])];
% TT3.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'PFC Baseline'};{'PAR Baseline'};{'HPC Plusmaze'};{'PFC Plusmaze'};{'PAR Plusmaze'};{'HPC Novelty'};{'PFC Novelty'};{'PAR Novelty'};{'HPC Foraging'};{'PFC Foraging'};{'PAR Foraging'}];    
TT3.Variables=    [[{'100-250Hz'};{'100-150Hz'};{'150-200Hz'};{'200-250Hz'}] num2cell([values_spec.nl(:,1) values_spec.plusmaze(:,1) values_spec.novelty(:,1) values_spec.for(:,1) values_spec.nl(:,2) values_spec.plusmaze(:,2) values_spec.novelty(:,2) values_spec.for(:,2) values_spec.nl(:,3) values_spec.plusmaze(:,3) values_spec.novelty(:,3) values_spec.for(:,3)])];
TT3.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    

Total=[n1; n3; n4]

t1=repmat({'x'},[1 13]);

tab=[TT;t1;TT1;t1;TT2;t1;TT3];
%%

if win_size== 25
writetable(tab,strcat('spec_ALL_values_25_rat_', num2str(Rat),'_' ,num2str(tr(2)),'.xls'),'Sheet',1,'Range','A2:Z50')  
save('Total.mat','Total')
end

if win_size== 50
writetable(tab,strcat('spec_ALL_values_rat_', num2str(Rat),'_' ,num2str(tr(2)),'.xls'),'Sheet',1,'Range','A2:Z50')  
end
 
%%
%Corrected:
%s: 1 for cohfos, 2 for singles.
%w:1 for hpc centered, 3 for par centered.
%% Find minimum number of ripples per type.

%HPC COHFOS
s=1;
w=1;
 n1=min([length(P.(labelconditions2{1}).(label1{w}){s}) length(P.(labelconditions2{2}).(label1{w}){s})...
        length(P.(labelconditions2{3}).(label1{w}){s}) length(P.(labelconditions2{4}).(label1{w}){s})]);
%PAR COHFOS
s=1;
w=3;
 n2=min([length(P.(labelconditions2{1}).(label1{w}){s}) length(P.(labelconditions2{2}).(label1{w}){s})...
        length(P.(labelconditions2{3}).(label1{w}){s}) length(P.(labelconditions2{4}).(label1{w}){s})]);

%HPC singles
s=2;
w=1;
 n3=min([length(P.(labelconditions2{1}).(label1{w}){s}) length(P.(labelconditions2{2}).(label1{w}){s})...
        length(P.(labelconditions2{3}).(label1{w}){s}) length(P.(labelconditions2{4}).(label1{w}){s})]);

%PAR singles
s=2;
w=3;
 n4=min([length(P.(labelconditions2{1}).(label1{w}){s}) length(P.(labelconditions2{2}).(label1{w}){s})...
        length(P.(labelconditions2{3}).(label1{w}){s}) length(P.(labelconditions2{4}).(label1{w}){s})]);
[n1 n2 n3 n4]
N=min([n1 n2 n3 n4]);

%% Find values
random_hfo=0;


win_size=50;
rand_first_run=0; %If you run for the first time.
same_nr_types=0; %Same N number across types

if same_nr_types==0
    N=[];
end
%HPC COHFOS
s=1;
w=1;
[values_spec,n1]=getval_spectra(P,Q,labelconditions2,label1,s,w,win_size,same_nr_types,N,random_hfo,rand_first_run,tr);
TT=table;
% TT.Variables=    [[{'100-250Hz'};{'100-150Hz'};{'150-200Hz'};{'200-250Hz'}] num2cell([values_spec.nl values_spec.plusmaze values_spec.novelty values_spec.for])];
% TT.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'PFC Baseline'};{'PAR Baseline'};{'HPC Plusmaze'};{'PFC Plusmaze'};{'PAR Plusmaze'};{'HPC Novelty'};{'PFC Novelty'};{'PAR Novelty'};{'HPC Foraging'};{'PFC Foraging'};{'PAR Foraging'}];    
TT.Variables=    [[{'100-250Hz'};{'100-150Hz'};{'150-200Hz'};{'200-250Hz'}] num2cell([values_spec.nl(:,1) values_spec.plusmaze(:,1) values_spec.novelty(:,1) values_spec.for(:,1) values_spec.nl(:,2) values_spec.plusmaze(:,2) values_spec.novelty(:,2) values_spec.for(:,2) values_spec.nl(:,3) values_spec.plusmaze(:,3) values_spec.novelty(:,3) values_spec.for(:,3)])];
TT.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    

%PAR COHFOS
s=1;
w=3;
[values_spec,n2]=getval_spectra(P,Q,labelconditions2,label1,s,w,win_size,same_nr_types,N,random_hfo,rand_first_run,tr);
TT1=table;
% TT1.Variables=    [[{'100-250Hz'};{'100-150Hz'};{'150-200Hz'};{'200-250Hz'}] num2cell([values_spec.nl values_spec.plusmaze values_spec.novelty values_spec.for])];
% TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'PFC Baseline'};{'PAR Baseline'};{'HPC Plusmaze'};{'PFC Plusmaze'};{'PAR Plusmaze'};{'HPC Novelty'};{'PFC Novelty'};{'PAR Novelty'};{'HPC Foraging'};{'PFC Foraging'};{'PAR Foraging'}];    
TT1.Variables=    [[{'100-250Hz'};{'100-150Hz'};{'150-200Hz'};{'200-250Hz'}] num2cell([values_spec.nl(:,1) values_spec.plusmaze(:,1) values_spec.novelty(:,1) values_spec.for(:,1) values_spec.nl(:,2) values_spec.plusmaze(:,2) values_spec.novelty(:,2) values_spec.for(:,2) values_spec.nl(:,3) values_spec.plusmaze(:,3) values_spec.novelty(:,3) values_spec.for(:,3)])];
TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    

%HPC singles
s=2;
w=1;
[values_spec,n3]=getval_spectra(P,Q,labelconditions2,label1,s,w,win_size,same_nr_types,N,random_hfo,rand_first_run,tr);
TT2=table;
% TT2.Variables=    [[{'100-250Hz'};{'100-150Hz'};{'150-200Hz'};{'200-250Hz'}] num2cell([values_spec.nl values_spec.plusmaze values_spec.novelty values_spec.for])];
% TT2.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'PFC Baseline'};{'PAR Baseline'};{'HPC Plusmaze'};{'PFC Plusmaze'};{'PAR Plusmaze'};{'HPC Novelty'};{'PFC Novelty'};{'PAR Novelty'};{'HPC Foraging'};{'PFC Foraging'};{'PAR Foraging'}];    
TT2.Variables=    [[{'100-250Hz'};{'100-150Hz'};{'150-200Hz'};{'200-250Hz'}] num2cell([values_spec.nl(:,1) values_spec.plusmaze(:,1) values_spec.novelty(:,1) values_spec.for(:,1) values_spec.nl(:,2) values_spec.plusmaze(:,2) values_spec.novelty(:,2) values_spec.for(:,2) values_spec.nl(:,3) values_spec.plusmaze(:,3) values_spec.novelty(:,3) values_spec.for(:,3)])];
TT2.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    

%PAR singles
s=2;
w=3;
[values_spec,n4]=getval_spectra(P,Q,labelconditions2,label1,s,w,win_size,same_nr_types,N,random_hfo,rand_first_run,tr);
TT3=table;
% TT3.Variables=    [[{'100-250Hz'};{'100-150Hz'};{'150-200Hz'};{'200-250Hz'}] num2cell([values_spec.nl values_spec.plusmaze values_spec.novelty values_spec.for])];
% TT3.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'PFC Baseline'};{'PAR Baseline'};{'HPC Plusmaze'};{'PFC Plusmaze'};{'PAR Plusmaze'};{'HPC Novelty'};{'PFC Novelty'};{'PAR Novelty'};{'HPC Foraging'};{'PFC Foraging'};{'PAR Foraging'}];    
TT3.Variables=    [[{'100-250Hz'};{'100-150Hz'};{'150-200Hz'};{'200-250Hz'}] num2cell([values_spec.nl(:,1) values_spec.plusmaze(:,1) values_spec.novelty(:,1) values_spec.for(:,1) values_spec.nl(:,2) values_spec.plusmaze(:,2) values_spec.novelty(:,2) values_spec.for(:,2) values_spec.nl(:,3) values_spec.plusmaze(:,3) values_spec.novelty(:,3) values_spec.for(:,3)])];
TT3.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'HPC Plusmaze'};{'HPC Novelty'};{'HPC Foraging'};{'PFC Baseline'};{'PFC Plusmaze'};{'PFC Novelty'};{'PFC Foraging'};{'PAR Baseline'};{'PAR Plusmaze'};{'PAR Novelty'};{'PAR Foraging'}];    

[n1 n2 n3 n4]

t1=repmat({'x'},[1 13]);

tab=[TT;t1;TT1;t1;TT2;t1;TT3];
%%
if random_hfo==0

    if same_nr_types==0
        if win_size== 25
        writetable(tab,strcat('spec_values_25_rat_', num2str(Rat),'_' ,num2str(tr(2)),'.xls'),'Sheet',1,'Range','A2:Z50')  
        end

        if win_size== 50
        writetable(tab,strcat('spec_values_rat_', num2str(Rat),'_' ,num2str(tr(2)),'.xls'),'Sheet',1,'Range','A2:Z50')  
        end
    else
        if win_size== 25
        writetable(tab,strcat('spec_values_SameNR_25_rat_', num2str(Rat),'_' ,num2str(tr(2)),'.xls'),'Sheet',1,'Range','A2:Z50')  
        end

        if win_size== 50
        writetable(tab,strcat('spec_values_SameNR_rat_', num2str(Rat),'_' ,num2str(tr(2)),'.xls'),'Sheet',1,'Range','A2:Z50')  
        end
    end

else

    if same_nr_types==0
        if win_size== 25
        writetable(tab,strcat('spec_rand_values_25_rat_', num2str(Rat),'_' ,num2str(tr(2)),'.xls'),'Sheet',1,'Range','A2:Z50')  
        end

        if win_size== 50
        writetable(tab,strcat('spec_rand_values_rat_', num2str(Rat),'_' ,num2str(tr(2)),'.xls'),'Sheet',1,'Range','A2:Z50')  
        end
    else
        if win_size== 25
        writetable(tab,strcat('spec_rand_values_SameNR_25_rat_', num2str(Rat),'_' ,num2str(tr(2)),'.xls'),'Sheet',1,'Range','A2:Z50')  
        end

        if win_size== 50
        writetable(tab,strcat('spec_rand_values_SameNR_rat_', num2str(Rat),'_' ,num2str(tr(2)),'.xls'),'Sheet',1,'Range','A2:Z50')  
        end
    end

end
%%
HPC_cohfos




PAR_cohfos




HPC_singles




PAR_singles

%%
%HPC specs
%HPC cohfos
% xo
same_nr_types=1; %Same N number across types
if same_nr_types==0
    N=[];
end
%s: 2 for single, 1 for cohfos
%w:1 for hpc centered, 3 for par centered.
s=1;
w=1;
plot_spectra(P,Q,labelconditions2,label1,s,w,same_nr_types,N)
if same_nr_types==1
printing(['Spec_HPC_cohfos_SameNR_rat' num2str(Rat) '_' num2str(tr(2))])
else
printing(['Spec_HPC_cohfos_rat' num2str(Rat) '_' num2str(tr(2))])    
end
close all
% TT=table;
% TT.Variables=    [[{'100-250Hz'};{'100-150Hz'};{'150-200Hz'};{'200-250Hz'}] num2cell([values_spec.baseline values_spec.plusmaze])];
% TT.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'PFC Baseline'};{'PAR Baseline'};{'HPC Plusmaze'};{'PFC Plusmaze'};{'PAR Plusmaze'}];    


s=1;
w=3;
plot_spectra(P,Q,labelconditions2,label1,s,w,same_nr_types,N)
%printing(['Spec_PAR_cohfos_rat' num2str(Rat) '_' num2str(tr(2))])
if same_nr_types==1
printing(['Spec_PAR_cohfos_SameNR_rat' num2str(Rat) '_' num2str(tr(2))])
else
printing(['Spec_PAR_cohfos_rat' num2str(Rat) '_' num2str(tr(2))])    
end
close all
% TT1=table;
% TT1.Variables=    [[{'100-250Hz'};{'100-150Hz'};{'150-200Hz'};{'200-250Hz'}] num2cell([values_spec.baseline values_spec.plusmaze])];
% TT1.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'PFC Baseline'};{'PAR Baseline'};{'HPC Plusmaze'};{'PFC Plusmaze'};{'PAR Plusmaze'}];    

s=2;
w=1;
plot_spectra(P,Q,labelconditions2,label1,s,w,same_nr_types,N)
% printing(['Spec_HPC_single_rat' num2str(Rat) '_' num2str(tr(2))])
if same_nr_types==1
printing(['Spec_HPC_single_SameNR_rat' num2str(Rat) '_' num2str(tr(2))])
else
printing(['Spec_HPC_single_rat' num2str(Rat) '_' num2str(tr(2))])    
end
close all
% TT2=table;
% TT2.Variables=    [[{'100-250Hz'};{'100-150Hz'};{'150-200Hz'};{'200-250Hz'}] num2cell([values_spec.baseline values_spec.plusmaze])];
% TT2.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'PFC Baseline'};{'PAR Baseline'};{'HPC Plusmaze'};{'PFC Plusmaze'};{'PAR Plusmaze'}];    


s=2;
w=3;
plot_spectra(P,Q,labelconditions2,label1,s,w,same_nr_types,N)
% printing(['Spec_PAR_single_rat' num2str(Rat) '_' num2str(tr(2))])
if same_nr_types==1
printing(['Spec_PAR_single_SameNR_rat' num2str(Rat) '_' num2str(tr(2))])
else
printing(['Spec_PAR_single_rat' num2str(Rat) '_' num2str(tr(2))])    
end
close all
% TT3=table;
% TT3.Variables=    [[{'100-250Hz'};{'100-150Hz'};{'150-200Hz'};{'200-250Hz'}] num2cell([values_spec.baseline values_spec.plusmaze])];
% TT3.Properties.VariableNames=[{'Range'};{'HPC Baseline'};{'PFC Baseline'};{'PAR Baseline'};{'HPC Plusmaze'};{'PFC Plusmaze'};{'PAR Plusmaze'}];    

xo
% t1=repmat({'x'},[1 7]);
% 
% tab=[TT;t1;TT1;t1;TT2;t1;TT3];
% writetable(tab,strcat('spec_values_rat_', num2str(Rat),'_' ,num2str(tr(2)),'.xls'),'Sheet',1,'Range','A2:Z50')    

%%
same_nr_types=1; %Same N number across types
if same_nr_types==0
    N=[];
end

s=1;
w=1;
plot_spec_traces(P,Q,labelconditions2,label1,s,w,same_nr_types,N)
if same_nr_types==1
printing(['SpecTraces_SameNR_HPC_cohfos_rat' num2str(Rat) '_' num2str(tr(2))])    
else
printing(['SpecTraces_HPC_cohfos_rat' num2str(Rat) '_' num2str(tr(2))])    
end
close all

s=1;
w=3;
plot_spec_traces(P,Q,labelconditions2,label1,s,w,same_nr_types,N)
if same_nr_types==1
printing(['SpecTraces_SameNR_PAR_cohfos_rat' num2str(Rat) '_' num2str(tr(2))])        
else
printing(['SpecTraces_PAR_cohfos_rat' num2str(Rat) '_' num2str(tr(2))])    
end
close all

s=2;
w=1;
plot_spec_traces(P,Q,labelconditions2,label1,s,w,same_nr_types,N)
if same_nr_types==1
printing(['SpecTraces_SameNR_HPC_single_rat' num2str(Rat) '_' num2str(tr(2))])    
else
printing(['SpecTraces_HPC_single_rat' num2str(Rat) '_' num2str(tr(2))])
end
close all

s=2;
w=3;
plot_spec_traces(P,Q,labelconditions2,label1,s,w,same_nr_types,N)
if same_nr_types==1
printing(['SpecTraces_SameNR_PAR_single_rat' num2str(Rat) '_' num2str(tr(2))])    
else
printing(['SpecTraces_PAR_single_rat' num2str(Rat) '_' num2str(tr(2))])    
end
close all

%%


for l=1:length(q)
    plot(q{l}(1,:))
    hold on
end



