function [zlim,mdam]=spectra_window(Rat,nFF,level,ro,w,labelconditions,label1,label2,iii,p,timecell,sig1_nl,sig2_nl,ripple_nl,cara_nl,veamos_nl,CHTM2,q,timeasleep2,RipFreq3,RipFreq2,timeasleep,ripple,CHTM,acer,block_time,NFF,mergebaseline,FiveHun,meth,rat26session3,rat27session3,notch,sanity,quinientos,outlie,rat24base,datapath,spectra_winval,Zlim,win_comp,equal_num,RAT24_test,varargin)

randrip=varargin;
randrip=cell2mat(randrip);

if Rat==24 % && RAT24_test==0
%Remove artifact from Rat 24. 
% run('rat24_december.m')
if RAT24_test==0
    if w==2  
    p=p(1,end-60:end);
    q=q(1,end-60:end);

    else
        if iii~=3
            p=p(1,end-50:end);
            q=q(1,end-50:end);

        else
            p=p(1,end-100:end-50);
            q=q(1,end-100:end-50);

        end   
    end
end
    %PLUSMAZE PFC CORRECTION
        if iii==2 && w~=1
%             for cn=1:length(p)
%                 q{cn}(w,:)= q{cn}(w,:).*0.195;
%             end
            [q]=rip_magnitude(q,w);
            if w==3
%                 for cn=1:length(p)
%                     q{cn}(w,:)= q{cn}(w,:).*0.195;
%                 end
           % [q]=rip_magnitude(q,w);

    %         else
    %             for cn=1:length(p)
    %                 p{cn}(w,:)= p{cn}(w,:).*(1/0.195);
    %             end
            end
        end
    % p=p(1,end-120:end-60);
    % q=q(1,end-120:end-60);
end

%Non-learning
if iii==2 %Only run on the Plusmaze session.

%[p_nl,q_nl,~,sos_nl]=getwin2(cara_nl{:,:,level},veamos_nl{level},sig1_nl,sig2_nl,ro);    
[p_nl,q_nl,~,sos_nl]=getwin2(cara_nl{1},veamos_nl{1},sig1_nl,sig2_nl,ro);    


%Ripple selection
if Rat~=24 || RAT24_test==1
[p_nl,q_nl,sos_nl]=ripple_selection(p_nl,q_nl,sos_nl,Rat,meth);
end
% [length(p_nl) length(p_nl2)]
% disp(sos_nl)
%xo
% if iii~=3
% p_nl=p_nl(1,end-60:end);
% q_nl=q_nl(1,end-60:end);
% else
% p_nl=p_nl(1,end-120:end-60);
% q_nl=q_nl(1,end-120:end-60);    
% end

%ATTENTION
% % % % % % % % % % % % % % % % % % % if Rat==24
% % % % % % % % % % % % % % % % % % % p_nl=p_nl(1,end-120:end-60);
% % % % % % % % % % % % % % % % % % % q_nl=q_nl(1,end-120:end-60);    
% % % % % % % % % % % % % % % % % % % end

% % if outlie==1 
% % ache=max_outlier(p_nl);
% % p_nl=p_nl(ache);
% % q_nl=q_nl(ache);
% % end
% % 
% % if quinientos==0
% % [ran_nl]=select_rip(p_nl,FiveHun);
% % p_nl=p_nl([ran_nl]);
% % q_nl=q_nl([ran_nl]);
% % 
% % else
% %      if iii~=2
% %         [ran_nl]=select_quinientos(p_nl,length(randrip)); 
% %         p_nl=p_nl([ran_nl]);
% %         q_nl=q_nl([ran_nl]);
% %      %    ran=1:length(randrip);
% %      end
% % end

