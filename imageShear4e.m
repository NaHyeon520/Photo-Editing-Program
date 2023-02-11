%HW06
%Task #1-(1)
function g = imageShear4e(f, sv, sh)

%f==grayscale img
%sy==vertical scalar shearing factors
%sh==horizontal scalar shearing factors
%g==a vector containing the pixel values along the specified row or column in f

%affine transformation
vertical=[1 sv 0; 0 1 0; 0 0 1];
horizontal=[1 0 0; sh 1 0; 0 0 1];
affine=vertical*horizontal; %combine two shearing matrix
inv_affine=inv(affine); %for inverse mapping, calculate inverse affine matrix((v,w)=T^-1(x,y))
[row_num, col_num]=size(f);% M, N

%Make a matrix A that has output image's coordinates
x_row=repmat((1:row_num), 1, col_num);%the first row
y_row=repelem((1:col_num), row_num);
z_row=ones(1, row_num*col_num);%the last row
A=cat(1, x_row, y_row, z_row);%concatenate

%apply affine transform(inverse)
B=inv_affine*A;%B has input image's coordinates that is mapped to output image's coordinates.

%B's coordinates would might not a integer, so use nearest neighbor interpolation(round)
C=round(B);

for i=1:row_num*col_num
    if C(1,i)<=0||C(2,i)<=0||C(1,i)>row_num||C(2,i)>col_num %check if original coordinate exceeds the boundary
        g(A(1,i),A(2,i))=0;
    else
        g(A(1,i),A(2,i))=f(C(1,i),C(2,i));
    end
end
end