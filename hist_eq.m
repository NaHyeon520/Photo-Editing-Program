function g=hist_eq(f)
[row_num, col_num]=size(f);
n=zeros(1,256);%n_k
s=zeros(1,256);%s_k
for i=1:row_num %iterate each pixel of f
    for j=1:col_num
        n(f(i,j)+1)=n(f(i,j)+1)+1; %P_r(r_j)=n_k/MN (MN=row_num*col_num)
    end
end
for i=1:length(n) %s_k=(L-1)*sum(P_r(r_j))
    temp=0;
    for j=1:i
        temp=temp+(n(j)/(row_num*col_num)); %sum(P_r(r_j))
    end
    s(i)=255*temp; %L-1=255
    s(i)=round(s(i)); %s_k might be not a integer, so round it
end
g=f;
for i=1:row_num %iterate each pixel of f
    for j=1:col_num
        g(i,j)=(s(f(i,j)+1)); %In original img if intensity value is r_k(==f(i,j)), it is mapped to s_k
    end
end
end

