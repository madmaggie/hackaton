function saveletterimage(filetoreadfrom, height, width, angle) %#codegen

%height = 35;
%width = 25;
%angle = 70;


%%%%%%%%%%%%%%%%%%%%%%   save letter image  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    letter = load(filetoreadfrom);

    %set(gcf, 'visible','off')

    plot(letter(:,1),letter(:,2),'r*')
    axis ij
    hold on

    % print liniatura caietului
    % linii orizontale continue si punctate si linii oblice

    border = minmax(letter(:,1:2)');

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


    a=-1/tan((90-angle)*pi/180);
    x=border(1,1)-1:0.1:border(1,2)+1;

    for i=0:width/height:border(1,2)+1
        b=3+i*tan(angle*pi/180);
        y=a*x+b;
        plot(x,y)
    end

    index = regexp(filetoreadfrom, '.txt');
    filetosaveto = [filetoreadfrom(1:index-1) '.png'];

    saveas(gcf, filetosaveto)

%%%%%%%%%%%%%%%%%%%%%  save letter bitmap  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % viewport coordinates
    xp = 50;
    yp = 50;

    clf

    index = regexp(filetoreadfrom, '.txt');        
    letterRaw = load([filetoreadfrom(1:index-1) '_raw.txt']);
    letterRaw = letterRaw(:,1:2)';

    bitmapLetter = zeros(xp,yp);

    %border = |minx miny|
    %         |maxx maxy|

    border = minmax(letterRaw);
    border(2,1) = round80((border(2,1)-10)/height)*height;
    border(2,2) = border(2,1)+height*3;
    border(1,1) = round80((border(1,1)-10)/width)*width;
    border(1,2) = border(1,1)+width*5;
    xcoord = round((letterRaw(1,:)-border(1,1)) * xp / (border(1,2)-border(1,1)));
    ycoord = round((letterRaw(2,:)-border(2,1)) * yp / (border(2,2)-border(2,1)));
    for k=1:size(xcoord,2)
        if (xcoord(1,k) > 0 && ycoord(1,k) > 0)
            bitmapLetter(xcoord(1,k), ycoord(1,k)) = 1;
        end
    end

    bitmapLetter = bitmapLetter';

    [r,c] = size(bitmapLetter);                           %# Get the matrix size
    imagesc((1:c)+0.5,(1:r)+0.5,bitmapLetter);            %# Plot the image
    colormap(gray);                              %# Use a gray colormap
    axis equal                                   %# Make axes grid sizes equal

    set(gca,'XTick',1:5:(c+1),'YTick',1:5:(r+1),...  %# Change some axes properties
            'XLim',[1 c+1],'YLim',[1 r+1],...
            'GridLineStyle','-','XGrid','on','YGrid','on');

    index = strfind(filetosaveto,'.png')-1;
    filetosaveto = strcat(filetosaveto(1:index),'_bitmap.png');

    saveas(gcf, filetosaveto);

end

