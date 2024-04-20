function [FILTER] = noise_red3(DEM)
I_G = DEM;
 filter = ones(3 , 3)/9;
    [FILTER] = convolution(I_G,filter);
end