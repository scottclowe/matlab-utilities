function rmat = cell2matpadNaN2(tcell)
% Turn a cell array into a matrix with padding of NaNs to make the dimensions in
% each cell match
    
    % Cells get merged together along every non-singleton dimension of the
    % cell matrix. If there is only one non-singleton dimension, there is
    % catenation along that dimension, and we don't need to worry about the
    % length of cell contents in that dim.
    if sum(size(tcell)~=1)==1
        paddingdims = find(size(tcell)==1);
    else
        paddingdims = 1:ndims(tcell);
    end
    
    if isempty(paddingdims)
        rmat = cell2mat(tcell);
        return;
    end
    
    maxsizes = nan(1,length(paddingdims));
    for idim = 1:length(paddingdims)
        dimsize = cellfun('size',tcell,paddingdims(idim));
        maxsizes(idim) = max(dimsize(:));
    end
    
    %# Create an anonymous function
    fcn = @(x) pad_nan(x,paddingdims,maxsizes);
    rmat = cellfun(fcn,tcell,'UniformOutput',false);    %# Pad each cell with NaNs
    rmat = cell2mat(rmat);                              % collapse down to matrix
    
end

function b=pad_nan(a,paddingdims,maxsizes)
    asize=size(a);
    targetsize = ones(1,max(paddingdims));
    targetsize(1:length(asize)) = asize;
    for idim=1:length(paddingdims)
        dim = paddingdims(idim);
        targetsize(dim) = max(maxsizes(idim),targetsize(dim));
    end
    b=nan(targetsize);
    cart = cell(1,length(asize));
    for idim=1:length(asize)
        cart{idim} = 1:asize(idim);
    end
    b(cart{:}) = a;
end