% % % % % % % % % % % % % % % % % % % % % % % % 
% % % % % % % % % % % % % % % % % % % % % % % % %No outliers
% % % % % % % % % % % % % % % % % % % % % % % % ache=max_outlier(p_nl);
% % % % % % % % % % % % % % % % % % % % % % % % p_nl=p_nl(ache);
% % % % % % % % % % % % % % % % % % % % % % % % q_nl=q_nl(ache);
% % % % % % % % % % % % % % % % % % % % % % % % %Find strongests rip_nlp_nlles. 
% % % % % % % % % % % % % % % % % % % % % % % % [p_nl,q_nl]=sort_rip(p_nl,q_nl);

%if Rat~=24 && rat24base~=2
%Equalize number of ripples. 
if equal_num==1 %&& Rat~=24
%Select n strongest
switch Rat
    case 24
        %n=550;
        %n=308;
        n=133;
    case 26
        n=180;
    case 27
        n=326;
    otherwise
        error('Error found')
end

p_nl=p_nl(1:n);
q_nl=q_nl(1:n);
% % % % % % % % % % % % % % % %Need to add sos_nl 
else
        if Rat==24 && RAT24_test==0
        p_nl=p_nl(1,end-120:end-60);
        q_nl=q_nl(1,end-120:end-60);    
        end
end

%Memory reasons:
if length(p_nl)>1000 %&& Rat~=24 %Novelty or Foraging
 p_nl=p_nl(1,1:1000);
 q_nl=q_nl(1,1:1000);
end
%end
% switch Rat
%     case 24
% %         n=550;
%         n=552;
%     case 26
% %         n=180;
%         n=385;
%     case 27
% %         n=326;
%         n=339;
% end
% 
% p=p(1:n);
% q=q(1:n);

%timecell_nl=timecell_nl([ran_nl]);
if sanity==1 && quinientos==0
 p_nl=p_nl(randrip);
 q_nl=q_nl(randrip);
end

[q_nl]=filter_ripples(q_nl,[66.67 100 150 266.7 133.3 200 300 333.3 266.7 233.3 250 166.7 133.3],.5,.5);

if mergebaseline==1
%% 
'MERGING BASELINES'
L1=length(p_nl);

NU{1}=p_nl;
QNU{1}=q_nl;
%% Other Baseline
if acer==0
    cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))
