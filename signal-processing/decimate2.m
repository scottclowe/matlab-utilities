%DECIMATE2 Decimate an n-dimensional array along the first dimension
%   Y = DECIMATE2(X, R, DIM, ...) resamples the sequence in matrix X along
%   dimension DIM at 1/R times the original sample rate.
%   
%   DECIMATE2(X, R) or DECIMATE2(X, R, [], ...) resamples along the first
%   non-singleton dimension.
%   
%   See also DECIMATE.

function odata = decimate2(idata, r, dim, varargin)

% Input handling
if nargin<3 || isempty(dim)
    % Default with first non-singleton dimension
    dim = find(size(idata) ~= 1, 1);
    if isempty(dim), dim = 1; end
end
if size(idata,dim)==1
    error('Input is singleton first dimension.');
end

% Permute so target dim is first
perm  = [dim, setdiff(1:ndims(idata),dim)];
idata = permute(idata, perm);

% Note down the original input size
isiz_full = size(idata);
% Reduce first dimension to find the target output size
osiz_full = [isiz_full(1)/r, isiz_full(2:end)];
% Find the size of input if we collapse all higher dimensions
isiz_resh = [isiz_full(1), prod(isiz_full(2:end))];
% Find the size of output if we collapse all higher dimensions
osiz_resh = [osiz_full(1), prod(osiz_full(2:end))];

% Collapse higher dimension of the input array so it is two-dimensional
idata = reshape(idata, isiz_resh);
% Initialise the output in a collapsed shape
odata = zeros(osiz_resh);
% Decimate each column in the collapsed matrix
for k=1:osiz_resh(2)
    odata(:,k) = decimate(idata(:,k), r, varargin{:});
end
% Reshape so columns are in the correct place of the array
% with all the higher dimensions present
odata = reshape(odata, osiz_full);

% Invert permute
odata = ipermute(odata, perm);

end
