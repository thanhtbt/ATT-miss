function mat = ten2mat(ten, n)

    N = ndims(ten);
    order    = 1:N;
    order(n) = [];
    order    = [n, order];
    perm_ten = permute(ten, order);
    ten_size = size(perm_ten);
    rows     = ten_size(1);
    cols     = prod(ten_size(2:end));
    mat      = reshape(perm_ten, [rows, cols]);
    mat      = mat.data; 
    
    
end