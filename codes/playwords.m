
t=5;
re=audiorecorder;
disp('start speaking');
recordblocking(re,t);
disp('sound recorded');
dat=getaudiodata(re);
disp('recording over , calculating words');
A=giveallword(dat);
disp('words calculated , now listen them');
A=largerwords(A);
%plot(dat);
[l,jgjgjhgjhg]=size(A);
x1=[];
for i=1:l    
    st=dat(A(i,1):A(i,2));
    wavplay(st,8000);
    x1=[x1;st];
end;
