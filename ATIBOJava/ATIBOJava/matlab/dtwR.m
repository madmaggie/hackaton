function [distRmatlab, distRyo] = dtwR(letterModel, letterTest)
%#codegen
% computes the DTW distance on rotated letters
% used to determine if letter inclination is correct


assert(isa(letterModel,'double') && all(size(letterModel) <= [2 6000]));
assert(isa(letterTest,'double') && all(size(letterTest) <= [2 6000]));

bitmapLetterModel = createBitmap(letterModel);
bitmapLetterTest = createBitmap(letterTest);

s  = regionprops(bitmapLetterModel, 'centroid');
val=round(cat(1, s.Centroid));
centroids_model_x=val(1);
centroids_model_y=val(2);

s  = regionprops(bitmapLetterTest, 'centroid');
val=round(cat(1, s.Centroid));
centroids_test_x=val(1);
centroids_test_y=val(2);

centroids_model=[centroids_model_x centroids_model_y]
centroids_test=[centroids_test_x centroids_test_y]
[distRmatlab, ~, ~]=rotated_bitmap(bitmapLetterModel, bitmapLetterTest, centroids_model, centroids_test, 0);







[centroids_model_x,centroids_model_y]=centroids(bitmapLetterModel);

[centroids_test_x,centroids_test_y]=centroids(bitmapLetterTest);

centroids_model=[centroids_model_x centroids_model_y]
centroids_test=[centroids_test_x centroids_test_y]
[distRyo, ~, ~]=rotated_bitmap(bitmapLetterModel, bitmapLetterTest, centroids_model, centroids_test, 0);

