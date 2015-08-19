%MAXIMISEFIGURE Maximises figure
%   With no argument supplied, MAXIMISEFIGURE() will maximise the
%   current figure.
%
%   MAXIMISEFIGURE(H) maximises the figure with handle H.

function maximisefigure(fh)

if nargin<1
    fh = gcf;
end
set(fh,'Position',get(0,'Screensize'));

end
