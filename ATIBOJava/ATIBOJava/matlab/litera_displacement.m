%
%
% exemplu de determinare a deplasarii pe x si y 
%
%
[filename1, pathname] = uigetfile('*.TXT', 'Pick the prototype file');
cd (pathname)
letterModel=load(filename1);
letterModel=letterModel(:,1:2);

[filename1, pathname] = uigetfile('*.txt', 'Pick the test file');
cd (pathname)
letter=load(filename1);
letter=letter(:,1:2);
cd ..

% viewport coordinates
xp = 50;
yp = 50;


% model letter
bitmapLetterModel = zeros(xp,yp);

%border = |minx miny|
%         |maxx maxy|

letterModel = letterModel';
border = minmax(letterModel);
border(2,1) = round((border(2,1)-10)/60)*60;
border(2,2) = border(2,1)+60*3;
border(1,1) = floor((border(1,1)-10)/30)*30;
border(1,2) = border(1,1)+30*6;
xcoord = round((letterModel(1,:)-border(1,1)) * xp / (border(1,2)-border(1,1)));
ycoord = round((letterModel(2,:)-border(2,1)) * yp / (border(2,2)-border(2,1)));
%t = ycoord.*xp+xcoord;
for i=1:size(xcoord,2)
    if (xcoord(1,i) > 0 && ycoord(1,i) > 0)
        bitmapLetterModel(xcoord(1,i), ycoord(1,i)) = 1;
    end
end

bitmapLetterModel = bitmapLetterModel';


% user letter
bitmapLetter = zeros(xp,yp);

%border = |minx miny|
%         |maxx maxy|

letter = letter';
border = minmax(letter);
border(2,1) = round((border(2,1)-10)/60)*60;
border(2,2) = border(2,1)+60*3;
border(1,1) = floor((border(1,1)-10)/30)*30;
border(1,2) = border(1,1)+30*6;
xcoord = round((letter(1,:)-border(1,1)) * xp / (border(1,2)-border(1,1)));
ycoord = round((letter(2,:)-border(2,1)) * yp / (border(2,2)-border(2,1)));
%t = ycoord.*xp+xcoord;
for i=1:size(xcoord,2)
    if (xcoord(1,i) > 0 && ycoord(1,i) > 0)
        bitmapLetter(xcoord(1,i), ycoord(1,i)) = 1;
    end
end

bitmapLetter = bitmapLetter';


subplot(2,2,1)

[r,c] = size(bitmapLetterModel);                           %# Get the matrix size
imagesc((1:c)+0.5,(1:r)+0.5,bitmapLetterModel);            %# Plot the image
colormap(gray);                              %# Use a gray colormap
axis equal                                   %# Make axes grid sizes equal

set(gca,'XTick',1:10:(c+1),'YTick',1:10:(r+1),...  %# Change some axes properties
        'XLim',[1 c+1],'YLim',[1 r+1],...
        'GridLineStyle','-','XGrid','on','YGrid','on');
title('Prototype Letter')

subplot(2,2,3)    

[r,c] = size(bitmapLetter);                           %# Get the matrix size
imagesc((1:c)+0.5,(1:r)+0.5,bitmapLetter);            %# Plot the image
colormap(gray);                              %# Use a gray colormap
axis equal                                   %# Make axes grid sizes equal

set(gca,'XTick',1:10:(c+1),'YTick',1:10:(r+1),...  %# Change some axes properties
        'XLim',[1 c+1],'YLim',[1 r+1],...
        'GridLineStyle','-','XGrid','on','YGrid','on');
title('Test Letter')

% make histogram on x
%hist(sum(bitmapLetter,1),50)

subplot(222)
plot(sum(bitmapLetterModel,1),'r')
hold on
plot(sum(bitmapLetter,1),'b')
axis([1 50 0 17])
hold off
title('The projection on x-axis')
legend('Prototype Letter','Test letter')

subplot(224)
plot(sum(bitmapLetterModel,2),'r')
hold on
plot(sum(bitmapLetter,2),'b')
axis([1 50 0 11])
hold off
title('The projection on y-axis')
legend('Prototype Letter','Test letter')

c = xcorr(sum(bitmapLetterModel,1),sum(bitmapLetter,1) - mean(sum(bitmapLetter,1)),'coeff');
[~,f] = max(c); timelag_x = (length(sum(bitmapLetterModel,1)) - f);

c = xcorr(sum(bitmapLetterModel,2),sum(bitmapLetter,2) - mean(sum(bitmapLetter,2)),'coeff');
[~,f] = max(c); timelag_y = (length(sum(bitmapLetterModel,2)) - f);

disp('x displacement  -  y displacement')

%[timelag_x timelag_y]

