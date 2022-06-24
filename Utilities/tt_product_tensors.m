function H =  tt_product_tensors(X,Y)
% Product two 3-way tensors H = X x Y
% Author     : LE Trung-Thanh
% Affiliation: University of Orleans, France
% Contact    : trung-thanh.le@univ-orleans.fr // letrungthanhtbt@gmail.com
% Date       : 3/2/2019


tt_dim_x = size(X);
tt_dim_y = size(Y);
H = [];
if tt_dim_x(end) ~= tt_dim_y(1)
    warning('Two tensors are not consistent in size!')
else
if length(tt_dim_x) == 2 %% X is matrix, Y is 3-order tensor
    for jj = 1 : tt_dim_y(end)
        U = Y(:,:,jj);
        H(:,:,jj) = X * U;
    end
elseif  length(tt_dim_y) == 2 %% X 3-order tensor, Y is a matrix
    H = ttm(tensor(X),Y,3); 
    H = H.data;
else %% X, Y are 3-order tensors
    H = zeros([ tt_dim_x(1:end-1) tt_dim_y(2:end)]);
    for i1 = 1 : tt_dim_x(1)
        for i2 = 1 : tt_dim_x(2)
            for i3 = 1 : tt_dim_y(2)
                for i4 = 1 : tt_dim_y(3)
                    for r = 1 : tt_dim_x(end)
                        H(i1,i2,i3,i4) = H(i1,i2,i3,i4) + X(i1,i2,r)*Y(r,i3,i4);
                    end
                end
            end
        end
    end
    
end
end



end