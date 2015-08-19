%ARRAY2STR Convert an array to a string in concise MATLAB syntax.
%   STR = ARRAY2STR(X) converts the array X to about as concise as possible 
%   a MATLAB string by making use of the COLON operator so that EVAL(STR)
%   produces the original matrix (to within 15 digits of precision).
%   A tolerance of 10^-10 is used in the script to compare step-intervals
%   and group together elements with the colon operator.
%
%   STR = ARRAY2STR(X, N) uses N digits of precision. If the value of N
%   applied to the absolute smallest non-zero element of the array requires
%   greater precision than the Caution must be taken
%   with large N, as this leads to problems with rounding errors.
%
%   STR = ARRAY2STR(X, FORMAT) uses the format string FORMAT (see SPRINTF 
%   for details). The default tolerance of 10^-10 is used, so step-intera
%
%   STR = ARRAY2STR(X, 'class') creates a string with the name of the class
%   of X included.  This option ensures that the result of evaluating STR
%   will also contain the class information.
%
%   STR = ARRAY2STR(X, ..., 'class') uses either N digits of precision or
%   the format string FORMAT supplied, and includes the class information.
%
%   The precision and format apply only to the numeric values
%   included in the string output.
%   
%   Note that the elements are grouped from left to right.
%   
%   Example 1:
%      array2str([1:0.07:10000]) produces the string [1:0.07:9999.94]
%
%   Example 2:
%      array2str(int8([1:3 4:2:8]'), 'class') produces the string
%         int8([1:4 6 8])'
%
%   See also ARRAY2STRDIRSAFE, MAT2STR, NUM2STR, INT2STR, SPRINTF, CLASS, 
%   EVAL, COLON.

% Scott Lowe, July 2012

function str = array2str(A, varargin)

%% Input handling

% If input is a string, return this string.
if ischar(A)
    str = x;
    return
end
if isempty(A)
    str = '[]';
    return
end
if islogical(A)
    error('Doesnt work on logicals.');
end

if (ndims(A) > 2)
    error(message('MATLAB:array2str:TwoDInput'));
end
[rows, cols] = size(A);
if rows~=1
    if cols~=1
        error(message('MATLAB:array2str:OneDInput'));
    else
        str = [array2str(A', varargin{:}) ''''];
        return
    end
end


useclass = false;
usedigits = false;
passargs = varargin;
for iarg = 1:length(varargin)
    if ischar(varargin{iarg})
        if strcmpi(varargin{iarg},'class')
            useclass = true;
            use_argin = 1:length(varargin);
            use_argin(iarg) = [];
            passargs = varargin(use_argin);
        else
%             % Try %0.0f/g format
%             [scans,count] = sscanf(varargin{iarg}, '%%%f%[diouxefgsc]');
%             if count==2
%                 char(scans(2))
%                 error('Invalid string format');
%                 % Doesn't work for more than 10sf
%                 ndigits = 10*(scans(1)-floor(scans(1)));
%                 10^(floor(log10(min(A(:))))-ndigits)
%             elseif count>2
%                 error('Invalid string format');
%             end
%             
%             % Try %d format
%             [scans,count] = sscanf(varargin{iarg}, '%%%f%[diouxefgsc]');
%             if count==0
%                 continue
%             elseif count==1 && strcmpi(char(scans),'d')
%                 precision = 0;
%             else
%                 error('Invalid string format');
%             end
        end
    elseif isnumeric(varargin{iarg})
        usedigits = true;
        ndigits = varargin{iarg};
        precision = 10^(floor(log10(min(abs(A(A~=0)))))-ndigits);
    else
        error(message('MATLAB:array2str:InvalidOptionType'));
    end
end


if issparse(A)
    [i,j,s] = find(A);
    str = ['sparse(' mat2str(i) ', ' mat2str(j), ', '];
    str = [str array2str(s, varargin{:})];
    str = [str ', ' mat2str(rows) ', ' mat2str(cols) ')'];
    return;
end


%% Defaults
% Perhaps the tolerance should depend on the precision specified in the
% input if it is present?
% This can lead to problems if the precision is unnecessarily high, but I
% suspect it might be useful
tolerance = 10^-10;
if usedigits
    tolerance = min(tolerance,precision/10);
else
    tolerance = min(tolerance,min(abs(A(A~=0)))/10);
end

%% Code

% Find differences between elements
diff = A(2:end)-A(1:end-1);

% Find where the difference between elements changes. Thems the breaks.
% We'll need to mention these in the string
% Have to compare the difference to a tolerance rather than compare for
% equality due to loss of precision
mention = abs( diff(2:end) - diff(1:end-1) ) > tolerance;
% Also mention the first and last numbers in the array
mention = [1 mention 1];

str = '[';
id = 1;
while id <= length(A)
    
    % If not at the start, we need a space as seperator
    if id~=1
        str = [str ' '];
    end
    % Add the current number
    str = [ str num2str(A(id),passargs{:}) ];
    
    % 
    next_mention_dist = find(mention((id+1):end),1);
    if isempty(next_mention_dist) || next_mention_dist==1
        id = id+1;
        continue
    end
    next_mention = id+next_mention_dist;
    str = [str ':'];
    if diff(next_mention-1)~=1
        str = [ str num2str(diff(next_mention-1),passargs{:}) ':' ];
    end
    str = [ str num2str(A(next_mention),passargs{:}) ];
    id = next_mention+1;
end
str = [ str ']' ];

if useclass
    str = [ class(A) '(' str ')' ];
end

end