function c = bsxfunTest(fun,a,b)
%MATLAB Code Generation Library Function

%   Copyright 1984-2010 The MathWorks, Inc.
%#codegen

eml_invariant(nargin == 3, ...
    eml_message('Coder:MATLAB:minrhs'));
eml_invariant(isa(fun,'function_handle'), ...
    eml_message('Coder:toolbox:bsxfun_2'), ...
    'IfNotConst','Fail');
ZERO = zeros(eml_index_class);
ONE = ones(eml_index_class);
% These values are needed in a few places below.
na1 = cast(size(a,1),eml_index_class);
nb1 = cast(size(b,1),eml_index_class);
% Calculate output size and the page-back vectors.
nda = eml_ndims(a);
ndb = eml_ndims(b);
% Check for input consistency.
eml_invariant(bsxfun_compatible(a,b), ...
    eml_message('Coder:MATLAB:bsxfun_arrayDimensionsMustMatch'));
eml_invariant(no_dynamic_expansion(a,b), ...
    eml_message('Coder:toolbox:bsxfun_dynamicExpansion'));
% Allocate csz vector.
nd = eml_const(cast(max(nda,ndb),eml_index_class));
ndm1 = eml_index_minus(nd,1);
csz = zeros(1,nd,eml_index_class);
% Fill in csz entries.
for k = coder.unroll(ONE:nd)
    if eml_is_const(size(a,k)) && size(a,k) == 1
        csz(k) = size(b,k);
    else
        csz(k) = size(a,k);
    end
end
% Calculate the page-back vectors.
% Since the inlined code below doesn't currently constant-fold when the
% input sizes are static, we include the equivalent computation in a
% subfunction for that case.
if eml_is_const(size(a)) && eml_is_const(size(b))
    aPageBack = eml_const(calc_page_back_vector(a,ndm1));
    bPageBack = eml_const(calc_page_back_vector(b,ndm1));
else
    aPageBack = zeros(1,ndm1,eml_index_class);
    bPageBack = zeros(1,ndm1,eml_index_class);
    aprod = na1;
    bprod = nb1;
    for k = 2:ndm1
        aprod = eml_index_times(aprod,size(a,k));
        aPageBack(k) = eml_index_minus(aprod,na1);
        bprod = eml_index_times(bprod,size(b,k));
        bPageBack(k) = eml_index_minus(bprod,nb1);
    end
end
% Allocate output matrix.
a0 = eml_scalar_eg(a);
b0 = eml_scalar_eg(b);
c0 = eml_scalar_eg(fun(a0([]),b0([])));
c = coder.nullcopy(eml_expand(c0,csz));
% Allocate temporary vectors.
av = coder.nullcopy(eml_expand(a0,[na1,1]));
bv = coder.nullcopy(eml_expand(b0,[nb1,1]));
% Allocate subscript vectors.
asub = ones(ndm1,1,eml_index_class);
bsub = ones(ndm1,1,eml_index_class);
% Initialize starting indices.
ak = ZERO;
bk = ZERO;
% Loop through each column of the inputs and call FUN.
nc1 = cast(size(c,1),eml_index_class);
for ck = ZERO : nc1 : eml_index_minus(eml_numel(c),nc1)
    % Copy vector from A.
    for k = ONE:na1
        av(k) = a(eml_index_plus(ak,k));
    end
    % Copy vector from B.
    for k = ONE:nb1
        bv(k) = b(eml_index_plus(bk,k));
    end
    % Call FUN.
    cv = fun(av,bv);
    % Copy output to C.
    for k = ONE:nc1
        c(eml_index_plus(ck,k)) = cv(k);
    end
    % Update subscript vectors and indices.
    for k = coder.unroll(ONE:ndm1)
        % The conditions that follow seem to do more work than necessary. 
        % They are crafted to assist the constant-folder in the 2D case.
        kp1 = eml_index_plus(k,1);
        if (ndm1 == ONE && eml_is_const(size(a,kp1)) && size(a,kp1) > 1) || ...
                asub(k) < size(a,kp1)
            ak = eml_index_plus(ak,na1);
            if eml_is_const(size(b,kp1)) && size(b,kp1) == 1
                bk = eml_index_minus(bk,bPageBack(k));
            else
                bk = eml_index_plus(bk,nb1);
                bsub(k) = eml_index_plus(bsub(k),1);
            end
            asub(k) = eml_index_plus(asub(k),1);
            break
        elseif (ndm1 == ONE && eml_is_const(size(b,kp1)) && size(b,kp1) > 1) || ...
                bsub(k) < size(b,kp1)
            ak = eml_index_minus(ak,aPageBack(k));
            bk = eml_index_plus(bk,nb1);
            bsub(k) = eml_index_plus(bsub(k),1);
            break
        else
            asub(k) = 1;
            bsub(k) = 1;
        end
    end
end

%--------------------------------------------------------------------------

function v = calc_page_back_vector(a,ndm1)
% Calculate a page-back vector.
v = zeros(1,ndm1,eml_index_class);
na1 = cast(size(a,1),eml_index_class);
aprod = na1;
for k = 2:ndm1
    aprod = eml_index_times(aprod,size(a,k));
    v(k) = eml_index_minus(aprod,na1);
end

%--------------------------------------------------------------------------

function p = bsxfun_compatible(a,b)
% Check for input consistency.
for k = coder.unroll(1:min(eml_ndims(a),eml_ndims(b)))
    if size(a,k) ~= 1 && size(b,k) ~= 1 && size(a,k) ~= size(b,k)
        p = false;
        return
    end
end
p = true;

%--------------------------------------------------------------------------

function p = no_dynamic_expansion(a,b)
% Check for implied expansion along variable-length dimensions where
% neither argument has a static length of 1.
if ~eml_is_const(size(a)) || ~eml_is_const(size(b))
    for k = coder.unroll(1:min(eml_ndims(a),eml_ndims(b)))
        if ~(eml_is_const(size(a,k)) && size(a,k) == 1) && ...
                ~(eml_is_const(size(b,k)) && size(b,k) == 1) && ...
                size(a,k) ~= size(b,k)
            p = false;
            return
        end
    end
end
p = true;

%--------------------------------------------------------------------------
