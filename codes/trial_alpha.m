function alpha_matrix=trial_alpha(N,PI,A,B,O)
global Table;
global Reference;
[T,~]=size(O);
Reference=zeros(N,T);
Table=zeros(N,T);
for k=1:N
    helper(N,PI,A,B,O,k,T);
end
alpha_matrix=Table;

function helper(N,PI,A,B,O,i,t)
if Reference(i,t)==0
    if t==1
        Reference(i,t)=1;
        Table(i,t)=PI(i)*b_ik(B,i,O(t,:));
    else
        for j=1:N
            helper(N,PI,A,B,O,j,t-1);
            p=Table(j,t-1)*A(j,i)*b_ik(B,i,O(t,:));
            Table(i,t)=Table(i,t)+p;
        end
    end
    Reference(i,t)=1;
end
end
end

