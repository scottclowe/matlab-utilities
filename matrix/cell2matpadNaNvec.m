function rmat = cell2matpadNaNvec(tcell,dim)
% Turn a cell array into a matrix with padding of NaNs to make the dimensions in
% each cell match.
% Note: only works for cells which are vector double arrays. Pads in the
% specified dimension (row or column). Works best if there is nothing in
% that dimension of the input cell array.

    if nargin<2
        dim = 2;
    end
    
    sizes=cellfun(@numel,tcell);
    maxSize = max(sizes(:));    %# Get the maximum vector size
    %# Create an anonymous function
    if dim==1
        fcn = @(x) [x; nan(maxSize-numel(x),1)];
    else
        fcn = @(x) [x nan(1,maxSize-numel(x))];
    end
    rmat = cellfun(fcn,tcell,'UniformOutput',false);    %# Pad each cell with NaNs
    %rmat = vertcat(rmat{:});                 %# Vertically concatenate cells
    rmat = cell2mat(rmat);                              % collapse down to 
    
end