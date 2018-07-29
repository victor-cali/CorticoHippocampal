acer=1;

%%
if acer==0
addpath('/home/raleman/Documents/MATLAB/analysis-tools-master'); %Open Ephys data loader. 
addpath('/home/raleman/Documents/GitHub/CorticoHippocampal')
addpath('/home/raleman/Documents/internship')
else
addpath('D:\internship\analysis-tools-master'); %Open Ephys data loader.
addpath('C:\Users\addri\Documents\internship\CorticoHippocampal')
   
end
%%
%Rat=26;
for Rat=4:4
rats=[26 27 21 24];
Rat=rats(Rat);    
    
% for Rat=26:26
if Rat==26
nFF=[
%    {'rat26_Base_II_2016-03-24'                         }
%    {'rat26_Base_II_2016-03-24_09-47-13'                }
%    {'rat26_Base_II_2016-03-24_12-55-58'                }
%    {'rat26_Base_II_2016-03-24_12-57-57'                }
    
   
%    {'rat26_nl_base_III_2016-03-30_10-32-57'            }
     {'rat26_nl_base_II_2016-03-28_10-40-19'             }
%     {'rat26_nl_baseline2016-03-01_11-01-55'             }
    {'rat26_plusmaze_base_2016-03-08_10-24-41'}
    
    
    
    {'rat26_novelty_I_2016-04-12_10-05-55'          }
%     {'rat26_novelty_II_2016-04-13_10-23-29'             }
    {'rat26_for_2016-03-21_10-38-54'                    }
%     {'rat26_for_II_2016-03-23_10-49-50'                 }
    
    ];

% labelconditions=[
%     {'Baseline_1' 
%      'Baseline_2'}
%      'Baseline_3'
%      'PlusMaze'
%      'Novelty_1'
%      'Novelty_2'
%      'Foraging_1'
%      'Foraging_2'
%     ];

labelconditions=[
    { 
    
    'Baseline'}
%     'Baseline_2'
%     'Baseline_3'
     'PlusMaze'    
     'Novelty'
%      'Novelty_2'
     'Foraging'
%      'Foraging_2'
    ];


end
if Rat==27
nFF=[
    {'rat27_nl_base_2016-03-28_15-01-17'                   }
   % {'rat27_NL_baseline_2016-02-26_12-50-26'               }
   % {'rat27_nl_base_III_2016-03-30_14-36-57'               }
    
    {'rat27_plusmaze_base_2016-03-14_14-52-48'             }
%     {'rat27_plusmaze_base_II_2016-03-24_14-10-08'          }
    {'rat27_novelty_I_2016-04-11_14-34-55'                 } 
    {'rat27_for_2016-03-21_15-03-05'                       }
    %{'Rat27_for_II_2016-03-23_15-06-59'                    }
    
    %{'rat27_novelty_II_2016-04-13_14-37-58'                }  %NO .MAT files found. 
    %{'rat27_novelty_II_2016-04-13_16-29-42'                } %No (complete).MAT files found.
   
  
%     {'rat27_plusmaze_dis_2016-03-10_14-35-18'              }
%     {'rat27_plusmaze_dis_II_2016-03-16_14-36-07'           }
%     {'rat27_plusmaze_dis_II_2016-03-18_14-46-24'           }
%     {'rat27_plusmaze_jit_2016-03-08_14-46-31'              }
%     {'rat27_plusmaze_jit_II_2016-03-16_15-02-27'           }
%     {'rat27_plusmaze_swrd_qPCR_2016-04-15_14-28-41'        }
%     {'rat27_watermaze_dis_morning_2016-04-06_10-18-36'     }
%     {'rat27_watermaze_jitter_afternoon_2016-04-06_15-41-51'}  
    ]

labelconditions=[
    { 
    'Baseline'}
%     'Baseline_2'
%     'Baseline_3'
    'PlusMaze'
%     'PlusMaze_2'
    'Novelty'
    'Foraging'
    
  %   'Foraging_2'
     
    
    
     
    ];

    
end

if Rat==21
 
 nFF=[  
    {'2015-11-27_13-50-07 5h baseline'             }
    {'rat21 baselin2015-12-11_12-52-58'            }
    {'rat21_learningbaseline2_2015-12-10_15-24-17' }
    {'rat21with45minlearning_2015-12-02_14-25-12'  }
    %{'rat21t_maze_2015-12-14_13-29-07'             }
    {'rat21 post t-maze 2015-12-14_13-30-52'       }
    
];

