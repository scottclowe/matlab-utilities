function h = uimagesc(varargin)
%UIMAGESC  Display scaled image with uneven axis.
%   UIMAGESC(...) is the same as UIMAGE(...) except the data is scaled
%   to use the full colormap. See UIMAGE for details.
%
%   Note: UIMAGESC is based on Matlab's original IMAGESC, Revision 5.11.4.5.
%   UIMAGESC simply calls UIMAGE with a scaled colormap.
% 
%   F. Moisy - adapted from TMW
%   Revision: 1.01,  Date: 2006/06/13.
%
%   See also IMAGE, IMAGESC, UIMAGE.

% History:
% 2006/06/12: v1.00, first version.

% Copyright (c) 2012, Frederic Moisy
% All rights reserved.
% 
% Redistribution and use in source and binary forms, with or without
% modification, are permitted provided that the following conditions are
% met:
% 
%     * Redistributions of source code must retain the above copyright
%       notice, this list of conditions and the following disclaimer.
%     * Redistributions in binary form must reproduce the above copyright
%       notice, this list of conditions and the following disclaimer in
%       the documentation and/or other materials provided with the distribution
%     * Neither the name of the University Paris Sud nor the names
%       of its contributors may be used to endorse or promote products derived
%       from this software without specific prior written permission.
% 
% THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
% AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
% IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
% ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE
% LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR
% CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF
% SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS
% INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
% CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE)
% ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
% POSSIBILITY OF SUCH DAMAGE.

clim = [];
switch (nargin),
  case 0,
    hh = uimage('CDataMapping','scaled');
  case 1,
    hh = uimage(varargin{1},'CDataMapping','scaled');
  case 3,
    hh = uimage(varargin{:},'CDataMapping','scaled');
  otherwise,

    % Determine if last input is clim
    if isequal(size(varargin{end}),[1 2])
      str = false(length(varargin),1);
      for n=1:length(varargin)
        str(n) = ischar(varargin{n});
      end
      str = find(str);
      if isempty(str) || (rem(length(varargin)-min(str),2)==0),
        clim = varargin{end};
        varargin(end) = []; % Remove last cell
      else
        clim = [];
      end
    else
      clim = [];
    end
    hh = uimage(varargin{:},'CDataMapping','scaled');
end

% Get the parent Axes of the image
cax = ancestor(hh,'axes');

if ~isempty(clim),
  set(cax,'CLim',clim)
elseif ~ishold(cax),
  set(cax,'CLimMode','auto')
end

if nargout > 0
    h = hh;
end
