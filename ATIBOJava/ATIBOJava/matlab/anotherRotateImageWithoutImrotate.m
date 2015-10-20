function imagerot = anotherRotateImageWithoutImrotate(image, angle)
%#codegen
% Rotates image with angle
% image - 50x50 bitmap letter (b&w image)
% angle - the angle, a double between [0,360], that the image is rotated
% with, in clockwise direction
% imagerot - rotated image; square matrix with dimenstions computed as
% needed
% Copyright 2013-2015 Atibo

assert(isa(image,'double') && all(size(image) <= [50 50]));
assert(isa(angle,'double'));

[rowsi,colsi] = size(image);

rads = 2*pi*angle/360;  
rads = mod(rads, 360);


rowsf=ceil(rowsi*abs(cos(rads))+colsi*abs(sin(rads)));                      
colsf=ceil(rowsi*abs(sin(rads))+colsi*abs(cos(rads)));                     

% define an array with calculated dimensions and fill the array  with zeros ie.,black
imagerot=zeros([rowsf colsf]);

%calculating center of original and final image
xo=ceil(rowsi/2);                                                            
yo=ceil(colsi/2);


for i=1:rowsi
    for j=1:colsi
        if (image(i,j)>0)
            x = (i-xo)*cos(rads)+(j-yo)*sin(rads);                                       
            y = -(i-xo)*sin(rads)+(j-yo)*cos(rads);                             
            x = round(x)+xo;
            y = round(y)+yo;
            
            if (x>=1 && y>=1 && x<=rowsi &&  y<=colsi)
                imagerot(x,y)=1;
            end
        end
    end
end

%imshow(C);