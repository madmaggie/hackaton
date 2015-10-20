function speech_emotion_test(varianta)


%clear
%centersPerCategory=20;
%addpath('kMeans');
%addpath('RBFN');
%varianta=1; %  1 for a test on recorded speech signal
            %  0 for recording a speech signal and test on it

pathname = '/media/micky/WORK/ATIBO/bazededate/BasedeDatos-EmoWisconsin/AY-molesto-negative';
            
files = dir(pathname)


%crtDir = pwd;
%cd (pathname)
            
for i=3:size(files,1)
    if varianta
        %crtDir = pwd;
        %[sound_file, pathname] = uigetfile('*.wav', 'Pick a sound file');
        %cd (pathname)
        % [Y,Fs,bits] = wavread(sound_file);
        sound_file = files(i).name;
        [Y,Fs] = audioread([pathname '/' sound_file]);

        %cd(crtDir);

        %Y=detectVoce(Y,Fs);

    else
        recObj = audiorecorder;
        disp('Start speaking.')
        recordblocking(recObj, 5);
        disp('End of Recording.');

        Fs=recObj.SampleRate;
        %bits=recObj.BitsPerSample;

        Y = getaudiodata(recObj);
        %Y=detectVoce(Y,Fs);
    end
    subplot(1,i-2,i-2), plot(Y), title(sound_file)

    %load param_rbf_new_buna
    load param_rbf

    [Y]    = soundnormalization(Y,Fs,Fs);
    [Feat] = sound2features_plus(Y,Fs);
    Feat=(Feat'-Minim)./(Maxim-Minim+eps);

    
    %cd('RBFN')
    scores = evaluateRBFN(Centers, betas, Theta, Feat);
    %cd ..

    %[maxScore, category] = max(scores);
    [~, category] = max(scores);
    switch category
        case 1
            disp('Speech Emotion: Negative');
        case 2
            disp('Speech Emotion: Neutral');
        case 3
            disp('Speech Emotion: Pozitive');
    end
    
end
