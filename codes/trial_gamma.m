function gamma_matrix=trial_gamma(N,PI,A,B,O)

global Table;
[T,~]=size(O);
Table=zeros(N,T);
alpha_matrix=trial_alpha(N,PI,A,B,O);
beta_matrix=trial_beta(N,PI,A,B,O);

for i=1:N
    for j=1:T
        Table(i,j)=alpha_matrix(i,j)*beta_matrix(i,j);
    end
end

sum_matrix=sum(Table);

for i=1:T
    Table(:,i)=Table(:,i)/sum_matrix(i);
end

gamma_matrix=Table;