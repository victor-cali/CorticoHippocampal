%gui_threshold_ripples
%% Find location
close all
dname=uigetdir([],'Select folder with Matlab data containing all rats.');
cd(dname)

%%
%Select rat number
opts.Resize = 'on';
opts.WindowStyle = 'modal';
opts.Interpreter = 'tex';
prompt=strcat('\bf Select a rat#. Options:','{ }',num2str(rats));
answer = inputdlg(prompt,'Input',[2 30],{''},opts);
Rat=str2num(answer{1});
cd(num2str(Rat))
%%
        % Ask for brain area.
% xx = inputdlg({'Cortical Brain area'},...
%               'Type your selection', [1 30],{'PAR'}); 
%xx={'PAR'};
          
%Brain region combinations.
list = {'HPC & PFC','HPC & PAR','PAR & PFC','PFC & PAR'};
[optionlist] = listdlg('PromptString',{'Select brain areas.'},'SelectionMode','single','ListString',list,'InitialValue',3);
switch optionlist
    case 1
      yy={'HPC'};       
      xx={'PFC'};
    case 2
      yy={'HPC'};    
      xx={'PAR'};  
    case 3
      yy={'PAR'};    
      xx={'PFC'};  
      
    case 4
      yy={'PFC'};    
      xx={'PAR'};  
        
end

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
%xo
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

z= zeros(length(label1),length(rats));
[T]=gui_table_channels(z,rats,label1,'Threholds');
tr=getfield(T,strcat('Rat',num2str(Rat)));%Thresholds 

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
% xo

%Spindles
[ripple,~,~,Mx_cortex,timeasleep,sig_cortex,Ex_cortex,Sx_cortex,...
  ~,~,~,~,~, ...
  ]=gui_findspindlesYASA(CORTEX,states,xx,multiplets,fn);

si=sig_cortex(~cellfun('isempty',sig_cortex));
si=[si{:}];
% All_Par.( strrep(g{k},'-','_'))=si;
% [x,y,z,~,~,~,l,p]=hfo_specs_spindles(si,timeasleep,fn,0);
%
%xo
%% Cortical Ripples

CORTEX=dir(strcat('*','PAR','*.mat'));
if isempty(CORTEX)
    g=g(~contains(g,g{k}));
    cd ..
    progress_bar(k,length(g),f)
    break
end
CORTEX=CORTEX.name;
CORTEX=load(CORTEX);
%CORTEX=CORTEX.CORTEX;
CORTEX=getfield(CORTEX,'PAR');
CORTEX=CORTEX.*(0.195);

A = dir('*states*.mat');
A={A.name};
if  ~isempty(A)
       cellfun(@load,A);
else
      error('No Scoring found')    
end
%
[ripple_sphfo,~,~,Mx_cortex_sphfo,~,sig_cortex_sphfo,Ex_cortex_sphfo,Sx_cortex_sphfo,...
  ~,~,~,~,~, ...
  ]=gui_findripples(CORTEX,states,{'PAR'},tr,multiplets,fn);


si=sig_cortex_sphfo(~cellfun('isempty',sig_cortex_sphfo));
si=[si{:}];

[~,~,~,~,~,~,~,~,si_mixed,~]=hfo_specs(si,timeasleep,0,Rat,tr);
%% Mixed distribution (Average freq) coHFOs
Mx_cortex_g1=Mx_cortex_sphfo;
Mx_cortex_g2=Mx_cortex_sphfo;
Ex_cortex_g1=Ex_cortex_sphfo;
Ex_cortex_g2=Ex_cortex_sphfo;
Sx_cortex_g1=Sx_cortex_sphfo;
Sx_cortex_g2=Sx_cortex_sphfo;

row=si_mixed.i1;
cont=0;
for ll=1:length(Mx_cortex_sphfo)
% cont=cont+length(Mx_cortex{ll});

    if ~isempty(Mx_cortex_sphfo{ll})

        for lll=1:length(Mx_cortex_sphfo{ll})
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



%% Coocur PFC spindle and ripples
[cohfos1_g1,cohfos2_g1]=cellfun(@(equis1,equis2,equis3,equis4,equis5,equis6) co_hfo_spindle(equis1,equis2,equis3,equis4,equis5,equis6),Sx_cortex_g1,Mx_cortex_g1,Ex_cortex_g1,Sx_cortex,Mx_cortex,Ex_cortex,'UniformOutput',false);
[cohfos1_g2,cohfos2_g2]=cellfun(@(equis1,equis2,equis3,equis4,equis5,equis6) co_hfo_spindle(equis1,equis2,equis3,equis4,equis5,equis6),Sx_cortex_g2,Mx_cortex_g2,Ex_cortex_g2,Sx_cortex,Mx_cortex,Ex_cortex,'UniformOutput',false);
%xo

Cohfos1_PFC_g1{k}=([cohfos1_g1{:}]);
Cohfos2_PFC_g1{k}=([cohfos2_g1{:}]);
Cohfos1_PFC_g2{k}=([cohfos1_g2{:}]);
Cohfos2_PFC_g2{k}=([cohfos2_g2{:}]);
%%
%PRE POST ANALYSIS
[Sx_pre,Mx_pre,Ex_pre,Sx_post,Mx_post,Ex_post]=cellfun(@(equis1,equis2,equis3) pre_post_spindle(equis1,equis2,equis3) ,Sx_cortex,Mx_cortex,Ex_cortex ,'UniformOutput',false);

%PRE
[cohfos1_g1_pre,cohfos2_g1_pre]=cellfun(@(equis1,equis2,equis3,equis4,equis5,equis6) co_hfo_spindle(equis1,equis2,equis3,equis4,equis5,equis6),Sx_cortex_g1,Mx_cortex_g1,Ex_cortex_g1,Sx_pre,Mx_pre,Ex_pre,'UniformOutput',false);
[cohfos1_g2_pre,cohfos2_g2_pre]=cellfun(@(equis1,equis2,equis3,equis4,equis5,equis6) co_hfo_spindle(equis1,equis2,equis3,equis4,equis5,equis6),Sx_cortex_g2,Mx_cortex_g2,Ex_cortex_g2,Sx_pre,Mx_pre,Ex_pre,'UniformOutput',false);
%xo

