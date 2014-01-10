function p=trial_viterbi(N,PI,A,B,O)
[T,~]=size(O);
[p,q]=trial(N,PI,A,B,O,1,T);
for j=2:N
    [temp_p,q_temp]=trial(N,PI,A,B,O,j,T);
    if temp_p > p
        q=q_temp;
        p=temp_p;
    end
end
