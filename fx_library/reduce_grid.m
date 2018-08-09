% This function reduces the input grid over the defined user range and outputs the indices
% for use in data arrays as well. A common use would be to define a latitude range and reduce that grid
% to a defined latitude range that the user wants, and get the indices to reduce the data array in the ab$
%
%	Inputs:
%               in_grid         -->             (1d array) The grid that you are reducing
%               in_range        -->             (1 or 2 element array) The array containing the end point$
%                                                       the grid (inclusive) to include in the output gri$
%                                                       The first element must be the smaller of the two $
%                                                       If using one element, out_inds will also return 1$
%
%	Outputs:
%               out_grid        -->             (1d array) The grid with the reduced number of elements b$
%               out_inds        -->             (1d array) The indices corresponding to the original "in_$
%                                                       by the above level program on data if necessary
%

function [out_grid,out_inds] = reduce_grid(in_grid,in_range)

%ensure that the input grid is a 1d array
if (iscolumn(in_grid)==1 | isrow(in_grid)==1)==0
        error('improper dimensions for "in_grid" input to reduce_grid()')
end

% Make sure that the first element is the smallest
if (length(in_range))==1
        out_inds=find(in_grid >= in_range(1) & in_grid <= in_range(end));
elseif (length(in_range))==2
        if (in_range(1) < in_range(2))
                out_inds=find(in_grid >= in_range(1) & in_grid <= in_range(end));
        else
            	in_range
                error('improper order for "in_range" elements in reduce_grid()')
                
               	in_range
               	error('improper order for "in_range" elements in reduce_grid()')
       	end
else
       	error('Wrong input size for "in_range" in reduce_grid()')
end

% reduce the size of the grid based on the out_inds for output
out_grid=in_grid(out_inds);

% go back to the above level
return


