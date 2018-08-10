% This code is designed to create and plot the QBO EOFs from Wallace et al. (2003) and
% the projections onto the QBO smoothed and deseasonalized timeseries from
% Singapore winds (and others if back before 1987)

% setup
clear
close all
addpath('/Users/dgilford/ncar_summer_2017/fx_library');

% Using the values from the EOF projections found in Wallace et al. (2003),
% courtesy of Mijeong Park (NCAR, 7/27/2017, see their module waccmreg.f)
eof1=[-.46,-.34,-.18,.13,.40,.50,.52];
eof2=[-.15,.40,.54,.57,.40,.18,-.07];
lvlgrid=[70 50 40 30 20 15 10];

% plot the first and second eofs
close all
hqbo=figure(1);
hold on
    plot(eof1,lvlgrid,'b','LineWidth',1.5)
    plot(eof2,lvlgrid,'r','LineWidth',1.5)
    plot([0 0],[lvlgrid(1) lvlgrid(end)],'k--','LineWidth',2)
    legend('QBO1','QBO2','Location','Best')
    set(gca,'YTick',fliplr(lvlgrid),'YTickLabel',fliplr(lvlgrid))
    set(gca,'XTick',-0.75:0.25:0.75)
    set(gca,'ydir','reverse','yscale','log')
    xlim([-0.75 0.75])
    title('EOFs 1 and 2 for QBO, from Wallace et al. 2003, Fig. 3')
    xlabel('Coefficients')
    ylabel('Pressure (hPa)')
hold off

% load the qbo data
load('/Users/dgilford/ncar_summer_2017/gr_radiosondes/variability_indices/qbo_data_0617.mat')

% integrate to get qbo1 and qbo2
qbo1(:)=(eof1(1).*qbo.index(:,1)+eof1(2).*qbo.index(:,2)+...
    eof1(3).*qbo.index(:,3)+eof1(4).*qbo.index(:,4)+...
    eof1(5).*qbo.index(:,5)+eof1(6).*qbo.index(:,6)+...
    eof1(7).*qbo.index(:,7))./2./10;

qbo2(:)=(eof2(1).*qbo.index(:,1)+eof2(2).*qbo.index(:,2)+...
    eof2(3).*qbo.index(:,3)+eof2(4).*qbo.index(:,4)+...
    eof2(5).*qbo.index(:,5)+eof2(6).*qbo.index(:,6)+...
    eof2(7).*qbo.index(:,7))./2./10;

% remove the seasonal cycle at every height
nyear=fix(qbo.time(end))-floor(qbo.time(1))+1;
for yr=1:nyear
    for m=1:12
        tind=(yr-1)*12+m;
        qbo1_ym(yr,m)=qbo1(tind);
        qbo2_ym(yr,m)=qbo2(tind);
    end
end
qbo1_seas=nanmean(qbo1_ym,1);
qbo2_seas=nanmean(qbo2_ym,1);
for yr=1:nyear
	qbo1_anom(yr,:)=qbo1_ym(yr,:)-qbo1_seas;
    qbo2_anom(yr,:)=qbo2_ym(yr,:)-qbo2_seas;
end
for yr=1:nyear
    for m=1:12
        tind=(yr-1)*12+m;
        qbo1_ts(tind,1)=qbo1_anom(yr,m);
        qbo2_ts(tind,1)=qbo2_anom(yr,m);
    end
end 

% smooth the QBO data
nmon_move=5;
qbo1_smooth=movmean(qbo1_ts,[nmon_move 0]);
qbo2_smooth=movmean(qbo2_ts,[nmon_move 0]);

% reduce the data to only Singapore period (>1987)
goodinds=find(qbo.time>=1987);
qbo1_red=qbo1_smooth(goodinds);
qbo2_red=qbo2_smooth(goodinds);

% plot the timeseries
hqbots=figure(2);
hold on
    plot(qbo.time,qbo1,'b','LineWidth',1.5)
    plot(qbo.time,qbo2,'r','LineWidth',1.5)
    plot([qbo.time(1) qbo.time(end)],[0 0],'k--','LineWidth',2)
    legend('QBO1','QBO2','Location','Best')
    title('QBO1 and 2 from Wallace et al. 2003')
    axis('tight')
    xlabel('Year')
    ylabel('Amplitude')
    axis('tight')
hold off

% plot the phase space
hqbophase=figure(3);
set(gcf,'color','w')
set(gca,'FontSize',16)
hold on
dat1=qbo1_red(~isnan(qbo1_red));
dat2=qbo2_red(~isnan(qbo2_red));
[color_grid,~]=colorGradient([0 0 1],[1 0 0],length(dat1));
    for k=1:length(dat1)
        plot(dat1(k),dat2(k),'o','color',color_grid(k,:),'MarkerFaceColor',color_grid(k,:))
    end
    plot(dat1,dat2,'k')
    grid
    title('QBO EOF Projections, following Wallace et al. 2003')
    xlim([-3 3])
    ylim([-3 3])
    xlabel('QBO1')
    ylabel('QBO2')
hold off

% contour the QBO with respect to height
clevels=-40:5:15;
hqboz=figure(4);
hold on
    contourf(qbo.time(goodinds),qbo.lvlgrid,qbo.index(goodinds,:)',clevels)
    set(gca,'YTick',fliplr(lvlgrid),'YTickLabel',fliplr(lvlgrid))
    set(gca,'XTick',1990:5:2017)
    set(gca,'ydir','reverse','yscale','log')
    xlabel('Time')
    ylabel('Pressure (hPa)')
    title('Singapore Winds with Height (m/s)')
    colorbar
hold off
set(hqboz, 'Position', [200 200 1000 400])
set(hqboz,'PaperPositionMode','auto')   

%% Save out the Data

% store the QBO EOF1+2 arrays
qbo.eof1_weights=eof1;
qbo.eof2_weights=eof2;
qbo.eof1=qbo1_ts;
qbo.eof2=qbo2_ts;

% save out the data
savepath1='/Users/dgilford/ncar_summer_2017/gr_radiosondes/variability_indices/qboeof_data_0617.mat';
save(savepath1,'qbo');