else
    cd(strcat('D:\internship\',num2str(Rat)))
end

cd(NFF{1}) %Baseline

% [sig1_nl,sig2_nl,ripple_nl,cara_nl,veamos_nl,CHTM2,RipFreq3,timeasleep2]=newest_only_ripple_level_ERASETHIS(level);
if meth==1
[sig1_nl,sig2_nl,ripple_nl,cara_nl,veamos_nl,CHTM2,RipFreq3,timeasleep2]=newest_only_ripple_level_ERASETHIS(level);
end

if meth==2
[sig1_nl,sig2_nl,ripple_nl,cara_nl,veamos_nl,CHTM2,RipFreq3,timeasleep2]=median_std;
end

if meth==3
chtm=load('vq_loop2.mat');
chtm=chtm.vq;
[sig1_nl,sig2_nl,ripple_nl,cara_nl,veamos_nl,RipFreq3,timeasleep2,~]=nrem_fixed_thr_Vfiles(chtm,notch);
CHTM2=[chtm chtm];
end


if meth==4

[timeasleep]=find_thr_base;
ror=2000/timeasleep;

    if acer==0
        cd(strcat('/home/raleman/Dropbox/Figures/Figure2/',num2str(Rat)))
    else
          %cd(strcat('C:\Users\Welt Meister\Dropbox\Figures\Figure2\',num2str(Rat)))   
          cd(strcat('C:\Users\addri\Dropbox\Figures\Figure2\',num2str(Rat)))   
    end

if Rat==26
Base=[{'Baseline1'} {'Baseline2'}];
end
if Rat==26 && rat26session3==1
Base=[{'Baseline3'} {'Baseline2'}];
end

if Rat==27 
Base=[{'Baseline2'} {'Baseline1'}];% We run Baseline 2 first, cause it is the one we prefer.
end

if Rat==27 && rat27session3==1
   Base=[{'Baseline2'} {'Baseline3'}];% We run Baseline 2 first, cause it is the one we prefer.    
end

base=2; %VERY IMPORTANT!
%openfig('Ripples_per_condition_best.fig')
h=openfig(strcat('Ripples_per_condition_',Base{base},'.fig'))

%h = gcf; %current figure handle
axesObjs = get(h, 'Children');  %axes handles
dataObjs = get(axesObjs, 'Children'); %handles to low-level graphics objects in axes

ydata=dataObjs{2}(8).YData;
xdata=dataObjs{2}(8).XData;
% figure()
% plot(xdata,ydata)
chtm = interp1(ydata,xdata,ror);
close(h)

if acer==0
    cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))
else
    cd(strcat('D:\internship\',num2str(Rat)))
end
cd(NFF{1})

%xo
[sig1_nl,sig2_nl,ripple_nl,cara_nl,veamos_nl,RipFreq3,timeasleep2,~]=nrem_fixed_thr_Vfiles(chtm,notch);
CHTM2=[chtm chtm];
end
%This seems incomplete:
% if meth==4
% [sig1_nl,sig2_nl,ripple_nl,cara_nl,veamos_nl,RipFreq3,timeasleep2,~]=nrem_fixed_thr_Vfiles(chtm,notch);
% CHTM2=[chtm chtm];
% end

if block_time==1
[cara_nl,veamos_nl]=equal_time2(sig1_nl,sig2_nl,cara_nl,veamos_nl,30,0);
ripple_nl=sum(cellfun('length',cara_nl{1}(:,1)));
end

if block_time==2
[cara_nl,veamos_nl]=equal_time2(sig1_nl,sig2_nl,cara_nl,veamos_nl,60,30);
ripple_nl=sum(cellfun('length',cara_nl{1}(:,1)));    
end

%[p_nl,q_nl,~,~]=getwin2(cara_nl{:,:,level},veamos_nl{level},sig1_nl,sig2_nl,label1,label2,ro,ripple_nl(level),CHTM2(level+1));
[p_nl,q_nl,~,~]=getwin2(cara_nl{:,:,level},veamos_nl{level},sig1_nl,sig2_nl,ro);

%%
clear sig1_nl sig2_nl

if quinientos==0
[ran_nl]=select_rip(p_nl,FiveHun);
p_nl=p_nl([ran_nl]);
q_nl=q_nl([ran_nl]);

else
     if iii~=2
        [ran_nl]=select_quinientos(p_nl,length(randrip)); 
        p_nl=p_nl([ran_nl]);
        q_nl=q_nl([ran_nl]);
     %    ran=1:length(randrip);
     end
end

%timecell_nl=timecell_nl([ran_nl]);
if sanity==1 && quinientos==0
 p_nl=p_nl(randrip);
 q_nl=q_nl(randrip);
end

%%
[q_nl]=filter_ripples(q_nl,[66.67 100 150 266.7 133.3 200 300 333.3 266.7 233.3 250 166.7 133.3],.5,.5);

NU{2}=p_nl;
QNU{2}=q_nl;
L2=length(p_nl);
amount=min([L1 L2]);
 
% p_nl(1:amount)=NU{1}(1:amount);
% p_nl(amount+1:2*amount)=NU{2}(1:amount);

p_nl(1:2*amount)=[NU{1}(1:amount) NU{1}(1:amount)];
p_nl(2:2:end)=[NU{2}(1:length(p_nl(2:2:end)))];


% q_nl(1:amount)=QNU{1}(1:amount);
% q_nl(amount+1:2*amount)=QNU{2}(1:amount);
q_nl(1:2*amount)=[QNU{1}(1:amount) QNU{1}(1:amount)];
q_nl(2:2:end)=[QNU{2}(1:length(q_nl(2:2:end)))];
    
    
end
clear sig1_nl sig2_nl 

end

% run('rat24_december_nl.m')

% % % %Need: P1, P2 ,p, q. 
% % % 
% % % P1=avg_samples(q,create_timecell(ro,length(p)));
% % % P2=avg_samples(p,create_timecell(ro,length(p)));

%cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))
% if acer==0
%     cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))
% else
%     cd(strcat(datapath,num2str(Rat)))
% end
% 
% %cd(strcat('D:\internship\',num2str(Rat)))
% cd(nFF{iii})
%%
%Plot both: No ripples and Ripples. 
if w==1 && iii==2
allscreen() 
end
%% Time Frequency plots
% Calculate Freq1 and Freq2

%toy=[-1:.01:1];
if ro==1200
%toy=[-1:.01:1];
    if  win_comp==0
        toy=[-.1:.001:.1];
    else
        toy=[-1:.01:1];
    end

else
%toy=[-10:.1:10];    
toy = [-10:.01:10];
end
%toy = [-1.2:.01:1.2];

if length(q)>1000
    q=q(1:1000);
end

if iii==2
if length(q_nl)>1000
    q_nl=q_nl(1:1000);
end
%         if w==1 && Rat==24
%         [q_nl]=rip_magnitude(q_nl,w);  %Magnitude correction
%         end
end


%By not equalizing the sizes of p and p_nl we assure that the spectrogram
%for NL wont change throughout the sessions.  There might be an issue with
%memory here. Would need to be solved using a max of i.e. 1000 ripples. 

if iii==2    
freq3=barplot2_ft(q_nl,create_timecell(ro,length(q_nl)),[100:1:300],w,toy);
end
freq4=barplot2_ft(q,create_timecell(ro,length(q)),[100:1:300],w,toy);


% Calculate zlim

%%
if spectra_winval==1
        if iii==2
        cfg              = [];
        cfg.channel      = freq3.label{w};
        [ zmin1, zmax1] = ft_getminmax(cfg, freq3);
        [zmin2, zmax2] = ft_getminmax(cfg, freq4);

        zlim=[min([zmin1 zmin2]) max([zmax1 zmax2])];
        
                if win_comp==0
                %Smaller windows values
                [mdam(1,1),mdam(2,1)]=smaller_window(freq3,w);
                [mdam(1,2),mdam(2,2)]=smaller_window(freq4,w);
                else
                    mdam=[];
                end
        
        else
        cfg              = [];
        cfg.channel      = freq4.label{w};
        [zmin2, zmax2] = ft_getminmax(cfg, freq4);
        zlim=[zmin2 zmax2];
        
                        if win_comp==0
                            %Smaller windows values
                            [mdam(1,1),mdam(2,1)]=smaller_window(freq4,w);
                        else
                            mdam=[];
                        end        
        end
else
    zlim=Zlim(w,:);
end

% zlim=[-max(abs(zlim)) max(abs(zlim))];

%%
cfg              = [];
cfg.zlim=zlim;% Uncomment this!
cfg.channel      = freq4.label{w};
cfg.colormap=colormap(jet(256));

%%
if iii==2
h(1)=subplot(3,4,4*(w-1)+1)
ft_singleplotTFR(cfg, freq3); 
% freq3=barplot2_ft(q_nl,timecell_nl,[100:1:300],w);
%if w==1
g=title('No Learning');
%end
g.FontSize=12;
xlabel('Time (s)')
%ylabel('uV')
ylabel('Frequency (Hz)')
ylim([100 250])
end
%%
%clear freq3
%%
% 
h(iii)=subplot(3,4,4*(w-1)+iii)

% freq4=barplot2_ft(q,timecell,[100:1:300],w)
%freq=justtesting(q,timecell,[100:1:300],w,0.5)
%title('High Gamma RIPPLE')
ft_singleplotTFR(cfg, freq4); 
% g=title(strcat('High Gamma',{' '},labelconditions{iii}));
%if w==1
g=title(strcat(labelconditions{iii}));
%end
g.FontSize=12;
%title(strcat('High Gamma',{' '},labelconditions{iii}))
%xo
xlabel('Time (s)')
%ylabel('uV')
ylabel('Frequency (Hz)')

% xlim([-.1 .1])
ylim([100 250])
end