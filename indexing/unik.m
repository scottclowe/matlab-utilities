%UNIK Find unique elements and a cumulative count of occurrences
%   B = UNIK(A) for the array A returns the same values as in A but
%   with no repetitions. B will also be sorted. A can be a cell array of
%   strings.
%   
%   [B,I,J] = UNIK(...) also returns index vectors I and J such
%   that B = A(I) and A = B(J) (or B = A(I,:) and A = B(J,:)).
%   
%   [B,I,J,K] = UNIK(...) also returns the cumulative count of occurrences
%   of each unique value. For every element in A, A(i) is the K(i)-th
%   occurrence of the unique value Z(J(i)).
%   
%   UNIK(A, ...) accepts the same flags as UNIQUE. See UNIQUE for
%   details.
%   
%   See also UNIQUE.

function [B, I, J, K] = unik(A, varargin)

% Use in-built function unique to do most of the work
[B, I, J] = unique(A, varargin{:});

if nargout<4
    % Exit now if we don't need to know K.
    % Although if this is the case the user should be using unique instead
    % of this function.
    return;
end

% Calculate K
K = zeros(size(A));
% Loop over every unique value
for ii = 1:numel(B)
    % Check which of the elements match the ii-th unique value
    li = J==ii;
    % Total up how many this is
    ss = cumsum(li);
    % And remember how many occurrences we have had
    K(li) = ss(li);
end 

end
