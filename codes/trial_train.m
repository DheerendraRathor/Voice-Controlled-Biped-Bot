function [PI_ret,A_ret,B_ret]=trial_train()
% training
R=5; % 5 times to be trained 
parameters=cell(R,4);

%initial arbid condition
N_states=6;
PI_matrix=[0.2 0.2 0.2 0.2 0.2 0.2];
B_matrix=cell(2,N_states);
A_matrix=[0.5 0.5 0 0 0 0;0 0.5 0.5 0 0 0;0 0 0.5 0.5 0 0;0 0 0 0.5 0.5 0;0 0 0 0 0.5 0.5;0 0 0 0 0 0.5];

Tr=zeros(R,1);%length of training sequence for each train
Obr=cell(R,1);
segments=cell(N_states,1);
%storing the values
for r=1:R
    
    disp('start next training for same word');
    while 1
        signal=trial_playwords();
        [l,~]=size(signal);
        if l~=0
            feature_vector=trial_feature_analysis(signal);

            O=feature_vector;
            Obr{r,1}=O;
            [l,~]=size(feature_vector);
            Tr(r)=l;
            n=floor(l/6);

            for i=0:N_states-1
                segments{i+1,1}=[segments{i+1,1};feature_vector((i*n+1):((i+1)*n),:)];
            end
            break
        end
    end
    
end

for i=1:N_states
    B_matrix{1,i}=mean(segments{i,1});
    B_matrix{2,i}=cov(segments{i,1});
end

for r=1:R
    alpha_matrix=trial_alpha(N_states,PI_matrix,A_matrix,B_matrix,Obr{r,1});
    beta_matrix=trial_beta(N_states,PI_matrix,A_matrix,B_matrix,Obr{r,1});
    gamma_matrix=trial_gamma(N_states,PI_matrix,A_matrix,B_matrix,Obr{r,1});
    eta_matrix=trial_eta(N_states,PI_matrix,A_matrix,B_matrix,Obr{r,1});
    parameters{r,1}=alpha_matrix;
    parameters{r,2}=beta_matrix;
    parameters{r,3}=gamma_matrix;
    parameters{r,4}=eta_matrix;
end

session=1;% number of training sessions
for k=1:session
    temp_PI_matrix=[0.2 0.2 0.2 0.2 0.2 0.2];
    temp_B_matrix=cell(2,N_states);
    temp_A_matrix=[0.5 0.5 0 0 0 0;0 0.5 0.5 0 0 0;0 0 0.5 0.5 0 0;0 0 0 0.5 0.5 0;0 0 0 0 0.5 0.5;0 0 0 0 0 0.5];
    %estimation of PI
    for i=1:N_states
        num=0;den=0;
        for r=1:R
            num=num+parameters{r,1}(i,1)*parameters{r,2}(i,1);
            temp_den=0;
            for j=1:N_states
                temp_den=temp_den+parameters{r,1}(j,1)*parameters{r,2}(j,1);
            end
            den=den+temp_den;
        end
        temp_PI_matrix(i)=num/den;
    end
    
    %estimation of A matrix
    for i=1:N_states
        for j=1:N_states
            num=0;den=0;
            for r=1:R
                for t=1:Tr(r)-1
                    num=num+parameters{r,1}(i,t)*A_matrix(i,j)*b_ik(B_matrix,j,Obr{r,1}(t+1,:))*parameters{r,2}(j,t+1);
                    den=den+parameters{r,1}(i,t)*parameters{r,2}(i,t);
                end
            end
            temp_A_matrix(i,j)=num/den;
        end
    end
    
    %estimation for B_matrix
    for j=1:N_states
        num1=0;den1=0;
        num2=0;den2=0;
        for r=1:R
            for t=1:Tr(r)
                num1=num1+parameters{r,3}(j,t)*Obr{r,1}(t,:);
                den1=den1+parameters{r,3}(j,t);
                num2=num2+parameters{r,3}(j,t)*((Obr{r,1}(t,:)-B_matrix{1,j})'*(Obr{r,1}(t,:)-B_matrix{1,j}));
                den2=den1;
            end
        end
        temp_B_matrix{1,j}=num1/den1;
        temp_B_matrix{2,j}=num2/den2;
    end
    
    %reallocating the estimations made
    PI_matrix=temp_PI_matrix;
    A_matrix=temp_A_matrix;
    B_matrix=temp_B_matrix;
end
PI_ret=PI_matrix;
A_ret=A_matrix;
B_ret=B_matrix;