Cohfos1_PFC_g1_pre{k}=([cohfos1_g1_pre{:}]);
Cohfos2_PFC_g1_pre{k}=([cohfos2_g1_pre{:}]);
Cohfos1_PFC_g2_pre{k}=([cohfos1_g2_pre{:}]);
Cohfos2_PFC_g2_pre{k}=([cohfos2_g2_pre{:}]);

%POST
[cohfos1_g1_post,cohfos2_g1_post]=cellfun(@(equis1,equis2,equis3,equis4,equis5,equis6) co_hfo_spindle(equis1,equis2,equis3,equis4,equis5,equis6),Sx_cortex_g1,Mx_cortex_g1,Ex_cortex_g1,Sx_post,Mx_post,Ex_post,'UniformOutput',false);
[cohfos1_g2_post,cohfos2_g2_post]=cellfun(@(equis1,equis2,equis3,equis4,equis5,equis6) co_hfo_spindle(equis1,equis2,equis3,equis4,equis5,equis6),Sx_cortex_g2,Mx_cortex_g2,Ex_cortex_g2,Sx_post,Mx_post,Ex_post,'UniformOutput',false);
%xo

Cohfos1_PFC_g1_post{k}=([cohfos1_g1_post{:}]);
Cohfos2_PFC_g1_post{k}=([cohfos2_g1_post{:}]);
Cohfos1_PFC_g2_post{k}=([cohfos1_g2_post{:}]);
Cohfos2_PFC_g2_post{k}=([cohfos2_g2_post{:}]);

%%

CORTEX=dir(strcat('*','HPC','*.mat'));
if isempty(CORTEX)
    g=g(~contains(g,g{k}));
    cd ..
    progress_bar(k,length(g),f)
    break
end
CORTEX=CORTEX.name;
CORTEX=load(CORTEX);
%CORTEX=CORTEX.CORTEX;
CORTEX=getfield(CORTEX,'HPC');
CORTEX=CORTEX.*(0.195);

A = dir('*states*.mat');
A={A.name};
if  ~isempty(A)
       cellfun(@load,A);
else
      error('No Scoring found')    
end
%
[ripple_nhpc,~,~,Mx_nhpc,~,sig_nhpc,Ex_nhpc,Sx_nhpc,...
  ~,~,~,~,~, ...
  ]=gui_findripples(CORTEX,states,{'HPC'},tr,multiplets,fn);

%% Coocur PFC spindle and HPC ripples
[cohfos1_hpc,cohfos2_hpc]=cellfun(@(equis1,equis2,equis3,equis4,equis5,equis6) co_hfo_spindle(equis1,equis2,equis3,equis4,equis5,equis6),Sx_nhpc,Mx_nhpc,Ex_nhpc,Sx_cortex,Mx_cortex,Ex_cortex,'UniformOutput',false);


Cohfos1_PFC_hpc{k}= ([cohfos1_hpc{:}]);
Cohfos2_PFC_hpc{k}= ([cohfos2_hpc{:}]);

%PRE POST ANALYSIS
%Previously computed PRE AND POST FOR SPINDLES.
%[Sx_pre,Mx_pre,Ex_pre,Sx_post,Mx_post,Ex_post]=cellfun(@(equis1,equis2,equis3) pre_post_spindle(equis1,equis2,equis3) ,Sx_cortex,Mx_cortex,Ex_cortex ,'UniformOutput',false);

%PRE
[cohfos1_hpc_pre,cohfos2_hpc_pre]=cellfun(@(equis1,equis2,equis3,equis4,equis5,equis6) co_hfo_spindle(equis1,equis2,equis3,equis4,equis5,equis6),Sx_nhpc,Mx_nhpc,Ex_nhpc,Sx_pre,Mx_pre,Ex_pre,'UniformOutput',false);
Cohfos1_PFC_hpc_pre{k}= ([cohfos1_hpc_pre{:}]);
Cohfos2_PFC_hpc_pre{k}= ([cohfos2_hpc_pre{:}]);

%POST
[cohfos1_hpc_post,cohfos2_hpc_post]=cellfun(@(equis1,equis2,equis3,equis4,equis5,equis6) co_hfo_spindle(equis1,equis2,equis3,equis4,equis5,equis6),Sx_nhpc,Mx_nhpc,Ex_nhpc,Sx_post,Mx_post,Ex_post,'UniformOutput',false);
Cohfos1_PFC_hpc_post{k}= ([cohfos1_hpc_post{:}]);
Cohfos2_PFC_hpc_post{k}= ([cohfos2_hpc_post{:}]);

%% COOCUR SPINDLE-HPC MULTIPLETS
[out_pfc]=coccur_multiplets(cohfos2_hpc);
Out_PFC{k}=out_pfc;

[out_pfc_pre]=coccur_multiplets(cohfos2_hpc_pre);
Out_PFC_pre{k}=out_pfc_pre;

[out_pfc_post]=coccur_multiplets(cohfos2_hpc_post);
Out_PFC_post{k}=out_pfc_post;

%%
%Remove repeated values
%[cohfos1,cohfos2]=cellfun(@(equis1,equis2) coocur_repeat(equis1,equis2), cohfos1,cohfos2,'UniformOutput',false);

%% HPC

HPC=dir(strcat('*',yy{1},'*.mat'));
if isempty(HPC)
    g=g(~contains(g,g{k}));
    cd ..
    progress_bar(k,length(g),f)
    break
end

HPC=HPC.name;
HPC=load(HPC);
%HPC=HPC.HPC;
HPC=getfield(HPC,yy{1});
HPC=HPC.*(0.195);
%xo
[ripple,RipFreq,rip_duration,Mx_hpc,timeasleep,sig_hpc,Ex_hpc,Sx_hpc,...
  ripple_multiplets_hpc,RipFreq_multiplets_hpc,rip_duration_multiplets_hpc,sig_multiplets_hpc,Mx_multiplets_hpc...    
  ]=gui_findspindlesYASA(HPC,states,yy,multiplets,fn);


