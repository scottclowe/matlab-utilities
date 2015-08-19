%MAT2STRCOMMA
%   The same as MAT2STR, but uses commas instead of spaces for element 
%   separation along the rows.
%
%   See also MAT2STR, ARRAY2STR, ARRAY2STRDIRSAFE.

% Scott Lowe, July 2012

function str = mat2strcomma(varargin)

str = regexprep(mat2str(varargin{:}),'\s',',');

end