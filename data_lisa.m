%%
function data_lisa(num)

str1=cell(6,1);
str1{1,1}='/media/raleman/My Book/ObjectSpace/rat_1/study_day_2_OR/post_trial1_2017-09-25_11-26-43';
str1{2,1}='/media/raleman/My Book/ObjectSpace/rat_1/study_day_2_OR/post_trial2_2017-09-25_12-17-49';
str1{3,1}='/media/raleman/My Book/ObjectSpace/rat_1/study_day_2_OR/post_trial3_2017-09-25_13-08-52';
str1{4,1}='/media/raleman/My Book/ObjectSpace/rat_1/study_day_2_OR/post_trial4_2017-09-25_14-01-00';
str1{5,1}='/media/raleman/My Book/ObjectSpace/rat_1/study_day_2_OR/post_trial5_2017-09-25_14-52-04';
str1{6,1}='/media/raleman/My Book/ObjectSpace/rat_1/study_day_2_OR/post_trial6_2017-09-26_11-10-21';

str2=cell(6,1);
str2{1,1}='/home/raleman/Documents/internship/Lisa_files/data/PT1';
str2{2,1}='/home/raleman/Documents/internship/Lisa_files/data/PT2';
str2{3,1}='/home/raleman/Documents/internship/Lisa_files/data/PT3';
str2{4,1}='/home/raleman/Documents/internship/Lisa_files/data/PT4';
str2{5,1}='/home/raleman/Documents/internship/Lisa_files/data/PT5';
str2{6,1}='/home/raleman/Documents/internship/Lisa_files/data/PT6';



% cd('/media/raleman/My Book/ObjectSpace/rat_1/study_day_2_OR/post_trial1_2017-09-25_11-26-43');
cd(str1{num,1});


fs=20000;
[data9m, ~, ~] = load_open_ephys_data_faster('100_CH14.continuous');
[data17m, ~, ~] = load_open_ephys_data_faster('100_CH46.continuous');
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