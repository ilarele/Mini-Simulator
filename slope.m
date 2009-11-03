%Elena Burceanu 2008
function m = slope(t,N)
	%1    2   3   4   5   6   7
	%V1  V2  TD  Tr  Tf  Pw  Period 
    
    if t < N(3)
        m = 0;
    else 
        t = mod(t - N(3),N(7));
        if t <= N(4)
            m = (N(2)-N(1))/(N(4));
        else
            if t <= N(6) + N(4)
                m = 0;
            else
                if t <= N(5) + N(6) + N(4)
                    m = -(N(2)-N(1))/(N(5));
                else
                    m = 0;
                end
            end
        end
    end
endfunction