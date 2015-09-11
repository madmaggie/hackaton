%function [cmModel, cmTest, Dist_x, Dist_y, Dist_u_abs, Dist_rot, height_model, height_test, width_model, width_test, borderModel, borderTest] = plotletter(fisref, fistest, fisrefRaw, fistestRaw, plotbit, plotno)
function [cmModel, cmTest, Dist_x, Dist_y, Dist_u_abs, Dist_rot, height_model, height_test, width_model, width_test, borderModel, borderTest] = plotletter(fisref, fistest, fisrefRaw, fistestRaw, plotbit)
%#codegen

% pwd
% fisref
% fistest
% fisrefRaw
% fistestRaw

letterModel = load(fisref);
%letterModel(:,1) = letterModel(:,1)+0.5;
%save 'cmaremare.txt' letterModel '-ascii'
%save 'cmaremare.txt' letterModel '-%4.3f'
%file=fopen('cmaremare.txt','w');
%fprintf(file,'%4.3f',letterModel);
%dlmwrite('cmaremare.txt',letterModel,'delimiter','\t');
%fclose(file);
letterTest = load(fistest);
letterTest(:,1) = letterTest(:,1).*0.83;


heightModel = 60;
widthModel = 30;
%heightTest = 35;
%widthTest = 25;
 heightTest = 30;
 widthTest = 20;
angle = 70;


% TODO
% acesl 0.83 de mai sus
% cu formula asta iese 0.7 (25/35) sau 0.74 (20/30)
%scalingConstant = (heightTest/heightModel) * (widthModel/widthTest);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% compute center of mass %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%

%disp('center of mass')
cmModel = mean(letterModel(:,1:2));
cmTest = mean(letterTest(:,1:2));
%mean(letterModel)

