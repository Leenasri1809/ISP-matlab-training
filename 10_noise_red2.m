function [FILTER] = noise_red2(DEM)
I_G = DEM
sigma = 1;
    %Window size
    sz = 2;
    [x,y]=meshgrid(-sz:sz,-sz:sz);
    
    M = size(x,1)-1;
    N = size(y,1)-1;
    Exp_comp = -(x.^2+y.^2)/(2*sigma*sigma);
    Kernel= exp(Exp_comp)/(2*pi*sigma*sigma);
    %Pad the vector with zeros
    I_G = padarray(I_G,[sz sz]);
    %Convolution
    [FILTER] = convolution(I_G, Kernel);
    FILTER = imresize(FILTER,[720,962]);
end