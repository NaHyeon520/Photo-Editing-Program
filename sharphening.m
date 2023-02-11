function g=sharphening(f, k)
%f: image
%k: parameter for sharphening
%------------------
%algorithm:
%step1: smoothing image with gaussian filter
%step2: subtract blurred image from original image
%step3: add a image from step2 to original image with multiplying k

if(k==0)
    g=f;
    return
end
%make gaussian filter
sigma=5;
len=15;
[X,Y]=meshgrid(-len:len,-len:len);
e=-(X.^2+Y.^2)/(2*sigma*sigma);
w=exp(e)/(2*pi*sigma*sigma);

f=double(f)/255;

%check if image is grayscale or not
[M,N,colors]=size(f);
if(colors>1)%if the image is rgb image
    %seperate color channels
    f_r=f(:,:,1);
    f_g=f(:,:,2);
    f_b=f(:,:,3);
    %padding
    [a,b]=size(w);
    r=(a-1)/2;
    c=(b-1)/2;
    f_r_pad=imPad4e(f_r,r,c,"zeros");
    f_g_pad=imPad4e(f_g,r,c,"zeros");
    f_b_pad=imPad4e(f_b,r,c,"zeros");
    
    %step1
    %convolution->blurring
    f_r_blur=zeros([M,N]);
    f_g_blur=zeros([M,N]);
    f_b_blur=zeros([M,N]);
    
    for i=1:M
        for j=1:N
            f_r_blur(i,j)=sum(sum(w.*f_r_pad(i:(i+2*r),j:(j+2*c))));
            f_g_blur(i,j)=sum(sum(w.*f_g_pad(i:(i+2*r),j:(j+2*c))));
            f_b_blur(i,j)=sum(sum(w.*f_b_pad(i:(i+2*r),j:(j+2*c))));
        end
    end
    
    %step2
    g_r_mask=f_r-f_r_blur;
    g_g_mask=f_g-f_g_blur;
    g_b_mask=f_b-f_b_blur;
    
    %step3
    g_r=f_r+k*g_r_mask;
    g_g=f_g+k*g_g_mask;
    g_b=f_b+k*g_b_mask;
    g=cat(3,g_r,g_g,g_b);
    g=rescale(g,0,255);
    g=uint8(g);
else %if the image is grayscale
    %padding
    [a,b]=size(w);
    r=(a-1)/2;
    c=(b-1)/2;
    f_pad=imPad4e(f,r,c,"zeros");
    
    %step1
    %convolution->blurring
    f_blur=zeros([M,N]);
    for i=1:M
        for j=1:N
            f_blur(i,j)=sum(sum(w.*f_pad(i:(i+2*r),j:(j+2*c))));
        end
    end
    
    %step2
    g_mask=f-f_blur;
    
    %step3
    g=f+k*g_mask;
    g=rescale(g,0,255);
    g=uint8(g);
end
end

