function feature_vector=trial_feature_analysis(signal)
% dat is the data of voice
%preprocessing 
sample_rate = 48000;
cutoff_hz =6000;
nyq_freq = sample_rate / 2;
cutoff_norm = cutoff_hz / nyq_freq;
order = 28;
fir_coeff = fir1(order, cutoff_norm);
new_dat = filter(fir_coeff, 1, signal);
%fir-filter


%Windowing
len=length(new_dat);
W=[];
N=floor((len-300)/100);
for i=0:N-1
    k=new_dat((i*100)+1:(i*100)+300);
    for n=1:300
       k(n)=k(n)*(0.54-0.46*cos((2*pi*(n-1))/299));
    end;
    W=[W k];
end;
W=W';
%W is windowing data
%windowing done

%cepstral calculations
 hlevinson = dsp.LevinsonSolver;
 hlevinson.AOutputPort = true; % Output polynomial coefficients
 hac = dsp.Autocorrelator;
 hac.MaximumLagSource = 'Property';
 hac.MaximumLag = 8; % Compute autocorrelation lags between [0:8]
 hlpc2cc = dsp.LPCToCepstral;
 hlpc2cc.CepstrumLengthSource='Property';
 hlpc2cc.CepstrumLength=13;
 [l,~]=size(W);
 cep=[];
 for i=1:l
     x=W(i,:)';
     a = step(hac, x);
     A = step(hlevinson, a); % Compute LPC coefficients
     CC = step(hlpc2cc, A); % Convert LPC to CC.
     cep = [cep;CC'];
 end;
 cep=cep(:,2:13);
 
 %Weighting of cepstral Coefficients
 W=[];
 Q=12;
 for i=1:Q
     W=[W 1+Q/2*(sin(pi*i/Q))];
 end;
 
 Wcepstral=zeros(size(cep));
 for i=1:N
      Wcepstral(i,:)=W.*cep(i,:);
 end;
 %Weighting done
 
 
 delta_cepstral=[];
 K=3;
 for i=1:N
     c=[];
     for m=1:12
         mew=0;sum=0;
         for k=-K:K
             if i+k>0 & i+k<=N
                 mew=mew+k*k;
                 sum=sum+k*Wcepstral(i+k,m);
             end;
         end;
         c=[c sum/mew];
     end;
     delta_cepstral=[delta_cepstral;c];
 end;
 
 %feature vector
 %feature_vector=Wcepstral;
 feature_vector=[Wcepstral';delta_cepstral']';