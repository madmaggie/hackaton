function [out]=sound2features_plus(Y,Fs)

win = 0.10;step = 0.10;
Mfcc = (melcepst1(Y,Fs));

E = ShortTimeEnergy(Y, win*Fs, step*Fs);
Z = zcr(Y, win*Fs, step*Fs, Fs);
R = SpectralRollOff(Y, win*Fs, step*Fs, 0.80, Fs);
C = SpectralCentroid(Y, win*Fs, step*Fs, Fs);

FFF = zeros(1,4);
FF = zeros(1,4);

FFF(1) = statistic(Z, 1, length(Z), 'mean');
FFF(2) = statistic(R, 1, length(R), 'mean');
FFF(3) = statistic(C, 1, length(C), 'mean');
FFF(4) = statistic(E, 1, length(E), 'mean');

FF(1) = statistic(Z, 1, length(Z), 'std');
FF(2) = statistic(R, 1, length(R), 'std');
FF(3) = statistic(C, 1, length(C), 'std');
FF(4) = statistic(E, 1, length(E), 'std');

f1 = mean(Mfcc);
f2 = std(Mfcc);

out = [FFF(:); FF(:); f1(:);  f2(:); ];
%out = [FFF(:); FF(:); ];
%plot(out); pause(.5)
%keyboard 
