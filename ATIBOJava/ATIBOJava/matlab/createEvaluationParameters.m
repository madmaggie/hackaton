% This file computes and writes to a file the evaluation parameters for a
% set of letters (the same type of letter written multiple times)
% Each row in the file contains:
% 1. Path to the file containing the (x,y) coordinates that compose the test letter
% 2. Euclidian distance between centers of mass of the test and model
% letters (normalized coordinates)
% 3. DTW distance computed on X (sum of the projections of bitmap letters on X)
% 4. DTW distance computed on Y (sum of the projections of bitmap letters on Y)
% 5. DTW distance computed on absolute angles (using normalized coordinates)
% 6. DTW distance computed on rotated letter - letter is rotated
% counterclockwise with 20 degrees; distance gives the inclination error of
% the test letter over the model letter (using normalized coordinates)


testFolder = 'W:\eclipseluna\ATIBOJava\BD litere antrenament\Bmic_Bine_1402488794505';
testFiles = dir(testFolder);

fisref = 'W:\eclipseluna\ATIBOJava\modellitere\BmicModel.txt';
fisrefRaw = 'W:\eclipseluna\ATIBOJava\modellitere\BmicModelRaw.txt';

resultsFile = fopen('evaluationParameters.txt','w');

%testFile = fopen('testfile.txt','w');


plotno=1;
figure('name',testFolder,'numbertitle','off')
%legend('Litera model', 'Litera test')
for j=1:length(testFiles)
    if (not(testFiles(j).isdir) && (size(regexp(testFiles(j).name,'.txt'),1)>0) && (size(regexp(testFiles(j).name,'_raw.txt'),1)==0))
        fistest = [testFolder '\' testFiles(j).name]
        index = regexp(fistest,'\')
    end
    if (not(testFiles(j).isdir) && (size(regexp(testFiles(j).name,'_raw.txt'),1)>0))
        fistestRaw = [testFolder '\' testFiles(j).name]
        subplot(3,10,plotno)
        plotno = plotno+1;
        [cmModel, cmTest, Dist_x, Dist_y, Dist_u_abs, Dist_rot, height_model, height_test, width_model, width_test, borderModel, borderTest] = plotletter(fisref, fistest, fisrefRaw, fistestRaw, 0, plotno);
        plotno = plotno+1;
        % euclidean distance berween the centers of mass of the test and model letters
        Dist_cm = sqrt((cmModel(1)-cmTest(1))^2+(cmModel(2)-cmTest(2))^2);
        %fprintf(resultsFile,'%s %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f %.2f [%.2f %.2f %.2f %.2f] [%.2f %.2f %.2f %.2f] \n', ...
        %        fistestRaw(index(end-1):end), Dist_cm, Dist_x, Dist_y, Dist_u_abs, Dist_rot, height_model, height_test, width_model, width_test, borderModel, borderTest);
       
        fprintf(resultsFile,'%s %.2f %.2f %.2f %.2f %.2f \n', fistestRaw(index(end-1):end), Dist_cm, Dist_x, Dist_y, Dist_u_abs, Dist_rot);
  
        %fprintf(testFile, '[%f %f %f %f] [%f %f %f %f] \n', borderModel, borderTest);
    end
end

%close all
fclose(resultsFile);
%fclose(testFile);


