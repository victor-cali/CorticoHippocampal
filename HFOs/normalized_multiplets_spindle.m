for n=1:4
% total_am(n)=sum(times(Out_PFC_post{n}(1,1),Out_PFC_post{n}(1,2)));
%total_am(n)=sum((Out_PFC_post{n}(1,2))); %All
total_am(n)=sum(times(Out_PFC_post{n}(1:end,1),Out_PFC_post{n}(1:end,2))); %All

end

for n=1:4
aver=squeeze(Out_rand_PFC(n,:,:));

for cont=1:1000
%     vec(All)=sum(aver(All,2:end).*[2:6]);
%      vec(All)=sum(aver(All,1)); %All
     vec(cont)=sum(aver(cont,1:end).*[1:6]); % All

end

histogram(vec)
xline(total_am(n),'-r','LineWidth',2)

    Y1 = prctile(vec,5)
    Y2 = prctile(vec,95)
    xline(Y1, '-.k','LineWidth',2)
    xline(Y2, '-.k','LineWidth',2)
    close All
aj(n)=(1+sum(vec >=total_am(n)))/(length(vec)+1)


% All_norm_post_24(n,:)=(vec-total_am(n))/std(vec);
All_PFC_norm_post_24(n,:)=(vec-total_am(n))/std(vec);

end
%% All conditions
% vec=All_norm_post_26(:);
% vec=All_norm_post_24(:);
vec=All_PFC_norm_post_24(:);

(1+sum(vec >=0))/(length(vec)+1)
clear vec
%%
%%
set(0,'defaultAxesFontName', 'Arial')
set(0,'defaultTextFontName', 'Arial')

labelconditions=[
    {'plusmaze'}
    {'baseline'      }
    {'foraging'     }
    {'novelty' }];

    
%n=1;% condition
for n=1:4
%w=1;
a_26=All_PFC_norm_post_26(n,:);
a_27=All_PFC_norm_post_27(n,:);
a_24=All_PFC_norm_post_24(n,:);

% a_26=All_norm_post_26(n,:);
% a_27=All_norm_post_27(n,:);
% a_24=All_norm_post_24(n,:);

% a_26=All_norm_post_26(n,:);
% a_27=All_norm_post_27(n,:);
% a_24=All_norm_post_24(n,:);

vec=[a_26 a_27 a_24];

% vec=a(:,mult);

histogram(vec,[-8.5:1:8.5],'FaceColor',[0 0 0])
    Y1 = prctile(vec,5)
    Y2 = prctile(vec,95)
    xline(Y1, '-.k','LineWidth',2)
     xline(Y2, '-.k','LineWidth',2)

xline(0, '-r','LineWidth',2)
xlim([-8 8])
xticks([-8:2:8])

aj(n)=(1+sum(vec >=0))/(length(vec)+1)

set(gca,'FontName','Arial')
set(gca,'FontSize',10)
 hold on
    ylabel('Frequency','FontSize',10,'FontName','Arial')
    xlabel('Count','FontSize',10,'FontName','Arial')
set(gca,'FontName','Arial')
set(gca,'FontSize',10)
ax = gca;
ax.YAxis.FontSize = 18 %for y-axis 
ax.XAxis.FontSize = 18 %for y-axis 
ax.XAxis.FontName='Arial';
ax.XAxis.FontName='Arial';

% printing(['PFC_Allplets_' labelconditions{n}])
close all

end
%%
a_26=All_PFC_norm_post_26(:,:);
a_26=a_26(:);
a_27=All_PFC_norm_post_27(:,:);
a_27=a_27(:);
a_24=All_PFC_norm_post_24(:,:);
a_24=a_24(:);

vec=[a_26; a_27; a_24]; %a_26; a_27; a_24
vec=vec(:);
(1+sum(vec >=0))/(length(vec)+1)


%% Counting Allplets, not individual ripples.

for n=1:4
total_am(n)=sum(Out_PFC{n}(:,2));
end

for n=1:4
aver=squeeze(Out_rand_PFC(n,:,:));

for All=1:1000
    vec(All)=sum(aver(All,:));
end

histogram(vec)
xline(total_am(n),'-r','LineWidth',2)

    Y1 = prctile(vec,5)
    Y2 = prctile(vec,95)
    xline(Y1, '-.k','LineWidth',2)
    xline(Y2, '-.k','LineWidth',2)
    close All
aj(n)=(1+sum(vec >=total_am(n)))/(length(vec)+1)


All_norm_All_units_24(n,:)=(vec-total_am(n))/std(vec);
end
