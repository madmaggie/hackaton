
currentFolder = pwd;


width = 20;
height = 30;
angle = 70;


% viewport coordinates
xp = 50;
yp = 50;

folder = uigetdir;
%cd (folder)
file_list = dir(folder);

for i=1:length(file_list)
    if (isempty(strfind(file_list(i).name,'raw')) == 0)
        letterRaw = load([folder '\' file_list(i).name]);
        size(letterRaw)
        letterRaw = letterRaw(:,1:2);
        size(letterRaw)
        letterRaw = letterRaw';
        size(letterRaw)
        
        bitmapLetter = zeros(xp,yp);

        %border = |minx maxx|
        %         |miny maxy|

        border = minmax(letterRaw(1:2,:));
        border(2,1) = round80((border(2,1)-10)/height)*height;
        border(2,2) = border(2,1)+height*5;
        border(1,1) = round80((border(1,1)-10)/width)*width;
        border(1,2) = border(1,1)+width*9;
        xcoord = round((letterRaw(1,:)-border(1,1)) * xp / (border(1,2)-border(1,1)));
        ycoord = round((letterRaw(2,:)-border(2,1)) * yp / (border(2,2)-border(2,1)));
        %t = ycoord.*xp+xcoord;
        for j=1:size(xcoord,2)
            if (xcoord(1,j) > 0 && ycoord(1,j) > 0)
                bitmapLetter(xcoord(1,j), ycoord(1,j)) = 1;
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

        index = strfind(file_list(i).name,'_')-1;
        %filetosaveto = strcat(file_list(i).name(1:index),'_bitmap.png');
        filetosaveto = [folder '\' strcat(file_list(i).name(1:index),'_bitmap.png')];
        
        saveas(gcf, filetosaveto)
    end
end

 
cd (currentFolder)

