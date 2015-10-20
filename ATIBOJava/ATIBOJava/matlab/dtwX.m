function DistX = dtwX(letterModel, letterTest)
%#codegen
% computes the DTW distance on X
% letterModel - raw (x,y) coordinates of the model letter
% letterTest - raw (x,y) coordinates of the test letter


assert(isa(letterModel,'double') && all(size(letterModel) <= [1 6000]));
assert(isa(letterTest,'double') && all(size(letterTest) <= [1 6000]));



%
% debug letterModel and letterTest print
%
% [r,c] = size(letterModel);
% formatStringWithNL = ['%d ' 10 0];
% formatStringWithoutNL = ['%d ' 0];
% coder.ceval('printf', ['letterModel size: ' 0]);
% coder.ceval('printf', formatStringWithoutNL, int32(r));
% coder.ceval('printf', formatStringWithNL, int32(c));
% 
% 
% for i=1:10
%     for j=1:10
%         formatStringWithoutNL = ['%1.3f ' 0];
%         coder.ceval('printf', formatStringWithoutNL, letterModel(i,j));
%     end
%     coder.ceval('printf', ['' 10 0]);
% end
% 
% 
% [r,c] = size(letterTest);
% formatStringWithNL = ['%d ' 10 0];
% formatStringWithoutNL = ['%d ' 0];
% coder.ceval('printf', ['letterTest size: ' 0]);
% coder.ceval('printf', formatStringWithoutNL, int32(r));
% coder.ceval('printf', formatStringWithNL, int32(c));
% for i=1:10
%     for j=1:10
%         formatStringWithoutNL = ['%1.3f ' 0];
%         coder.ceval('printf', formatStringWithoutNL, letterTest(i,j));
%     end    
%     coder.ceval('printf',['' 10 0]);
% end
% 
% 



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

hor1 = sum(bitmapLetterModel,1);
hor2 = sum(bitmapLetterTest,1);
sum1 = max(hor1);
sum2 = max(hor2);

DistX = dtw(hor1/sum1, hor2/sum2);