% print reference letter and student letter on the same figure
% using normalized coordinates
% figure('name',fistest,'numbertitle','off')
plot(letterModel(:,1),letterModel(:,2),'r*')
axis ij
hold on
%plot(letterTest(:,1).*((widthModel/heightModel)/(widthTest/heightTest)*(cos(pi/2-angleModel)/cos(pi/2-angleTest))),letterTest(:,2),'b*')
%plot(letterTest(:,1).*((widthModel/heightModel)/(widthTest/heightTest)),letterTest(:,2),'b*')
plot(letterTest(:,1),letterTest(:,2),'b*')
%plot(letterTest(:,1).*scalingConstant,letterTest(:,2),'b*')
index = regexp(fistest,'\');
imagetitle = fistest(index(end-1):end);
title(imagetitle)
%legend('Litera model', 'Litera test')
%if (plotno==2)
    legend('Litera model', 'Litera test')
%end

% print liniatura caietului
% linii orizontale continue si punctate si linii oblice

% axis([-0.1,3.5,-0.1,3.6])

% plot(0:0.1:3.5,0*ones(1,36),'--')
% plot(0:0.1:3.5,ones(1,36),'-')
% plot(0:0.1:3.5,2*ones(1,36),'-')
% plot(0:0.1:3.5,3*ones(1,36),'--')
% 
% b=3;
% a=-1/tan(20*pi/180);
% x=0:0.1:3.5;
% y=a*x+b;
% plot(x,y)
% 
% b=3+0.5*tan(70*pi/180);
% y=a*x+b;
% plot(x,y)
% 
% b=3+1*tan(70*pi/180);
% y=a*x+b;
% plot(x,y)
% 
% b=3+1.5*tan(70*pi/180);
% y=a*x+b;
% plot(x,y)
% 
% b=3+2*tan(70*pi/180);
% y=a*x+b;
% plot(x,y)
% 
% b=3+2.5*tan(70*pi/180);
% y=a*x+b;
% plot(x,y)
% 
% plot(0*ones(1,36),0:0.1:3.5)

%%%%%%%%%   print horizontal lines   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

border = minmax([letterModel(:,1:2); letterTest(:,1:2)]');

%border = |minx maxx|
%         |miny maxy|

%axis = [minx, maxx, miny, maxy]

axis([min(0,border(1,1)-1),border(1,2)+1,border(2,1)-1,border(2,2)+1])

x=border(1,1)-1:0.1:border(1,2)+1;
for i=0:round(border(2,2)+1)
    if (mod(i,3)==0)
        plot(x,i*ones(1,size(x,2)),'--')
    else
        plot(x,i*ones(1,size(x,2)),'-')
    end
end

%%%%%%%%%%%%   print oblique lines   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


a=-1/tan((90-angle)*pi/180);
x=border(1,1)-1:0.1:border(1,2)+1;

for i=0:widthTest/heightTest:border(1,2)+1
    b=3+i*tan(angle*pi/180);
    y=a*x+b;
    plot(x,y,'b')
end


hold on

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% plot bitmap and projections of each letter %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


letterTestRaw = load(fistestRaw);
letterModelRaw = load(fisrefRaw);

% viewport coordinates
xp = 50;
yp = 50;


% model letter
bitmapLetterModel = zeros(xp,yp);

%border = |minx maxx|
%         |miny maxy|

letterModelRaw = letterModelRaw';
border = minmax(letterModelRaw(1:2,:));
border(2,1) = round80((border(2,1)-10)/heightModel)*heightModel;
border(2,2) = border(2,1)+heightModel*3;
border(1,1) = round80((border(1,1)-10)/widthModel)*widthModel;
border(1,2) = border(1,1)+widthModel*5;
xcoord = round((letterModelRaw(1,:)-border(1,1)) * xp / (border(1,2)-border(1,1)));
ycoord = round((letterModelRaw(2,:)-border(2,1)) * yp / (border(2,2)-border(2,1)));
for i=1:size(xcoord,2)
    if (xcoord(1,i) > 0 && ycoord(1,i) > 0 && xcoord(1,i) <= 50 && ycoord(1,i) <=50)
        bitmapLetterModel(xcoord(1,i), ycoord(1,i)) = 1;
    end
end

bitmapLetterModel = bitmapLetterModel';
borderModel = border;

% user letter
bitmapLetter = zeros(xp,yp);

%border = |minx miny|
%         |maxx maxy|

letterTestRaw = letterTestRaw';
border = minmax(letterTestRaw(1:2,:));
border(2,1) = round80((border(2,1)-10)/heightTest)*heightTest;
border(2,2) = border(2,1)+heightTest*3;
border(1,1) = round80((border(1,1)-10)/widthTest)*widthTest;
border(1,2) = border(1,1)+widthTest*5;
%xcoord = round(((letterTestRaw(1,:)-border(1,1)) * xp / (border(1,2)-border(1,1))) .* (widthModel/heightModel)/(widthTest/heightTest));%+round(24*xp/(border(1,2)-border(1,1)));
xcoord = round(((letterTestRaw(1,:)-border(1,1)) * xp / (border(1,2)-border(1,1))));
ycoord = round((letterTestRaw(2,:)-border(2,1)) * yp / (border(2,2)-border(2,1)));
for i=1:size(xcoord,2)
    if (xcoord(1,i) > 0 && ycoord(1,i) > 0 && xcoord(1,i) <= 50 && ycoord(1,i) <= 50)
        bitmapLetter(xcoord(1,i), ycoord(1,i)) = 1;
    end
end

%size(bitmapLetter)
bitmapLetter = bitmapLetter';
borderTest = border;


if (~plotbit)
    %subplot(3,10,plotno)
    [r,c] = size(bitmapLetter);                           %# Get the matrix size
    imagesc((1:c)+0.5,(1:r)+0.5,bitmapLetter);            %# Plot the image
    colormap(gray);                              %# Use a gray colormap
    axis equal                                   %# Make axes grid sizes equal

    set(gca,'XTick',1:5:(c+1),'YTick',1:5:(r+1),...  %# Change some axes properties
            'XLim',[1 c+1],'YLim',[1 r+1],...
            'GridLineStyle','-','XGrid','on','YGrid','on');
    imagetitle = fistest(index(end):end);
    title(imagetitle)
end

if (plotbit)
    
    figure('name',fistestRaw,'numbertitle','off')

    subplot(2,2,1)

    [r,c] = size(bitmapLetterModel);                           %# Get the matrix size
    imagesc((1:c)+0.5,(1:r)+0.5,bitmapLetterModel);            %# Plot the image
    colormap(gray);                              %# Use a gray colormap
    axis equal                                   %# Make axes grid sizes equal

    set(gca,'XTick',1:5:(c+1),'YTick',1:5:(r+1),...  %# Change some axes properties
            'XLim',[1 c+1],'YLim',[1 r+1],...
            'GridLineStyle','-','XGrid','on','YGrid','on');
    title('Litera model')

    subplot(2,2,2)
    [r,c] = size(bitmapLetter);                           %# Get the matrix size
    imagesc((1:c)+0.5,(1:r)+0.5,bitmapLetter);            %# Plot the image
    colormap(gray);                              %# Use a gray colormap
    axis equal                                   %# Make axes grid sizes equal

    set(gca,'XTick',1:5:(c+1),'YTick',1:5:(r+1),...  %# Change some axes properties
            'XLim',[1 c+1],'YLim',[1 r+1],...
            'GridLineStyle','-','XGrid','on','YGrid','on');
    title('Litera test')


    subplot(2,2,3)
    plot(sum(bitmapLetterModel,1),'r')
    hold on
    plot(sum(bitmapLetter,1),'b')
    title('Proiectia pe X')
    legend('Litera model','Litera test')

    subplot(2,2,4)
    plot(sum(bitmapLetterModel,2),'r')
    hold on
    plot(sum(bitmapLetter,2),'b')
    title('Proiectia pe Y')
    legend('Litera model','Litera test')
    
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% dynamic time warping %%%%%%%%%%%%%%%%%%%%%%%%%%%%

difer=10;

%[nl1,nc1]=size(letterModel);
%[nl2,nc2]=size(letterTest);
%[nl1,~]=size(letterModel);
%[nl2,~]=size(letterTest);
[~,nl1] = size(sum(bitmapLetterModel,1));
[nc1,~] = size(sum(bitmapLetterModel,2));
[~,nl2] = size(sum(bitmapLetter,1));
[nc2,~] = size(sum(bitmapLetter,2));

% interpolate letterModel to 500 vertices
x=0:1/nl1:1-1/nl1;
y=0:1/nc1:1-1/nc1;
t=0:1/500:1-1/500;
%model1_interpx = interp1(x,letterModel(:,1)',t,'pchip');
%model1_interpy = interp1(x,letterModel(:,2)',t,'pchip');
% model1_interpx = interp1(x,bitmapLetterModel(:,1)',t,'pchip');
% model1_interpy = interp1(x,bitmapLetterModel(:,2)',t,'pchip');
model1_interpx = interp1(x,sum(bitmapLetterModel,1)',t,'pchip');
model1_interpy = interp1(y,sum(bitmapLetterModel,2)',t,'pchip');


% interpolate letterTest to 500 vertices
x=0:1/nl2:1-1/nl2;
y=0:1/nc2:1-1/nc2;
%model2_interpx = interp1(x,letterTest(:,1)',t,'pchip');
%model2_interpy = interp1(x,letterTest(:,2)',t,'pchip');
% model2_interpx = interp1(x,bitmapLetter(:,1)',t,'pchip');
% model2_interpy = interp1(x,bitmapLetter(:,2)',t,'pchip');
model2_interpx = interp1(x,sum(bitmapLetter,1)',t,'pchip');
model2_interpy = interp1(y,sum(bitmapLetter,2)',t,'pchip');

% size(model1_interpx)
% size(model1_interpy)
% size(model2_interpx)
% size(model2_interpy)

%[Dist_x,D_x,k_x,w_x,rw_x,tw_x]=dtw(model1_interpx,model2_interpx,0);
%[Dist_y,D_y,k_y,w_y,rw_y,tw_y]=dtw(model1_interpy,model2_interpy,0);
[Dist_x,~,~,~,~,~]=dtw(model1_interpx,model2_interpx,0);
[Dist_y,~,~,~,~,~]=dtw(model1_interpy,model2_interpy,0);

%disp('max interp')
%max(model1_interpx)

%disp('size of model2_interpx and model2_interpy')
%size(model2_interpx)
%size(model2_interpy)

%pwd

% ung2rel=Compute_RelAng_Chain([model2_interpx(1:difer:end)' model2_interpy(1:difer:end)']);
% ung1rel=Compute_RelAng_Chain([model1_interpx(1:difer:end)' model1_interpy(1:difer:end)']);
% [Dist_u_rel,D_u,k_u,w_u,rw_u,tw_u]=dtw(ung1rel,ung2rel,0);
% figure
% subplot(2,1,1)
% plot(ung1rel)
% hold on
% plot(ung2rel,'r')
% title('Unghiuri relative')
% legend('reference angles','second angles')

ung2abs=Compute_AbslAng_Chain([model2_interpx(1:difer:end)' model2_interpy(1:difer:end)']);
ung1abs=Compute_AbslAng_Chain([model1_interpx(1:difer:end)' model1_interpy(1:difer:end)']);
%[Dist_u_abs,D_u,k_u,w_u,rw_u,tw_u]=dtw(ung1abs,ung2abs,0);
[Dist_u_abs,~,~,~,~,~]=dtw(ung1abs,ung2abs,0);

if (plotbit)

    figure('name','Dynamic time warping','numbertitle','off')

    subplot(3,1,1)
    plot(model1_interpx)
    hold on
    plot(model2_interpx, 'r')
    title('Coordonate X')
    legend('litera model', 'litera test');

    subplot(3,1,2)
    plot(model1_interpy)
    hold on
    plot(model2_interpy, 'r')
    title('Coordonate Y')
    legend('litera model', 'litera test');

    subplot(3,1,3)
    plot(ung1abs)
    hold on
    plot(ung2abs,'r')
    title('Unghiuri')
    legend('litera model','litera test')

end

Dist_u_abs = Dist_u_abs/50/360;

%disp(' DTW distance for x, y and angle')
%[Dist_x Dist_y Dist_u_rel/50/360 Dist_u_abs/50/360]
%[Dist_x Dist_y Dist_u_abs/50/360]

%%%%%%%%%%%%%%%%%%% compute displacements %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
% [Dist_x_proj,D_x,k_x,w_x,rw_x,tw_x]=dtw(sum(bitmapLetterModel)/max(sum(bitmapLetterModel)),...
%                                         sum(bitmapLetter)/max(sum(bitmapLetter)),0);
% [Dist_y_proj,D_y,k_y,w_y,rw_y,tw_y]=dtw(sum(bitmapLetterModel')/max(sum(bitmapLetterModel')),...
%                                         sum(bitmapLetter')/max(sum(bitmapLetter')),0);
% 
% disp('distanta pe X  la proiectii:')
% Dist_x_proj
% 
% disp('distanta pe Y  la proiectii:')
% Dist_y_proj
% 
% %sumsqr(sum(bitmapLetterModel)-sum(bitmapLetter))
% 
% c = xcorr(sum(bitmapLetterModel,1),sum(bitmapLetter,1) - mean(sum(bitmapLetter,1)),'coeff');
% [d,f] = max(c); x_disp = (length(sum(bitmapLetterModel,1)) - f);
% 
% c = xcorr(sum(bitmapLetterModel,2),sum(bitmapLetter,2) - mean(sum(bitmapLetter,2)),'coeff');
% [d,f] = max(c); y_disp = (length(sum(bitmapLetterModel,2)) - f);
% 
% disp('x displacement  -  y displacement')
% 
% [x_disp y_disp]

% [nrmodel, ncmodel] = size(bitmapLetterModel);
% [nrtest, nctest] = size(bitmapLetter);
% nr = min(nrmodel,nrtest);
% nc = min(ncmodel,nctest);
% bitmapLetterModel = bitmapLetterModel(1:nr,1:nc);
% bitmapLetter = bitmapLetter(1:nr,1:nc);
% 
% [Dist_hor, Dist_ver, timelag_x, timelag_y] = proiectie(bitmapLetterModel, bitmapLetter,draw);





%%%%%%%%%%%%%%%%%%%%%%%%%%%%% DTW pe X pe litera rotita %%%%%%%%%%%%%%%%%%%

plott=0;

disp('size(bitmapLetterModel)=')
size(bitmapLetterModel)
disp('size(bitmapLetter)=')
size(bitmapLetter)

s  = regionprops(bitmapLetterModel, 'centroid');
val = round(cat(1, s.Centroid));
centroids_model_x = val(1);
centroids_model_y = val(2);

s  = regionprops(bitmapLetter, 'centroid');
val = round(cat(1, s.Centroid));
centroids_test_x = val(1);
centroids_test_y = val(2);


%centroid_x = round(centroids_test_x-centroids_model_x);
%centroid_y = round(centroids_test_y-centroids_model_y);

centroids_model = [centroids_model_x centroids_model_y];
centroids_test = [centroids_test_x centroids_test_y];

%[Dist_rot, summodel, sumtest] = rotated_bitmap(bitmapLetterModel, bitmapLetter, centroids_model, centroids_test, plott);
[Dist_rot, ~, ~] = rotated_bitmap(bitmapLetterModel, bitmapLetter, centroids_model, centroids_test, plott);



%%%%%%%%%%%%%%%%%%%%%%%% latime si inaltime litera %%%%%%%%%%%%%%%%%%%%%%%%


st_model = regionprops(bitmapLetterModel, 'BoundingBox' );
for k = 1 : length(st_model)
    thisBB_model = st_model(k).BoundingBox;
end
height_model = round(abs(thisBB_model(4)-thisBB_model(2))); 
width_model = round(abs(thisBB_model(3)-thisBB_model(1))); 

st_test = regionprops(bitmapLetter, 'BoundingBox' );
for k = 1 : length(st_test)
    thisBB = st_test(k).BoundingBox;
end

height_test = round(abs(thisBB(4)-thisBB(2))); 
width_test = round(abs(thisBB(3)-thisBB(1)));
%height_rap = height_test/height_model; 
%width_rap = width_test/width_model; 


%%%%%%%%%%%%% DTW pe unghiuri pe proiectie bitmap %%%%%%%%%%%%%%%%%%%%%%%%%
% 
% factor = 7;
% model = regionprops(bitmapLetterModel,'PixelList');
% test = regionprops(bitmapLetter,'PixelList');
% model0 = model.PixelList(1:factor:end,:);
% test0 = test.PixelList(1:factor:end,:);
% model1 = Compute_AbslAng_Chain([model0(:,1) model0(:,2)]);
% test1 = Compute_AbslAng_Chain([test0(:,1) test0(:,2)]);
% [Dist_u,D_u,k_u,w_u,rw_u,tw_u] = dtw(model1/360,test1/360,0);
% Dist_glob = 0.45*Dist_hor+0.45*Dist_ver+0.08*Dist_u+0.02*Dist_rot;
% matr_global(i,j-1) = Dist_glob;



%close all