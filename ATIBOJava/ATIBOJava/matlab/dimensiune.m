function [m n p q] = dimensiune(matrice)
%#codegen


assert(isa(matrice,'double') && all(size(matrice) <= [1 6000]));

%matrice = [1 2 3 0 0 0 0 4 5 6 0 0 0 0];

[m n] = size(matrice);

matrice = matrice(matrice~=0);

[p q] = size(matrice);