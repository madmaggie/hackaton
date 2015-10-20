function DistY = dtwY(letterModel, letterTest)
%#codegen
% computes the DTW distance on Y
% letterModel - raw (x,y) coordinates of the model letter
% letterTest - raw (x,y) coordinates of the test letter

assert(isa(letterModel,'double') && all(size(letterModel) <= [1 6000]));
assert(isa(letterTest,'double') && all(size(letterTest) <= [1 6000]));




% letterModel and letterTest arrays have 0 cordinates
% because of how they are constucted in Java

% although the received parameters are (1x6000) arrays
% after deleting the 0 coordinates they become (6000x1) arrays
% therefore the arrays need to be transposed
% this is only when calling the dll version of this function from Java
% when called as standalone from Matlab, no need for transposition
letterModel = letterModel(letterModel~=0)';
letterTest = letterTest(letterTest~=0)';




% because arrays are (1x6000)
% we split them in two-row arrays
% x-coordinate on the first row
% y-coordinate on the second row
szm = round(size(letterModel,2)/2);
szt = round(size(letterTest,2)/2);

letterModel = reshape(letterModel, szm, 2)';
letterTest = reshape(letterTest, szt, 2)';

bitmapLetterModel = createBitmap(letterModel);
bitmapLetterTest = createBitmap(letterTest);

ver1 = sum(bitmapLetterModel,2)';
ver2 = sum(bitmapLetterTest,2)';
sum1 = max(ver1);
sum2 = max(ver2);

DistY = dtw(ver1/sum1, ver2/sum2);