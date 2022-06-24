function [PER,tt_core_es,Xre] = ATT(X_miss,Omega,tt_rank,OPTS_PER)

% Tensor Tracking with Missing Data Under Tensor-Train Format
% Author     : LE Trung-Thanh
% Affiliation: University of Orleans, France
% Contact    : trung-thanh.le@univ-orleans.fr // letrungthanhtbt@gmail.com
% Date       : 09/01/2022

%%
tt_dim = size(X_miss);
N = length(tt_dim);
T = tt_dim(N);

Xre = zeros(tt_dim);
PER = zeros(1,T);

if isfield(OPTS_PER,'window'), % Forgetting factor
     window = OPTS_PER.window;
else window = 1;
end

if isfield(OPTS_PER,'forget_factor'), % Forgetting factor
     beta = OPTS_PER.forget_factor;
else beta = 0.5;
end

if isfield(OPTS_PER,'rho'), % Forgetting factor
     rho = OPTS_PER.rho;
else rho = 1;
end

Xtrue = OPTS_PER.Xtrue;

%% Initialization
G{1} = randn(tt_dim(1),tt_rank(1)); 
G{2} = randn(tt_rank(1),tt_dim(2),tt_rank(2)); 
G{3} = randn(tt_rank(2),tt_dim(3),tt_rank(3)); 
G{4}   = [];

Delta_G{1} = zeros(tt_dim(1),tt_rank(1));
Delta_G{2} = zeros(tt_dim(2),tt_rank(1)*tt_rank(2)); 
Delta_G{3} = zeros(tt_dim(3),tt_rank(2)*tt_rank(3)); 


tt_core_es = cell(N,1);

S_re{1} = 1*eye(tt_rank(1));
S_re{2} = 1*eye(tt_rank(1)*tt_rank(2));
S_re{3} = 1*eye(tt_rank(2)*tt_rank(3));

ii = 1;
while ii <= T
 
    %% Data Collection
    if  ii + window - 1 > T
         t   = ii : T;
         window = T - ii + 1;
    else
         t  = ii : ii + window - 1;
    end
   
    X_t     = X_miss(:,:,:,t); 
    Omega_t = Omega(:,:,:,t);
    
    %% The last G4
    G4_buffer = tt_product_tensors(tt_product_tensors(G{1},G{2}),G{3});
    H_t       = ten2mat(tensor(G4_buffer),4)';
    G4 = [];
    Delta_X_t = tensor(zeros([tt_dim(1:end-1) window]));
    
    for ll = 1 : window
        if window == 1
            X_t_ll = X_t;
        else
            X_t_ll = X_t(:,:,:,ll);
        end
        x_t_ll     = X_t_ll.data(:);
        Omega_t_ll = Omega_t(:,:,:,ll);
        omega_t_ll = Omega_t_ll(:);
        idx_t      = find(omega_t_ll);
        H_Omega    = H_t(idx_t,:);
        g4         = H_Omega \ x_t_ll(idx_t);                   
        G4         = [G4 g4];
        X_t_ll_re  = H_t * g4;
        X_t_ll_re  = tensor(reshape(X_t_ll_re,[tt_dim(1:end-1)]));
        Delta_X_t_ll = Omega_t_ll .* (X_t_ll - X_t_ll_re);
        Delta_X_t(:,:,:,ll) = Delta_X_t_ll;
    end
 
    G{4} = [G{4}, G4];
    
    %% G1
    ER_Unfolding_1 = ten2mat(Delta_X_t,1);
   
    G_buffer{1}    = ttm(tensor(tt_product_tensors(G{2},G{3})),G4',4);
    W{1}           = ten2mat(G_buffer{1},1);
    S_re{1}        =  beta*S_re{1} +  W{1}*W{1}';
    Delta_G{1}     = (ER_Unfolding_1 * W{1}' + beta*rho*Delta_G{1}) ...
                      * ( inv(S_re{1} + rho* eye(tt_rank(1))) )';
    G{1}           = G{1} + Delta_G{1}; 
  
    %% G2
    ER_Unfolding_2 = ten2mat(Delta_X_t,2);
    G_buffer{2}    = ttm(tensor(G{3}),G4',3); 
    G_buffer{2}    = ten2mat(G_buffer{2},1);
    W{2}           = kron(G_buffer{2}, G{1}');
    S_re{2}        = beta*S_re{2} + W{2}*W{2}';
    Delta_G{2}     = (ER_Unfolding_2 * W{2}' +  beta*rho*Delta_G{2}) ...
                      * ( inv(S_re{2} + rho*eye(tt_rank(1)*tt_rank(2))) )';
    G2_Unfolding_2 = ten2mat(tensor(G{2}),2) + Delta_G{2};
    G{2}           = mat2ten(G2_Unfolding_2,[tt_rank(1), tt_dim(2), tt_rank(2)],[2]);
    
    %% G3
    ER_Unfolding_3   = ten2mat(Delta_X_t,3);
    G_buffer{3}      = ten2mat(tensor(tt_product_tensors(G{1},G{2})),3);
    W{3}             = kron(G4,G_buffer{3});
    S_re{3}          = beta*S_re{3} + W{3} * W{3}';
    G3_Unfolding_2   = ten2mat(tensor(G{3}),2);
    Delta_G{3}       = (ER_Unfolding_3 * W{3}' +  beta*rho*Delta_G{3}) ...
                       * ( inv(S_re{3} + rho*eye(tt_rank(2)*tt_rank(3))) )';
    G3_Unfolding_2   = G3_Unfolding_2 + Delta_G{3};
    G{3}             = mat2ten(G3_Unfolding_2,[tt_rank(2), tt_dim(3), tt_rank(3)],[2]);
    
    
    %% Save
    tt_core_es{1} = G{1};
    tt_core_es{2} = G{2};
    tt_core_es{3} = G{3};
    tt_core_es{4} = G4';
    
    %% Performance estimation
    
    X_t_true    = Xtrue(:,:,:,ii);
    X_t_re      = tt_recover_tensor(tt_core_es);
    X_t_re      = X_t_re(:,:,:,1);
    PER(1,t)    = norm(X_t_true - X_t_re) / norm(X_t_true);
    
    ii = ii + window;
end
end