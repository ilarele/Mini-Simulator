%Elena Burceanu 2008
function graphic(N,step,stop)
   t = 0:step:stop;
   for i = 1:length(t)
      u(i) = udet(t(i),N);
   end
   plot(t,u) ;
   axis([0 stop -N(2)-1 N(2)+1]);
endfunction
    