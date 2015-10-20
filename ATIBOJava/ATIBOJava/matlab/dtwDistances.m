function [DistX, DistY, DistU, DistR] = dtwDistances(letterModel, letterTest)
%#codegen
% computes the DTW distances on X, on Y, on absolute angles and on rotated
% letters
% letterModel - raw (x,y) coordinates of the model letter
%               2*N matrix
% letterTest - raw (x,y) coordinates of the test letter
%               2*N matrix
%
% Copyright 2013-2015 Atibo

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%               DTW distance on X                 %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

hor1 = sum(bitmapLetterModel,1);
hor2 = sum(bitmapLetterTest,1);
sum1 = max(hor1);
sum2 = max(hor2);

DistX = dtw(hor1/sum1, hor2/sum2);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%               DTW distance on Y                 %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


ver1 = sum(bitmapLetterModel,2)';
ver2 = sum(bitmapLetterTest,2)';
sum1 = max(ver1);
sum2 = max(ver2);

DistY = dtw(ver1/sum1, ver2/sum2);



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%         DTW distance on absolute angles         %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

factor = 7;

pixModel = pixels(bitmapLetterModel);
pixTest = pixels(bitmapLetterTest);
model0 = pixModel(1:factor:end,:);
test0 = pixTest(1:factor:end,:);
model1 = Compute_AbslAng_Chain(model0);
test1 = Compute_AbslAng_Chain(test0);

DistU = dtw(model1/360,test1/360);




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%         DTW distance on rotated letters         %%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

[centroids_model_x,centroids_model_y]=correctCentroids(bitmapLetterModel);
[centroids_test_x,centroids_test_y]=correctCentroids(bitmapLetterTest);

centroids_model = [centroids_model_x centroids_model_y];
centroids_test = [centroids_test_x centroids_test_y];


dyt = -round(centroids_test(1))+25;
dxt = -round(centroids_test(2))+25; 
dym = -round(centroids_model(1))+25;
dxm = -round(centroids_model(2))+25; 

[~, nc]=size(bitmapLetterModel);
centeredLetterTest = bitmapLetterTest;
centeredLetterModel = bitmapLetterModel;

if dxt>0
    centeredLetterTest=[zeros(dxt, nc);centeredLetterTest];
else
    centeredLetterTest=[centeredLetterTest; zeros(abs(dxt), nc)];
end

[nr, ~] = size(centeredLetterTest);
if dyt>0
    centeredLetterTest = [zeros(nr, dyt) centeredLetterTest];
else
    centeredLetterTest = [centeredLetterTest zeros(nr, abs(dyt))];
end



[~, nc] = size(centeredLetterModel);
if dxm>0
    centeredLetterModel=[zeros(dxm, nc);centeredLetterModel];
else
    centeredLetterModel=[centeredLetterModel; zeros(abs(dxm), nc)];
end;

[nr, ~]=size(centeredLetterModel);
if dym>0
    centeredLetterModel=[zeros(nr, dym) centeredLetterModel];
else
    centeredLetterModel=[centeredLetterModel zeros(nr, abs(dym))];
end


[centroids_model_x,centroids_model_y]=correctCentroids(centeredLetterModel);
[centroids_test_x,centroids_test_y]=correctCentroids(centeredLetterTest);
centroids_model = [centroids_model_x centroids_model_y];
centroids_test = [centroids_test_x centroids_test_y];

centeredLetterTest = centeredLetterTest(centroids_test(1)-24:centroids_test(1)+24, centroids_test(2)-24:centroids_test(2)+24);
centeredLetterModel = centeredLetterModel(centroids_model(1)-24:centroids_model(1)+24, centroids_model(2)-24:centroids_model(2)+24);




unghi = 340;

rotated_test = anotherRotateImageWithoutImrotate(centeredLetterTest,unghi);
rotated_model = anotherRotateImageWithoutImrotate(centeredLetterModel,unghi);


%subplot(2,2,1), imshow(bitmapLetterModel)
%subplot(2,2,2), imshow(bitmapLetterTest)
%subplot(2,2,3), imshow(rotated_model)
%subplot(2,2,4), imshow(rotated_test)

sumtest=sum(rotated_test);
summodel=sum(rotated_model);

DistR=dtw(sumtest,summodel)/sum(summodel);



