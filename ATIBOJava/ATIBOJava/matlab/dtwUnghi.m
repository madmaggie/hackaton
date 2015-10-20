function DistU = dtwUnghi(letterModel, letterTest)
%#codegen

assert(isa(letterModel,'double') && all(size(letterModel) <= [1 6000]));
assert(isa(letterTest,'double') && all(size(letterTest) <= [1 6000]));





% letterModel and letterTest arrays have 0 cordinates
% because of how they are constucted in Java

% although the received parameters are (1x6000) arrays
% after deleting the 0 coordinates they become (6000x1) arrays
% therefore the arrays need to be transposed
% this is only when calling the dll version of this function from Java
% when called as standalone from Matlab, no need for transposition
%letterModel = letterModel(letterModel~=0)';
%letterTest = letterTest(letterTest~=0)';






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

reshapedBitmapLetterModel = reshape(bitmapLetterModel,1,size(bitmapLetterModel,1)*size(bitmapLetterModel,2));
reshapedBitmapLEtterTest = reshape(bitmapLetterTest,1,size(bitmapLetterTest,1)*size(bitmapLetterTest,2));


factor = 7;

pixModel = pixels(reshapedBitmapLetterModel);
pixTest = pixels(reshapedBitmapLEtterTest);
model0 = pixModel(1:factor:end,:);
test0 = pixTest(1:factor:end,:);
model1 = Compute_AbslAng_Chain(model0);
test1 = Compute_AbslAng_Chain(test0);

DistU = dtw(model1/360,test1/360);