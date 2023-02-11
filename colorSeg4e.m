function I=colorSeg4e(f,m,T)
f=double(f);
[X,R]=imstack2vectors4e(f);

[M,N,c]=size(f);
k=repmat(m,M*N,1);
k=double(k);
D=sqrt(sum((X-k).^2,2));
ind=find(D<T);
I=ind;

end

