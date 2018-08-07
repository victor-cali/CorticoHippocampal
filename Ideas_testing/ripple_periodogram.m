%Periodogram of ripples

for cont=1:length(q)
    [f,G]=frequencylog(q{cont}(3,:));
    %gg(cont,:)=abs(G(1,end/2:end));
    gg(cont,:)=abs(G(1,1:length(f)));
end

%%
figure()
gt=mean(gg);
area(f*500,smooth(gt))
%%
[Q]=filter_ripples(q,[66.67 100 150 266.7 133.3 200 300 333.3 266.7 233.3 250 166.7 133.3],.5,.5);
%%
for cont=1:length(Q)
    [f,G]=frequencylog(Q{cont}(3,:),'no');
    %gg(cont,:)=abs(G(1,end/2:end));
    gg(cont,:)=abs(G(1,1:length(f)));
end

%%
figure()
gt=mean(gg);
area(f*500,smooth(gt,29))