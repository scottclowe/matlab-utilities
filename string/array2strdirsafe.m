% Same as array2str, except whitespace is swapped to commas, colons are
% swapped to hyphens and square braces are removed.
% Caution: removes the apostrophe at the end if the input is a column
% array.
%
%   See also ARRAY2STR.

% Scott Lowe, July 2012

function str = array2strdirsafe(A, varargin)

str = array2str(A, varargin{:});
expressions  = { '['  , ']' , '''', '\s'  , ':' };
replacements = { ''   , ''  , ''  ,  ','  , '-' };
str = regexprep(str,expressions,replacements);

% str = regexprep(str,'\s',',');
% str = regexprep(str,':','-');
% str = regexprep(str,'[','');
% str = regexprep(str,']','');
% str = regexprep(str,'''','');

end