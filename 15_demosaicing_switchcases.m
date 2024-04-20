function [output] = demosaicing(input,type,inbuilt)
% Load image
Z = input;
Z = double(Z)
% Create CFA filter for each of the three colours in RGGB format
Rcfa = repmat([1 0;0 0],round(size(Z)/2));
Gcfa = repmat([0 1;1 0],round(size(Z)/2));
Bcfa = repmat([0 0;0 1],round(size(Z)/2));
% Split data into 'hat' variables
Rh = Z.*Rcfa;
Gh = Z.*Gcfa;
Bh = Z.*Bcfa;
switch inbuilt
    case 'yes'
        switch type
            case 'neighbor' % nearest neighbor interpolation
               R = Rh(floor([0:end-1]/2)*2+1,floor([0:end-1]/2)*2+1);
               G = zeros(size(Gh));
               G(floor([0:end-1]/2)*2+1,:) = Gh(floor([0:end-1]/2)*2+1,floor([0:end-1]/2)*2+2);
               G(floor([0:end-1]/2)*2+2,:) = Gh(floor([0:end-1]/2)*2+2,floor([0:end-1]/2)*2+1);
               B = Bh(floor([0:end-1]/2)*2+2,floor([0:end-1]/2)*2+2);
           case 'bilinear' % bilinear interpolation
               R = conv2(Rh,[1 2 1;2 4 2;1 2 1]/4,'same');
               G = conv2(Gh,[0 1 0;1 4 1;0 1 0]/4,'same');
               B = conv2(Bh,[1 2 1;2 4 2;1 2 1]/4,'same');
           case 'smooth_hue' % smooth hue transition interpolation
               G = conv2(Gh,[0 1 0;1 4 1;0 1 0]/4,'same') ;
               R = G.*conv2(Rh./G,[1 2 1;2 4 2;1 2 1]/4,'same') ;
               B = G.*conv2(Bh./G,[1 2 1;2 4 2;1 2 1]/4,'same') ;
           case 'median' % median-filtered bilinear interpolation
               R = conv2(Rh,[1 2 1;2 4 2;1 2 1]/4,'same') ;
               G = conv2(Gh,[0 1 0;1 4 1;0 1 0]/4,'same') ;
               B = conv2(Bh,[1 2 1;2 4 2;1 2 1]/4,'same') ;
               Mrg = R-G;
               Mrb = R-B;
               Mgb = G-B;
               R = Z+Mrg.*Gcfa+Mrb.*Bcfa ;
               G = Z-Mrg.*Rcfa+Mgb.*Bcfa ;
               B = Z-Mrb.*Rcfa-Mgb.*Gcfa ;
           case 'gradient' % gradient-based interpolation
               H = abs((Z(:,[1 1 1:end-2])+Z(:,[3:end end end]))/2-Z);
               V = abs((Z([1 1 1:end-2],:)+Z([3:end end end],:))/2-Z);
               G = Gh+(Rcfa+Bcfa).*((H<V).*((Gh(:,[1 1:end-1])+Gh(:,[2:end end]))/2)+(H>V).*((Gh([1 1:end-1],:)+Gh([2:end end],:))/2)+(H==V).*((Gh(:,[1 1:end-1])+Gh(:,[2:end end])+Gh([1 1:end-1],:)+Gh([2:end end],:))/4)) ;
               R = G+conv2(Rh-Rcfa.*G,[1 2 1;2 4 2;1 2 1]/4,'same');
               B = G+conv2(Bh-Bcfa.*G,[1 2 1;2 4 2;1 2 1]/4,'same');
        end
        %% Output
        output(:,:,1)=R; output(:,:,2)=G; output(:,:,3)=B;
        output = rescale(output);
    case 'no'
        switch type
            case 'neighbor' % nearest neighbor interpolation
               R = Rh(floor([0:end-1]/2)*2+1,floor([0:end-1]/2)*2+1);
               G = zeros(size(Gh));
               G(floor([0:end-1]/2)*2+1,:) = Gh(floor([0:end-1]/2)*2+1,floor([0:end-1]/2)*2+2);
               G(floor([0:end-1]/2)*2+2,:) = Gh(floor([0:end-1]/2)*2+2,floor([0:end-1]/2)*2+1);
               B = Bh(floor([0:end-1]/2)*2+2,floor([0:end-1]/2)*2+2);
               %% Output
               output(:,:,1)=R; output(:,:,2)=G; output(:,:,3)=B;
               output = rescale(output);
           case 'bilinear' % bilinear interpolation
               Img = Rh;
               K = [1 2 1;2 4 2;1 2 1]/4;
               R = convolution(Img, K);
               Img = Gh;
               K = [0 1 0;1 4 1;0 1 0]/4;
               G = convolution(Img, K);
               Img = Bh;
               K = [1 2 1;2 4 2;1 2 1]/4;
               B = convolution(Img, K);
               %% Output
               output(:,:,1)=R; output(:,:,2)=G; output(:,:,3)=B;
               output = rescale(output);
           case 'smooth_hue' % smooth hue transition interpolation
               %G = conv2(Gh,[0 1 0;1 4 1;0 1 0]/4,'same') ;
               Img = Gh;
               K = [0 1 0;1 4 1;0 1 0]/4;
               G = convolution(Img, K);
               %R = G.*conv2(Rh./G,[1 2 1;2 4 2;1 2 1]/4,'same') ;
               Img = Rh./G;
               K = [1 2 1;2 4 2;1 2 1]/4;
               R = convolution(Img, K);
               R = G.*R;
               %B = G.*conv2(Bh./G,[1 2 1;2 4 2;1 2 1]/4,'same') ;
                Img = Bh./G;
               K = [1 2 1;2 4 2;1 2 1]/4;
               B = convolution(Img, K);
               B = G.*B;
               %% Output
               output(:,:,1)=R; output(:,:,2)=G; output(:,:,3)=B;
               output = rescale(output);
            case 'median' % median-filtered bilinear interpolation
               %R = conv2(Rh,[1 2 1;2 4 2;1 2 1]/4,'same') ;
               Img = Rh;
               K = [1 2 1;2 4 2;1 2 1]/4;
               R = convolution(Img, K);
               %G = conv2(Gh,[0 1 0;1 4 1;0 1 0]/4,'same') ;
               Img = Gh;
               K = [0 1 0;1 4 1;0 1 0]/4;
               G = convolution(Img, K);
               %B = conv2(Bh,[1 2 1;2 4 2;1 2 1]/4,'same') ;
               Img = Bh;
               K = [1 2 1;2 4 2;1 2 1]/4;
               B = convolution(Img, K);
               Mrg = R-G;
               Mrb = R-B;
               Mgb = G-B;
               R = Z+Mrg.*Gcfa+Mrb.*Bcfa ;
               G = Z-Mrg.*Rcfa+Mgb.*Bcfa ;
               B = Z-Mrb.*Rcfa-Mgb.*Gcfa ;
               %% Output
               output(:,:,1)=R; output(:,:,2)=G; output(:,:,3)=B;
               output = rescale(output);
            case 'gradient' % gradient-based interpolation
               H = abs((Z(:,[1 1 1:end-2])+Z(:,[3:end end end]))/2-Z);
               V = abs((Z([1 1 1:end-2],:)+Z([3:end end end],:))/2-Z);
               G = Gh+(Rcfa+Bcfa).*((H<V).*((Gh(:,[1 1:end-1])+Gh(:,[2:end end]))/2)+(H>V).*((Gh([1 1:end-1],:)+Gh([2:end end],:))/2)+(H==V).*((Gh(:,[1 1:end-1])+Gh(:,[2:end end])+Gh([1 1:end-1],:)+Gh([2:end end],:))/4)) ;
               %R = G+conv2(Rh-Rcfa.*G,[1 2 1;2 4 2;1 2 1]/4,'same');
               Img = Rh-Rcfa.*G;
               K = [1 2 1;2 4 2;1 2 1]/4;
               R = convolution(Img, K);
               R = G+R;
               %B = G+conv2(Bh-Bcfa.*G,[1 2 1;2 4 2;1 2 1]/4,'same');
               Img = Bh-Bcfa.*G;
               K = [1 2 1;2 4 2;1 2 1]/4;
               B = convolution(Img, K);
               B = G+B;
               %% Output
               output(:,:,1)=R; output(:,:,2)=G; output(:,:,3)=B;
               output = rescale(output);

        end
end
end
   
