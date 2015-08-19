function h = uimage(varargin)
%UIMAGE  Display image with uneven axis.
%   UIMAGE(X,Y,C) displays matrix C as an image, using the vectors X and
%   Y to specify the X and Y coordinates. X and Y may be unevenly spaced
%   vectors, but must be increasing. The size of C must be LENGTH(Y)*
%   LENGTH(X). (Most probably you'll want to display C' instead of C).
%
%   Contrary to Matlab's original IMAGE function, here the vectors X and Y
%   do not need to be linearly spaced. Whereas IMAGE linearly interpolates
%   the X-axis between X(1) and X(end), ignoring all other values (idem
%   for Y), UIMAGE allows for X and/or Y to be unevenly spaced vectors, by
%   locally stretching the matrix C (ie, by duplicating some elements of C)
%   for larger X and/or Y intervals.
%
%   The syntax for UIMAGE(X,Y,C,...) is the same as IMAGE(X,Y,C,...)
%   (all the remaining arguments, eg 'PropertyName'-PropertyValue pairs,
%   are passed to IMAGE). See IMAGE for details.
%
%   Use UIMAGESC to scale the data using the full colormap. The syntax for
%   UIMAGESC(X,Y,C,...) is the same as IMAGESC(X,Y,C,...).
%
%   Typical uses:
%      - Plotting a spatio-temporal diagram (T,X), with unevenly spaced
%      time intervals for T (eg, when some values are missing, or when
%      using a non-constant sampling rate).
%      - Plotting a set of power spectra with frequency in log-scale.
%
%   h = UIMAGE(X,Y,C,...) returns a handle to the image.
%
%   Example:
%     c = randn(50,20);         % Random 50x20 matrix
%     x = logspace(1,3,50);     % log-spaced X-axis, between 10 and 1000
%     y = linspace(3,8,20);     % lin-spaced Y-axis, between 3 and 8
%     uimagesc(x,y,c');         % displays the matrix
%
%   F. Moisy
%   Revision: 1.10,  Date: 2012/01/31.
%
%   See also IMAGE, IMAGESC, UIMAGESC.


% History:
% 2006/06/12: v1.00, first version.
% 2006/06/14: v1.03, minor bug fixed; works in ML6.
% 2012/01/31: v1.10, bug fixed for both uneven X and Y axis
%  (thanks to Janti and Tim on the Matlab Central!!)
% 2014/04/14: v2.00 Scott Lowe. Complete rewrite.

error(nargchk(3,inf,nargin));

% maximum number of matrix elements to interpolate the uneven axis
% (typically between 500 and 5000):
nmax = 4000;

sf = 4;

x = varargin{1};
y = varargin{2};
c = varargin{3};

if nargin>=4 && ischar(varargin{4}) && strcmp(varargin{4},'pad')
    padmode = true;
    varargin = varargin([1:3 5:end]);
elseif nargin>=4 && ischar(varargin{4}) && strcmp(varargin{4},'nopad')
    padmode = false;
    varargin = varargin([1:3 5:end]);
else
    padmode = true; % Default padding mode
end

if any(diff(x)<=0) || any(diff(y)<=0)
    error('The X and Y axis should be increasing.');
end

dx = min(diff(x));                   % smallest interval for X
dy = min(diff(y));                   % smallest interval for Y

% test if X and Y are linearly spaced (to within 10^-12):
evenx = all(abs(diff(x)/dx-1)<1e-12);     % true if X is linearly spaced
eveny = all(abs(diff(y)/dy-1)<1e-12);     % true if Y is linearly spaced

if ~evenx && padmode
    x1 = x(1) - (x(2)-x(1))/2 + dx/2/sf;
    x2 = x(end) + (x(end)-x(end-1))/2 - dx/2/sf;
else
    x1 = x(1);
    x2 = x(end);
end

if ~eveny && padmode
    y1 = y(1) - (y(2)-y(1))/2 + dy/2/sf;
    y2 = y(end) + (y(end)-y(end-1))/2 - dy/2/sf;
else
    y1 = y(1);
    y2 = y(end);
end

if evenx && eveny         % X and Y both evenly spaced

    xe = x;
    ye = y;
    ce = c;

elseif evenx && ~eveny    % X even and Y uneven
    
    nx = length(x);
    xe = x;

    ny = ceil(1 + (y2 - y1)/dy);   % number of points for Y
    ny = min(sf*ny, nmax);
    ye = linspace(y1, y2, ny);

    ce = zeros(ny,nx);
    
    if length(ye)<length(y)
        for j=1:ny
            [~, indj] = min(abs(y-ye(j)));
            ce(j,1:nx) = c(indj, 1:nx);
        end
        
    else
        
        for j=1:length(y)
            if j==1;
                indj = abs(ye-y(j)) <= abs(ye-y(j+1));
            elseif j==length(y)
                indj = abs(ye-y(j)) < abs(ye-y(j-1));
            else
                indj = abs(ye-y(j)) < abs(ye-y(j-1)) & abs(ye-y(j)) <= abs(ye-y(j+1));
            end
            
            if isempty(indj); continue; end
            ce(indj, 1:nx) = repmat(c(j, 1:nx), [sum(indj) 1]);
            
        end
        
    end

elseif ~evenx && eveny    % X uneven and Y even
    
    nx = ceil(1 + (x2 - x1)/dx);   % number of points for X
    nx = min(4*nx, nmax);
    xe = linspace(x1, x2, nx);

    ny = length(y);
    ye = y;

    ce = zeros(ny,nx);

    if length(xe)<length(x)
        for i=1:nx
            [~, indi] = min(abs(x-xe(i)));
            ce(1:ny,i) = c(1:ny, indi);
        end
        
    else
        
        for i=1:length(x)
            if i==1;
                indi = abs(xe-x(i)) <= abs(xe-x(i+1));
            elseif i==length(x)
                indi = abs(xe-x(i)) < abs(xe-x(i-1));
            else
                indi = abs(xe-x(i)) < abs(xe-x(i-1)) & abs(xe-x(i)) <= abs(xe-x(i+1));
            end
            
            if isempty(indi); continue; end
            ce(1:ny, indi) = repmat(c(1:ny,i), [1 sum(indi)]);
            
        end
        
    end
    
elseif ~evenx && ~eveny   % X and Y both uneven
    
    nx = ceil(1 + (x2 - x1)/dx);   % number of points for X
    nx = min(sf*nx, nmax);
    xe = linspace(x1, x2, nx);
    
    ny = ceil(1 + (y2 - y1)/dy);   % number of points for Y
    ny = min(sf*ny, nmax);
    ye = linspace(y1, y2, ny);

    ce = zeros(ny,nx);
    
    if length(xe)<length(x)
        for i=1:nx
            % indi = find(x<=xe(i),1,'last');
            [~, indi] = min(abs(x-xe(i)));
            for j=1:ny
                % indj = find(y<=ye(j),1,'last');
                [~, indj] = min(abs(y-ye(j)));
                ce(j,i) = c(indj, indi);
            end
        end
        
    else
        
        for i=1:length(x)
            if i==1;
                indi = abs(xe-x(i)) <= abs(xe-x(i+1));
            elseif i==length(x)
                indi = abs(xe-x(i)) < abs(xe-x(i-1));
            else
                indi = abs(xe-x(i)) < abs(xe-x(i-1)) & abs(xe-x(i)) <= abs(xe-x(i+1));
            end
            if isempty(indi); continue; end
            
            for j=1:length(y)
                if j==1;
                    indj = abs(ye-y(j)) <= abs(ye-y(j+1));
                elseif j==length(y)
                    indj = abs(ye-y(j)) < abs(ye-y(j-1));
                else
                    indj = abs(ye-y(j)) < abs(ye-y(j-1)) & abs(ye-y(j)) <= abs(ye-y(j+1));
                end
                
                ce(indj,indi) = c(j, i);
                
            end
        end
        
    end
end

hh = image(xe, ye, ce, varargin{4:end});

if nargout>0
    h = hh;
end
