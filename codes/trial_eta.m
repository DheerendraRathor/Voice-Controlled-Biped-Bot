function eta_matrix=trial_eta(N,PI,A,B,O)

global Table_cell;
[T,~]=size(O);
Table_cell=cell(1,T);
alpha_matrix=trial_alpha(N,PI,A,B,O);
beta_matrix=trial_beta(N,PI,A,B,O);

for t=1:T-1
    table=zeros(N,N);
    for i=1:N
        for j=1:N
            table(i,j)=alpha_matrix(i,t)*beta_matrix(j,t+1)*A(i,j)*b_ik(B,j,O(t+1,:));
        end
    end
    Table_cell{1,t}=table;
end

for i=1:T
    Table_cell{1,i}=Table_cell{1,i}/sum(sum(Table_cell{1,i}));
end

eta_matrix=Table_cell;