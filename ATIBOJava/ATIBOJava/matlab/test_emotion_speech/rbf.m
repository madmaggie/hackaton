function [TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy, Centers, betas, Theta] = rbf(train_mat,test_mat,centersPerCategory)

% Usage: [TrainingTime, TestingTime, TrainingAccuracy, TestingAccuracy] = rbf(TrainingData_File, TestingData_File, Elm_Type, NumberofHiddenNeurons, ActivationFunction)
%

matrix_data=[train_mat test_mat];

[features_size, Lfeat]=size(matrix_data); 
%idx = randperm(features_size);
idx=1:features_size;
matrix_data = matrix_data(idx,:);

dimens=fix(2*features_size/3);

trainDistance = matrix_data(1:dimens,1:Lfeat-1);
trainEmotion = matrix_data(1:dimens,Lfeat);
testEmotion = matrix_data(dimens+1:size(matrix_data,1),Lfeat);
testDistance = matrix_data(dimens+1:size(matrix_data,1),1:Lfeat-1);

% Set 'm' to the number of data points.
m = size(trainDistance, 1);

%disp('Training the RBFN...');

start_time_train=cputime;

[Centers, betas, Theta] = trainRBFN(trainDistance,   trainEmotion, centersPerCategory,0);
end_time_train=cputime;
TrainingTime=end_time_train-start_time_train;        %   Calculate CPU time (seconds) spent for training ELM
%%%%%%%%%%% Calculate the training accuracy
numRight = 0;
wrong = [];
% For each training sample...
for i = 1 : m,
    % Compute the scores for all the 3 categories.
    
    scores = evaluateRBFN(Centers, betas, Theta, trainDistance(i, :));
   
	[maxScore, category] = max(scores);
    	
    % Validate the result.
    if (category == trainEmotion(i))
        numRight = numRight + 1;
    else
        wrong = [wrong; trainDistance(i, :)];
    end
    
end

TrainingAccuracy = numRight / m * 100;
%fprintf('Training accuracy: %d / %d, %.1f%%\n', numRight, m, TrainingAccuracy);

%%%%%%%%%%% Calculate the output of testing input
start_time_test=cputime;
%disp('Measuring testing accuracy...');

numRight = 0;
wrong = [];
m1 = size(testDistance,1);

% For each training sample...
for i = 1 : m1,
    % Compute the scores for all the 3 categories.
    scores = evaluateRBFN(Centers, betas, Theta, testDistance(i, :));
    
	[maxScore, category] = max(scores);
	
    % Validate the result.
    if (category == testEmotion(i))
        numRight = numRight + 1;
    else
        wrong = [wrong; testDistance(i, :)];
    end
    
end

TestingAccuracy = numRight / m1 * 100;
%fprintf('Testing accuracy: %d / %d, %.1f%%\n', numRight, m1, TestingAccuracy);

end_time_test=cputime;
TestingTime=end_time_test-start_time_test;           %   Calculate CPU time (seconds) spent by ELM predicting the whole testing data

%[C,order] = confusionmat(group,grouphat)

