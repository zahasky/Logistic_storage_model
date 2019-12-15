% FigS1_generation.m
% Christopher Zahasky
% 10/18/2019

clear all
close all

% set a few new plot defaults
set(0,'DefaultAxesFontSize',14, 'defaultlinelinewidth', 2,...
    'DefaultAxesTitleFontWeight', 'normal')

rcc = gray(6); %flipud(cbrewer('seq', 'Reds', 6 , 'linear'));

%% Load/define data
load('matlab_IPCC_data_for_FigS1')

%% Plot storage rate data
figure ('position', [-1287   165   860  778])
subplot(2,1,1)
position1 = 1:1:length(years)-1;
position2 = [1:1:length(years)-1]+0.2;

% plot boxplots of data
boxplot(IPCC1_5(:,2:end)./1000, years(2:end), 'PlotStyle','compact', 'colors', rcc(4,:), ...
    'positions',position1, 'whisker',1000)
hold on
h = boxplot(IPCC2(:,2:end)./1000, years(2:end), 'PlotStyle','compact', 'colors', rcc(2,:), ...
    'positions',position2, 'LabelOrientation', 'horizontal', 'whisker',1000);


ylabel('CO_2 storage rate [GT/yr]')
box on
set(gca, 'Color', 'none');
set(gca,'linewidth',1.5)
set(findobj(get(h(1), 'parent'), 'type', 'text'), 'fontsize', 13);
txt = findobj(gca,'Type','text');
set(txt(3:end),'VerticalAlignment', 'Middle');

plot([0 1], [-1 -10], 'color', rcc(4,:))
plot([0 1], [-1 -10], 'color', rcc(2,:))
legend({['1.5', char(176), ' pathways [78]'], ['2', char(176), ' pathways [114]']}, ...
    'Box', 'off',  'fontsize', 13, 'location', 'northwest')


%% Calculate cumulative storage rate
xi = (years(1):1:years(end))'; 
x = years'; 

% 1.5 degree scenarios
[r c] = size(IPCC1_5);
IPCC1_5_cum = zeros(r, length(xi));
for i = 1:r
    y = IPCC1_5(i,:)'./1000;
    yi = interp1q(x,y,xi);
    IPCC1_5_cum(i, :) = cumsum(yi)';
end

% 2 degree scenarios
[r c] = size(IPCC2);
IPCC2_cum = zeros(r, length(xi));
for i = 1:r
    y = IPCC2(i,:)'./1000;
    yi = interp1q(x,y,xi);
    IPCC2_cum(i, :) = cumsum(yi)';
end

%% Plot cumulative storage 
subplot(2,1,2)
boxplot(IPCC1_5_cum(:,[11:10:end]), years(2:end), 'PlotStyle','compact', ...
    'colors', rcc(4,:), 'positions', position1, 'whisker',1000, 'symbol','')
hold on
h = boxplot(IPCC2_cum(:,[11:10:end]), years(2:end), 'PlotStyle','compact', ...
    'colors', rcc(2,:), 'positions',position2, 'LabelOrientation', 'horizontal', 'whisker',1000, 'symbol','');

% format plot
ylabel('Cumulative storage [GT]')
box on
set(gca, 'Color', 'none');
set(gca,'linewidth',1.5)
set(findobj(get(h(1), 'parent'), 'type', 'text'), 'fontsize', 13);
txt = findobj(gca,'Type','text');
set(txt(3:end),'VerticalAlignment', 'Middle');
