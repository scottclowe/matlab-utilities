function rmat = cellcat2matpadNaN(dim,tcell)
% Turn a cell array into a matrix with padding of NaNs to make the dimensions in
% each cell match.
% Note: only works for cells which are vector double arrays. Pads in the
% specified dimension (row or column). Works best if there is nothing in
% that dimension of the input cell array.
    
    sizes = cellfun('size',tcell,dim);
    maxSize = max(sizes(:));    %# Get the maximum vector size
    %# Create an anonymous function
    if dim==2
        fcn = @(x) [x; nan(maxSize-size(x,1), size(x,2))];
    elseif dim==1
        fcn = @(x) [x, nan(size(x,1), maxSize-size(x,2))];
    else
        fcn = @(x) cat(dim, x, nan(1,maxSize-size(x,2)));
        error('I am stupid and dont know how to handle more than 2 dim.');
    end
    rmat = cellfun(fcn,tcell,'UniformOutput',false);    %# Pad each cell with NaNs
    rmat = cat(dim,rmat{:});
    
end