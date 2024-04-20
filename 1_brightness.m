clc;
clear all;
close all;
I = imread("RGB image.jpg");
disp(I);
B = I+100;
if B<0
    B = 0;
elseif B>255
    B = 255;
else
    B = B;
end
figure(1);
imshow(I);
figure(2);
imshow(B);
R = I(:,:,1);
R = max(R(:));
G = I(:,:,2);
G = max(G(:));
B = I(:,:,3);
B = max(B(:));
BR = R+G+B
BRI = BR/3;
disp(BRI);