function signal=trial_playwords()

t=5;
re=audiorecorder;
disp('start speaking now');
recordblocking(re,t);
disp('sound recorded yoyo');
dat=getaudiodata(re);
disp('recording over , calculating words');
A=giveallword(dat);
disp('words calculated , now listen them');
A=largerwords(A);
[l,~]=size(A);

signal=[];
%giving option to select which part to select
if l~=0
    
    for i=1:l    
        st=dat(A(i,1):A(i,2));
        wavplay(st);
        reply=input('Do you want to include this? yes = 1/ no = 0 -- ');
        if reply==1
            signal=st;
            break
        end
    end
    
end