function bitmapLetter=createBitmap(letter)
%#codegen
% function receives raw coordinates of a letter and creates a bitmap of the
% letter
% letter: (x,y) coordinates of the letter - 2*N matrix
%       letter(1,:) - all x coordinates
%       letter(2,:) - all y coordinates
% bitmapLetter: xp*yp matrix with 1s and 0s
% Copyright 2013-2015 Atibo


assert(isa(letter,'double') && all(size(letter) <= [2 3000]));

% width & height of the grid
% witdh - distance (in pixels) between two oblique lines
% height - distance (in pixels) between two horizontal lines
% 25 & 35 are the values for the model letters written by Ana
% and for the letters acquired from 1st grade kids by Magda
% these are probably the final values so they are hardcoded here
% maybe a better idea would be to pass them as parameters to this function
% but for now, I leave them hardcoded here
width = 25;
height = 35;

% viewport coordinates
xp = 50;
yp = 50;

% bitmap letter
bitmapLetter = zeros(xp,yp);

%border = |minx maxx|
%         |miny maxy|

%letter = letter';
% minmax not available for codegen :(
% border = minmax(letter);

border = zeros(2,2);
border(1,1) = min(letter(1,:)); % minx
border(1,2) = max(letter(1,:)); % maxx
border(2,1) = min(letter(2,:)); % miny
border(2,2) = max(letter(2,:)); % maxy

border(2,1) = round80((border(2,1)-10)/height)*height; % miny - first horizontal line above the letter
border(2,2) = border(2,1)+height*5; % maxy-miny = 5*height
border(1,1) = round80((border(1,1)-10)/width)*width; % minx - first oblique line at the left of the letter
border(1,2) = border(1,1)+width*9; % maxx-minx = 9*width

xcoord = round((letter(1,:)-border(1,1)) * xp / (border(1,2)-border(1,1)));
ycoord = round((letter(2,:)-border(2,1)) * yp / (border(2,2)-border(2,1)));
for i=1:size(xcoord,2)
    if (xcoord(1,i) > 0 && ycoord(1,i) > 0)
        bitmapLetter(xcoord(1,i), ycoord(1,i)) = 1;
    end
end

bitmapLetter = bitmapLetter';