si=sig_hpc(~cellfun('isempty',sig_hpc));
si=[si{:}];

% plot_hfo(si,Mx_hpc,Sx_hpc,label1{1})
% title(['HFO HPC  ' strrep(g{k},'_','-')])
% cd ..
% printing(['HFO HPC  ' strrep(g{k},'_','-')])
% close all
% cd(g{k})
% xo
%All_HPC.( strrep(g{k},'-','_'))=si;


[x,y,z,~,~,~,l,p]=hfo_specs_spindles(si,timeasleep,fn,0);
%xo
%%
% [cohfos1_g1,cohfos2_g1]=cellfun(@(equis1,equis2,equis3,equis4,equis5,equis6) co_hfo_spindle(equis1,equis2,equis3,equis4,equis5,equis6),Sx_cortex_g1,Mx_cortex_g1,Ex_cortex_g1,Sx_hpc,Mx_hpc,Ex_hpc,'UniformOutput',false);
% [cohfos1_g2,cohfos2_g2]=cellfun(@(equis1,equis2,equis3,equis4,equis5,equis6) co_hfo_spindle(equis1,equis2,equis3,equis4,equis5,equis6),Sx_cortex_g2,Mx_cortex_g2,Ex_cortex_g2,Sx_hpc,Mx_hpc,Ex_hpc,'UniformOutput',false);
% %xo
% 
% Cohfos1_PAR_g1{k}=([cohfos1_g1{:}]);
% Cohfos2_PAR_g1{k}=([cohfos2_g1{:}]);
% Cohfos1_PAR_g2{k}=([cohfos1_g2{:}]);
% Cohfos2_PAR_g2{k}=([cohfos2_g2{:}]);
%%
%PRE POST ANALYSIS
[Sx_pre,Mx_pre,Ex_pre,Sx_post,Mx_post,Ex_post]=cellfun(@(equis1,equis2,equis3) pre_post_spindle(equis1,equis2,equis3) ,Sx_hpc,Mx_hpc,Ex_hpc ,'UniformOutput',false);

% %PRE
% [cohfos1_g1_pre,cohfos2_g1_pre]=cellfun(@(equis1,equis2,equis3,equis4,equis5,equis6) co_hfo_spindle(equis1,equis2,equis3,equis4,equis5,equis6),Sx_cortex_g1,Mx_cortex_g1,Ex_cortex_g1,Sx_pre,Mx_pre,Ex_pre,'UniformOutput',false);
% [cohfos1_g2_pre,cohfos2_g2_pre]=cellfun(@(equis1,equis2,equis3,equis4,equis5,equis6) co_hfo_spindle(equis1,equis2,equis3,equis4,equis5,equis6),Sx_cortex_g2,Mx_cortex_g2,Ex_cortex_g2,Sx_pre,Mx_pre,Ex_pre,'UniformOutput',false);
% %xo
% 
% Cohfos1_PAR_g1_pre{k}=([cohfos1_g1_pre{:}]);
% Cohfos2_PAR_g1_pre{k}=([cohfos2_g1_pre{:}]);
% Cohfos1_PAR_g2_pre{k}=([cohfos1_g2_pre{:}]);
% Cohfos2_PAR_g2_pre{k}=([cohfos2_g2_pre{:}]);

% %POST
% [cohfos1_g1_post,cohfos2_g1_post]=cellfun(@(equis1,equis2,equis3,equis4,equis5,equis6) co_hfo_spindle(equis1,equis2,equis3,equis4,equis5,equis6),Sx_cortex_g1,Mx_cortex_g1,Ex_cortex_g1,Sx_post,Mx_post,Ex_post,'UniformOutput',false);
% [cohfos1_g2_post,cohfos2_g2_post]=cellfun(@(equis1,equis2,equis3,equis4,equis5,equis6) co_hfo_spindle(equis1,equis2,equis3,equis4,equis5,equis6),Sx_cortex_g2,Mx_cortex_g2,Ex_cortex_g2,Sx_post,Mx_post,Ex_post,'UniformOutput',false);
% %xo
% 
% Cohfos1_PAR_g1_post{k}=([cohfos1_g1_post{:}]);
% Cohfos2_PAR_g1_post{k}=([cohfos2_g1_post{:}]);
% Cohfos1_PAR_g2_post{k}=([cohfos1_g2_post{:}]);
% Cohfos2_PAR_g2_post{k}=([cohfos2_g2_post{:}]);


%% Coocur PAR spindle and HPC ripples
[cohfos1_hpc,cohfos2_hpc]=cellfun(@(equis1,equis2,equis3,equis4,equis5,equis6) co_hfo_spindle(equis1,equis2,equis3,equis4,equis5,equis6),Sx_nhpc,Mx_nhpc,Ex_nhpc,Sx_hpc,Mx_hpc,Ex_hpc,'UniformOutput',false);


Cohfos1_PAR_hpc{k}= ([cohfos1_hpc{:}]);
Cohfos2_PAR_hpc{k}= ([cohfos2_hpc{:}]);

%PRE POST ANALYSIS
%PRE AND POST SPINDLE COMPUTED ABOVE.
% [Sx_pre,Mx_pre,Ex_pre,Sx_post,Mx_post,Ex_post]=cellfun(@(equis1,equis2,equis3) pre_post_spindle(equis1,equis2,equis3) ,Sx_hpc,Mx_hpc,Ex_hpc ,'UniformOutput',false);

%PRE
[cohfos1_hpc_pre,cohfos2_hpc_pre]=cellfun(@(equis1,equis2,equis3,equis4,equis5,equis6) co_hfo_spindle(equis1,equis2,equis3,equis4,equis5,equis6),Sx_nhpc,Mx_nhpc,Ex_nhpc,Sx_pre,Mx_pre,Ex_pre,'UniformOutput',false);
Cohfos1_PAR_hpc_pre{k}= ([cohfos1_hpc_pre{:}]);
Cohfos2_PAR_hpc_pre{k}= ([cohfos2_hpc_pre{:}]);

