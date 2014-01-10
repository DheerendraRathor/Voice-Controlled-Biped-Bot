function [p]=b_ik(B,i,o)
X=B{1,i};
Y=B{2,i};
p=prob(o',X',Y);
