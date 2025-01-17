function [ran]=select_rip(p,FiveHun)

    av=cat(1,p{1:end});
    %av=cat(1,q{1:end});

    av=av(1:3:end,:); %Only Hippocampus
    %AV=max(av.');
    %[B I]= maxk(AV,1000);
    %[B I]= maxk(max(av.'),1000); %Look for the 1000 ripples with highest amplitude. THIS SHOULD BE MEAN instead of Max since some peaks go downwards and no upwards. 

    [ach]=max(av.');
    [achinga]=sort(ach,'descend');
    if FiveHun==1 || FiveHun==2
        if length(achinga)>1000
        achinga=achinga(1:1000);
        end
    end
    B=achinga;
    I=nan(1,length(B));
    for hh=1:length(achinga)
       % I(hh)= min(find(ach==achinga(hh)));
    I(hh)= find(ach==achinga(hh),1,'first');
    end

 if FiveHun==1
    [ajal, ind]=unique(B); %Repeated ripples, which are very close to each other. 
 end 
 
 if FiveHun ==2
    ajal=B;
    
 end
    
if FiveHun==1
    if length(ajal)>500
    ajal=ajal(end-499:end);
    ind=ind(end-499:end);
    end
end
    % if length(ajal)>1000
    % ajal=ajal(end-999:end);
    % ind=ind(end-999:end);
    % end
if FiveHun==1
    dex=I(ind);
else
    dex=I;
end  % Files=dir(fullfile(cd,'*.mat'));


    % ran=I.'; % Select ripples with highest magnitudes. 
    ran=dex.';
end