%POST
[cohfos1_hpc_post,cohfos2_hpc_post]=cellfun(@(equis1,equis2,equis3,equis4,equis5,equis6) co_hfo_spindle(equis1,equis2,equis3,equis4,equis5,equis6),Sx_nhpc,Mx_nhpc,Ex_nhpc,Sx_post,Mx_post,Ex_post,'UniformOutput',false);
Cohfos1_PAR_hpc_post{k}= ([cohfos1_hpc_post{:}]);
Cohfos2_PAR_hpc_post{k}= ([cohfos2_hpc_post{:}]);
%% During-spindle ripples
clear During_rip Pre_rip Post_rip
for ix=1: size(sig_nhpc,1)
% Mx_nhpc{ix}
% cohfos1_hpc_pre{ix}
% % ismember(cohfos1_hpc_pre{ix},Mx_nhpc{ix})
% ismember(Mx_nhpc{ix},cohfos1_hpc_pre{ix})
rip=sig_nhpc{ix};
during_rip=rip(ismember(Mx_nhpc{ix},cohfos1_hpc{ix}));
During_rip{ix}=during_rip;

pre_rip=rip(ismember(Mx_nhpc{ix},cohfos1_hpc_pre{ix}));
Pre_rip{ix}=pre_rip;

post_rip=rip(ismember(Mx_nhpc{ix},cohfos1_hpc_post{ix}));
Post_rip{ix}=post_rip;


end

d_rip=During_rip(~cellfun('isempty',During_rip));
d_rip=[d_rip{:}];

pr_rip=Pre_rip(~cellfun('isempty',Pre_rip));
pr_rip=[pr_rip{:}];

po_rip=Post_rip(~cellfun('isempty',Post_rip));
po_rip=[po_rip{:}];

amount_pre(k)=length(pr_rip);
amount_during(k)=length(d_rip);
amount_post(k)=length(po_rip);
% 
% mean_amount_epoch_pre(k)=mean(cellfun('length',pr_rip));
% mean_amount_epoch_during(k)=mean(cellfun('length',d_rip));
% mean_amount_epoch_post(k)=mean(cellfun('length',po_rip));

[x_pre(k),y_pre(k),z_pre(k),w_pre(k),h_pre(k),q_pre(k),l_pre(k),p_pre(k),~,~,r_pre(k)]=hfo_features(pr_rip,0,0);
[x_dur(k),y_dur(k),z_dur(k),w_dur(k),h_dur(k),q_dur(k),l_dur(k),p_dur(k),~,~,r_dur(k)]=hfo_features(d_rip,0,0);
[x_post(k),y_post(k),z_post(k),w_post(k),h_post(k),q_post(k),l_post(k),p_post(k),~,~,r_post(k)]=hfo_features(po_rip,0,0);



%% COOCUR SPINDLE-HPC MULTIPLETS
% [out_par]=coccur_multiplets(cohfos2_hpc);
% Out_PAR{k}=out_par;
% 
% [out_par_pre]=coccur_multiplets(cohfos2_hpc_pre);
% Out_PAR_pre{k}=out_par_pre;
% 
% [out_par_post]=coccur_multiplets(cohfos2_hpc_post);
% Out_PAR_post{k}=out_par_post;

%%
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
% hfos_hpc(k)=ripple;
% hfos_hpc_rate(k)=RipFreq;
% hfos_hpc_duration(k)=rip_duration;

% xo
%% Coocurent hfos
% [cohfos1,cohfos2]=cellfun(@(equis1,equis2,equis3,equis4,equis5,equis6) co_hfo_spindle(equis1,equis2,equis3,equis4,equis5,equis6),Sx_hpc,Mx_hpc,Ex_hpc,Sx_cortex,Mx_cortex,Ex_cortex,'UniformOutput',false);
% %Remove repeated values
% [cohfos1,cohfos2]=cellfun(@(equis1,equis2) coocur_repeat(equis1,equis2), cohfos1,cohfos2,'UniformOutput',false);
% 
% 
% %cohfos1: HPC.
% %cohfos2: Cortex.
% %Common values:
% cohfos_count(k)=sum(cellfun('length',cohfos1));
% cohfos_rate(k)=sum(cellfun('length',cohfos1))/(timeasleep*(60));


%% Mixed distribution (Average freq) coHFOs
% Mx_cortex_g1=Mx_cortex;
% Mx_cortex_g2=Mx_cortex;
% 
% row=si_mixed.i1;
% cont=0;
% for ll=1:length(Mx_cortex)
% % cont=cont+length(Mx_cortex{ll});
% 
%     if ~isempty(Mx_cortex{ll})
% 
%         for lll=1:length(Mx_cortex{ll})
%             cont=cont+1;
%     %         xo
% 
%             if ~ismember(cont,row)
%                 Mx_cortex_g1{ll}(lll)=NaN;
%             else
%                 Mx_cortex_g2{ll}(lll)=NaN;
%             end
% 
%         end
%          Mx_cortex_g1{ll}=Mx_cortex_g1{ll}(~isnan(Mx_cortex_g1{ll}));
%          Mx_cortex_g2{ll}=Mx_cortex_g2{ll}(~isnan(Mx_cortex_g2{ll}));
% 
%     end
% 
% end
% 
% [cohfos1_g1,cohfos2_g1]=cellfun(@(equis1,equis2) co_hfo(equis1,equis2),Mx_hpc,Mx_cortex_g1,'UniformOutput',false);
% [cohfos1_g2,cohfos2_g2]=cellfun(@(equis1,equis2) co_hfo(equis1,equis2),Mx_hpc,Mx_cortex_g2,'UniformOutput',false);
% 
% cohfos_count_g1(k)=sum(cellfun('length',cohfos1_g1));
% cohfos_rate_g1(k)=sum(cellfun('length',cohfos1_g1))/(timeasleep*(60));
% 
% cohfos_count_g2(k)=sum(cellfun('length',cohfos1_g2));
% cohfos_rate_g2(k)=sum(cellfun('length',cohfos1_g2))/(timeasleep*(60));
% %xo
% 
% v2_g1=cellfun(@(equis1,equis2) single_hfo_get_sample(equis1,equis2),Mx_cortex_g1,cohfos2_g1,'UniformOutput',false);
% singles_count_g1(k)=sum(cellfun('length',v2_g1));
% singles_rate_g1(k)=sum(cellfun('length',v2_g1))/(timeasleep*(60));
% 
% 
% v2_g2=cellfun(@(equis1,equis2) single_hfo_get_sample(equis1,equis2),Mx_cortex_g2,cohfos2_g2,'UniformOutput',false);
% singles_count_g2(k)=sum(cellfun('length',v2_g2));
% singles_rate_g2(k)=sum(cellfun('length',v2_g2))/(timeasleep*(60));


