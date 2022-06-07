function value=lower_value(Img,T_up)
[a,b]=size(Img);
N_total=a*b;
nonzero=(Img~=0);
L=sum(nonzero(:));
value=min(N_total,T_up*L)/256;


