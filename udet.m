%Elena Burceanu 2008
function u = udet(t,N)
    %variation of U(t)
    
    N(2) = N(2) - N(1);
    if N(7) == 0
        u = 0;
        return;
    end
    
    
    if t <= N(3)
      u = 0;
    else
      t = mod(t-N(3),N(7));
      if t <= N(4)
          u = N(2)*t/N(4);
      else if t <= N(4) + N(6)
              u = N(2);
           else if t <= N(4) + N(6) + N(5)
                    u = N(2)+N(2)*(N(6)+N(4)-t)/N(5);
                else
                    u = 0;
                end
            end
        end
    end
    
    u = u + N(1);
endfunction    