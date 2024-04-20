I4 = imread("2.png");
% Find the max and min value
Max = max(I4,[],'all');
Min = min(I4,[],'all');
disp(Max);
disp(Min);
DR = (log(Max)-log(Min));
disp(DR);