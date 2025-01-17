%gui_threshold_ripples
%% Select rat 
prompt = {'Select a Rat ID'};
dlgtitle = 'Rat ID';
definput = {'26'};
RatID = inputdlg(prompt,dlgtitle,[1 40],definput);
RatID=str2num(RatID{1});

%% Find location
close all
dname=uigetdir([],'Select folder with Matlab data of trial');
cd(dname)
%%
answer_print = questdlg('Print plots?', ...
	'Select an option', ...
	'Yes','No thank you','Yes');
% Handle response
switch answer_print
    case 'Yes'
        answer_print = 1;
    case 'No thank you'
        answer_print = 0;
end
%%
%Band pass filter design:
fn=1000; % New sampling frequency. 
Wn1=[100/(fn/2) 300/(fn/2)]; % Cutoff=100-300 Hz
% Wn1=[50/(fn/2) 80/(fn/2)]; 
[b1,a1] = butter(3,Wn1,'bandpass'); %Filter coefficients

%LPF 300 Hz:
fn=1000; % New sampling frequency. 
Wn1=[320/(fn/2)]; % Cutoff=320 Hz
[b2,a2] = butter(3,Wn1); %Filter coefficients

HPC=dir('*HPC*.mat');
HPC=HPC.name;
HPC=load(HPC);
HPC=HPC.HPC;
HPC=HPC.*(0.195);

PFC=dir('*PFC*.mat');
PFC=PFC.name;
PFC=load(PFC);
PFC=PFC.PFC;
PFC=PFC.*(0.195);



A = dir('*states*.mat');
A={A.name};

cellfun(@load,A);


    %Convert signal to 1 sec epochs.
    e_t=1;
    e_samples=e_t*(1000); %fs=1kHz
    ch=length(HPC);
    nc=floor(ch/e_samples); %Number of epochs
    NC=[];
    NC2=[];
    
    for kk=1:nc    
      NC(:,kk)= HPC(1+e_samples*(kk-1):e_samples*kk);
      NC2(:,kk)= PFC(1+e_samples*(kk-1):e_samples*kk);
    end
    
    vec_bin=states;
    vec_bin(vec_bin~=3)=0;
    vec_bin(vec_bin==3)=1; %Ones are NREM
    %Cluster one values:
    v2=ConsecutiveOnes(vec_bin);
    
    v_index=find(v2~=0);%NREM
    v_values=v2(v2~=0);

%     
%     ver=NC(:, v_index(1):v_index(1)+(v_values(1,1)-1));
%     v{1}=reshape(A, numel(A), 1);
for epoch_count=1:length(v_index)
v_hpc{epoch_count,1}=reshape(NC(:, v_index(epoch_count):v_index(epoch_count)+(v_values(1,epoch_count)-1)), [], 1);
v_pfc{epoch_count,1}=reshape(NC2(:, v_index(epoch_count):v_index(epoch_count)+(v_values(1,epoch_count)-1)), [], 1);
end 
%%
%v_hpc and v_pfc: NREM epochs of hpc and pfc.

%Detect Microarousal periods in PFC
V_HPC=[];
V_PFC=[];

    max_length=cellfun(@length,v_hpc); 
    Nrem_epoch=find(max_length==max(max_length)==1);%Look for largest NREM epoch

