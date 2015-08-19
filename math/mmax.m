% MMAX Multidimensional maximum
%   For matrices MMAX(X) is the maximum element from the entire matrix.
%   
%   MMAX(X,DIMS) takes the maximum along the all the dimensions in the
%   array DIMS, and returns a matrix which is singleton for every dimension
%   in DIMS and the same size as X in all others.
%   
%   MMAX(X,DIMS,'x') takes the maximum along the all the dimensions of X
%   which are not in the array DIMS. The output is a matrix which is the
%   same size of X in each of the dimensions in DIMS and singleton for
%   all others.
%   
%   See also max, mmin.

function x = mmax(x,dims,flag)

% Default inputs ---------------------------------------------------------------
if nargin<2
    % User specifies no dims and no flag -> max over everything
    dims = [];
    flag = 'x';
elseif nargin<3;
    % User specifies dims but no flag -> max over dims
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
    x = max(x,[],dims(i));
end

end
