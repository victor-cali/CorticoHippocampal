function presleep(num)

str1=cell(2,1);
str1{1,1}='/media/raleman/My Book/ObjectSpace/rat_1/study_day_2_OR/pre-sleep_2017-09-26_10-14-42';
str1{2,1}='/media/raleman/My Book/ObjectSpace/rat_1/study_day_2_OR/presleep_2017-09-25_10-30-34';

%str1{6,1}='/media/raleman/My Book/ObjectSpace/rat_1/study_day_2_OR/post_trial6_2017-09-26_11-10-21';


str2=cell(2,1);
str2{1,1}='/home/raleman/Documents/internship/Lisa_files/data/Presleep1';
str2{2,1}='/home/raleman/Documents/internship/Lisa_files/data/Presleep2';
% str2{3,1}='/home/raleman/Documents/internship/Lisa_files/data/PT3';
% str2{4,1}='/home/raleman/Documents/internship/Lisa_files/data/PT4';
% str2{5,1}='/home/raleman/Documents/internship/Lisa_files/data/PT5';
%str2{6,1}='/home/raleman/Documents/internship/Lisa_files/data/PT6';



% cd('/media/raleman/My Book/ObjectSpace/rat_1/study_day_2_OR/post_trial1_2017-09-25_11-26-43');
cd(str1{num,1});


fs=20000;
[data9m, ~, ~] = load_open_ephys_data_faster('100_CH14.continuous');
% if num==5
%     st=30*(60)*(fs);
%     dat=cell(6,1);
%     dat{1,1}=data9m(1:st);
%     dat{2,1}=data9m(st+1:2*st);
%     dat{3,1}=data9m(2*st+1:3*st);
%     dat{4,1}=data9m(3*st+1:4*st);
%     dat{5,1}=data9m(4*st+1:5*st);
%     dat{6,1}=data9m(5*st+1:end);
%     clear data9m    
% end
% save('dat.mat','dat')

[data17m, ~, ~] = load_open_ephys_data_faster('100_CH46.continuous');
% if num==5
%     st=30*(60)*(fs);
%     dat2=cell(6,1);
%     dat2{1,1}=data17m(1:st);
%     dat2{2,1}=data17m(st+1:2*st);
%     dat2{3,1}=data17m(2*st+1:3*st);
%     dat2{4,1}=data17m(3*st+1:4*st);
%     dat2{5,1}=data17m(4*st+1:5*st);
%     dat2{6,1}=data17m(5*st+1:end);
%     clear data17m    
% end
% 
% save('dat2.mat','dat2')

% Loading accelerometer data
[ax1, ~, ~] = load_open_ephys_data_faster('100_AUX1.continuous');
[ax2, ~, ~] = load_open_ephys_data_faster('100_AUX2.continuous');
[ax3, ~, ~] = load_open_ephys_data_faster('100_AUX3.continuous');


% Verifying time
 l=length(ax1); %samples
% t=l*(1/fs); %  2.7276e+03  seconds
% Equivalent to 45.4596 minutes
t=1:l;
t=t*(1/fs);

sos=ax1.^2+ax2.^2+ax3.^2;
clear ax1 ax2 ax3 



% close all
%[vtr]=findsleep(sos,0.006,t); %post_trial2
[vtr]=findsleep(sos,0.006,t); %post_trial3


vin=find(vtr~=1);
%tvin=vin*(1/fs);

C9=data9m(vin).*(0.195);
C17=data17m(vin).*(0.195);

clear data17m data9m

cd(str2{num,1});

% cd('/home/raleman/Documents/internship/Lisa_files/data/PT1')
save('C9.mat','C9')
save('C17.mat','C17')
clear all
end

% %
%     st=30*(60)*(fs);
%     C17m=cell(6,1);
%     C17m{1,1}=C17(1:st);
%     C17m{2,1}=C17(st+1:2*st);
%     C17m{3,1}=C17(2*st+1:3*st);
%     C17m{4,1}=C17(3*st+1:4*st);
%     C17m{5,1}=C17(4*st+1:5*st);
%     C17m{6,1}=C17(5*st+1:end);
%         
% %%
% st=30*(60)*(fs);
%     C9m=cell(6,1);
%     C9m{1,1}=C9(1:st);
%     C9m{2,1}=C9(st+1:2*st);
%     C9m{3,1}=C9(2*st+1:3*st);
%     C9m{4,1}=C9(3*st+1:4*st);
%     C9m{5,1}=C9(4*st+1:5*st);
%     C9m{6,1}=C9(5*st+1:end);
% 