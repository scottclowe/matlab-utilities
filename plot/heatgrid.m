%HEATGRID   Checkboard "heatmap" plot
%   HEATGRID(Z) uses PCOLOR to generate a checkerboard grid of colors using
%   the current colormap. Any NaN values are left blank, so the figure 
%   background (default white) shows through. The y-axis direction is
%   reversed, and ticks are set to have length [0 0] so they are not 
%   rendered, but tick labels are.
%
%   HEATGRID(X,Y,Z) is the same as with one input, except the axes are
%   labelled with the values in X and Y. X and Y may be vectors or cells.
%   If the labels are sequential integers in a vector, only about 12 labels
%   will be shown (the values in between are implied). If they are non-
%   sequential, or the input is a cell, all the values will be printed 
%   along the axis.
%
%   HEATGRID(X,Z) will use the dimensions of X and Z to try to work out
%   which dimension X refers to. The other dimension is labelled with its 
%   indcices. Note that if Z is a square matrix, X will be used for the 
%   x-axis labels.
%
%   HEATGRID(AX,...) plots into AX instead of GCA.
%
%   H = HEATGRID(...) returns a handle to a SURFACE object.
%   HEATGRID is really a SURF with its view set to directly above, since it
%   utilises PCOLOR.
%
%   If X is not of the form X(1):X(end), you may want to call
%   XTICKLABEL_ROTATE([],45) after calling HEATGRID, so that the xlabels
%   do not overlap and are all legible.
%
%   Example:
%      heatgrid( eye(4) )
%      heatgrid( {'one','two','buckle'}, [4 9 2.3], magic(3) )
%      heatgrid( [45:68], {'Alice','Bob', 'Charlie'}, rand(3,24) );
%
%   See also pcolor, pcolorf, caxis, surf, mesh, imagesc, xticklabel_rotate.

%   Scott Lowe, July 2012

function varargout = heatgrid(varargin)

%% 

def_nlabels = 12;   % Default number of labels
rotate_x = 0;       % Rotate XTickNames if needed

%% INPUT HANDLING
error(nargchk(1, 3, nargin, 'struct'));

if nargin>1 && length(varargin{1})==1 && ishandle(varargin{1})
    ax = varargin{1};
    varargin = varargin(2:end);
else
    ax = gca;
end
switch length(varargin)
    case 1
        Z = varargin{1};
        X = 1:size(Z,2);
        Y = 1:size(Z,1);
    case 2
        Z = varargin{2};
        if size(Z,2)>1
            X = varargin{1};
            Y = 1:size(Z,1);
        elseif size(Z,1)>1
            Y = varargin{1};
            X = 1:size(Z,2);
        end
    case 3
        X = varargin{1};
        Y = varargin{2};
        Z = varargin{3};
    otherwise
        error('Incorrect number of inputs.');
end

%% Input error checks
% These don't work great
if length(X)~=size(Z,2)
    error('X must have the same length as size(Z,2) (given variables have %d and %d).',length(X),size(Z,2));
end
if length(Y)~=size(Z,1)
    error('Y must have the same length as size(Z,1) (given variables have %d and %d).',length(Y),size(Z,1));
end

% override_x = 0;
% override_y = 0;
% if ~isnumeric(X) || ~isequal(X, X(1):X(end))
%     XNames = X;
%     override_x = 1;
%     X = 1:length(X);
% end
% if ~isnumeric(Y) || ~isequal(Y, Y(1):Y(end))
%     YNames = Y;
%     override_y = 1;
%     Y = 1:length(Y);
% end


XNames = X;
override_x = 1;
X = 1:length(X);

YNames = Y;
override_y = 1;
Y = 1:length(Y);


%% Plotting

% Old method: imagesc
% imagesc(X,Y,Z,'Parent',ax);

% New method: pcolor
% Use this because it renders NaN with white space
% Have to add blanks to the end and offset X and Y because it is faceted
% shading and doesn't use the final colours otherwise
padZ = nan(size(Z)+1);
padZ(1:end-1,1:end-1) = Z;
padX = [X X(end)+1]-0.5;
padY = [Y Y(end)+1]-0.5;
h = pcolor(ax,padX,padY,padZ);
set(h,'EdgeColor','none');
set(ax, ...
    'Layer'     , 'top'         , ...
    'YDir'      , 'reverse'     , ...
    'box'       , 'on'          , ...
    'TickDir'   , 'out'         , ...
    'TickLength', [0 0]         , ...
    'XTick'     , X(1):ceil(length(X)/def_nlabels):X(end) , ...  % default spacing has 12 labels
    'YTick'     , Y(1):ceil(length(Y)/def_nlabels):Y(end) );     % default spacing has 12 labels

% Override with names
if override_x
set(ax, ...
    'XTick'     , X             , ...
    'XTickLabel', XNames        );
end
if override_y
set(ax, ...
    'YTick'     , Y             , ...
    'YTickLabel', YNames        );
end

% Rotate if needed
if override_x && rotate_x
    xticklabel_rotate([],45);
end

%% Output
% Supply handle if requested

if nargout>0
    varargout{1} = h;
end

end