%% DEMO: Adaptive TT for streaming 4-order tensors
clear;clc; close all

run_path;

n_exp        = 5;
tt_dim       = [10 15 20 1000];
tt_rank      = [5 5 5];
sampling     = 0.9;
fac_noise    = [1e-4, 1e-3, 1e-2, 1e-1];
time_varying = 0;
epsilon      = time_varying*ones(1,tt_dim(end));
epsilon(600) = 1; %Aim to create a significant change

PER_ATT  = zeros(length(fac_noise),tt_dim(end));

for ll = 1 : length(fac_noise)
    
    fac_noise_ll = fac_noise(ll);
    fprintf('Noise level = %f \n',fac_noise_ll);
    
    for ii = 1 : n_exp
        fprintf(' run %d/%d \n',ii,n_exp);
        %% Generate Data
  
        [Xtrue,tt_core] = tt_generate_tensor(tt_dim,tt_rank,epsilon);
        
        OPTS_PER.Xtrue         = Xtrue;
        OPTS_PER.forget_factor = 0.5;
        PER1                   = zeros(1,tt_dim(end));
        X_full  = Xtrue + fac_noise_ll*randn(tt_dim);
        Omega   = rand(tt_dim);
        Omega   = 1.*(Omega <= sampling);
        X_miss  = Omega .* X_full;
        
        % Algorithm
        
        [per,~,~] = ATT(X_miss,Omega,tt_rank,OPTS_PER);
        
        PER1 = PER1 + per;
    end
    PER_ATT(ll,:) = PER1 / n_exp;
end

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


d1 = semilogy(1:k:T,PER_ATT(1,1:k:end),...
    'linestyle','-','color',red_o,'LineWidth',LineWidth);
d11 = plot(1:100:T,PER_ATT(1,1:100:end),...
    'marker','p','markersize',makerSize,...
    'linestyle','none','color',red_o,'LineWidth',LineWidth);
d12 = semilogy(1:1,PER_ATT(1,1:1),...
    'marker','p','markersize',makerSize,...
    'linestyle','-','color',red_o,'LineWidth',LineWidth);


d2 = semilogy(1:k:T,PER_ATT(2,1:k:end),...
    'linestyle','-','color',blue_o,'LineWidth',LineWidth);
hold on;
d21 = plot(1:100:T,PER_ATT(2,1:100:end),...
    'marker','^','markersize',makerSize,...
    'linestyle','none','color',blue_o,'LineWidth',LineWidth);
d22 = semilogy(1:1,PER_ATT(2,1:1),...
    'marker','^','markersize',makerSize,...
    'linestyle','-','color',blue_o,'LineWidth',LineWidth);

d3 = semilogy(1:k:T,PER_ATT(3,1:k:end),...
    'linestyle','-','color','g','LineWidth',LineWidth);
hold on;
d31 = plot(1:100:T,PER_ATT(3,1:100:end),...
    'marker','h','markersize',makerSize,...
    'linestyle','none','color','g','LineWidth',LineWidth);
d32 = semilogy(1:1,PER_ATT(3,1:1),...
    'marker','h','markersize',makerSize,...
    'linestyle','-','color','g','LineWidth',LineWidth);

d4 = semilogy(1:k:T,PER_ATT(4,1:k:end),...
    'linestyle','-','color','k','LineWidth',LineWidth);
hold on;
d41 = plot(1:100:T,PER_ATT(4,1:100:end),...
    'marker','p','markersize',makerSize,...
    'linestyle','none','color','k','LineWidth',LineWidth);
d42 = semilogy(1:1,PER_ATT(4,1:1),...
    'marker','p','markersize',makerSize,...
    'linestyle','-','color','k','LineWidth',LineWidth);


lgd = legend([d12,d22,d32,d42],'$\sigma_n = 10^{-4}$','$\sigma_n = 10^{-3}$','$ \sigma_n = 10^{-2}$','$\sigma_n = 10^{-1}$');
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


