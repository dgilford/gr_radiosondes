% 
% This code is designed to read in the netcdf data from RSS and reorganize
% it into a *.mat file for use in the rest of the project.
%

% choose the channel to make the mat file for (string)
chan='TLS';

% set the data path
loadpath='/Users/dgilford/ncar_summer_2017/msu_data/data/netcdf/';

% load in the data from netcdf source
loadfile=strcat(loadpath,'RSS_Tb_Maps_ch_',chan,'_V3_3.nc');
% ncdisp(loadfile) % uncomment if you want want to see the data structure
latgrid=ncread(loadfile,'latitude');
longrid=ncread(loadfile,'longitude');
Tb=ncread(loadfile,'brightness_temperature');

% data starts in 1979 and runs through June 2017
% remove 1978 from dataset
Tb=Tb(:,:,13:end);
[nlon,nlat,ntime]=size(Tb);
% create a timegrid along which the data will lie, through end of 2017
firstyear=1979; nyear=ntime/12; lastyear=nyear+firstyear-1;
timegrid=linspace(firstyear,lastyear+1-1/12,nyear*12);

% save out dataset
msu_timegrid=timegrid; msu_latgrid=latgrid; msu_longrid=longrid;
save('../data/MSU_gridded_data.mat','Tb','msu_timegrid','msu_latgrid','msu_longrid')
