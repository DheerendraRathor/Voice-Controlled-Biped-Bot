function [p,q]=trial(N,PI,A,B,O,i,t)

global Table_states;
global Table_prob;
global Reference;
Table_states=cell(N,t);
Table_prob=zeros(N,t);
Reference=zeros(N,t);
helper(N,PI,A,B,O,i,t);
q=Table_states{i,t};
p=Table_prob(i,t);

function helper(N,PI,A,B,O,i,t)

if Reference(i,t)==0
    if t==1
        Reference(i,t)=1;
        Table_prob(i,t)=PI(i)*b_ik(B,i,O(t,:));
        Table_states{i,t}=i;
    else
        helper(N,PI,A,B,O,1,t-1);
        new_q=1;
        new_p = A(1,i)*Table_prob(1,t-1);
        for j=2:N
            helper(N,PI,A,B,O,j,t-1);
            temp_p=A(j,i)*Table_prob(j,t-1);
            if temp_p>new_p
                new_p=temp_p;
                new_q=j;
            end
        end
        Reference(i,t)=1;
        Table_prob(i,t)= new_p * b_ik(B,i,O(t,:));
        Table_states{i,t}= [Table_states{new_q,t-1} i];
    end
end
end
end