%%
% 
% 
% %HPC COHFOS
% cohf_mx_hpc=Mx_hpc(~cellfun('isempty',cohfos1));%Peak values cells where HPC cohfos were found.
% cohf_sx_hpc=Sx_hpc(~cellfun('isempty',cohfos1));%Peak values cells where HPC cohfos were found.
% cohf_ex_hpc=Ex_hpc(~cellfun('isempty',cohfos1));%Peak values cells where HPC cohfos were found.
% 
% Cohfos1=cohfos1(~cellfun('isempty',cohfos1));
% 
% %Locate sample per cohfos
% coh_samp_hpc= cellfun(@(equis1,equis2) co_hfo_get_sample(equis1,equis2),cohf_mx_hpc,Cohfos1,'UniformOutput',false);
% 
% cohf_sx_hpc_val=cellfun(@(equis1,equis2) equis1(equis2),cohf_sx_hpc,coh_samp_hpc,'UniformOutput',false);
% cohf_sx_hpc_val=[cohf_sx_hpc_val{:}];
% 
% cohf_mx_hpc_val=cellfun(@(equis1,equis2) equis1(equis2),cohf_mx_hpc,coh_samp_hpc,'UniformOutput',false);
% cohf_mx_hpc_val=[cohf_mx_hpc_val{:}];
% 
% cohf_ex_hpc_val=cellfun(@(equis1,equis2) equis1(equis2),cohf_ex_hpc,coh_samp_hpc,'UniformOutput',false);
% cohf_ex_hpc_val=[cohf_ex_hpc_val{:}];
% 
% cohf_hpc_dura=cohf_ex_hpc_val-cohf_sx_hpc_val;
% cohf_hpc_dura=median(cohf_hpc_dura);
% Cohf_hpc_dura(k)=cohf_hpc_dura;
% %xo
% Sig_hpc=sig_hpc(~cellfun('isempty',cohfos1));
% Sig_hpc=cellfun(@(equis1,equis2) equis1(equis2),Sig_hpc,coh_samp_hpc,'UniformOutput',false);
% Sig_hpc=[Sig_hpc{:}];
% %xo

% plot_hfo(Sig_hpc,{cohf_mx_hpc_val},{cohf_sx_hpc_val},label1{1})
% title(['coHFO HPC envelope  ' strrep(g{k},'_','-')])
% cd ..
% printing(['coHFO HPC envelope ' strrep(g{k},'_','-')])
% close all
% cd(g{k})

% 
% 
% [x,y,z,w,h,q,l,p]=hfo_specs_spindles(Sig_hpc,timeasleep,fn,0);
% fi_cohfo_hpc(k)=x;
% fa_cohfo_hpc(k)=y;
% amp_cohfo_hpc(k)=z;
% count_cohfo_hpc(k)=w;
% rate_cohfo_hpc(k)=h;
% dura_cohfo_hpc(k)=q;
% auc_cohfo_hpc(k)=l;
% p2p_cohfo_hpc(k)=p;
% %Single HFOs HPC
% %[v2]=single_hfo_get_sample(Mx_hpc{1},cohfos1{1});
% v2=cellfun(@(equis1,equis2) single_hfo_get_sample(equis1,equis2),Mx_hpc,cohfos1,'UniformOutput',false);
% 
% Sig_hpc_single=cellfun(@(equis1,equis2) equis1(equis2),sig_hpc,v2,'UniformOutput',false);
% Sig_hpc_single=[Sig_hpc_single{:}];
% 
% 
% [single_mx_hpc_val,single_sx_hpc_val]=cellfun(@(equis1,equis2,equis3) single_hfos_mx(equis1,equis2,equis3),cohfos1,Mx_hpc,Sx_hpc,'UniformOutput',false);
% single_mx_hpc_val=[single_mx_hpc_val{:}];
% single_sx_hpc_val=[single_sx_hpc_val{:}];
% % xo


% plot_hfo(Sig_hpc_single,{single_mx_hpc_val},{single_sx_hpc_val},label1{1})
% title(['Single HPC envelope ' strrep(g{k},'_','-')])
% cd ..
% printing(['Single HPC envelope ' strrep(g{k},'_','-')])
% close all
% cd(g{k})



%%%%
% %Cortical COHFOS
% cohf_mx_cortex=Mx_cortex(~cellfun('isempty',cohfos2));%Peak values cells where cortex cohfos were found.
% cohf_sx_cortex=Sx_cortex(~cellfun('isempty',cohfos2));%Peak values cells where cortex cohfos were found.
% cohf_ex_cortex=Ex_cortex(~cellfun('isempty',cohfos2));%Peak values cells where cortex cohfos were found.
% 
% Cohfos2=cohfos2(~cellfun('isempty',cohfos2));
% 
% %Locate sample per cohfos
% coh_samp_cortex= cellfun(@(equis1,equis2) co_hfo_get_sample(equis1,equis2),cohf_mx_cortex,Cohfos2,'UniformOutput',false);
% cohf_sx_cortex_val=cellfun(@(equis1,equis2) equis1(equis2),cohf_sx_cortex,coh_samp_cortex,'UniformOutput',false);
% cohf_sx_cortex_val=[cohf_sx_cortex_val{:}];
% 
% cohf_mx_cortex_val=cellfun(@(equis1,equis2) equis1(equis2),cohf_mx_cortex,coh_samp_cortex,'UniformOutput',false);
% cohf_mx_cortex_val=[cohf_mx_cortex_val{:}];
% 
% cohf_ex_cortex_val=cellfun(@(equis1,equis2) equis1(equis2),cohf_ex_cortex,coh_samp_cortex,'UniformOutput',false);
% cohf_ex_cortex_val=[cohf_ex_cortex_val{:}];
% cohf_cortex_dura=cohf_ex_cortex_val-cohf_sx_cortex_val;
% cohf_cortex_dura=median(cohf_cortex_dura);
% Cohf_cortex_dura(k)=cohf_cortex_dura;
% 
% Sig_cortex=sig_cortex(~cellfun('isempty',cohfos2));
% Sig_cortex=cellfun(@(equis1,equis2) equis1(equis2),Sig_cortex,coh_samp_cortex,'UniformOutput',false);
% Sig_cortex=[Sig_cortex{:}];
% xo

