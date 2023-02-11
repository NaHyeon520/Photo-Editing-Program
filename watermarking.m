function g=watermarking(f)

[img_row, img_col, colors] = size(f);

img_row=uint32(img_row);
img_col=uint32(img_col);
% Read the size of the watermark
watermark = imread('Watermark_Design.jpg');
[mark_row, mark_col mark] = size(watermark);
watermark=rgb2gray(watermark);

% Resize the watermark image 
new_row = uint32(img_row*0.5);
new_col = uint32(img_col*0.1);

resizedSize = [new_row new_col];
FinalWaterMark = imresize(watermark, resizedSize);

% Place the resized watermark over the input image 
if(colors>1)
    f((img_row-new_row+1):img_row, (img_col-new_col+1):img_col, 1)=FinalWaterMark;
    f((img_row-new_row+1):img_row, (img_col-new_col+1):img_col, 2)=FinalWaterMark;
    f((img_row-new_row+1):img_row, (img_col-new_col+1):img_col, 3)=FinalWaterMark;
else
    f((img_row-new_row+1):img_row, (img_col-new_col+1):img_col)=FinalWaterMark;
end
g=f;

end