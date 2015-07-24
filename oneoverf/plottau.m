load('oneoverftest_004.mat');

X1 = alpha;

YMatrix1 = calc_mean(:,2:9);

fontname = 'Arial';

% Create figure
figure1 = figure;
set(figure1, 'Position' ,[427 40 793 650]);
set(figure1, 'Color',[1 1 1]);


% Create axes
axes1 = axes('Parent',figure1,'FontWeight','demi','FontSize',14,...
   'FontName',fontname);
%% Uncomment the following line to preserve the X-limits of the axes
xlim(axes1,[0.0 4.0]);
%% Uncomment the following line to preserve the Y-limits of the axes
ylim(axes1,[0. 1.0]);
box(axes1,'on');
hold(axes1,'all');

% Create multiple lines using matrix input to plot
plot1 = plot(X1,YMatrix1,'Parent',axes1,'LineWidth',2);
set(plot1(1),'DisplayName','8');
set(plot1(2),'LineWidth',3,'LineStyle','--','Color',[0 0 1],...
   'DisplayName','16');
set(plot1(3),'Color',[0 1 0],'DisplayName','32');
set(plot1(4),'LineStyle','--','Color',[0 1 0],'DisplayName','64');
set(plot1(5),'Color',[1 1 0],'DisplayName','128');
set(plot1(6),'LineStyle','--','Color',[1 1 0],'DisplayName','256');
set(plot1(7),'Color',[1 0 0],'DisplayName','512');
set(plot1(8),'LineStyle','--','Color',[1 0 0],'DisplayName','1024');

%zeroline = plot([0,4],[0,0], 'color', 'black', 'LineWidth', 1);
%set(get(get(zeroline,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

% Create xlabel
xlabel('\alpha','FontWeight','bold','FontSize',14,'FontName',fontname);

% Create ylabel
ylabel({'\tau/T',''},'FontWeight','bold',...
   'FontSize',14,...
   'FontName',fontname);

% Create title
title('Relative Correlation Time vs. \alpha & Oversampling','FontWeight','bold','FontSize',14,...
   'FontName',fontname);

% Create legend
legend1 = legend(axes1,'show');
set(legend1,'EdgeColor',[1 1 1],'Orientation','vertical','YColor',[1 1 1],...
   'XColor',[1 1 1],...
   'Position',[0.75 0.15 0.1 0.3]);

% Create textbox
annotation(figure1,'textbox',...
   [0.7 0.45 0.25 0.038],...
   'String',{'Oversampling'},...
   'FontWeight','demi',...
   'FontSize',14,...
   'FontName','Arial',...
   'FitBoxToText','off',...
   'LineStyle','none');

% %hold off;
% plot(alpha, (emp_mean(:,2)-calc_mean(:,2))./calc_mean(:,2), 'color','blue');
% %hold on;
% plot(alpha, (emp_mean(:,3)-calc_mean(:,3))./calc_mean(:,3), '--', 'color','blue');
% plot(alpha, (emp_mean(:,4)-calc_mean(:,4))./calc_mean(:,4), 'color','green');
% plot(alpha, (emp_mean(:,5)-calc_mean(:,5))./calc_mean(:,5), '--', 'color','green');
% plot(alpha, (emp_mean(:,6)-calc_mean(:,6))./calc_mean(:,6), '--', 'color','yellow');
% plot(alpha, (emp_mean(:,7)-calc_mean(:,7))./calc_mean(:,7), '--', 'color','yellow');
% plot(alpha, (emp_mean(:,8)-calc_mean(:,8))./calc_mean(:,8), '--', 'color','red');
% plot(alpha, (emp_mean(:,9)-calc_mean(:,9))./calc_mean(:,9), '--', 'color','red');

% % Create xlabel
% xlabel('\alpha');
% 
% % Create ylabel
% ylabel({'(\sigma_\mu - <|a_0|^2>)/<|a_0|^2>',''});
% 

