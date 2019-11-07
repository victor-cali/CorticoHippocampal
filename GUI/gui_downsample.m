%gui_downsample
%Downsamples ephys data.
function gui_downsample(channels,label1,labelconditions,labelconditions2,rats)

%SAMPLING FREQUENCY AND DOWNSAMPLED FREQUENCY.
prompt = {'Enter acquisition frequency (Hz):','Enter downsampling frequency (Hz):'};
dlgtitle = 'Input';
dims = [1 35];
definput = {'30000','1000'};
answer = inputdlg(prompt,dlgtitle,dims,definput)
fs=str2num(answer{1});
fs_new=str2num(answer{2});

%SELECT TRIALS
   answer = questdlg('Should we use all trials?', ...
            'Trial selection', ...
            'Use all','Select trials','Select trials');
        
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
        %g=g(contains(g,{'PT'}));
end
stage=an;

%Splits Multiple trials
if ~isempty(stage(contains(an,',')))
    stage=stage(contains(an,','));
    stage=stage{1};
    stage=strsplit(stage,',');
end

%Adds trials containing an initial capital letter.
idx = isstrprop(stage,'upper') ;
for indexup=1:length(idx)
     varind=idx{indexup};
     if varind(1)~=1
         vj=stage{indexup};
         vj(1)=upper(vj(1));
         stage= [stage vj];
     end
end

iter_no_saving=0; 

%SELECT RAT(S).
opts.Resize = 'on';
opts.WindowStyle = 'modal';
opts.Interpreter = 'tex';
prompt=strcat('\bf Select a rat#. Options:','{ }',num2str(rats));
answer = inputdlg(prompt,'Input',[2 30],{''},opts);
Rat=str2double(answer{1});
% Rat=str2num(answer{1});

%xo
%for RAT=1:length(rats) %4
% Rat=rats(RAT); 

%GET EPHYS AND NEW FOLDER.
dname=uigetdir([],strcat('Select folder with Ephys data for Rat',num2str(Rat)));
dname2=uigetdir([],strcat('Select folder where downsampled data should be saved'));
%%
%SELECT CONDITION.

%Center figure.
f=figure();
movegui(gcf,'center');

%Checkboxes
Boxcheck = cell(1,4);
for h1=1:length(labelconditions)
boxcheck = uicontrol('Style','checkbox','String',labelconditions{h1},'Position',[10 f.Position(4)-30*h1 200 20]);
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
labelconditions=labelconditions(find(boxch~=0));
labelconditions2=labelconditions2(find(boxch~=0));

close(f);
%%
%GO TO FOLDER AND READ ALL CONDITION FILES.
iii=1;
% for iii=4:length(labelconditions) 
 while iii<=length(labelconditions)  
%     if Rat==9 && strcmp(labelconditions{iii},'OR_N')
%         labelconditions{4}='OR+NOV';
%     end
%     if Rat==9 && strcmp(labelconditions{iii},'HC')
%         labelconditions{iii}='homecage';
%     end

cd(dname)
% aa=getfolder;

% if contains(aa{1},'rat') || contains(aa{1},'Rat')
%     
% end

%xo
[BB,labelconditions,labelconditions2]=select_folder(Rat,iii,labelconditions,labelconditions2);
cd(BB)
%%
A=getfolder;
%Look for trial
var=zeros(size(A));
for j=1:length(stage)
aver=cellfun(@(x) strfind(x,stage{j}),A,'UniformOutput',false);
aver=cellfun(@(x) length(x),aver,'UniformOutput',false);
var=or(cell2mat(aver),var);
end

%In case of extra folder
if var==0
 cd(A{1})
        A=getfolder;
        %Look for trial
        var=zeros(size(A));
        for j=1:length(stage)
        aver=cellfun(@(x) strfind(x,stage{j}),A,'UniformOutput',false);
        aver=cellfun(@(x) length(x),aver,'UniformOutput',false);
        var=or(cell2mat(aver),var);
        end 
end

A=A(var);
A=A.';
%%
% for n=1:size(A,1)
%     ch=A{n};
%     ch=ch(~isletter(ch));
%     ch=strsplit(ch,'_')
%     ch=ch(~cellfun('isempty',ch));
%     ch=ch(~cellfun(@isnumeric,ch));
%     ch2=cellfun('length',ch);
%     ch=ch(ch2~=1);
%     ch=strrep(ch,'-','+');
%     ch=strrep(ch,'_','+');
%     B(n,:)=cellfun(@str2num,ch);
% end

