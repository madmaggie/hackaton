% algorithm for evalauting the letter
% function receives as input
%   cmModel - centre of mass of the model letter, normalized coordinates
%   cmTest - centre of mass of the test letter, normalized coordinates
%   Dist_x - DTW distance measured over X vector coordinates
%   Dist_y - DTW distance measured over Y vector coordinates
%   Dist_abs - DTW distance measured over the angles between each line
%   segment of the letter and the X axis
%   borderModel - min and max values
% returns as output
%   horizontalShift - shows the distance that the letter is shifted with to the left or
%   right of the oblique line (+ - shifte to the right, - - shifted to the
%   left, 0 - not shifted)
%   verticalShift - shows the distance that the letter is shifted with
%   upper or lower of the horizontal line (+ - shifte up, - - shifted down, 0 - not shifted)

function [horizontalShift, verticalShift, shape] = evaluate(cmModel, cmTest, Dist_x, Dist_y, Dist_abs, borderModel, borderTest)

[filename1, pathname] = uigetfile('*.TXT', 'Pick the prototype file')
letterModel = load(strcat(pathname,filename1));
letterModel = letterModel(:,1:2);

[filename1, pathname] = uigetfile('*.txt', 'Pick the test file');
cd (pathname)
letter = load(filename1);
letter = letter(:,1:2);
cd ..

% viewport coordinates
xp = 50;
yp = 50;