function [BB,labelconditions,labelconditions2]=select_folder(Rat,iii,labelconditions,labelconditions2)
% if Rat<9
%     cd(strcat('G:/ephys/rat',num2str(Rat)));
% else
%     cd(strcat('G:/ephys/'));
%     aa=getfolder;
%     if strfind(aa{1},strcat('Rat',num2str(Rat)))
%         cd(aa{1})
%     else
%         cd(aa{2})
%     end
% end
    
%     A = dir(cd);
%     A={A.name};
A=getfolder;

%Find all folders containing name of condition. 
    no=0; %Number of folders. 
    for j=1:length(A)
        B=A{j};
        k = strfind(B,labelconditions{iii});
        if k>=1
            no=no+1;
            BB{no}=B;
        end
    end

    
      
    if no>=2 %Save BB with the plain OR. 
        %xo
        labelconditions{iii}=BB{1};
        labelconditions=[labelconditions; BB(2:end).'];
        
        labelconditions2{iii}=BB{1};
        labelconditions2=[labelconditions2; BB(2:end).'];
%         if strfind(BB{1},'OD')>0
%         
%         
%            v1=strfind(BB{1},'OD-N');
% %            v2=strfind(BB{2},labelconditions{4});
% 
%            if v1>0
%                BB=BB{2};
%            else
%                BB=BB{1};
%            end
%         
%         
%         else
%         
%            v1=strfind(BB{1},labelconditions{4});
% %            v2=strfind(BB{2},labelconditions{4});
% 
%            if v1>0
%                BB=BB{2};
%            else
%                BB=BB{1};
%            end

        else
            labelconditions{iii}=BB{1};
        end
        
    %     for j=1:length(BB)
    %         
    %end 

if iscell(BB)==1
    BB=BB{1};
end

if no==2 && iii==length(labelconditions)
    BB=BB{2};    
end

end