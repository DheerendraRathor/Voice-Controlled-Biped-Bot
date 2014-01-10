function  A=giveallword(dat)
A=[];
l=length(dat);
i=1;
while i < l
    
    [st,en]=try1(dat,i);
    if en == 0 
        i=l;
    elseif (en - st) > 1000 
         A=[A;[st,en]];
         i=min(en+100,l);
    else
        i=min(en+100,l);
    end;
end;
    