%%
str2=cell(size(A,1),1);

    
   for j=1:length(stage)
       cont=0;
       for n=1:size(A,1)
              
            if n==1
                
            end
           
            if contains(A{n},stage{j})
              cont=cont+1;  
              str2{n,1}=strcat(stage{j},num2str(cont));   

            end       
       end
     %str2{n,1}=strcat(stage{1},num2str(n));
   end
%%
%LABEL TRIALS.

f = figure(2);
set(f, 'NumberTitle', 'off', ...
    'Name',strcat('Rat',num2str(Rat),'_',labelconditions{iii}));

c = uicontrol('Style','text','Position',[1 380 450 30]);
% c = uicontrol('Style','text','Position',[1 380 450 20]);
% c.String = {'Edit the Label column with the correct trial index according to the dates.'};
c.String =sprintf('%s\n%s','Edit the Label column with the correct trial index according to the dates.','Leave blank if trial is corrupted.');
%{'Edit the Label column with the correct trial index according to the dates' 'Leave blank if trial is corrupted.'};
c.FontSize=10;
c.FontAngle='italic';

% label = uilabel(f,...
%     'Position',[100 164 100 15],...
%     'Text','Enter Comments:');
uit = uitable(f);
% d = {A,str2};
uit.Data = [A str2];
uit.ColumnName={'File name'; 'Label'};
uit.ColumnWidth= {200,50};;
% uit.Position = [20 20 258 78];


% t = uitable('Parent',f,'Data',dat,'ColumnName',cnames,... 
%             'RowName',rnames,'Position',[20 280 450 100]);
        
set(uit,'ColumnEditable',true(1,2))
h = uicontrol('Position',[350 20 100 40],'String','Confirm',...
              'Callback','uiresume(gcbf)');
h.FontSize=10;
uiwait(gcf); 
str2= get(uit,'Data');   
str2=str2(:,2);
%Remove corrupted trials.
close(f);
str1=A;
str1=str1(not(cellfun('isempty',str2)));
A=A(not(cellfun('isempty',str2)));
str2=str2(not(cellfun('isempty',str2)));
%%
% if strcmp(BB,'Study_day7_OR_N_1_2mar2018')
% cd(BB)    
% end
% %xo
% if Rat==6 || Rat==9 || Rat==11
% [str1,str2]=select_trial('Pre',Rat,stage);    
% else
% [str1,str2]=select_trial('pre',Rat,stage);        
% end
% xo
% %Reverse order of wrong strings. 
% S=sum(cell2mat(cellfun(@(x) strfind(x,'pre-sleep'), str1,'UniformOutput',0)));
% if S==1 && length(str1)>1
% str1=sortrows(str1,[-1 1]);    
% end

% str2={'PT5'};
f=waitbar(0,'Please wait...');
for num=1:length(str1)
    %length(str1)
       
% if strcmp(BB,'Study_day7_OR_N_1_2mar2018') && num>1
% cd(BB)    
% end
 chfol=getfolder;
 if length(chfol)==1
     cd(chfol{1})
 end
 
    cd(str1{num,1});
%     xo
 if iter_no_saving~=1   
%         if Rat==11
% 
%             if Rat==11 && num==5 && iii==3
%             [ax1, ~, ~] = load_open_ephys_data_faster('100_AUX1_2_0.continuous');
%             [ax2, ~, ~] = load_open_ephys_data_faster('100_AUX2_2_0.continuous');
%             [ax3, ~, ~] = load_open_ephys_data_faster('100_AUX3_2_0.continuous'); 
%             else
% 
%             [ax1, ~, ~] = load_open_ephys_data_faster('100_AUX1_0.continuous');
%             [ax2, ~, ~] = load_open_ephys_data_faster('100_AUX2_0.continuous');
%             [ax3, ~, ~] = load_open_ephys_data_faster('100_AUX3_0.continuous');   
% 
%             end
% 
% 
%         else
%             [ax1, ~, ~] = load_open_ephys_data_faster('100_AUX1.continuous');
%             [ax2, ~, ~] = load_open_ephys_data_faster('100_AUX2.continuous');
%             [ax3, ~, ~] = load_open_ephys_data_faster('100_AUX3.continuous');    
%         end



        % Verifying time
