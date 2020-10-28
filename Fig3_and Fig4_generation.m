% logistic_storage_analysis.m
% Christopher Zahasky
% 10/3/2019

clear all
close all
set(0,'DefaultAxesFontSize',14, 'defaultlinelinewidth', 2,...
    'DefaultAxesTitleFontWeight', 'normal')

% Define colormaps, note that colorbrewer was used for manuscript figures,
% and requires additional packages
bluecc = cool(4); 
redcc = flipud(autumn(4)); 
greycc = flipud(gray(6)); 

%% Load Data
load('matlab_storage_data')
years = storage_data(:,1); % years
qinj = storage_data(:,2); % MT
Q = storage_data(:,3)./1000; % Gt

%% Input
% Grwoth rate fit to current data
w = 0.0863;
% possible storage in 2100 at current rates
Qinf = [911 2200];
% Fit peak years
peak_year = [2105.6    2116.0 ]; 

% Input for models with change in rate in 2030
year_rate_change = [2030];
% rate change
rtarget = [0.106, 0.121, 0.121];
% resulting storage to meet 2100 target
Qtarget =[2691.7, 1504.5, 369.1];
% resulting peak injection
peak_target = [2101.8,  2088,  2076.4];
% vector defining years to calculate model output
x = [years(1):2150];

%% Plot cumulative storage
figure('position', [105  337  1700  441])
subplot(1,3,1)
hold on

% Plot current trajectory data
for i=1:length(Qinf)
    C(i) = Qinf(i);
    qt = C(i)./(1+exp(w*(peak_year(i)-x)));
    plot(x,qt, 'color', bluecc(i,:))
end

% Plot increased rate data
for i=1:length(Qtarget)
    % trajectory
    cum_at_rate_change = exp(year_rate_change.*w).*exp(-1.749e+02);
    x2 = [year_rate_change:2150];
    
    C = (Qtarget(i)-cum_at_rate_change);
    qt = (C./(1+exp(rtarget(i)*(peak_target(i)-x2))));
    plot(x2,qt, 'color', redcc(i+1,:))
end

% trajectory
y = exp(x.*w).*exp(-1.749e+02);
y(129)
% Plot inf growth rate projection
plot(x, y, '--', 'color', 0.7.*[1 1 1],'HandleVisibility','off')
% Plot actual data
plot(years(1:end-6), Q(1:end-6),'-ok','MarkerFaceColor', 'k','MarkerSize',2, 'linewidth', 1,'HandleVisibility','off')
plot(years(end-6:end), Q(end-6:end),':k', 'linewidth', 1,'HandleVisibility','off')
% Plot point at 2100 with current trajectory
plot([2070 x(129)], [y(129) y(129)], 'color', ones(1,3).*0, 'linewidth', 1,'HandleVisibility','off')
plot(x(129), y(129), '.k', 'markersize', 9,'HandleVisibility','off')
text(2042.6, 591.57, '561 Gt', 'fontsize', 13)
% plot point at 1218
plot([2085 2100], [1218 1218], 'color', ones(1,3).*0, 'linewidth', 1,'HandleVisibility','off')
plot(2100, 1218, '.k', 'markersize', 9,'HandleVisibility','off')
text(2053, 1447.3, '1218 Gt', 'fontsize', 13)
% plot point at 348 (low model)
plot([2100 2100], [100 348], 'color', ones(1,3).*0, 'linewidth', 1)
plot(2100, 348, '.k', 'markersize', 9)
text(2089.67, 63.4, '348 Gt', 'fontsize', 13)

% Large plot axis
text(1976.4, 3695, 'Growth Rates', 'fontsize', 14)
axis([1970 2150 10^-3.5 10^4])
legend({[num2str(8.6), '%'], [num2str(8.6), '%'], ...
    [num2str(rtarget(1)*100), '%'], [num2str(rtarget(2)*100), '%'], ...
    [num2str(rtarget(3)*100), '%']}, ...
    'Box', 'off',  'fontsize', 13, 'Position', ...
    [0.116309523809523 0.59 0.100892855493084 0.263])
% label plot
text(1990, 0.0025, 'A', 'fontsize', 40, 'FontWeight', 'bold')

% inset plot axis
inset_plot_axis = [1990 2030 0.02 2.5];
% plot box in main plot corresponding to axis
plot([inset_plot_axis(1), inset_plot_axis(2)], ...
    [inset_plot_axis(3), inset_plot_axis(3)], '--k', 'linewidth', 1,'HandleVisibility','off')
plot([inset_plot_axis(1), inset_plot_axis(2)], ...
    [inset_plot_axis(4), inset_plot_axis(4)], '--k', 'linewidth', 1,'HandleVisibility','off')
