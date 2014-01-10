function beta_matrix=trial_beta(N,PI,A,B,O)
global Reference;
global Table;
[T,~]=size(O);
Reference=zeros(N,T);
Table=zeros(N,T);

for s=1:N
    helper(N,PI,A,B,O,s,1);
end

beta_matrix=Table;

function helper(N,PI,A,B,O,i,t)
[T,~]=size(O);
if Reference(i,t)==0
    if t==T
        Table(i,t)=1;
        Reference(i,t)=1;
    else
        sum1=0;
        for j=1:N
            helper(N,PI,A,B,O,j,t+1);
            sum1=sum1+A(i,j)*b_ik(B,j,O(t+1,:))*Table(j,t+1);
        end
        Table(i,t)=sum1;
        Reference(i,t)=1;
    end
end
end
end