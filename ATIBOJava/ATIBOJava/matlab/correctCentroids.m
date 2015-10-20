function [x,y] = correctCentroids(bitmapLetter)
% #codegen
% computes the (x,y) coordinates of non-zero values in a matrix of 1s and 0s
% equivalent code for regionprops(bitmapLetter,'centroids')
% regionprops not supported by codegen
%
% bitmapLetter - bitmap representation of a letter
%              - 50x50 row of 0s and 1s
% returns x - x coordinae of the centroid
%         y - y coordinate of the centroid
%
% Copyright 2013-2015 Atibo



%assert(isa(bitmapLetter,'double') && all(size(bitmapLetter) <= [50 50]));

% need to get back to 50*50 array
%bitmapLetter = reshape(bitmapLetter,sqrt(size(bitmapLetter,2)),sqrt(size(bitmapLetter,2)));

[row,col] = size(bitmapLetter);
sumx = 0;
sumy = 0;
nrpct = 0;
for i=1:row
    for j=1:col
        if (bitmapLetter(i,j)>0)
            sumx = sumx + i;
            sumy = sumy + j;
            nrpct = nrpct+1;
        end
    end
end

y = round(sumx/nrpct);
x = round(sumy/nrpct);