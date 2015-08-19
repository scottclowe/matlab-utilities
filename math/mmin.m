% MMIN Multidimensional minimum
%   For matrices MMIN(X) is the minimum element from the entire matrix.
%   
%   MMIN(X,DIMS) takes the minimum along the all the dimensions in the
%   array DIMS, and returns a matrix which is singleton for every dimension
%   in DIMS and the same size as X in all others.
%   
%   MMIN(X,DIMS,'x') takes the minimum along the all the dimensions of X
%   which are not in the array DIMS. The output is a matrix which is the
%   same size of X in each of the dimensions in DIMS and singleton for
%   all others.
%   
%   See also min, mmax.

function x = mmin(x, dims, flag)

% Default inputs ---------------------------------------------------------------
if nargin<2
    % User specifies no dims and no flag -> min over everything
    dims = [];
    flag = 'x';
elseif nargin<3;
    % User specifies dims but no flag -> min over dims
    flag = '';
end

% Input handling ---------------------------------------------------------------
% Handle exclusion
if strncmpi(flag,'x',1);
    dims = setdiff(1:ndims(x), dims);
end

% Main -------------------------------------------------------------------------
% Take the min for each dim
for i=1:length(dims)
    x = min(x, [], dims(i));
end

end
