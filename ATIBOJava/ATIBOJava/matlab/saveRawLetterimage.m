
close all;
clf;

height = 35;
width = 25;
angle = 70;
xoffset = 10;
yoffset = 10;


folder = uigetdir('/media/micky/WORK/ATIBO/bazededate/LITERE/LITERE-MODEL-ANA/toate/Amare/Amare__1425464249550');
filestoreadfrom = dir(folder);


for j=1:length(filestoreadfrom)

    %%%%%%%%%%%%%%% save each letter as image file %%%%%%%%%%%%%%%%%%%%%%%%
    % each letter is given by the raw coordinates in '*_raw.txt' file
    
    if (not(filestoreadfrom(j).isdir) && (size(regexp(filestoreadfrom(j).name,'_raw.txt'),1)>0))   
        %disp([folder '/' filestoreadfrom(j).name])
        clf
        
        letter = load([folder '/' filestoreadfrom(j).name]);

        plot(letter(:,1),letter(:,2),'r*')
        axis ij
        axis equal
        hold on

        % print liniatura caietului
        % linii orizontale continue si punctate (una punctata la 2 continue pe y) si linii oblice

        border = minmax(letter(:,1:2)');

        %border = |minx maxx|
        %         |miny maxy|

        axis([border(1,1)-width, border(1,2)+width, border(2,1)-height/2, border(2,2)+height/2])

        %%%%%%%%%%%   horizontal lines   %%%%%%%%%%%%%%%%%%%%%
        hor_lines_no = ceil((border(2,2)-border(2,1))/height)+2; % No of horizontal lines to be drawn
        
        % x coordinates of the first and last point on each horizotal line
        x = [border(1,1)-width border(1,2)+width];
        
        % y coordinate of the first horizontal line
        y_start = round((border(2,1)-yoffset)/(3*height))*3*height+yoffset-height;
        
        % yi are the y coordinates of each horizontal line
        %for yi=y_start:height:round(border(2,2)+height)
        for yi=y_start:height:y_start+hor_lines_no*height
            if (mod((yi-yoffset)/height,3)==0)
                plot(x,yi*ones(1,size(x,2)),'--')
            else
                plot(x,yi*ones(1,size(x,2)),'-')
            end
        end
               
        
        %%%%%%%%%%%%   oblique lines   %%%%%%%%%%%%%%%%%%%%%%%%%%
        ver_lines_no = floor((border(2,2)-border(2,1))/width)+2; % generally, should draw 5-8 oblique lines or more
       % x=border(1,1)-1:width:border(1,2)+1;
        
        % computes (minx, ymix) - coordinates of the left-most point of the
        % letter
        [minx,index_minx] = min(letter(:,1));
        yminx = letter(index_minx,2);

        % x coordinate of the intersection between y=yoffset line and the
        % oblique line passing through (minx, yminx)
        x_start = minx + yminx/tan(degtorad(angle));
        % x coordinate of the intersection between y=yoffset line and the
        % oblique line of the page grid passing closest to (minx, yminx)
        x_start = round((x_start-xoffset)/width)*width + xoffset;
        % x coordinate of the intersection between y=y_start line and the
        % oblique line of the page grid passing closest to (minx, yminx)
        x_start = x_start - y_start/tan(degtorad(angle));
       
        for xi=x_start:width:x_start+ver_lines_no*width
            x_stop = xi  - (hor_lines_no*height)/tan(degtorad(angle));
            plot([xi x_stop], [y_start, yi])            
        end       

        index = regexp(filestoreadfrom(j).name,'.txt');

        filetosaveto = [folder '/' filestoreadfrom(j).name(1:index-1) '.png'];
        saveas(gcf, filetosaveto)
    end

    
     
     
     
     
     
     
     
   %%%%%%%%%%%%%%%%%  save each letter as bitmap  %%%%%%%%%%%%%%%%%%%%%%%%%%

   % if (not(filestoreadfrom(j).isdir) && (size(regexp(filestoreadfrom(j).name,'_raw.txt'),1)>0))
   if 0
        % viewport coordinates
        xp = 50;
        yp = 50;

        clf;
        
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

        %filetosaveto = fopen([folder '\' filestoreadfrom(j).name(1:index-1) '.png'],'w');
        saveas(gcf, filetosaveto);
   end
   
end

