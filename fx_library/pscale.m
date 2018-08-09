% This function adjusts the axes of the current plot to be reversed and set
% on a log pressure scale
%
% User Inputs:
%               lvlgrid  --> Pressure levels of the y-axis
%               inds     --> The indices used to access the lvlgrid
%               ylimits  --> The limit of your y-axis (reversed, highest
%               pressure first)

function [suc] = pscale(lvlgrid,inds,ylimits);

% change the y-axis scale
new_lvl=flipud(lvlgrid(inds));
set(gca,'ydir','reverse','yscale','log')
set(gca,'YTick',new_lvl,'YTickLabel',num2str(floor(new_lvl)))

% change the y-limit
ylim([ylimits(2) ylimits(1)])

% add a label
ylabel('Pressure (hPa)')

% go to the above program level
return