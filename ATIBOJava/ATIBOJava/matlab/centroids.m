function [x,y] = centroids(bitmapLetter)
% #codegen
% computes the (x,y) coordinates of non-zero values in a matrix of 1s and 0s
% equivalent code for regionprops(bitmapLetter,'PixelList')
% regionprops not supported by codegen
%
% bitmapLetter - bitmap representation of a letter
%              - 1x2500 row of 0s and 1s
% returns pix = n*2 array
%   where n is the number of non-zero values in bitmapLetter
%
% Copyright 2013-2015 Atibo



% reshaped 50*50 array of 0s and 1s because multi-dimensional array
% doesn't work when code is included in shared library
%assert(isa(bitmapLetter,'double') && all(size(bitmapLetter) <= [1 2500]));

% need to get back to 50*50 array
%bitmapLetter = reshape(bitmapLetter,sqrt(size(bitmapLetter,2)),sqrt(size(bitmapLetter,2)));

[row,col] = size(bitmapLetter);
imin = col+1;
for i=1:row
    for j=1:col
        if (bitmapLetter(i,j)>0)
            if (imin > i)
            	imin = i;
            end
        end
    end
end

imax = 0;
for i=1:row
    for j=1:col
        if (bitmapLetter(i,col-j+1) > 0)
            if (imax < col-j+1)
                imax = col-j+1;
            end
        end
    end
end

jmin = row+1;
for j=1:col
    for i=1:row
        if (bitmapLetter(i,j)>0)
            if (jmin > j)
                jmin = j;
            end
        end
    end
end

jmax = 0;
for j=1:col
    for i=1:row
        if (bitmapLetter(row-i+1,j) > 0)
            if (jmax < row-i+1)
                jmax = row-i+1;
            end
        end
    end
end

x = round((imin+imax)/2);
y = round((jmin+jmax)/2);