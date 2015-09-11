%Angles Cumputation
function[Rel_Angles] = Compute_RelAng_Chain(PixC)
%#codegen

% added for codegen
sz = size(PixC)-1;
DiffY = zeros(1,sz);
DiffX = zeros(1,sz);

for i=1:(size(PixC)-1)
    DiffY(i)=PixC(i,1)-PixC(i+1,1);
    DiffX(i)=PixC(i+1,2)-PixC(i,2);
end
Angles=atan2(DiffY,DiffX);

 %Making All angles between 0 and 2*pi:
Angles=Angles+(Angles<0).*(zeros(1,(size(Angles,2)))+2*pi);


% added for codegen
sza = size(Angles,2)-1;
Rel_Angles = zeros(1,sza);

%Computing Chain
for i=1:(size(Angles,2)-1)
    BigAngle=max(Angles(i),Angles(i+1));
    SmallAngle=min(Angles(i),Angles(i+1));
    Delta=min(BigAngle-SmallAngle,SmallAngle+(2*pi-BigAngle));
    if(Angles(i)+Delta==Angles(i+1))
        Rel_Angles(i)=Delta;
    else
        Rel_Angles(i)=-Delta;
    end
end

Rel_Angles=Rel_Angles*(180/pi);
