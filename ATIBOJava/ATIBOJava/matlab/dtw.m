function Dist=dtw(r,t)
%#codegen
% Dynamic Time Warping Algorithm
% Dist is unnormalized distance between t and r
% t is the vector you are testing (test letter)
% r is the vector you are testing against (model letter)

assert(isa(r,'double') && all(size(r) <= [1 3000]));
assert(isa(t,'double') && all(size(t) <= [1 3000]));

% [row,M]=size(r);
% if (row > M)
%     M=row;
%     r=r';
% end;
% 
% [row,N]=size(t);
% if (row > N)
%     N=row;
%     t=t';
% end;

[~,M]=size(r);
[~,N]=size(t);
d=(repmat(r',1,N)-repmat(t,M,1)).^2;


D=zeros(size(d));
D(1,1)=d(1,1);

for m=2:M
    D(m,1)=d(m,1)+D(m-1,1);
end
for n=2:N
    D(1,n)=d(1,n)+D(1,n-1);
end
for m=2:M
    for n=2:N
        D(m,n)=d(m,n)+min(D(m-1,n),min(D(m-1,n-1),D(m,n-1))); % this double Min construction improves in 10-fold the Speed-up. Thanks Sven Mensing
    end
end

Dist=D(M,N);
