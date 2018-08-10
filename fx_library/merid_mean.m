% This function takes in an array of values and latitudinally averages over
% them using the curvature of the earth (cos(latitude)) as weighting.
%
%	Inputs:
%               arrayin         -->             (1d array) The values that you want to average over a latitude band
%
%               latitude        -->             (1d array) The latitudes at which the values in "arrayin" are valid
%               nanswitch       -->             (0 or 1) If == 1, exclude NaNs in average, else set to 0 
%
%	Outputs:
%               arrayout        -->             (Floating number) The average value of "arrayin" values over all latitudes
%               
%

function [arrayout] = merid_mean(arrayin, latgrid, nanswitch)

% make sure the arrays are shaped correctly
arrayin=squeeze(arrayin);
latgrid=squeeze(latgrid);
check1=size(arrayin);
check2=size(latgrid);
if check1(1)==check2(2)
        arrayin=arrayin';
end

% if nanswitch==1 take averages removing NaNs
if nanswitch==1
    nans=isnan(arrayin);
    newarray=arrayin.*cosd(latgrid);
    num=sum(newarray(~nans));
    latgrid(~nans);
    den=sum(cosd(latgrid(~nans)));
    if den==0
        arrayout=NaN;
        return
    end
    arrayout=num./den;
elseif nanswitch==0
    % take the meridional average
    newarray=arrayin.*cosd(latgrid);
    num=sum(newarray);
    den=sum(cosd(latgrid));
    arrayout=num./den;
else
    error('nanswitch not correctly specified for "merid_mean()". /n')
end

% go to the above program level
return