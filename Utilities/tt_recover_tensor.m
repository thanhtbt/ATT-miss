function [X] = tt_recover_tensor(tt_core)
% Author     : LE Trung-Thanh
% Affiliation: University of Orleans, France
% Contact    : trung-thanh.le@univ-orleans.fr // letrungthanhtbt@gmail.com
% Date       : 4/2/2019


N = length(tt_core);
X = tt_core{1,1};
for ii = 2:N-1
    X = tt_product_tensors(X,tt_core{ii,1});
end
X = ttm(tensor(X),tt_core{N,1},N);
end