ff=waitbar(0,'Please wait...');
for nrem_epoch=1:length(v_hpc)

    aver=v_pfc{nrem_epoch};%NREM TRACE
    aver2=v_hpc{nrem_epoch};

    %Compute spectrogram
        t_aver=1:length(aver);
        t_aver=t_aver-1;
        t_aver=t_aver/1000;
        t_aver={t_aver};
        w=1;
        toy=[0.5:0.5:length(t_aver{1})/1000]; %secs 
        q={[aver aver aver ].'};
        freq4=barplot2_ft(q,t_aver,[100:2:300],w,toy,100);
        [freq4]=spectral_correction(freq4);%Reduces 1/f effect.
        new_freq4=freq4;
%%
if nrem_epoch==Nrem_epoch && answer_print==1
    %Visualization of spectrogram
    cfg              = [];
    cfg.channel      = freq4.label{w};
    cfg.colormap=colormap(jet(256));

    aa1=subplot(4,1,1)
    ft_singleplotTFR(cfg, freq4);
    xlim([0 max(t_aver{1})])
    g=title('High Frequencies PFC');
    g.FontSize=12;
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
end
    %Get matrix
    FREQ4=squeeze(freq4.powspctrm(1,1,:,:));
%     imagesc(FREQ4);colorbar();colormap(jet(1000))

    %REMOVE NaN and replace with median power
    med_pow=(median(FREQ4(~isnan(FREQ4))));
    std_pow=(std(FREQ4(~isnan(FREQ4))));
    FREQ4(isnan(FREQ4))=med_pow;
% xo
    %Thresholding s
    if RatID==26
         N=5;
    else
         N=7;
    end
   
    %nFREQ=FREQ4>N*med_pow;
    nFREQ=FREQ4> std_pow*N;
%     N=400;

    %Visualization
    dnFREQ=double(nFREQ);
    dnFREQ(nFREQ==0)=NaN;
    new_freq4.powspctrm(1,1,:,:)=dnFREQ;

    
%     figure()
if nrem_epoch==Nrem_epoch && answer_print==1
%     aa1=subplot(3,1,2)
    % TF = isoutlier(FREQ4,'percentiles',[0 99.5]);
    
    cfg              = [];
    cfg.channel      = new_freq4.label{w};
    cfg.masknans='yes'
    [ zmin1, zmax1] = ft_getminmax(cfg, new_freq4);

    %     I=imagesc(freq4.time,freq4.freq,nFREQ); C=colorbar(); %colormap(jet(10))
    cfg              = [];
    cfg.channel      = freq4.label{w};
    cfg.zlim=[0 1]; 
    cfg.colormap=colormap(jet(256));
    aa2=subplot(4,1,2)
    

    F=ft_singleplotTFR(cfg, new_freq4)
    xlabel('Time (s)')
    ylabel('Frequency (Hz)')
    g=title(['Thresholded values' ' STD x ' num2str(N) ]);
%    g=title(['Thresholded values' ' THR: ' num2str(N) ]);
%     g=title(['Thresholded values' ' THR: 500']);
    g.FontSize=12;
%     linkaxes([aa1 aa2 ],'xy')
%     printing(['microarousals_' num2str(N)])
%      printing(['microarousals_500test'])

%     close all
end

    %%
    
    nFREQ_ind=sum(nFREQ);
    nFREQ_ind=nFREQ_ind>0; 
    microarousal=nFREQ_ind;
%     xo
    [Micro]=microarousal_edges(microarousal); %Includes edges of spectrogram.
%     nFREQ_ind=not(nFREQ_ind);%1 is NOT a microarousal.
    nFREQ_ind=not(Micro);%1 is NOT a microarousal.


    N_ind=ConsecutiveOnes(nFREQ_ind);
    v_index2=find(N_ind~=0);
    v_values2=N_ind(N_ind~=0);
    %%
    %Chunk vector into 500ms windows.
    [NC_pfc]=chunk(aver,0.5);
    [NC_hpc]=chunk(aver2,0.5); 
%xo

    for epoch_count=1:length(v_index2)
        if v_index2(epoch_count)<= size(NC_pfc,2)
            v_new_pfc{epoch_count,1}=reshape(NC_pfc(:, v_index2(epoch_count):v_index2(epoch_count)+(v_values2(1,epoch_count)-1)), [], 1);
            v_new_hpc{epoch_count,1}=reshape(NC_hpc(:, v_index2(epoch_count):v_index2(epoch_count)+(v_values2(1,epoch_count)-1)), [], 1);
        end
    end 
    V_HPC=[V_HPC ;v_new_hpc];
    V_PFC=[V_PFC ;v_new_pfc];
    %%
%    xo
    if nrem_epoch==Nrem_epoch && answer_print==1
%         xo
%     Microarousal = repelem(microarousal,500);
%     Microarousal=[zeros(1,500) Microarousal];

    aa3=subplot(4,1,3)
    plot(([1:length(aver)]*(1/1000))-(1/1000),aver)
%     ntime=freq4.time(1)-0.25:0.25:freq4.time(end);
    
%  Microarousal=repelem(microarousal,2);
%  Microarousal=Microarousal(1:end-1);   
     hold on
%     area(([1:length(Microarousal)]*(1/1000))-(1/1000),max(aver)*Microarousal); alpha(.5)
    area(freq4.time,microarousal*max(aver)); alpha(0.4)
%     area(ntime,Microarousal*max(aver)); alpha(0.5)

   
    xlabel('Time (Sec)')
    title('Microarousal detection PFC')
    aa3.XLim=[0 max(freq4.time)];
    colorbar()
%    xo
aa4=subplot(4,1,4)
    plot(([1:length(aver2)]*(1/1000))-(1/1000),aver2)
%     ntime=freq4.time(1)-0.25:0.25:freq4.time(end);
    
%  Microarousal=repelem(microarousal,2);
%  Microarousal=Microarousal(1:end-1);   
     hold on
%     area(([1:length(Microarousal)]*(1/1000))-(1/1000),max(aver)*Microarousal); alpha(.5)
    area(freq4.time,microarousal*max(aver2)); alpha(0.4)
%     area(ntime,Microarousal*max(aver)); alpha(0.5)

   
    xlabel('Time (Sec)')
    title('Microarousal detection HPC')
    aa4.XLim=[0 max(freq4.time)];
    colorbar()
    
    
    
    linkaxes([aa1 aa2 aa3 aa4],'x')
    printing(['microarousals_complete_' num2str(N)])

%     printing(['microarousals_trace_std_x_' num2str(N)])
%    printing(['microarousals_trace_thr_' num2str(N)])
%    printing(['microarousals_trace_thr_500test'])

    close all
    end

progress_bar(nrem_epoch,length(v_hpc),ff)    
end

%%
xo
%%
%Ripple detection
V_hpc=cellfun(@(equis) filtfilt(b2,a2,equis), V_HPC ,'UniformOutput',false);
Mono_hpc=cellfun(@(equis) filtfilt(b1,a1,equis), V_hpc ,'UniformOutput',false); %100-300 Hz
signal2_hpc=cellfun(@(equis) times((1/0.195), equis)  ,Mono_hpc,'UniformOutput',false); %Remove convertion factor for ripple detection

V_pfc=cellfun(@(equis) filtfilt(b2,a2,equis), V_PFC ,'UniformOutput',false);
Mono_pfc=cellfun(@(equis) filtfilt(b1,a1,equis), V_pfc ,'UniformOutput',false); %100-300 Hz
signal2_pfc=cellfun(@(equis) times((1/0.195), equis)  ,Mono_pfc,'UniformOutput',false); %Remove convertion factor for ripple detection
fn=1000;

ti=cellfun(@(equis) reshape(linspace(0, length(equis)-1,length(equis))*(1/fn),[],1) ,signal2_hpc,'UniformOutput',false);
% ti_pfc=cellfun(@(equis) reshape(linspace(0, length(equis)-1,length(equis))*(1/fn),[],1) ,signal2_pfc,'UniformOutput',false);


% Find largest epoch.
max_length=cellfun(@length,v_new_hpc);
nrem_epoch=find(max_length==max(max_length)==1);
% Pop up window
f=figure();
movegui(gcf,'center');
f.Position=[f.Position(1) f.Position(2) 350 f.Position(4)/3];
movegui(gcf,'center');

%Checkboxes
manual_select = uicontrol('Style','checkbox','String','Manual selection of threshold','Position',[10 f.Position(4)-30 250 20],'Value',1);
manual_select.FontSize=11;
% aver_trial = uicontrol('Style','checkbox','String','Average trials','Position',[10 f.Position(4)-60 200 20]);
% aver_trial.FontSize=11;

set(f, 'NumberTitle', 'off', ...
    'Name', 'Select an option');

%Push button
c = uicontrol;
c.String = 'Continue';
c.FontSize=10;
c.Position=[f.Position(1)/7 c.Position(2)-10 f.Position(3)/2 c.Position(4)];

%Callback
c.Callback='uiresume(gcbf)';
uiwait(gcf); 
% scoring=scoring.Value;
manual_select=manual_select.Value;
% aver_trial=aver_trial.Value;
close(f);

%
if manual_select==0
    D1=4.*std(signal2_hpc{nrem_epoch}) 
    D2=4.*std(signal2_pfc{nrem_epoch})
else
%
    prompt = {'Select a threshold value for HPC'};
    dlgtitle = 'Threshold HPC';
    definput = {'100'};
    % opts.Interpreter = 'tex';
    answer = inputdlg(prompt,dlgtitle,[1 40],definput);
    D1=str2num(answer{1}) 
    %100 for Rat 26


    prompt = {'Select a threshold value for PFC'};
    dlgtitle = 'Threshold PFC';
    definput = {'30'};
    % opts.Interpreter = 'tex';
    answer = inputdlg(prompt,dlgtitle,[1 40],definput);
    D2=str2num(answer{1}) 
%35 for Rat 26
end
% SWR in HPC
%D1=100;%THRESHOLD
k=1;
    [Sx_hpc,Ex_hpc,Mx_hpc] =cellfun(@(equis1,equis2) findRipplesLisa(equis1, equis2, D1, (D1)*(1/2), [] ), signal2_hpc,ti,'UniformOutput',false);    
    swr_hpc(:,:,k)=[Sx_hpc Ex_hpc Mx_hpc];
    s_hpc(:,k)=cellfun('length',Sx_hpc);
% Cortical ripples
%D2=35;%THRESHOLD
    [Sx_pfc,Ex_pfc,Mx_pfc] =cellfun(@(equis1,equis2) findRipplesLisa(equis1, equis2, D2, (D2)*(1/2), [] ), signal2_pfc,ti,'UniformOutput',false);    
    swr_pfc(:,:,k)=[Sx_pfc Ex_pfc Mx_pfc];
    s_pfc(:,k)=cellfun('length',Sx_pfc);%% Cortical ripples

%%
% Find max and plot
max_length=cellfun(@length,V_HPC);
Max_L=(((not(cellfun(@isempty,swr_pfc(:,3)))))).*max_length; %Only show those which have cortical 'ripples'.
hpc=V_hpc{Max_L==max(Max_L)};
pfc=V_pfc{Max_L==max(Max_L)};

% plot((1:length(hpc))./1000./60,5.*zscore(hpc)+100,'Color','blue')
% hold on
% plot((1:length(pfc))./1000./60,5.*zscore(pfc)+150,'Color','red')
% xlabel('Time (Minutes)')
plot((1:length(hpc))./1000,5.*zscore(hpc)+100,'Color','blue')
hold on
plot((1:length(pfc))./1000,5.*zscore(pfc)+150,'Color','red')
xlabel('Time (Seconds)')

yticks([100 150])
yticklabels({'HPC','PFC'})
% a = get(gca,'YTickLabel');
% set(gca,'YTickLabel',a,'FontName','Times','fontsize',12)
b=gca;
b.FontSize=12;


n=find(Max_L==max(Max_L));
stem([swr_hpc{n,3}],ones(length([swr_hpc{n}]),1).*200,'Color','blue')

stem([swr_pfc{n,3}],ones(length([swr_pfc{n}]),1).*200,'Color','red')%Seconds
title('Raw traces after microarousal removal')
%%
answer1 = questdlg('Compute spectrograms?', ...
	'Select one', ...
	'Yes','No','No');
% Handle response
switch answer1
    case 'Yes'
        dessert = 1;
    case 'No'
        dessert = 0;
    otherwise
        xo
end


if dessert==1
%%  Spectrogram HPC

    % figure()
    figure('Name','HPC spectrogram','NumberTitle','off')
    aver=hpc;
    t_aver=1:length(aver);
    t_aver=t_aver-1;
    t_aver=t_aver/1000;
    t_aver={t_aver};

    w=1;
    %toy=[1:60:length(t_aver{1})/1000]; %secs
    toy=[1:0.10:length(t_aver{1})/1000]; %secs %480

    %toy=[-1:.01:1];
    % q={[aver  ].'};
    q={[aver aver aver ].'};

    freq4=barplot2_ft(q,t_aver,[100:2:300],w,toy);
    [freq4]=spectral_correction(freq4);

    cfg              = [];
    %cfg.zlim=zlim; %U might want to uncomment this if you use a smaller step: (Memory purposes)
    cfg.channel      = freq4.label{w};
    cfg.colormap=colormap(jet(256));

    a1=subplot(2,1,1)
    ft_singleplotTFR(cfg, freq4);
    xlim([0 max(t_aver{1})])
    g=title('High Frequencies HPC after microarousal removal');
    g.FontSize=12;
    xlabel('Time (s)')
    %ylabel('uV')
    ylabel('Frequency (Hz)')
    % xlim([0.3 0.8])

    a2=subplot(2,1,2)
    plot(t_aver{1},aver)
    xlim([0 max(t_aver{1})])
    colorbar()

    linkaxes([a1 a2],'x')

    %%  Spectrogram PFC

    % figure()
    figure('Name','PFC spectrogram','NumberTitle','off')
    aver=pfc;
    t_aver=1:length(aver);
    t_aver=t_aver-1;
    t_aver=t_aver/1000;
    t_aver={t_aver};

    w=1;
    %toy=[1:60:length(t_aver{1})/1000]; %secs
    toy=[1:0.25:length(t_aver{1})/1000]; %secs %480

    %toy=[-1:.01:1];
    % q={[aver  ].'};
    q={[aver aver aver ].'};

    freq4=barplot2_ft(q,t_aver,[100:2:300],w,toy);
    [freq4]=spectral_correction(freq4);

    cfg              = [];
    %cfg.zlim=zlim; %U might want to uncomment this if you use a smaller step: (Memory purposes)
    cfg.channel      = freq4.label{w};
    cfg.colormap=colormap(jet(256));

    a1=subplot(2,1,1)
    ft_singleplotTFR(cfg, freq4);
    xlim([0 max(t_aver{1})])
    g=title('High Frequencies PFC after microarousal removal');
    g.FontSize=12;
    xlabel('Time (s)')
    %ylabel('uV')
    ylabel('Frequency (Hz)')
    % xlim([0.3 0.8])

    a2=subplot(2,1,2)
    plot(t_aver{1},aver)
    xlim([0 max(t_aver{1})])
    colorbar()

    linkaxes([a1 a2],'x')
%%
end


%% Bandpassed signals.
%num_1=0;
figure()
hpc=signal2_hpc{Max_L==max(Max_L)};
pfc=signal2_pfc{Max_L==max(Max_L)};
ax1 = subplot(2,1,2)
plot((1:length(hpc))./1000./60,(hpc),'Color','blue')
title('HPC (100-300 Hz)')  
D=ones(1,length(hpc)).*D1;
hold on
plot((1:length(hpc))./1000./60,(D),'Color','black')

% yticks([num_1 (D1)+num_1])
% yticklabels({'HPC',['Thr: ' num2str(D1)]})
stem([swr_hpc{n,3}/60],ones(length([swr_hpc{n}]),1).*250,'Color','black')
xlabel('Time (Minutes)')
b=gca;
b.FontSize=10;

ax2 = subplot(2,1,1)
plot((1:length(pfc))./1000./60,(pfc),'Color','red')
title('PFC (100-300 Hz)')
D=ones(1,length(pfc)).*D2;
hold on
plot((1:length(pfc))./1000./60,D,'Color','black')

stem([swr_pfc{n,3}/60],ones(length([swr_pfc{n}]),1).*100,'Color','black')
xlabel('Time (Minutes)')
linkaxes([ax1 ax2 ],'xy')

% b = get(gca,'XTickLabel');
b=gca;
b.FontSize=10;
% set(gca,'XTickLabel',b,'FontName','Times','fontsize',10)
%set(gca,'XTickLabel',b,'FontName','Times','fontsize',10)

% %%  Spectrogram HPC
% 
% figure()
% aver=hpc;
% t_aver=1:length(aver);
% t_aver=t_aver-1;
% t_aver=t_aver/1000;
% t_aver={t_aver};
% 
% w=1;
% %toy=[1:60:length(t_aver{1})/1000]; %secs
% toy=[1:0.5:length(t_aver{1})/1000]; %secs %480
% 
% %toy=[-1:.01:1];
% % q={[aver  ].'};
% q={[aver aver aver ].'};
% 
% freq4=barplot2_ft(q,t_aver,[100:1:300],w,toy);
% [freq4]=spectral_correction(freq4);
% 
% cfg              = [];
% %cfg.zlim=zlim; %U might want to uncomment this if you use a smaller step: (Memory purposes)
% cfg.channel      = freq4.label{w};
% cfg.colormap=colormap(jet(256));
% 
% a1=subplot(2,1,1)
% ft_singleplotTFR(cfg, freq4);
% xlim([0 max(t_aver{1})])
% g=title('High Frequencies');
% g.FontSize=12;
% xlabel('Time (s)')
% %ylabel('uV')
% ylabel('Frequency (Hz)')
% % xlim([0.3 0.8])
% 
% a2=subplot(2,1,2)
% plot(t_aver{1},aver)
% xlim([0 max(t_aver{1})])
% colorbar()
% 
% linkaxes([a1 a2],'x')
% 
% %%  Spectrogram PFC
% 
% figure()
% aver=pfc;
% t_aver=1:length(aver);
% t_aver=t_aver-1;
% t_aver=t_aver/1000;
% t_aver={t_aver};
% 
% w=1;
% %toy=[1:60:length(t_aver{1})/1000]; %secs
% toy=[1:0.5:length(t_aver{1})/1000]; %secs %480
% 
% %toy=[-1:.01:1];
% % q={[aver  ].'};
% q={[aver aver aver ].'};
% 
% freq4=barplot2_ft(q,t_aver,[100:1:300],w,toy);
% [freq4]=spectral_correction(freq4);
% 
% cfg              = [];
% %cfg.zlim=zlim; %U might want to uncomment this if you use a smaller step: (Memory purposes)
% cfg.channel      = freq4.label{w};
% cfg.colormap=colormap(jet(256));
% 
% a1=subplot(2,1,1)
% ft_singleplotTFR(cfg, freq4);
% xlim([0 max(t_aver{1})])
% g=title('High Frequencies');
% g.FontSize=12;
% xlabel('Time (s)')
% %ylabel('uV')
% ylabel('Frequency (Hz)')
% % xlim([0.3 0.8])
% 
% a2=subplot(2,1,2)
% plot(t_aver{1},aver)
% xlim([0 max(t_aver{1})])
% colorbar()
% 
% linkaxes([a1 a2],'x')













%%
% %
% %ax3=subplot(2,1,2)
% plot((1:length(hpc))./1000./60,5.*zscore(hpc),'Color','blue')
% %stem([swr_hpc{n,3}/60],ones(length([swr_hpc{n}]),1).*5,'Color','blue')
% stem([swr_hpc{n,3}/60],ones(length([swr_hpc{n}]),1).*80,'Color','blue')
% title('HPC')
% xlabel('Time (Seconds)')
% 
% ax4=subplot(2,1,1)
% 
% plot((1:length(pfc))./1000./60,5.*zscore(pfc)+150,'Color','red')
% stem([swr_pfc{n,3}/60],ones(length([swr_pfc{n}]),1).*5,'Color','red')
% title('PFC')
% 
% xlabel('Time (Seconds)')

%%



% plot((1:length(hpc))./1000./60,5.*zscore(hpc)+100,'Color','blue')
% hold on
% plot((1:length(pfc))./1000./60,5.*zscore(pfc)+250,'Color',[1 0.5 0])
% xlabel('Time (Seconds)')



%%
% stem([swr_hpc{68}],ones(length([swr_hpc{68}]),1).*200)

% rip_times(:,:,1)=[Sx_hpc Ex_hpc Mx_hpc]; %Stack them    
% %%
% 
% for ind=1:size(s_hpc,2)
% veamos{:,ind}=find(s_hpc(:,ind)~=0);  %Epochs with ripples detected
% cara{:,:,ind}=swr_hpc(veamos{:,ind},:,ind);
% ripples_times{:,:,ind}=rip_times(veamos{:,ind},:,ind);
% 
% % veamos2{:,ind}=find(s217(:,ind)~=0);  %Epochs with ripples detected
% % cara2{:,:,ind}=swr217(veamos2{:,ind},:,ind);
% end
% 
% %%
% %Run ripple detection
% for kk=1:size(signal2_hpc,1)
%    % ti2{kk,1}=(transitions(kk,2):1/1000:transitions(kk,3));
%      ti{kk,1}=linspace(transitions(kk,2),transitions(kk,3),length(signal2_hpc{kk}));
% end
% 
% %%
% plot_traces(sig2,veamos,cara,ti,amp_vec,iii,labelconditions,chtm,include_hpc,cara_hpc,veamos_hpc,chtm_hpc);
% 


