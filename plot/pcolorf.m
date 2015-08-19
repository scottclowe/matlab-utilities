%PCOLORF Full faceted pseudocolor (checkerboard) plot.
%   PCOLORF(...) is the same as PCOLOR(...) except the X and Y values are
%   bilinear interpolated and extended by one value in each direction so
%   that all the values in C are plotted.
%
%   H = PCOLORF(...) returns a handle to a SURFACE object.
%
%   Note: you may wish to use
%   SET(H,'EdgeColor','None');
%   after calling PCOLORF. This is not done as part of the function for
%   consistency with PCOLOR. Note also that calls to SHADING will reset
%   the EdgeColor and you will need to set this again afterward.
%
%   Caution: using shading('interp') with PCOLORF will yield neither useful
%   nor desirable results.
%  
%   See also pcolor, heatgrid, caxis, surf, mesh, imagesc.

%   Scott Lowe, July 2012

function varargout = pcolorf(varargin)

if nargin>1 && length(varargin{1})==1 && ishandle(varargin{1})
    ax = varargin{1};
    varargin = varargin(2:end);
else
    ax = gca;
end
if length(varargin)==1
    Z = varargin{1};
    X = 1:size(Z,1);
    Y = 1:size(Z,2);
elseif length(varargin)==3
    X = varargin{1};
    Y = varargin{2};
    Z = varargin{3};
    
    if length(X)~=size(Z,2)
        error('X must have the same length as size(Z,2) (given variables have %d and %d).',length(X),size(Z,2));
    end
    if length(Y)~=size(Z,1)
        error('Y must have the same length as size(Z,1) (given variables have %d and %d).',length(Y),size(Z,1));
    end
else
    error('Incorrect number of inputs.');
end

% Use bilinear interpolation on the axes (where the color patches begin and 
% end) instead of the color values
padZ = nan(size(Z)+1);
padZ(1:end-1,1:end-1) = Z;
padX = [ 3*X(1)-X(2) (X(1:end-1)+X(2:end)) 3*X(end)-X(end-1) ] /2;
padY = [ 3*Y(1)-Y(2) (Y(1:end-1)+Y(2:end)) 3*Y(end)-Y(end-1) ] /2;

h = pcolor(ax,padX,padY,padZ);
set(ax,'Layer', 'top');

if nargout>0
    varargout{1} = h;
end

end