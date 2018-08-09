% 
% This code is designed to read in the text weighting function data
% from RSS and save it into a *.mat file for use in the rest of the project.
%

% define the weighting function file from RSS we are looking for
filename='std_atmosphere_wt_function_chan_tls.txt';

% load the MSU weighting function data file
loadpath='/Users/dgilford/ncar_summer_2017/msu_data/weighting_functions/';
filepath=strcat(loadpath,filename);
headerlines=6;
dat=importdata(filepath,' ',headerlines);

% get the pressure grid and weighting functions, convert pressure to hPa
lvlgrid=dat.data(:,4)./100;
nlvl=length(lvlgrid);
weights=dat.data(:,6);

% save out the weighting functions into a *.mat file
p_weights=lvlgrid;
save('../data/tls_weighting_function.mat','p_weights','weights');