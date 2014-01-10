function A=largerwords(mt)
[l,k]=size(mt);
b=[];
for i=1:l,
    b=[b mt(i,2)-mt(i,1)];
end;
[n,k]=sort(b);
newmt=[];
for i=1:l,
    newmt=[newmt;[mt(k(l-i+1),1),mt(k(l-i+1),2)]];
end;
A=newmt;
        
        
    