plot([inset_plot_axis(1), inset_plot_axis(1)], ...
    [inset_plot_axis(3), inset_plot_axis(4)], '--k', 'linewidth', 1,'HandleVisibility','off')
plot([inset_plot_axis(2), inset_plot_axis(2)], ...
    [inset_plot_axis(3), inset_plot_axis(4)], '--k', 'linewidth', 1,'HandleVisibility','off')


xlabel('Year')
ylabel('Cumulative storage [Gt]')
box on
set(gca, 'YScale', 'log')
set(gca, 'Color', 'none');
set(gca,'linewidth',1.5)
% explicitly define y labels
yticks(10.^[-4:4])

% Inset plot
axes('Position', [0.233529411764706 0.214 0.0984705882352938 0.389174603174603])
box on
hold on
% plot model fit
for i=1:length(Qinf)
    C(i) = Qinf(i);
    qt = C(i)./(1+exp(w*(peak_year(i)-x)));
    plot(x,qt, 'color', bluecc(i,:))
end

% plot exponential trajectory
plot(x, y, '--', 'color', 0.7.*[1 1 1])
% Plot storage data
plot(years(1:end-6), Q(1:end-6),'-ok','MarkerFaceColor', 'k','MarkerSize',3, 'linewidth', 1.5)
% Short-term projected storage data
plot(years(end-6:end), Q(end-6:end),':k')

% plot slope triangle
yd = exp(years(25:49).*w).*exp(-1.749e+02).*1.5;
plot(years(25:49), yd, '-', 'color', 0.7.*[1 1 1], 'linewidth', 1.5)
plot([years(25), years(25)], [yd(1), yd(end)], '-', 'color', 0.7.*[1 1 1], 'linewidth', 1.5)
plot([years(25), years(49)], [yd(end), yd(end)], '-', 'color', 0.7.*[1 1 1], 'linewidth', 1.5)
text(1997, 1.35, '8.6% growth', 'fontsize', 13)

axis(inset_plot_axis)
set(gca, 'YScale', 'log')
set(gca, 'Color', 'none');
set(gca,'linewidth',1.5)
yticks(10.^[-4:4])
xticks([1995 2005 2015 2025])
ax = gca;
ax.TickLength = [0.02 0.02];


%% Storage rate subplot
subplot(1,3,2)
hold on
% load, plot, and annotate IPCC median pathway
load('matlab_IPCC_data_for_Fig2B')
plot(ipcc2c(:,1), ipcc2c(:,2)./1000, '-.', ...
    'color',  ones(1,3).*0.7,'HandleVisibility','off')
text(2025, 16.5, sprintf(['Median of \nIPCC 2', char(176), ' \npathways']), 'fontsize', 13)

% Calculate and plot storage rate curves
for i=1:length(Qinf)
    yrate = (Qinf(i).*w.*exp(w*(peak_year(i)-x)))./...
        ((1+exp(w*(peak_year(i)-x))).^2);
    plot(x,yrate, 'color', bluecc(i,:))
end

% Calculate inflection points
inflection_time = peak_year-log(2+sqrt(3))/w;
y_inflect = (Qinf.*w.*exp(w*(peak_year-inflection_time)))./...
        ((1+exp(w*(peak_year-inflection_time))).^2);
    
    
for i=1:length(Qtarget)
    cum_2030 = exp(year_rate_change.*w).*exp(-1.749e+02);
    x2 = [year_rate_change:2150];
    
    C = (Qtarget(i)-cum_2030);
    
    yrate = (C.*rtarget(i).*exp(rtarget(i).*(peak_target(i)-x2)))./...
        ((1+exp(rtarget(i).*(peak_target(i)-x2))).^2);
    
    plot(x2,yrate, 'color', redcc(i+1,:))
end

% Calculate inflection years
inflection_time_red = peak_target-log(2+sqrt(3))./rtarget;
C = (Qtarget-cum_2030);
y_inflect_red = (C.*rtarget.*exp(rtarget.*(peak_target-inflection_time_red)))./...
        ((1+exp(rtarget.*(peak_target-inflection_time_red))).^2);

% Label and plot inflection years    
plot(inflection_time, y_inflect, '.k', 'markersize', 12)
plot(inflection_time_red, y_inflect_red, '.k', 'markersize', 12)
plot([inflection_time(1) 2092], [y_inflect(1) 10], '-k', 'linewidth', 1)
plot([inflection_time_red(3) 2075], [y_inflect_red(3) 3], '-k', 'linewidth', 1)
text(2091.1, 8.28, num2str(round(inflection_time(1))), 'fontsize', 13)
text(2104, 33.3, num2str(round(inflection_time(2))), 'fontsize', 13)
text(2091.9, 48.6, num2str(round(inflection_time_red(1))), 'fontsize', 13)
text(2060.7, 31.3, num2str(round(inflection_time_red(2))), 'fontsize', 13)
text(2075.9, 3.28, num2str(round(inflection_time_red(3))), 'fontsize', 13)

