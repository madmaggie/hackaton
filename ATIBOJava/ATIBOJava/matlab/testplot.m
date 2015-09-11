

heightModel = 60;
widthModel = 30;
heightTest30 = 30;
widthTest20 = 20;
heightTest35 = 35;
widthTest25 = 25;

angle = 70;

scalingConstant3525 = (heightTest35/heightModel) * (widthModel/widthTest25);
scalingConstant3020 = (heightTest30/heightModel) * (widthModel/widthTest20);

letterModel = load('modellitere\MmicModel.txt');
%letterTest3525 = load('Mmic\Mmic__1423844019356_h35-w25\3.txt');
letterTest3525 = load('W:\ATIBO\2014_09_30 - literecopii\Amare\Amare_achizitionat_1411622801188\0.txt');
letterTest3020 = load('Mmic\Mmic__1423844806713_h30-w20\3.txt');

%%%%%%%%%%%%%%%%%%%%%%%%%   plot letters   %%%%%%%%%%%%%%%%%%%%%%%%%%

%plot(letterModel(:,1),letterModel(:,2),'r*')
axis ij
hold on
% plot(letterTest3525(:,1).*scalingConstant3525,letterTest3525(:,2),'b*')
% plot(letterTest3525(:,1).*0.83,letterTest3525(:,2),'gx')
plot(letterTest3525(:,1),letterTest3525(:,2),'bo')

%plot(letterTest3020(:,1).*scalingConstant3020,letterTest3020(:,2),'g*')
%plot(letterTest3020(:,1),letterTest3020(:,2),'go')

%legend('Litera model', 'Litera test3525', 'Litera test3525 nescalata', 'Litera test3525 scalata cu 0.83', 'Litera test 3020', 'Litera test3020 nescalata')

% print liniatura caietului - height = 1 & width = 30/60=0.5 
% linii orizontale continue si punctate si linii oblice

%%%%%%%%%   print horizontal lines   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

border = minmax([letterModel(:,1:2); letterTest3525(:,1:2); letterTest3020(:,1:2)]');

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

%%%%%%%%%%%   model letter   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% a=-1/tan((90-angle)*pi/180);
% x=border(1,1)-1:0.1:border(1,2)+1;
% 
% for i=0:widthModel/heightModel:border(1,2)+1
%     b=3+i*tan(angle*pi/180);
%     y=a*x+b;
%     plot(x,y,'r')
% end


%%%%%%%%%%%   test letter 35-25  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

a=-1/tan((90-angle)*pi/180);
x=border(1,1)-1:0.1:border(1,2)+1;

for i=0:widthTest25/heightTest35:border(1,2)+1
    b=3+i*tan(angle*pi/180);
    y=a*x+b;
    plot(x,y,'b')
end


%%%%%%%%%%%  test letter 30-20   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% a=-1/tan((90-angle)*pi/180);
% x=border(1,1)-1:0.1:border(1,2)+1;
% 
% for i=0:widthTest20/heightTest30:border(1,2)+1
%     b=3+i*tan(angle*pi/180);
%     y=a*x+b;
%     plot(x,y,'g')
% end

