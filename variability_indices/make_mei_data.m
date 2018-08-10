% This script loads and organizes the MEI data from the NOAA ESRL website:
% https://www.esrl.noaa.gov/psd/enso/mei/table.html

% get the filepath and load the data
dat_path='/Users/dgilford/ncar_summer_2017/index_data/mei_062017.txt';
mei_dat=importdata(dat_path);

% organize into a structure
mei.year=mei_dat.data(:,1);
mei.index=mei_dat.data(:,2:13);
textdata=char(mei_dat.textdata);
for m=1:12
    first_point=8+(m-1)*8+1;
    last_point=first_point+5;
    string=char(textdata(first_point:last_point));
    mei.monstring{m}=string;
end

% save out
save('/Users/dgilford/ncar_summer_2017/gr_radiosondes/variability_indices/mei_data_0617.mat','mei')