% Format and annotate plot
box on
xlabel('Year')
ylabel('Storage Rate [Gt/year]')
set(gca, 'Color', 'none');
set(gca,'linewidth',1.5)
axis([2020 2150 0 80])

text(2128.2, 71.7, 'B', 'fontsize', 40, 'FontWeight', 'bold')

text(2025.36, 75, sprintf('Storage capacity required'), 'fontsize', 14)
legend({[num2str(Qinf(1)), ' Gt'], [num2str(Qinf(2)), ' Gt'], ...
    [num2str(round(Qtarget(1))), ' Gt'], [num2str(round(Qtarget(2))), ' Gt'], ...
    [num2str(round(Qtarget(3))), ' Gt']}, ...
    'Box', 'off',  'fontsize', 13,... 
    'Position',[0.420 0.59 0.07 0.2630])

%% Now plot target tradeoff curves
subplot(1,3,3)
hold on
axis_def = [7 15 100 10000];
line_grey = ones(1,3).*0.9;
for i=300:100:1000
plot([axis_def(1)+0.1, axis_def(2)-0.1], [i i], 'linewidth', 1, 'color', line_grey,'HandleVisibility','off')
end
for i=2000:1000:9000
plot([axis_def(1)+0.1, axis_def(2)-0.1], [i i], 'linewidth', 1, 'color', line_grey,'HandleVisibility','off')
end
for i=axis_def(1)+1:2:axis_def(2)
plot([i, i], [axis_def(3)+5 axis_def(4)-600], 'linewidth', 1, 'color', line_grey,'HandleVisibility','off')
end

load('matlab_348_target_fit_for_Fig2C')
M = movmean(Qmin,15);
plot(Rr.*100, M, '-', 'color', greycc(end,:))
hold on
load('matlab_687_target_fit_for_Fig2C')
M = movmean(Qmin,15);
plot(Rr.*100, M, '-', 'color', greycc(end-1,:))
load('matlab_1218_target_fit_for_Fig2C')
M = movmean(Qmin,15);
plot(Rr.*100, M, '-', 'color', greycc(end-2,:))
load('matlab_1218_target_2050_fit_for_Fig2C')
M = movmean(Qmin,15);
plot(Rr.*100, M, '--', 'color', greycc(end-2,:))

% load contour data
load('matlab_inflection_year_contours_for_Fig2C')
% plot data
for t = 1:length(Tn)
    % crop extreme ends
    if t>2
        ind = find(T_store(:, t)>400, 1, 'first');
    else
        ind = 1;
    end
    if t>4
        ind_L = find(T_store(:, t)>4500, 1, 'first');
    else
        ind_L = length(Rate_range);
    end
    % plot
    plot(Rate_range(ind:ind_L).*100, T_store(ind:ind_L, t), ':', 'color', greycc(6,:), 'linewidth', 1, 'HandleVisibility','off')
end


% plot points
for i=1:length(Qinf)
    plot(w.*100,Qinf(i), '.','markersize', 30, 'color', bluecc(i,:),'HandleVisibility','off')
end
    
for i=1:length(Qtarget)
    cum_2030 = exp(year_rate_change.*w).*exp(-1.749e+02);
    C = (Qtarget(i)-cum_2030);
    plot(rtarget(i).*100,C, '.','markersize', 30, 'color', redcc(i+1,:),'HandleVisibility','off')
end

% Format and annotate plot
t11 = text(8.7, 1240, sprintf('60 yr'), 'fontsize', 14);
set(t11,'Rotation',45);
t22 = text(9.7, 734, sprintf('50 yr'), 'fontsize', 14);
set(t22,'Rotation',42);
t33 = text(11.2, 545.9, sprintf('40 yr'), 'fontsize', 14);
set(t33,'Rotation',38);
t44 = text(13.9, 451, sprintf('30 yr'), 'fontsize', 14);
set(t44,'Rotation',28);

text(10.8, 6678, sprintf('Growth rate change \ndelayed to 2050'), 'fontsize', 14)
set(gca, 'YScale', 'log')
axis(axis_def)
box on
xlabel('Growth Rate [%]')
ylabel('Storage capacity required [Gt]')
set(gca, 'Color', 'none');
set(gca,'linewidth',1.5)

% arrow require arrow package
% arrow([10.05 6000], [10.6 6480], 'Width', 2, 'Length', 10);

text(7.3, 345.9, sprintf('2100 storage targets'), 'fontsize', 14)
text(13.7, 181.5, 'C', 'fontsize', 40, 'FontWeight', 'bold')

legend({['348 Gt'], ['687 Gt'], ['1218 Gt']}, ...
    'Box', 'off',  'fontsize', 13,'location', 'southwest')

