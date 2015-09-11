function bitmapLetterModel=desen_bitmap2(letterModel)
%#codegen

% viewport coordinates
xp = 50;
yp = 50;
width = 25;
height = 35;
%angle = 70;
% model letter
bitmapLetterModel = zeros(xp,yp);


%border = |minx miny|
%         |maxx maxy|

letterModel = letterModel';
border = minmax(letterModel);
border(2,1) = round80((border(2,1)-10)/height)*height;
border(2,2) = border(2,1)+height*5;
border(1,1) = round80((border(1,1)-10)/width)*width;
border(1,2) = border(1,1)+width*9;
xcoord = round((letterModel(1,:)-border(1,1)) * xp / (border(1,2)-border(1,1)));
ycoord = round((letterModel(2,:)-border(2,1)) * yp / (border(2,2)-border(2,1)));
%t = ycoord.*xp+xcoord;
for i=1:size(xcoord,2)
    if (xcoord(1,i) > 0 && ycoord(1,i) > 0)
        bitmapLetterModel(xcoord(1,i), ycoord(1,i)) = 1;
        %disp('xcoord ycoord')
        %[xcoord(1,i) ycoord(1,i)]
    end
end

bitmapLetterModel = bitmapLetterModel';

