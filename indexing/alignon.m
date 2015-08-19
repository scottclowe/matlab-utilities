%ALIGNON  Aligns arrays based on a hinge vector.
%    [M1, M2, HH] = alignon(DIM, 'inner', M1, H1, M2, H2) aligns the arrays
%    M1 and M2 so that only the rows which correspond to the elements which
%    appear in both H1 and H2 are included.
%    
%    [M1, M2, HH] = alignon(DIM, 'left', M1, H1, M2, H2) aligns the arrays
%    so only rows corresponding to elements in H1 are included. HH is the
%    same as H1, and M1 is returned as-is.
%    
%    [M1, M2, HH] = alignon(DIM, 'right', M1, H1, M2, H2) aligns the arrays
%    so only rows corresponding to elements in H2 are included. HH is the
%    same as H2, and M2 is returned as-is.
%    
%    [M1, M2, HH] = alignon(DIM, 'outer', M1, H1, M2, H2) aligns the arrays
%    M1 and M2 so that when you read across dimension DIM, both M1 and M2
%    have elements corresponding to the same HH vector.
%    
%    For 'inner' and 'outer', HH is returned as a sorted vector. With
%    'left' and 'right', this is not the case.

function [M1, M2, hh] = alignon(dim, type, M1, h1, M2, h2)

% Parameters --------------------------------------------------------------
type_aliases = {...
    @aligninner, {'inner','simple'    , 'intersect'};
    @alignleft , {'left' ,'leftouter' };
    @alignright, {'right','rightouter'};
    @alignouter, {'full' ,'fullouter' , 'outer'    , 'union'};
    };
def_type = 'inner';

% Default inputs ----------------------------------------------------------
if isempty(dim)
    % Default with first non-singleton dimension?
    dim = find(size(x)~= 1, 1);
    if isempty(dim), dim = 1; end
end
if isempty(type)
    type = def_type;
end

% Input checks ------------------------------------------------------------
assert(numel(unique(h1))==numel(h1), ...
    'The input h1 is not a unique vector.');
assert(numel(unique(h2))==numel(h2), ...
    'The input h2 is not a unique vector.');
assert(size(M1,dim)==numel(h1), ...
    'The size of M1 along dimension %d does not match the length of h1.',...
    dim);
assert(size(M2,dim)==numel(h2), ...
    'The size of M2 along dimension %d does not match the length of h2.',...
    dim);
assert(ischar(type),...
    'The type must be specified as a string');

% Main --------------------------------------------------------------------
for iMode=1:size(type_aliases,1)
    if ismember(lower(type), type_aliases{iMode,2})
        [M1, M2, hh] = type_aliases{iMode,1}(dim, M1, h1, M2, h2);
        return;
    end
end

error('Invalid type specified: %s', type);

end


function [M1, M2, hh] = aligninner(dim, M1, h1, M2, h2)

% Check which the values exist in both h1 and h2
[hh, I1, I2] = intersect(h1, h2);

% Fix up the first array -------
% We don't know how many dims there will be, so we need to use ':' for
% every dimension except for dim.
p1 = repmat({':'}, 1, ndims(M1));
% For dim, we need to reorder with I1
p1{dim} = I1;
% We 
M1 = M1(p1{:});

% Fix up the second array -------
% Same as for M1.
p2 = repmat({':'}, 1, ndims(M2));
p2{dim} = I2;
M2 = M2(p2{:});

end


function [M1, M2_, h1] = alignleft(dim, M1, h1, M2, h2)

% Check where values in the second array are in the first
[TF, I2] = ismember(h2, h1);

% Fix up the second array so it aligns with h1
% We don't know how many dims there will be, so we need to use ':' for
% every dimension except for dim.
pp = repmat({':'}, 1, ndims(M2));
lft = pp;
rgt = pp;
% The assigment will use only the values corresponding to those in h2 which
% were also present in h1.
lft{dim} = I2(TF);
rgt{dim} = TF;

% Initialise a new version of M2 which has NaNs for the appropriate size.
% We won't be able to fill all the values, because some elements in h2
% won't be in h1, but we need to pad dimension dim to have the same size as
% the length of h1.
siz = size(M2);
siz(dim) = size(M1,dim);
M2_ = nan(siz);
% Now we can put the acceptable values into the right places
M2_(lft{:}) = M2(rgt{:});

end


function [M1, M2, hh] = alignright(dim, M1, h1, M2, h2)

% Just reverse the inputs, do alignleft, and reverse the outputs.
[M2, M1, hh] = alignleft(dim, M2, h2, M1, h1);

end


function [M1_, M2_, hh] = alignouter(dim, M1, h1, M2, h2)

% Combine the two h1 and h2 vectors to make a new, bigger vector
hh = union(h1, h2);
[~, I1] = ismember(h1, hh);
[~, I2] = ismember(h2, hh);

% Fix up the first array so it aligns with hh
% Initialise a new version of M1 which has NaNs for the appropriate size.
% We won't be able to fill all the values, because some elements in h1
% won't be in hh, but we need to pad dimension dim to have the same size as
% the length of hh.
siz = size(M1);
siz(dim) = length(hh);
M1_ = nan(siz);
% Work out where we will place the elements from M1
% We don't know how many dims there will be, so we need to use ':' for
% every dimension except for dim.
p1 = repmat({':'}, 1, ndims(M1));
p1{dim} = I1;
% Now we can put the acceptable values into the right places
M1_(p1{:}) = M1;

% Fix up the second array so it aligns with hh
% Initialise a new version of M2 which has NaNs for the appropriate size.
siz = size(M2);
siz(dim) = length(hh);
M2_ = nan(siz);
% Work out where we will place the elements from M2
p2 = repmat({':'}, 1, ndims(M2));
p2{dim} = I2;
% Now we can put the acceptable values into the right places
M2_(p2{:}) = M2;


end
