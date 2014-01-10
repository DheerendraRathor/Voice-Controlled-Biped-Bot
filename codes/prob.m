function [p]=prob(x,mew,sigma)
[k,~]=size(x);
p=1;
for i=1:k
    d=sigma(i,i);
    if d<10^(-3)
        d=10^(-3);
    end
    p=p*exp(-(x(i)-mew(i))^2/(2*d))/sqrt(2*pi*d);
end
if p<10^(-6)
    p=10^(-6);
end