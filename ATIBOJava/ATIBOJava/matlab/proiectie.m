function [Dist_hor, Dist_ver, timelag_x, timelag_y]=proiectie(bitmapLetterModel, bitmapLetter)
hor1=sum(bitmapLetterModel,1); hor2=sum(bitmapLetter,1);
ver1=sum(bitmapLetterModel,2); ver2=sum(bitmapLetter,2);

c = xcorr(sum(bitmapLetterModel,1),sum(bitmapLetter,1) - mean(sum(bitmapLetter,1)),'coeff');
%[d,f] = max(c);
[~,f] = max(c);
timelag_x = (length(sum(bitmapLetterModel,1)) - f);

c = xcorr(sum(bitmapLetterModel,2),sum(bitmapLetter,2) - mean(sum(bitmapLetter,2)),'coeff');
%[d,f] = max(c);
[~,f] = max(c);
timelag_y = (length(sum(bitmapLetterModel,2)) - f);

%disp('x displacement  -  y displacement')

%[timelag_x timelag_y]

sum1=max(hor1);
sum2=max(hor2);

%[Dist_hor,D_x,k_x,w_x,rw_x,tw_x] = dtw(hor1/sum1,hor2/sum2,0);
%[Dist_ver,D_y,k_y,w_y,rw_y,tw_y] = dtw(ver1/sum1,ver2/sum2,0);
[Dist_hor,~,~,~,~,~] = dtw_original(hor1/sum1,hor2/sum2,0);

sum1=max(ver1);
sum2=max(ver2);

[Dist_ver,~,~,~,~,~] = dtw_original(ver1/sum1,ver2/sum2,0);

%disp('distanta DTW orizontala  --- distanta DTW verticala  ')
%[Dist_hor Dist_ver]