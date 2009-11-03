%Elena Burceanu 2008
function M = elimColumn(M,c)
	%eliminates column c from M
    [n m] = size(M);
    temp = zeros(n,m-1);
    temp(:,1:c-1) = M(:,1:c-1);
    temp(:,c:m-1) = M(:,c+1:m);
    M = temp;
endfunction



