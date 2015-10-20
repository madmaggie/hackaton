function pix = pixels(bitmapLetter)
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

size(bitmapLetter)

% reshaped 50*50 array of 0s and 1s because multi-dimensional array
% doesn't work when code is included in shared library
assert(isa(bitmapLetter,'double') && all(size(bitmapLetter) <= [50 50]));

% need to get back to 50*50 array
%bitmapLetter = reshape(bitmapLetter,sqrt(size(bitmapLetter,2)),sqrt(size(bitmapLetter,2)));

pix = zeros(sum(sum(bitmapLetter)),2);
k=1;
for i=1:size(bitmapLetter,1)
    for j=1:size(bitmapLetter,2)
        if (bitmapLetter(j,i)>0)
            pix(k,2)=j;
            pix(k,1)=i;
            k=k+1;
        end
    end
end