function [X,tt_core] = tt_generate_tensor(tt_dim,tt_rank,epsilon,window)
%% Generate streaming 4-order tensors
% Author     : LE Trung-Thanh
% Affiliation: University of Orleans, France
% Contact    : trung-thanh.le@univ-orleans.fr // letrungthanhtbt@gmail.com

%%
if nargin < 3 %% Static Tensor
    epsilon = zeros(tt_dim(end),1);
else
end
if nargin < 4
    window = 1;
else
end

d = length(tt_dim);

%% Create Core Tensors (t = 0)
tt_core = cell(d,1);
tt_core{1,1} = randn(tt_dim(1),tt_rank(1));
tt_core{d,1} = randn(tt_dim(d),tt_rank(d-1));
for ii = 2 : d-1
    tt_core{ii,1} =  randn(tt_rank(ii-1),tt_dim(ii),tt_rank(ii));
end
%% Create Tensor Slices
T  = tt_dim(d);
X  = zeros(tt_dim);
G1 = tt_core{1,1};
G2 = tt_core{2,1};
G3 = tt_core{3,1};
G4 = tt_core{4,1};

for t = 1 : T
    
    X12   = tt_product_tensors(G1,G2);
    X123  = tt_product_tensors(X12,G3);
    g4    = G4(t,:);
    Xii   = ttm(tensor(X123),g4,d);
    Xii   = Xii(:,:,:,1);
    X(:,:,:,t) = Xii.data;
    
    if epsilon(t) == 1 %% Create a significant change
        G1    = randn(size(G1));
        G2    = randn(size(G2));
        G3    = randn(size(G3));
    else
        G1    = G1  + epsilon(t)*randn(size(G1));
        G2    = G2  + epsilon(t)*randn(size(G2));
        G3    = G3  + epsilon(t)*randn(size(G3));
        
    end
    
end

X = tensor(X);

end
