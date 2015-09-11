function [Yout]=soundnormalization(Yin,Fsin,Fs)

N = size(Yin,1);
M = size(Yin,2);
% Stereo to mono conversion
if N>2
    Yout = Yin(:,1);
end
if M>2
    Yout = Yin(:,1);
end
% Double conversion
Yout = double(Yout);
Yout = resample(Yout,Fs,Fsin);