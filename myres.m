%Elena Burceanu 2008
function res = myres (y,dy, t)
	%auxiliary function of dassl
	%1    2   3   4   5   6   7
	%V1  V2  TD  Tr  Tf  Pw  Period 

    [fid err] = fopen('tra.txt','rt');
	if err
        disp('Can not read from file!');
        return;
    end
    n = fscanf(fid, '%i', 1);
    N = zeros(1,7);
    N = fscanf(fid, '%f', 7);
    Mprim = zeros(n);
    M2 = zeros(n);
    M3 = zeros(n,1);
    for i = 1:n
         Mprim(i,:) = fscanf(fid, '%f', n);
    end
   
    for i = 1:n
        M2(i,:) = fscanf(fid, '%f', n);
    end
    
  
    M3 = fscanf(fid, '%f ', n);
    M3prim = fscanf(fid, '%f ', n);

    fclose(fid);
	

	% result = %M2*V + M3*U(t) + M3prim*V'(t) + Mprim*V' = 0
    res = M2*y + M3*udet(t,N) + M3prim*slope(t,N) + Mprim*dy;
endfunction        