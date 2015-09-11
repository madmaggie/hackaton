
currentFolder = pwd;

 [fisref, pathname] = uigetfile('*.TXT', 'Pick the reference file (RAW)');
 cd (pathname)
 letterRawModel = load(fisref);
 
 
 [fistest, pathname] = uigetfile('*.TXT', 'Pick the test file (RAW)');
 cd (pathname)
 letterRawTest = load(fistest);
 
 cd (currentFolder)
 
 widthref = 30;
 heightref = 60;
 angleref = 70;
 
 widthtest = 20;
 heighttest = 30;
 angletest = 70;
 
 %rap = (heighttest/widthtest)/(heightref/widthref);
 %rap = (heightref/widthref)/(heighttest/widthtest);
 rap = widthtest/widthref;

%fisref = './modellitere/coordRAWmodelAmare.txt';
%fistest = 'coordRAW.txt';

%letterRawTest = load(fistest);
%letterRawModel = load(fisref);

%letter = 

% viewport coordinates
xp = 50;
yp = 50;


% model letter
bitmapLetterModel = zeros(xp,yp);

%border = |minx miny| = |(1,1) (1,2)|
%         |maxx maxy|   |(2,1) (2,2)|

letterRawModel = letterRawModel';
border = minmax(letterRawModel);
border(2,1) = round80((border(2,1)-10)/heightref)*heightref;
border(2,2) = border(2,1)+heightref*5;
border(1,1) = round80((border(1,1)-10)/widthref)*widthref;
border(1,2) = border(1,1)+widthref*9;
%border(1,1) = 0;
%border(1,2) = 0;
% bitmapLetterModel = zeros(border(2,1),border(2,2));
% for i=1:size(letterRawModel,2)
    % bitmapLetterModel(letterRawModel(1,i),letterRawModel(2,i)) = 1;
% end
xcoord = round80((letterRawModel(1,:)-border(1,1)) * xp / (border(1,2)-border(1,1)));
ycoord = round80((letterRawModel(2,:)-border(2,1)) * yp / (border(2,2)-border(2,1)));
for i=1:size(xcoord,2)
    if (xcoord(1,i) > 0 && ycoord(1,i) > 0)
        bitmapLetterModel(xcoord(1,i), ycoord(1,i)) = 1;
    end
end

bitmapLetterModel = bitmapLetterModel';

%tg = find(sum(bitmapLetterModel)>5)
%round((tg(1)-10)/width)*width

% user letter
bitmapLetter = zeros(xp,yp);

%border = |minx miny|
%         |maxx maxy|

letterRawTest = (letterRawTest(1:2))';
border = minmax(letterRawTest);
border(2,1) = round80((border(2,1)-10)/heighttest)*heighttest;
border(2,2) = border(2,1)+heighttest*5;
border(1,1) = round80((border(1,1)-10)/widthtest)*widthtest;
border(1,2) = border(1,1)+widthtest*6;
xcoord = round80((letterRawTest(1,:)-border(1,1)) * xp / (border(1,2)-border(1,1)));
ycoord = round80((letterRawTest(2,:)-border(2,1)) * yp / (border(2,2)-border(2,1)));
for i=1:size(xcoord,2)
    if (xcoord(1,i) > 0 && ycoord(1,i) > 0)
        bitmapLetter(xcoord(1,i), ycoord(1,i)) = 1;
    end
end

bitmapLetter = bitmapLetter';


figure

subplot(2,3,1)
%fisref = './modellitere/coordmodelAmare.txt';
%fistest = 'coord.txt';
%letterModel = load(fisref);
%letterTest = load(fistest);

 [fisref, pathname] = uigetfile('*.TXT', 'Pick the reference file (normalized)');
 cd (pathname)
 letterModel = load(fisref);
  
 [fistest, pathname] = uigetfile('*.TXT', 'Pick the test file (normalized)');
 cd (pathname)
 letterTest = load(fistest);
 
 cd (currentFolder)
 
plot(letterModel(:,1),letterModel(:,2),'r*')
axis ij
hold on
plot(letterTest(:,1).*rap,letterTest(:,2),'b*')
title('Compara litera din abecedar cu litera ta')
legend('Litera din abecedar', 'Litera ta')

% plot liniatura caietului
% linii orizontale (continue si punctate) si linii oblice
% axis([-0.1,3.5,-0.1,3.6])

% plot(0:0.1:3.5,0*ones(1,36),'--')
% plot(0:0.1:3.5,ones(1,36),'-')
% plot(0:0.1:3.5,2*ones(1,36),'-')
% plot(0:0.1:3.5,3*ones(1,36),'--')

% b=3;
% a=-1/tan(20*pi/180);
% x=0:0.1:3.5;
% y=a*x+b;
% plot(x,y)

% b=3+0.5*tan(70*pi/180);
% y=a*x+b;
% plot(x,y)