%%
labelconditions=[
    {    
     'Learning Baseline'
                }
     
     '45minLearning'
     'Novelty_2'
     't-maze'
     'Post t-maze'
    ];
    
end

if Rat==24
nFF=[  
    {'Baseline1'}
    {'Baseline2'}
    {'Baseline3'}
    {'Baseline4'}
    {'Plusmaze1'}
    {'Plusmaze2'}
       
];       
labelconditions=nFF;
end

%% Go to main directory
if acer==0
    cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))
    addpath /home/raleman/Documents/internship/fieldtrip-master/
    InitFieldtrip()

    cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))
    clc
else
    cd(strcat('D:\internship\',num2str(Rat)))
    addpath D:\internship\fieldtrip-master
    InitFieldtrip()

    % cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))
    cd(strcat('D:\internship\',num2str(Rat)))
    clc
end

%% Select experiment to perform. 

Score=1;

myColorMap = jet(8);                                                                                                                                                                                    
myColorMap =myColorMap([2 4 5 7],:);
myColorMap(2,:)=[0, 204/255, 0];
myColorMap(3,:)=[0.9290, 0.6940, 0.1250];
if Rat==24
    myColorMap = jet(length(nFF));                                                                                                                                                                                    
end


for iii=1:length(nFF)

    
%  clearvars -except nFF iii labelconditions inter granger Rat ro label1 label2 coher selectripples acer mergebaseline nr_27 nr_26 co_26 co_27 nrem notch myColorMap



%for level=1:length(ripple)-1;    
 %for level=1:1
     
for w=1:1

if acer==0
    cd(strcat('/home/raleman/Documents/internship/',num2str(Rat)))
else
    cd(strcat('D:\internship\',num2str(Rat)))
end

cd(nFF{iii})

%xo
if Rat==24
   load('states.mat')
else
    if Score==2 && (strcmp(labelconditions{iii},'Baseline') || strcmp(labelconditions{iii},'PlusMaze'))
         load('states2.mat')
    else
        st=strcat(nFF{iii},'-states.mat');
        load(st) 
    end
end
% 
 %xo
% Z{iii}=states;
% % %%
L= length(states)/60%min

 g1=sum(states==1)/60; %Wake
 g3=sum(states==3)/60; %NREM
 g4=sum(states==4)/60; %Transitional Sleep
 g5=sum(states==5)/60; %REM

 G=[g1 g3 g4 g5];
 g=G;
 G=G/L*100

Z{iii}=G;
X{iii}=g; 
 %  v=G;
% %%
% f=figure();
%    %v =sort(v,'descend');
% bb=bar([v; nan(1,length(v))], 'Stacked');
% %set(gca,'xtick',1)}
% xlim([0 3])
% lg=legend(fliplr(bb),strcat('State1:','{ }',num2str(round(v(4))),'%'),strcat('State2:','{ }',num2str(round(v(3))),'%'),strcat('State3:','{ }',num2str(round(v(2))),'%'),strcat('State4:','{ }',num2str(round(v(1))),'%'));
% % camroll(-90)
% lg.Location='east'
% %lg.FontSize=18
% 


end


%%

end
% xo
%end



if Rat~=24
%%
% ax=figure();
allscreen()
y = [Z{1};Z{2};Z{3};Z{4}];
c = categorical({'Baseline','Plusmaze','Novelty','Foraging'});
bb=bar(c,y,'stacked')
ylabel('Cumulative percentage of sleep','FontSize',16)
lg=legend('Wake','NREM','Transitional Sleep','REM')
lg.Location='eastoutside';
lg.FontSize=14
ax = gca;
ax.XAxis.FontSize = 16;
ax.YAxis.FontSize = 16;
%%
dim = [.14 .2 .2 .2];
st1=strcat('Wake: ','{  }',num2str(round(X{1}(1))), ' min','{      }');
st2=strcat('NREM: ','{ }',num2str(round(X{1}(2))), ' min','{        }');
st3=strcat('T.S.: ','{     }',num2str(round(X{1}(3))), ' min','{     }');
st4=strcat('REM: ','{    }',num2str(round(X{1}(4))), ' min','{       }');
st6='------------------------';
st5=strcat('Total: ','{ }',num2str(sum(round(X{1}))), ' min','{      }');


str=[st1;st2;st3;st4;st6;st5];
%str = [ strcat('Wake:',num2str(round(X{1}(1))), ' min'); strcat('NREM:',num2str(round(X{1}(2))), '  min'); strcat('T.S. :',num2str(round(X{1}(3))), '  min');strcat('REM:  ',num2str(round(X{1}(4))), '  min')];
A=annotation('textbox',dim,'String',str,'FitBoxToText','on','FontSize',12);
A.BackgroundColor=[1 1 1]
%%
dim = [.307 .2 .2 .2];
st1=strcat('Wake: ','{  }',num2str(round(X{4}(1))), ' min','{      }');
st2=strcat('NREM: ','{ }',num2str(round(X{4}(2))), ' min','{        }');
if Rat==27
st3=strcat('T.S.: ','{     }',num2str(round(X{4}(3))), ' min','{     }');
st4=strcat('REM: ','{    }',num2str(round(X{4}(4))), ' min','{       }');
else
st3=strcat('T.S.: ','{     }',num2str(round(X{4}(3))), ' min','{     }');
st4=strcat('REM: ','{    }',num2str(round(X{4}(4))), ' min','{       }');    
end
st6='------------------------';
st5=strcat('Total: ','{ }',num2str(sum(round(X{4}))), ' min','{      }');


str=[st1;st2;st3;st4;st6;st5];
%str = [ strcat('Wake:',num2str(round(X{1}(1))), ' min'); strcat('NREM:',num2str(round(X{1}(2))), '  min'); strcat('T.S. :',num2str(round(X{1}(3))), '  min');strcat('REM:  ',num2str(round(X{1}(4))), '  min')];
B=annotation('textbox',dim,'String',str,'FitBoxToText','on','FontSize',12);
B.BackgroundColor=[1 1 1]
%%

dim = [.472 .2 .2 .2];
st1=strcat('Wake: ','{  }',num2str(round(X{3}(1))), ' min','{      }');
if Rat==27
st2=strcat('NREM: ','{ }',num2str(round(X{3}(2))), ' min','{       }');
else
st2=strcat('NREM: ','{ }',num2str(round(X{3}(2))), ' min','{        }');    
end
st3=strcat('T.S.: ','{     }',num2str(round(X{3}(3))), ' min','{     }');
st4=strcat('REM: ','{    }',num2str(round(X{3}(4))), ' min','{       }');
st6='------------------------';
st5=strcat('Total: ','{ }',num2str(sum(round(X{3}))), ' min','{      }');


str=[st1;st2;st3;st4;st6;st5];
%str = [ strcat('Wake:',num2str(round(X{1}(1))), ' min'); strcat('NREM:',num2str(round(X{1}(2))), '  min'); strcat('T.S. :',num2str(round(X{1}(3))), '  min');strcat('REM:  ',num2str(round(X{1}(4))), '  min')];
C=annotation('textbox',dim,'String',str,'FitBoxToText','on','FontSize',12);
C.BackgroundColor=[1 1 1]

%%

dim = [.64 .2 .2 .2];
st1=strcat('Wake: ','{  }',num2str(round(X{2}(1))), ' min','{      }');
st2=strcat('NREM: ','{ }',num2str(round(X{2}(2))), ' min','{        }');
st3=strcat('T.S.: ','{     }',num2str(round(X{2}(3))), ' min','{     }');
st4=strcat('REM: ','{    }',num2str(round(X{2}(4))), ' min','{       }');
st6='------------------------';
st5=strcat('Total: ','{ }',num2str(sum(round(X{2}))), ' min','{      }');


str=[st1;st2;st3;st4;st6;st5];
%str = [ strcat('Wake:',num2str(round(X{1}(1))), ' min'); strcat('NREM:',num2str(round(X{1}(2))), '  min'); strcat('T.S. :',num2str(round(X{1}(3))), '  min');strcat('REM:  ',num2str(round(X{1}(4))), '  min')];
D=annotation('textbox',dim,'String',str,'FitBoxToText','on','FontSize',12);
D.BackgroundColor=[1 1 1]

else
%% Rat 24    
allscreen()
y = [Z{1};Z{2};Z{3};Z{4};Z{5};Z{6}];
c = categorical({'Baseline 1','Baseline 2','Baseline 3','Baseline 4','Plusmaze 1','Plusmaze 2'});
bb=bar(c,y,'stacked')
ylabel('Cumulative percentage of sleep','FontSize',16)
lg=legend('Wake','NREM','Transitional Sleep','REM')
lg.Location='eastoutside';
lg.FontSize=14
ax = gca;
ax.XAxis.FontSize = 16;
ax.YAxis.FontSize = 16;

dim = [.12 .2 .2 .2];
st1=strcat('Wake: ','{  }',num2str(round(X{1}(1))), ' min','{      }');
st2=strcat('NREM: ','{ }',num2str(round(X{1}(2))), ' min','{       }');
st3=strcat('T.S.: ','{     }',num2str(round(X{1}(3))), ' min','{     }');
st4=strcat('REM: ','{    }',num2str(round(X{1}(4))), ' min','{      }');
st6='------------------------';
st5=strcat('Total: ','{ }',num2str(sum(round(X{1}))), ' min','{      }');


str=[st1;st2;st3;st4;st6;st5];
%str = [ strcat('Wake:',num2str(round(X{1}(1))), ' min'); strcat('NREM:',num2str(round(X{1}(2))), '  min'); strcat('T.S. :',num2str(round(X{1}(3))), '  min');strcat('REM:  ',num2str(round(X{1}(4))), '  min')];
A=annotation('textbox',dim,'String',str,'FitBoxToText','on','FontSize',12);
A.BackgroundColor=[1 1 1]
    
%A.Position=[0.1200 0.2259 0.1115 0.1741];
A.Position=[0.1195    0.2259    0.1045    0.1741];

dim = [.23 .2 .2 .2];
st1=strcat('Wake: ','{  }',num2str(round(X{2}(1))), ' min','{      }');
st2=strcat('NREM: ','{ }',num2str(round(X{2}(2))), ' min','{        }');
st3=strcat('T.S.: ','{     }',num2str(round(X{2}(3))), ' min','{     }');
st4=strcat('REM: ','{    }',num2str(round(X{2}(4))), ' min','{       }');
st6='------------------------';
st5=strcat('Total: ','{ }',num2str(sum(round(X{2}))), ' min','{      }');


str=[st1;st2;st3;st4;st6;st5];
%str = [ strcat('Wake:',num2str(round(X{1}(1))), ' min'); strcat('NREM:',num2str(round(X{1}(2))), '  min'); strcat('T.S. :',num2str(round(X{1}(3))), '  min');strcat('REM:  ',num2str(round(X{1}(4))), '  min')];
A=annotation('textbox',dim,'String',str,'FitBoxToText','on','FontSize',12);
A.BackgroundColor=[1 1 1]

ch=3;
dim = [.34 .2 .2 .2];
st1=strcat('Wake: ','{  }',num2str(round(X{ch}(1))), ' min','{      }');
st2=strcat('NREM: ','{ }',num2str(round(X{ch}(2))), ' min','{        }');
st3=strcat('T.S.: ','{     }',num2str(round(X{ch}(3))), ' min','{     }');
st4=strcat('REM: ','{    }',num2str(round(X{ch}(4))), ' min','{       }');
st6='------------------------';
st5=strcat('Total: ','{ }',num2str(sum(round(X{ch}))), ' min','{      }');


str=[st1;st2;st3;st4;st6;st5];
%str = [ strcat('Wake:',num2str(round(X{1}(1))), ' min'); strcat('NREM:',num2str(round(X{1}(2))), '  min'); strcat('T.S. :',num2str(round(X{1}(3))), '  min');strcat('REM:  ',num2str(round(X{1}(4))), '  min')];
A=annotation('textbox',dim,'String',str,'FitBoxToText','on','FontSize',12);
A.BackgroundColor=[1 1 1]

ch=4;
dim = [.45 .2 .2 .2];
st1=strcat('Wake: ','{  }',num2str(round(X{ch}(1))), ' min','{      }');
st2=strcat('NREM: ','{ }',num2str(round(X{ch}(2))), ' min','{        }');
st3=strcat('T.S.: ','{     }',num2str(round(X{ch}(3))), ' min','{     }');
st4=strcat('REM: ','{    }',num2str(round(X{ch}(4))), ' min','{       }');
st6='------------------------';
st5=strcat('Total: ','{ }',num2str(sum(round(X{ch}))), ' min','{      }');


str=[st1;st2;st3;st4;st6;st5];
%str = [ strcat('Wake:',num2str(round(X{1}(1))), ' min'); strcat('NREM:',num2str(round(X{1}(2))), '  min'); strcat('T.S. :',num2str(round(X{1}(3))), '  min');strcat('REM:  ',num2str(round(X{1}(4))), '  min')];
A=annotation('textbox',dim,'String',str,'FitBoxToText','on','FontSize',12);
A.BackgroundColor=[1 1 1]

ch=5;
dim = [.56 .2 .2 .2];
st1=strcat('Wake: ','{  }',num2str(round(X{ch}(1))), ' min','{       }');
st2=strcat('NREM: ','{ }',num2str(round(X{ch}(2))), ' min','{       }');
st3=strcat('T.S.: ','{     }',num2str(round(X{ch}(3))), ' min','{     }');
st4=strcat('REM: ','{    }',num2str(round(X{ch}(4))), ' min','{      }');
st6='------------------------';
st5=strcat('Total: ','{ }',num2str(sum(round(X{ch}))), ' min','{      }');


str=[st1;st2;st3;st4;st6;st5];
%str = [ strcat('Wake:',num2str(round(X{1}(1))), ' min'); strcat('NREM:',num2str(round(X{1}(2))), '  min'); strcat('T.S. :',num2str(round(X{1}(3))), '  min');strcat('REM:  ',num2str(round(X{1}(4))), '  min')];
A=annotation('textbox',dim,'String',str,'FitBoxToText','on','FontSize',12);
A.BackgroundColor=[1 1 1]
%%
ch=6;
dim = [.67 .2 .2 .2];
st1=strcat('Wake: ','{  }',num2str(round(X{ch}(1))), ' min','{       }');
st2=strcat('NREM: ','{ }',num2str(round(X{ch}(2))), ' min','{       }');
st3=strcat('T.S.: ','{     }',num2str(round(X{ch}(3))), ' min','{     }');
st4=strcat('REM: ','{    }',num2str(round(X{ch}(4))), ' min','{      }');
st6='------------------------';
st5=strcat('Total: ','{ }',num2str(sum(round(X{ch}))), ' min','{      }');


str=[st1;st2;st3;st4;st6;st5];
%str = [ strcat('Wake:',num2str(round(X{1}(1))), ' min'); strcat('NREM:',num2str(round(X{1}(2))), '  min'); strcat('T.S. :',num2str(round(X{1}(3))), '  min');strcat('REM:  ',num2str(round(X{1}(4))), '  min')];
A=annotation('textbox',dim,'String',str,'FitBoxToText','on','FontSize',12);
A.BackgroundColor=[1 1 1]

%%    
end
%%
% allscreen()
% y = [Z{1}];
% % c = categorical({'Wake','NREM','Transitional Sleep','REM'});
% bb=bar(y,'stacked')
%%
% figure; 
% b1=bar(sum(v), 'b')
% hold on
% bar(v(1), 'm')
% hold off
% hold on
% bar(v(2), 'r')
% bar(v(3), 'g')
% bar(v(4), 'y')
%%


%%
% allscreen()
% y = [Z{1};Z{2};Z{3};Z{4}];
% c = categorical({'Baseline','Plusmaze','Novelty','Foraging'});
% bar(c,y,'stacked')
% ylabel('Percentage of sleep','FontSize',16)
% lg=legend('Wake','NREM','Transitional Sleep','REM')
% lg.Location='West';
% lg.FontSize=14
% ax = gca;
% ax.XAxis.FontSize = 16;
% ax.YAxis.FontSize = 16;
% % lg2=legend('Wake','NREM','Transitional Sleep','REM')
% % lg2.Location='East';
% % lg2.FontSize=14
% 
%%
% grid on
if acer==0
    cd(strcat('/home/raleman/Dropbox/Figures/Figure2/',num2str(Rat)))
else
      %cd(strcat('C:\Users\Welt Meister\Dropbox\Figures\Figure2\',num2str(Rat)))   
      cd(strcat('C:\Users\addri\Dropbox\Figures\Figure2\',num2str(Rat)))   
end


if Score==2
    cd('new_scoring')
end

string=strcat('Sleep_amount','.eps');
% saveas(gcf,string)
print(string,'-depsc')

string=strcat('Sleep_amount','.fig');
saveas(gcf,string)

string=strcat('Sleep_amount','.pdf');
figure_function(gcf,[],string,[]);


close all

%%
clearvars -except acer Rat

end
