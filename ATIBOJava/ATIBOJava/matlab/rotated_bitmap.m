function [Dist_rot, summodel, sumtest] = rotated_bitmap(bitmapLetterModel, bitmapLetter, centroids_model, centroids_test, plott)
%#codegen

%keyboard
dyt=-round(centroids_test(1))+25; dxt=-round(centroids_test(2))+25; 
dym=-round(centroids_model(1))+25; dxm=-round(centroids_model(2))+25; 

%[nr, nc]=size(bitmapLetterModel);
[~, nc]=size(bitmapLetterModel);
centeredLetter=bitmapLetter;
centeredLetterModel=bitmapLetterModel;

if dxt>0
    centeredLetter=[zeros(dxt, nc);centeredLetter];
else
    centeredLetter=[centeredLetter; zeros(abs(dxt), nc)];
end

%[nr, nc]=size(centeredLetter);
[nr, ~]=size(centeredLetter);
if dyt>0
    centeredLetter=[zeros(nr, dyt) centeredLetter];
else
    centeredLetter=[centeredLetter zeros(nr, abs(dyt))];
end

%[nr, nc]=size(centeredLetterModel);
[~, nc]=size(centeredLetterModel);
if dxm>0
    centeredLetterModel=[zeros(dxm, nc);centeredLetterModel];
else
    centeredLetterModel=[centeredLetterModel; zeros(abs(dxm), nc)];
end;

%[nr, nc]=size(centeredLetterModel);
[nr, ~]=size(centeredLetterModel);
if dym>0
    centeredLetterModel=[zeros(nr, dym) centeredLetterModel];
else
    centeredLetterModel=[centeredLetterModel zeros(nr, abs(dym))];
end

disp('rotated_bitmap')

s  = regionprops(centeredLetter, 'centroid');
centroids_testc = round(cat(1, s.Centroid))
s  = regionprops(centeredLetterModel, 'centroid');
centroids_modelm = round(cat(1, s.Centroid))
%centroids_testc=[25 25];centroids_modelm=centroids_testc;

% [centroids_model_x,centroids_model_y] = centroids(centeredLetterModel);
% [centroids_test_x,centroids_test_y] = centroids(centeredLetter);
% centroids_modelm = [centroids_model_x centroids_model_y]
% centroids_testc = [centroids_test_x centroids_test_y]

centeredLetter = centeredLetter(centroids_testc(1)-24:centroids_testc(1)+24, centroids_testc(2)-24:centroids_testc(2)+24);
centeredLetterModel = centeredLetterModel(centroids_modelm(1)-24:centroids_modelm(1)+24, centroids_modelm(2)-24:centroids_modelm(2)+24);

unghi = 340;
%rotated_test = imrotate(centeredLetter, unghi); % 90-20=70
%rotated_model = imrotate(centeredLetterModel, unghi);

 % trebuie sa se taie imaginea la dimensiunea de 49x49
% nu merge tot tmpul cu imrotate ->imagine mai mare!!
%rotated_test = rotateAround(centeredLetter, centroids_testc(1),centroids_testc(2), unghi);
%rotated_model = rotateAround(centeredLetterModel, centroids_modelm(1),centroids_modelm(2), unghi); 
%rotated_test = rotateAround(centeredLetter, 25, 25, unghi);
%rotated_model = rotateAround(centeredLetterModel, 25,25, unghi);


rotated_test = anotherRotateImageWithoutImrotate(centeredLetter,unghi);
rotated_model = anotherRotateImageWithoutImrotate(centeredLetterModel,unghi);

sumtest=sum(rotated_test);
summodel=sum(rotated_model);

%disp('DTW on rotated letters')
Dist_rot=dtw(sumtest,summodel)/sum(summodel);

if plott
figure,subplot(221), imshow(centeredLetterModel), title('model'),subplot(222), imshow(centeredLetter), title('test')
subplot(223), imshow(rotated_model), title('rotated model'),subplot(224), imshow(rotated_test), title('rotated test')
figure, plot(sumtest);hold on;plot(summodel,'r'); title('rotated projection'),legend('test','model')
end