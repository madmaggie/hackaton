
function [x,y] = matlabCentroids(bitmapLetter)


%assert(isa(bitmapLetter,'double') && all(size(bitmapLetter) <= [1 2500]));

% need to get back to 50*50 array
%bitmapLetter = reshape(bitmapLetter,sqrt(size(bitmapLetter,2)),sqrt(size(bitmapLetter,2)));

s  = regionprops(bitmapLetter, 'centroid');
val = round(cat(1, s.Centroid));
x = val(1);
y = val(2);


