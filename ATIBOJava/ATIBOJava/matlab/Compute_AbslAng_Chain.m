function Abs_Angles = Compute_AbslAng_Chain(PixC)
%#codegen

% added for codegen
sz = size(PixC,1);
DiffY = zeros(1,sz);
DiffX = zeros(1,sz);


%for i=1:(size(PixC)-1)
for i=1:sz-1
    DiffY(i)=PixC(i,1)-PixC(i+1,1);
    DiffX(i)=PixC(i+1,2)-PixC(i,2);
end
Angles=atan2(DiffY,DiffX);

 %Making All angles between 0 and 2*pi:
Angles=Angles+(Angles<0).*(zeros(1,(size(Angles,2)))+2*pi);
Abs_Angles=floor(Angles*(180/pi));