%          l=length(ax1); %samples
%         % t=l*(1/fs); %  2.7276e+03  seconds
%         % Equivalent to 45.4596 minutes
%         t=1:l;
%         t=t*(1/fs);

%         sos=ax1.^2+ax2.^2+ax3.^2;    
%         clear ax1 ax2 ax3 

        Wn=[(fs_new/2)/(fs/2) ]; % Cutoff=500 Hz 
        [b,a] = butter(3,Wn); %Filter coefficients for LPF
% 
%         sos=filtfilt(b,a,sos);
%         sos=decimator(sos,20);

    vr=getfield(channels,strcat('Rat',num2str(Rat)));%Electrode channels. 

    cfold=dir;
    cfold={cfold.name};
    cfold=cfold(cellfun(@(x) contains(x,'CH'),cfold));
    
    cf1=cfold(cellfun(@(x) contains(x,num2str(vr(1))),cfold));
    cf2=cfold(cellfun(@(x) contains(x,num2str(vr(2))),cfold));
    
    if size(cf1,1)~=1 || size(cf2,1)~=1 
        error('Ambiguous channel')
        xo
    end

    %Hippocampus
    [HPC, ~, ~] = load_open_ephys_data_faster(cf1{1});    
    HPC=filtfilt(b,a,HPC);
    HPC=decimator(HPC,fs/fs_new);


%     [HPC, ~, ~] = load_open_ephys_data_faster(cf1{1});    
%     HPC=filtfilt(b,a,HPC);
%     HPC=decimator(HPC,20);

    %PFC
%     [PFC, ~, ~] = load_open_ephys_data_faster(cf2{1});
%     PFC=filtfilt(b,a,PFC);
%     PFC=decimator(PFC,20);
    [PFC, ~, ~] = load_open_ephys_data_faster(cf2{1});
    PFC=filtfilt(b,a,PFC);
    PFC=decimator(PFC,fs/fs_new);

    %strcat('100_CH',num2str(vr(1)),'.continuous')

 end

% cd(strcat('F:\Lisa_files\',num2str(Rat)))
cd(dname2)
% if ~exist(num2str(Rat))
if ~isfolder(num2str(Rat))
    mkdir(num2str(Rat))
end
cd(num2str(Rat))

% if ~exist(labelconditions2{iii}, 'dir')
if ~isfolder(labelconditions2{iii})    
   mkdir(labelconditions2{iii})
end
cd(labelconditions2{iii})
%xo

% cd(stage(1))
% mkdir(stage{1})
% mkdir(stage{2})

% G=getfolder;
% if sum(cellfun(@(x) strcmp(x,'Pre_trial'), G))>=1
% rmdir Pre_trial 
% rmdir Post_trial
% end

if ~exist(str2{num}, 'dir')
   mkdir(str2{num})
end

cd(str2{num})
if iter_no_saving~=1
 save('PFC.mat','PFC')
 save('HPC.mat','HPC')
%  save('sos.mat','sos')
 ftext = fopen( str1{num}, 'w' );  
 fclose(ftext);
end
clear PFC HPC %sos

%xo
cd(strcat(dname,'/',BB))

%  if Rat<9
%      cd(strcat('F:\ephys\rat',num2str(Rat),'\',BB))
%  else
%      cd(strcat('G:\ephys'))
%      aa=getfolder;
%      if Rat==9
%          cd(strcat(aa{2},'/',BB))
%      else
%          cd(strcat(aa{1},'/',BB))
%      end
%  end
 
%     %%
%    [vtr]=findsleep(sos,median(sos)/100,t); %Threshold. 0.006
%
%     plot(sos(100000/2:400000))
%     hold on
%     stripes((vtr(100000/2:400000)),0.5)
    %%
%     vin=find(vtr~=1);

% xo
% [a1,a2] = unique(vtr);
% 
% [G,ID] = findgroups(vtr);
% out = double(diff([~vtr(1);vtr(:)]) == 1);
% v = accumarray(cumsum(out).*vtr(:)+1,1);
% out(out == 1) = v(2:end);
    
    %Create transition matrix
%    xo
        
        
progress_bar(num,length(str1),f)    
end
iii=iii+1;
%xo
end

end






