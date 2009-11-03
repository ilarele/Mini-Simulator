%Elena Burceanu 2008
function M = elimLine(M,l)
	%eliminates line l from M
    [n m] = size(M);
    temp = zeros(n-1,m);
    temp(1:l-1,:) = M(1:l-1,:);
    temp(l:n-1,:) = M(l+1:n,:);
    M = temp;
endfunction



