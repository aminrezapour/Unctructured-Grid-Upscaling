% This function creates a loc_mat matrix from an image that is stored in
% form of a matrix. myImage is a m-by-n matrix and each entry is a
% intensity/color-code pixel of the image. loc_mat is a m*n-by3 matrix,
% first two columns represent the cartesian location of the node (or pixel
% here), and the third column stores the node value (here the pixel
% intensity).

function loc_mat = locMatFromMatrix(myImage)

    [a,b] = size(myImage);
    loc_mat = zeros(a*b,3);
    k = 1;
    for i = 1:a
    for j = 1:b
       loc_mat(k,:) = [i j myImage(i,j)];
       k = k+1;
    end
    end