% plot_hfo(Sig_cortex,{cohf_mx_cortex_val},{cohf_sx_cortex_val},label1{2})
% title(['coHFO cortex envelope ' strrep(g{k},'_','-')])
% cd ..
% printing(['coHFO cortex envelope ' strrep(g{k},'_','-')])
% close all
% cd(g{k})
% 
% 
% %Single HFOs Cortex
% %[v2]=single_hfo_get_sample(Mx_hpc{1},cohfos1{1});
% v2=cellfun(@(equis1,equis2) single_hfo_get_sample(equis1,equis2),Mx_cortex,cohfos2,'UniformOutput',false);
% 
% Sig_cortex_single=cellfun(@(equis1,equis2) equis1(equis2),sig_cortex,v2,'UniformOutput',false);
% Sig_cortex_single=[Sig_cortex_single{:}];
% %xo
% [single_mx_cortex_val,single_sx_cortex_val]=cellfun(@(equis1,equis2,equis3) single_hfos_mx(equis1,equis2,equis3),cohfos2,Mx_cortex,Sx_cortex,'UniformOutput',false);
% single_mx_cortex_val=[single_mx_cortex_val{:}];
% single_sx_cortex_val=[single_sx_cortex_val{:}];



% plot_hfo(Sig_cortex_single,{single_mx_cortex_val},{single_sx_cortex_val},label1{2})
% title(['Single cortex envelope ' strrep(g{k},'_','-')])
% cd ..
% printing(['Single cortex envelope ' strrep(g{k},'_','-')])
% close all
% cd(g{k})

% xo
progress_bar(k,length(g),f)
    cd ..    
    end
  xo
%%

amount_pre
amount_during
amount_post

mean_amount_epoch_pre
mean_amount_epoch_during
mean_amount_epoch_post
%%
% [x_pre(k),y_pre(k),z_pre(k),w_pre(k),h_pre(k),q_pre(k),l_pre(k),p_pre(k),~,~,r_pre(k)]
% [x_dur(k),y_dur(k),z_dur(k),w_dur(k),h_dur(k),q_dur(k),l_dur(k),p_dur(k),~,~,r_dur(k)]
% [x_post(k),y_post(k),z_post(k),w_post(k),h_post(k),q_post(k),l_post(k),p_post(k),~,~,r_post(k)]

% [x_pre,y_pre,z_pre,w_pre,h_pre,q_pre,l_pre,p_pre,r_pre]
T=[[x_pre;y_pre;z_pre;w_pre;q_pre;l_pre;p_pre;r_pre] [x_dur;y_dur;z_dur;w_dur;q_dur;l_dur;p_dur;r_dur] ...
[x_post;y_post;z_post;w_post;q_post;l_post;p_post;r_post]];
% [x_dur,y_dur,z_dur,w_dur,q_dur,l_dur,p_dur,r_dur]
% [x_post,y_post,z_post,w_post,q_post,l_post,p_post,r_post]
 TT=table;
    TT.Variables= T;
%     TT.Properties.VariableNames=[cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false).'].';
    writetable(TT,strcat('pre_during_post_ripples','.xls'),'Sheet',1,'Range','A2:L50')    

%%
Cohfos1_PAR_g1_pre
Cohfos1_PAR_g2_pre
Cohfos1_PFC_g1_pre
Cohfos1_PFC_g2_pre

Cohfos1_PAR_g1_post
Cohfos1_PAR_g2_post
Cohfos1_PFC_g1_post
Cohfos1_PFC_g2_post

Cohfos2_PAR_hpc_pre
Cohfos2_PAR_hpc_post
Cohfos2_PFC_hpc_pre
Cohfos2_PFC_hpc_post

Out_PAR_pre
Out_PFC_pre
Out_PAR_post
Out_PFC_post

save('PREPOST_24.mat','Cohfos1_PAR_g1_pre','Cohfos1_PAR_g2_pre','Cohfos1_PFC_g1_pre','Cohfos1_PFC_g2_pre',...
    'Cohfos1_PAR_g1_post','Cohfos1_PAR_g2_post','Cohfos1_PFC_g1_post','Cohfos1_PFC_g2_post',...
    'Cohfos2_PAR_hpc_pre','Cohfos2_PAR_hpc_post','Cohfos2_PFC_hpc_pre','Cohfos2_PFC_hpc_post',...
    'Out_PAR_pre','Out_PFC_pre','Out_PAR_post','Out_PFC_post');

  %% HFOs-spindles PRE and POST
    TT=table;
    TT.Variables= [cellfun('length',Cohfos1_PAR_g1_pre); cellfun('length',Cohfos1_PAR_g2_pre);...
       cellfun('length',Cohfos1_PFC_g1_pre); cellfun('length',Cohfos1_PFC_g2_pre); 
    ] ;
    TT.Properties.VariableNames=[cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false).'].';
    writetable(TT,strcat('ripple_spindles_pre','.xls'),'Sheet',1,'Range','A2:L10')    

    TT=table;
    TT.Variables= [cellfun('length',Cohfos1_PAR_g1_post); cellfun('length',Cohfos1_PAR_g2_post);...
       cellfun('length',Cohfos1_PFC_g1_post); cellfun('length',Cohfos1_PFC_g2_post); 
    ] ;
    TT.Properties.VariableNames=[cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false).'].';
    writetable(TT,strcat('ripple_spindles_post','.xls'),'Sheet',1,'Range','A2:L10')    

