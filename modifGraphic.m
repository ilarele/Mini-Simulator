%Elena Burceanu 2008
function c = modifGraphic(step,n1,n3,n4)
    if step > n3 && step > n4 
        c = step - 2;
        return;
    end
    
    
    if step < n3 && step < n4 
        c = step;
        return;
    end
    
    if (step > n3 && step < n4) || (step < n3 && step > n4)
        c = step - 1;
        return;
    end
    
    if step == n3
        c = n1;
        return;
    end

    if step == n4
            c = n1 - 1;
            return;
    end
endfunction