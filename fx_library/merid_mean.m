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

function [arrayout] = merid_mean(arrayin, latgrid)
arrayin=squeeze(arrayin);
latgrid=squeeze(latgrid);

check1=size(arrayin);
check2=size(latgrid);
if check1(1)==check2(2)
        arrayin=arrayin';
        size(arrayin);
        size(latgrid);
end


nans=isnan(arrayin);
newarray=arrayin.*cosd(latgrid);
num=sum(newarray(~nans));
latgrid(~nans);
den=sum(cosd(latgrid(~nans)));
if den==0
	arrayout=NaN;
        %fprintf('bad denominator, filling with NaN\n')
    return
end
arrayout=num./den;

return