%% HPC ripples-spindles PRE POST
    TT=table;
    TT.Variables= [cellfun('length',Cohfos2_PAR_hpc_pre); cell2mat(cellfun(@(equis) length(unique(equis)),Cohfos2_PAR_hpc_pre,'UniformOutput',false));...
       cellfun('length',Cohfos2_PFC_hpc_pre); cell2mat(cellfun(@(equis) length(unique(equis)),Cohfos2_PFC_hpc_pre,'UniformOutput',false))]; 
    
    TT.Properties.VariableNames=[cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false).'].';
                writetable(TT,strcat('hpc_ripple_spindles_pre','.xls'),'Sheet',1,'Range','A2:L50')    

                    TT=table;
    TT.Variables= [cellfun('length',Cohfos2_PAR_hpc_post); cell2mat(cellfun(@(equis) length(unique(equis)),Cohfos2_PAR_hpc_post,'UniformOutput',false));...
       cellfun('length',Cohfos2_PFC_hpc_post); cell2mat(cellfun(@(equis) length(unique(equis)),Cohfos2_PFC_hpc_post,'UniformOutput',false))]; 
    
    TT.Properties.VariableNames=[cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false).'].';
                writetable(TT,strcat('hpc_ripple_spindles_post','.xls'),'Sheet',1,'Range','A2:L50')    

%% HPC ripples-spindles-multiplets PRE POST
    TT=table;
    TT.Variables=([Out_PAR_pre{1}(:,2) Out_PAR_pre{2}(:,2) Out_PAR_pre{3}(:,2) Out_PAR_pre{4}(:,2); [NaN NaN NaN NaN] ;Out_PFC_pre{1}(:,2) Out_PFC_pre{2}(:,2) Out_PFC_pre{3}(:,2) Out_PFC_pre{4}(:,2)] );
    TT.Properties.VariableNames=[cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false).'].';
                 writetable(TT,strcat('hpc_ripple_spindles_multiplets_pre','.xls'),'Sheet',1,'Range','A2:L50')    

    TT=table;
    TT.Variables=([Out_PAR_post{1}(:,2) Out_PAR_post{2}(:,2) Out_PAR_post{3}(:,2) Out_PAR_post{4}(:,2); [NaN NaN NaN NaN] ;Out_PFC_post{1}(:,2) Out_PFC_post{2}(:,2) Out_PFC_post{3}(:,2) Out_PFC_post{4}(:,2)] );
    TT.Properties.VariableNames=[cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false).'].';
                 writetable(TT,strcat('hpc_ripple_spindles_multiplets_post','.xls'),'Sheet',1,'Range','A2:L50')    

  %% HFOs-spindles
    TT=table;
    TT.Variables= [cellfun('length',Cohfos1_PAR_g1); cellfun('length',Cohfos1_PAR_g2);...
       cellfun('length',Cohfos1_PFC_g1); cellfun('length',Cohfos1_PFC_g2); 
    ] ;
    TT.Properties.VariableNames=[cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false).'].';
            writetable(TT,strcat('ripple_spindles','.xls'),'Sheet',1,'Range','A2:L10')    
%% HPC ripples-spindles
    TT=table;
    TT.Variables= [cellfun('length',Cohfos2_PAR_hpc); cell2mat(cellfun(@(equis) length(unique(equis)),Cohfos2_PAR_hpc,'UniformOutput',false));...
       cellfun('length',Cohfos2_PFC_hpc); cell2mat(cellfun(@(equis) length(unique(equis)),Cohfos2_PFC_hpc,'UniformOutput',false))]; 
    
    TT.Properties.VariableNames=[cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false).'].';
                writetable(TT,strcat('hpc_ripple_spindles','.xls'),'Sheet',1,'Range','A2:L50')    
%% HPC ripples-spindles-multiplets
    TT=table;
TT.Variables=([Out_PAR{1}(:,2) Out_PAR{2}(:,2) Out_PAR{3}(:,2) Out_PAR{4}(:,2); [NaN NaN NaN NaN] ;Out_PFC{1}(:,2) Out_PFC{2}(:,2) Out_PFC{3}(:,2) Out_PFC{4}(:,2)] );
    TT.Properties.VariableNames=[cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false).'].';
                writetable(TT,strcat('hpc_ripple_spindles_multiplets','.xls'),'Sheet',1,'Range','A2:L50')    

%%
    %%
  
% All_timeasleep
% All_Par
A_cell = struct2cell(All_Par);
All_Par_26=[A_cell{:}];
hfo_specs_spindles(All_Par_26,timeasleep,fn,1)
printing(['HistogramSpindles_' num2str(Rat) '_All_PFC_count'])
close all


A_cell = struct2cell(All_HPC);
All_Par_26=[A_cell{:}];
hfo_specs_spindles(All_Par_26,timeasleep,fn,1)
printing(['HistogramSpindles_' num2str(Rat) '_All_PAR_count'])
close all

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
    

%%
% count_cohfo_hpc(isnan(count_cohfo_hpc))=0;

    TT=table;
    TT.Variables=    [[{['Count_' xx{1} '_total']};{['Count_' yy{1} '_total']};{['Count_coocur_' xx{1} '_' yy{1}]};{['Count_single_' xx{1}]};{['Count_single_' yy{1}]}] num2cell([...
        hfos_cortex;hfos_hpc;count_cohfo_hpc;count_single_cortex;count_single_hpc])];

    TT.Properties.VariableNames=['Metric';cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false).'].';

            writetable(TT,strcat(xx{1},'_',yy{1},'_spindles','.xls'),'Sheet',1,'Range','A2:L10')    
%%
    %% Cortex
    hfos_cortex
    count_cohfo_cortex
    count_single_cortex
    %HPC
    hfos_hpc
    count_cohfo_hpc
    count_single_hpc
    %%
    %All detections cortex
%     xo
    TT=table;
    TT.Variables=    [[{'Count'};{'Rate'};{'Duration'};{'Average Frequency'};{'Instantaneous Frequency'};{'Amplitude'}] num2cell([hfos_cortex;hfos_cortex_rate;hfos_cortex_duration;fa_cortex;fi_cortex; amp_cortex])];
