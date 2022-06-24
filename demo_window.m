%% DEMO: Adaptive TT of Streaming 4-order Tensors with Missing Data
clear;clc; 

run_path;

n_exp        = 2;
tt_dim       = [10 15 20 1000];
tt_rank      = [5 6 7];
sampling     = 0.5;
fac_noise    = 1e-3;
time_varying = 1e-3;
window       = 3;              % number of data samples collected at time t
epsilon      = time_varying*ones(1,tt_dim(end));
epsilon(600) = 1;              % Aim to create a significant change


PER0  = zeros(1,tt_dim(end));
PER1  = zeros(1,tt_dim(end));

for ii = 1:n_exp
    fprintf(' run %d/%d \n',ii,n_exp);
    
    %% Generate Data
    [Xtrue,tt_core] = tt_generate_tensor(tt_dim,tt_rank,epsilon,window);
    X_full  = Xtrue + fac_noise*randn(tt_dim);
    Omega   = rand(tt_dim); Omega = 1.*(Omega <= sampling);
    X_miss  = Omega .* X_full;

    %% Parameters    
    OPTS_PER.Xtrue = Xtrue;    
    OPTS_PER.forget_factor = 0.5;
    OPTS_PER.window = 3;    

    %% Algorithms
    t_start = tic;
    [PER,~,~] = ATT(X_miss,Omega,tt_rank,OPTS_PER);
    t1 = toc(t_start);
    PER0 = PER0 + PER;   
    fprintf('  + ATT (W = %0.1f): %f(s) \n',OPTS_PER.window,t1);
    
    
    OPTS_PER.window = 1;    
    t_start = tic;
    [PER,~,~] = ATT(X_miss,Omega,tt_rank,OPTS_PER);
    t1= toc(t_start);
    PER1 = PER1 + PER;
    fprintf('  + ATT (W = 1)  : %f(s) \n',t1);
end


%% Error Bound


PER0 = PER0/n_exp;
PER1 = PER1/n_exp;
 
%% Plot

makerSize = 11;
numbMarkers = 500;
LineWidth = 2;

color   = get(groot,'DefaultAxesColorOrder');
red_o   = [1,0,0];
blue_o  = [0, 0, 1];
mag_o   = [1 0 1];
gree_o  = [0, 0.5, 0];
black_o = [0.25, 0.25, 0.25];

blue_n  = color(1,:);
oran_n  = color(2,:);
yell_n  = color(3,:);
viol_n  = color(4,:);
gree_n  = color(5,:);
lblu_n  = color(6,:);
brow_n  = color(7,:);
lbrow_n = [0.5350    0.580    0.2840];

% %% SEP
T = tt_dim(end);
fig = figure;
hold on;
k = 2;


d1 = semilogy(1:k:T,PER0(1:k:end),...
    'linestyle','-','color',red_o,'LineWidth',LineWidth);
d11 = plot(1:100:T,PER0(1:100:end),...
    'marker','p','markersize',makerSize,...
    'linestyle','none','color',red_o,'LineWidth',LineWidth);
d12 = semilogy(1:1,PER0(1:1),...
    'marker','p','markersize',makerSize,...
    'linestyle','-','color',red_o,'LineWidth',LineWidth);


d2 = semilogy(1:k:T,PER1(1:k:end),...
    'linestyle','-','color',blue_o,'LineWidth',LineWidth);
hold on;
d21 = plot(1:100:T,PER1(1:100:end),...
    'marker','^','markersize',makerSize,...
    'linestyle','none','color',blue_o,'LineWidth',LineWidth);
d22 = semilogy(1:1,PER1(1:1),...
    'marker','^','markersize',makerSize,...
    'linestyle','-','color',blue_o,'LineWidth',LineWidth);

lgd = legend([d12,d22],'\texttt{ATT-W}','\texttt{ATT}');
lgd.FontSize = 18;
set(lgd, 'Interpreter', 'latex', 'Color', [0.95, 0.95, 0.95]);

xlabel('Time Index','interpreter','latex','FontSize',13,'FontName','Times New Roman');
ylabel('RE$(\mathcal{X}_{tr},\mathcal{X}_{es})$','interpreter','latex','FontSize',13,'FontName','Times New Roman');

set(fig, 'units', 'inches', 'position', [0.5 0.5 7.5 6.5]);
h=gca;
set(h,'FontSize',16,'XGrid','on','YGrid','on','GridLineStyle',':','MinorGridLineStyle',':','FontName','Times New Roman');
set(h,'FontSize', 22);
% axis([0 T 1*1e-4 1e1]);
grid on;
set(h, 'YScale', 'log','box','on')


