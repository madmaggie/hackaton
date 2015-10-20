widthTest = 25;
heightTest = 35;

%%%%%%%%%   print horizontal lines   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%border = minmax([letterModel(:,1:2); letterTest(:,1:2)]');
border = [1 9; 1 9];

%border = |minx maxx|
%         |miny maxy|

%axis = [minx, maxx, miny, maxy]

axis([min(0,border(1,1)-1),border(1,2)+1,border(2,1)-1,border(2,2)+1])
axis 'ij'
hold on
x=border(1,1)-1:0.1:border(1,2)+1;
for i=0:round(border(2,2)+1)
    if (mod(i,3)==0)
        plot(x,i*ones(1,size(x,2)),'--')
    else
        plot(x,i*ones(1,size(x,2)),'-')
    end
end

%%%%%%%%%%%%   print oblique lines   %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

k=0;
for angle=60:10:90

a=-1/tan((90-angle)*pi/180);
x=border(1,1)-1:0.1:border(1,2)+1;

for i=0:widthTest/heightTest:border(1,2)+1
    b=7+i*tan(angle*pi/180);
    y=a*x+b;
    if (mod(k,3)==0)
        plot(x,y,'r')
    else
        if (mod(k,3)==1)
            plot(x,y,'g')
        else
            if (mod(k,3)==2)
                plot(x,y,'b')
            end
        end
    end
end

k=k+1;
end


hold on