%     TT.Variables=    [[{'Count'};{'Rate'};{'Duration'}] num2cell([hfos_hpc;hfos_hpc_rate;hfos_hpc_duration])];
    
    TT.Properties.VariableNames=['Metric' cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false)].';
    
%     if strcmp(xx{1},'HPC')
%             writetable(TT,strcat(xx{1},'_',num2str(tr(1)),'.xls'),'Sheet',1,'Range','A2:L6')    
%     else
            writetable(TT,strcat(xx{1},'_Features_spindles','.xls'),'Sheet',1,'Range','A2:L10')    

%            writetable(TT,strcat(xx{1},'_spindles','.xls'),'Sheet',1,'Range','A2:L10')    
%     end

%%
%Cortex cohfos
    TT=table;
    TT.Variables=    [[{'Count'};{'Rate'};{'Duration'};{'Average Frequency'};{'Instantaneous Frequency'};{'Amplitude'}] num2cell([count_cohfo_cortex;rate_cohfo_cortex;dura_cohfo_cortex;fa_cohfo_cortex;fi_cohfo_cortex; amp_cohfo_cortex])];
%     TT.Variables=    [[{'Count'};{'Rate'};{'Duration'}] num2cell([hfos_hpc;hfos_hpc_rate;hfos_hpc_duration])];
    
    TT.Properties.VariableNames=['Metric' cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false)].';
    
%     if strcmp(xx{1},'HPC')
%             writetable(TT,strcat(xx{1},'_',num2str(tr(1)),'.xls'),'Sheet',1,'Range','A2:L6')    
%     else
            writetable(TT,strcat(xx{1},'_spindles','_cohfos','.xls'),'Sheet',1,'Range','A2:L10')    

%Cortex singles
    TT=table;
    TT.Variables=    [[{'Count'};{'Rate'};{'Duration'};{'Average Frequency'};{'Instantaneous Frequency'};{'Amplitude'}] num2cell([count_single_cortex;rate_single_cortex;dura_single_cortex;fa_single_cortex;fi_single_cortex; amp_single_cortex])];
%     TT.Variables=    [[{'Count'};{'Rate'};{'Duration'}] num2cell([hfos_hpc;hfos_hpc_rate;hfos_hpc_duration])];
    
    TT.Properties.VariableNames=['Metric' cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false)].';
    
%     if strcmp(xx{1},'HPC')
%             writetable(TT,strcat(xx{1},'_',num2str(tr(1)),'.xls'),'Sheet',1,'Range','A2:L6')    
%     else
            writetable(TT,strcat(xx{1},'_spindles','_singles','.xls'),'Sheet',1,'Range','A2:L10')    

  %%  HPC        
%All detections
    TT=table;
    TT.Variables=    [[{'Count'};{'Rate'};{'Duration'};{'Average Frequency'};{'Instantaneous Frequency'};{'Amplitude'}] num2cell([hfos_hpc;hfos_hpc_rate;hfos_hpc_duration;fa_hpc;fi_hpc;amp_hpc])];        
%    TT.Properties.VariableNames=['Metric';g];
    TT.Properties.VariableNames=['Metric' cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false)].';
    
%     if strcmp(xx{1},'HPC')
%             writetable(TT,strcat(xx{1},'_',num2str(tr(1)),'.xls'),'Sheet',1,'Range','A2:L6')    
%     else
            writetable(TT,strcat(yy{1},'_Features_spindles','.xls'),'Sheet',1,'Range','A2:L10')    
%     end


%%
%hpc cohfos
    TT=table;
    TT.Variables=    [[{'Count'};{'Rate'};{'Duration'};{'Average Frequency'};{'Instantaneous Frequency'};{'Amplitude'}] num2cell([count_cohfo_hpc;rate_cohfo_hpc;dura_cohfo_hpc;fa_cohfo_hpc;fi_cohfo_hpc; amp_cohfo_hpc])];
%     TT.Variables=    [[{'Count'};{'Rate'};{'Duration'}] num2cell([hfos_hpc;hfos_hpc_rate;hfos_hpc_duration])];
    
    TT.Properties.VariableNames=['Metric' cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false)].';
    
%     if strcmp(xx{1},'HPC')
%             writetable(TT,strcat(xx{1},'_',num2str(tr(1)),'.xls'),'Sheet',1,'Range','A2:L6')    
%     else
            writetable(TT,strcat(yy{1},'_spindles','_cohfos_','.xls'),'Sheet',1,'Range','A2:L10')    

%hpc singles
    TT=table;
    TT.Variables=    [[{'Count'};{'Rate'};{'Duration'};{'Average Frequency'};{'Instantaneous Frequency'};{'Amplitude'}] num2cell([count_single_hpc;rate_single_hpc;dura_single_hpc;fa_single_hpc;fi_single_hpc; amp_single_hpc])];
%     TT.Variables=    [[{'Count'};{'Rate'};{'Duration'}] num2cell([hfos_hpc;hfos_hpc_rate;hfos_hpc_duration])];
    
    TT.Properties.VariableNames=['Metric' cellfun(@(equis) strrep(equis,'_','-'),g,'UniformOutput',false)].';
    
%     if strcmp(xx{1},'HPC')
%             writetable(TT,strcat(xx{1},'_',num2str(tr(1)),'.xls'),'Sheet',1,'Range','A2:L6')    
%     else
            writetable(TT,strcat(yy{1},'_spindles','_singles','.xls'),'Sheet',1,'Range','A2:L10')    



%%
%COHFOS
    
    TT=table;
    TT.Variables=    [[{'Count'};{'Rate'}] num2cell([cohfos_count;cohfos_rate;])];
    TT.Properties.VariableNames=['Metric';g];    
    writetable(TT,strcat('coHFOs_spindles',num2str(tr(2)),'.xls'),'Sheet',1,'Range','A2:L6')    
    

%%

%     if size(label1,1)==3 %If Plusmaze
% %        xo
%         break;
%     end
%xo    
%end
xo