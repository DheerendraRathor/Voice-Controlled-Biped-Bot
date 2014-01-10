function [st,eno]=try1(a,beg)
l=length(a);
eno=0;
st=0;
s=0;
en=1;
i=beg;
while i < l-501
    temp=mean(abs(a(i:i+500)));
    if temp > 0.02 & s==0,
        st=i;
        s=1;
        en=0;
    end;
    if temp <= 0.02 & en==0,
        eno=i+500;
        en=1;
        i=l;
    end;
    i=i+50;
end;
if eno == 0 & st ~=0
    eno=l;
end;