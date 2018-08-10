% This code is designed to read in the FU-Berlin QBO dataset and save it out into a workable *.mat file
% The original data is available at http://www.geo.fu-berlin.de/en/met/ag/strat/produkte/qbo/
%

% setup
clear
close all

% select the data file path
filepath='/Users/dgilford/ncar_summer_2017/index_data/qbo_rawdata_062017.txt';

% open the data file
fid=fopen(filepath);

% get the first line
tline = fgetl(fid);

% setup our counter
i=1;

% loop over all the lines
while ischar(tline)
    
               	% get the station
               	stn(i,1)=fix(str2num(tline(1:5)));
                % get the yymm
               	yymm{i,1}=tline(7:10);
               	for y=1:7
                    if i<37 & y==7
                       qbo_in(i,y)=NaN;
                    else
                        inds=13+(y-1)*7:13+(y-1)*7+4;
                        qbo_in(i,y)=str2num(tline(inds));
                    end
                end
                
        % read the next line of the data and increment our counter
       	tline=fgets(fid);
        i=i+1;
        

end

% close the data file
fclose(fid);

% scale the data to m/s from 0.1m/s
qbo_in=qbo_in./10;

% setup the lvlgrid
lvlgrid=[70 50 40 30 20 15 10];

% set up the timegrid
firstyear_str=strcat('19',yymm{1}(1:2));
firstyear=str2num(firstyear_str);
lastyear_str=strcat('20',yymm{end}(1:2));
lastyear=str2num(lastyear_str);

% create the timegrid
nyear=lastyear-firstyear+1;
ntime=nyear*12;
timegrid=linspace(firstyear,(lastyear+1)-1/12,ntime);

% fill missing months with NaNs
[ntqbo,~]=size(qbo_in);
miss_inds=ntime-ntqbo;
qbo_in(end+1:end+miss_inds,:)=NaN;

% organize and save out the dataset
qbo.index=qbo_in;
qbo.time=timegrid;
qbo.lvlgrid=lvlgrid;
save('/Users/dgilford/ncar_summer_2017/gr_radiosondes/variability_indices/qbo_data_0617.mat','qbo')