% b=3+1*tan(70*pi/180);
% y=a*x+b;
% plot(x,y)

% b=3+1.5*tan(70*pi/180);
% y=a*x+b;
% plot(x,y)

% b=3+2*tan(70*pi/180);
% y=a*x+b;
% plot(x,y)

% b=3+2.5*tan(70*pi/180);
% y=a*x+b;
% plot(x,y)

% plot(0*ones(1,36),0:0.1:3.5)

border = minmax([letterModel(:,1:2); letterTest(:,1:2)]');

%axis([-0.1,3.5,-0.1,3.6])
axis([min(0,border(1,1)-1),border(1,2)+1,border(2,1)-1,border(2,2)+1])

% plot horizonal lines
x=border(1,1)-1:0.1:border(1,2)+1;
for i=0:round(border(2,2))
    if (mod(i,3)==0)
        plot(x,i*ones(1,size(x,2)),'--')
    else
        plot(x,i*ones(1,size(x,2)),'-')
    end
end

% plot oblique lines
a=-1/tan((90-angleref)*pi/180);
x=border(1,1)-1:0.1:border(1,2)+1;

for i=0:widthref/heightref:border(1,2)+1
    %i
    b=3+i*tan(angleref*pi/180);
    y=a*x+b;
    plot(x,y)
end



%%%%%%%%%%%%%%%%%%%%%%% bitmap litera model %%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(2,3,2)

[r,c] = size(bitmapLetterModel);                           %# Get the matrix size
imagesc((1:c)+0.5,(1:r)+0.5,bitmapLetterModel);            %# Plot the image
colormap(gray);                              %# Use a gray colormap
axis equal                                   %# Make axes grid sizes equal

set(gca,'XTick',1:50:(c+1),'YTick',1:50:(r+1),...  %# Change some axes properties
        'XLim',[1 c+1],'YLim',[1 r+1],...
        'GridLineStyle','-','XGrid','on','YGrid','on');
title('Litera din abecedar')

%%%%%%%%%%%%%%%%%%%%%%% bitmap litera model rotita %%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(2,3,4)

initial = bitmapLetterModel;
bitmapLetterModel = imrotate(bitmapLetterModel,20);

%tg = find(sum(bitmapLetterModel)>5)
%round((tg(1)-10)/30)*30


[r,c] = size(bitmapLetterModel);                           %# Get the matrix size
imagesc((1:c)+0.5,(1:r)+0.5,bitmapLetterModel);            %# Plot the image
colormap(gray);                              %# Use a gray colormap
axis equal                                   %# Make axes grid sizes equal

set(gca,'XTick',1:50:(c+1),'YTick',1:50:(r+1),...  %# Change some axes properties
        'XLim',[1 c+1],'YLim',[1 r+1],...
        'GridLineStyle','-','XGrid','on','YGrid','on');
title('Litera din abecedar')



%%%%%%%%%%%%%%%%%%%%% bitmap litera test %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


subplot(2,3,3)
[r,c] = size(bitmapLetter);                           %# Get the matrix size
bitmapLetter = imrotate(bitmapLetter,20);
imagesc((1:c)+0.5,(1:r)+0.5,bitmapLetter);            %# Plot the image
colormap(gray);                              %# Use a gray colormap
axis equal                                   %# Make axes grid sizes equal

set(gca,'XTick',1:5:(c+1),'YTick',1:5:(r+1),...  %# Change some axes properties
        'XLim',[1 c+1],'YLim',[1 r+1],...
        'GridLineStyle','-','XGrid','on','YGrid','on');
title('Litera ta')



%%%%%%%%%%%%%%%%%%%%%%% proiectie litera model %%%%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(2,3,5)
plot(sum(initial,1),'r')
hold on
plot(sum(bitmapLetterModel,1),'g')
plot(sum(bitmapLetter,1),'b')
legend('litera din abecedar', 'litera din abecedar rotita', 'litera ta')


%%%%%%%%%%%%%%%%%%%%%%%%%% proiectie litera test %%%%%%%%%%%%%%%%%%%%%%%%%%

subplot(2,3,6)
plot(sum(bitmapLetterModel,2),'r')
hold on
plot(sum(bitmapLetter,2),'b')
legend('litera din abecedar', 'litera ta')



%%%%%%%%%%%%%%%%%%% compute displacements %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

c = xcorr(sum(bitmapLetterModel,1),sum(bitmapLetter,1) - mean(sum(bitmapLetter,1)),'coeff');
[~,f] = max(c); timelag_x = (length(sum(bitmapLetterModel,1)) - f);

c = xcorr(sum(bitmapLetterModel,2),sum(bitmapLetter,2) - mean(sum(bitmapLetter,2)),'coeff');
[~,f] = max(c); timelag_y = (length(sum(bitmapLetterModel,2)) - f);

disp('x displacement  -  y displacement')

%[timelag_x timelag_y]

