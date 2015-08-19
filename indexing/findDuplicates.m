%FINDDUPLICATES
%   Z = FINDDUPLICATES(X) finds the elements in X which occur more than
%   once.
%   
%   [Z, TF, LOC] = FINDDUPLICATES(X) also returns a logical array of which
%   elements in X are repeated as TF. For each element of X, LOC indicates
%   which of the elements of Z they are, or 0 if they are unique.

function [Z, TF, LOC] = findDuplicates(X, varargin)

% Find a unique set of values which are present in X
[~,I,~] = unique(X, varargin{:});

% Find indices of the X for which the value is not listed in the unique
% mapping
duplicate_ind = setdiff(1:numel(X), I);

% Get a set of values which are duplicated
Z = unique(X(duplicate_ind));

if nargout<=1
    % We can return now if the user only needs to know Z
    return;
end

% Check which members of X are in the list of duplicates
[TF, LOC] = ismember(X, Z);

end
