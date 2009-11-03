function EC_simulate(filename)
    %Elena Burceanu 2008
	%read date from file
    N = zeros(1,11);
    nod = zeros(1,3);
    
    [fid err] = fopen(filename,'rt');
    if err
        disp('Can not read from file!');
        return;
    end
    
    [temp contor] = fscanf(fid, '%c', 1);
    [N(1:2) contor] = fscanf(fid, '%i', 2);

    R = zeros(N(1),N(1));
    C = zeros(N(1),N(1));
    areCondens = 0;
    
    [temp contor] = fscanf(fid, '%c', 2);
    [N(3:4) contor] = fscanf(fid, '%f', 2);

	%counting nodes from 1
    N(3:4) = N(3:4) + 1;
    
    %N1 --> - borne ;  N2 --> + borne
    contor = N(3);
    N(3)=N(4);
    N(4) = contor;
    
    
    [temp contor] = fscanf(fid, '%c', 7);
    [N(5:11) contor] = fscanf(fid, '%f', 7);
    [temp contor] = fscanf(fid, '%c', 2);
    

    %N records: 1  2   3   4   5   6   7   8   9   10    11 
    %           N  M   N1  N2  V1  V2  TD  Tr  Tf  Pw  Period 
    
    %not testing zero equality when computing the rises and falls of the graphic
    if ~N(8)
        N(8) = 0.0001;
    end
    if ~N(9)
        N(9) = 0.0001;
    end
    
	
    %matrix R - resistances   matrix C - condensators
    mm = N(2)-1;
    
    while mm ~= 0
        [temp contor] = fscanf(fid, '%c', 1);
        [nod contor] = fscanf(fid, '%i', 2);
        [nod(3) contor] = fscanf(fid, '%f', 1);
        nod(1:2) = nod(1:2) +1;
        if (temp=='R')
            
            R(nod(1),nod(2)) = nod(3);
            R(nod(2),nod(1)) = nod(3);
        
        else 
             C(nod(1),nod(2)) = nod(3);
             C(nod(2),nod(1)) = nod(3);
             areCondens = 1;
        
        end

        [temp contor] = fscanf(fid, '%c', 1);
        mm--;
    end

    [temp contor] = fscanf(fid, '%c', 6);
    [step(1:2) contor] = fscanf(fid, '%f', 2);
    [temp contor] = fscanf(fid, '%c', 14);
    [step(3) contor] = fscanf(fid, '%f', 1);
    [temp contor] = fscanf(fid, '%c', 1);
    [step(4) contor] = fscanf(fid, '%f', 1);
	%step records:   1     2    3 4
    %               TSTEP TSTOP i j
    
    fclose(fid);

    %initial graphic for TSTEP and TSTOP
    subplot(2,1,1);        
    graphic(N(5:11),step(1),step(2));
    axis([0 step(2) N(5)-1 N(6)+1]);  
    
    
  %differential system (or only linear if there are no condensators)  
    Mprim = zeros(N(1),N(1));
    M2 = zeros(N(1),N(1));
    for i = 1:N(1)
        if i ~= N(3) && i ~=N(4)
             for j = 1:N(1)
                    if R(i,j) && i ~= j
                        M2(i,j) = -1/R(i,j);
                        M2(i,i) += 1/R(i,j);
                    else if C(i,j) && i ~=j
                           
                           Mprim(i,j) = -C(i,j);
                           Mprim(i,i) += C(i,j);  
                         end
                    end      
             end
        end
    end


    %eliminating columns for the node with 0 potential
    M2 = elimLine(M2,N(3));
    M2 = elimColumn(M2,N(3));

    Mprim = elimLine(Mprim,N(3));
    Mprim = elimColumn(Mprim,N(3));

    %which is the line and column for N(4), after elimination
    if(N(4)>N(3))
        c1 = N(4)-1;
    else
        c1 = N(4);
    end 
    


    %Mprim*V'+ M2*V + M3*U(t) + M3prim*slope(t) = 0 
    M2 = elimLine(M2,c1); 
    Mprim = elimLine(Mprim,c1);
    M3 = M2(:,c1);
    M3prim = Mprim(:,c1);
    M2 = elimColumn(M2,c1);
    Mprim = elimColumn(Mprim,c1);
   
	
	%which are the "new" (after elimination) i,j -> we need graphic representation for (Vi - Vj)
    c1 = modifGraphic(step(3)+1,N(1),N(3),N(4));
    c2 = modifGraphic(step(4)+1,N(1),N(3),N(4));
    k = 1;
    for t = 0:step(1):step(2)
        V(k++,N(1)-1) = udet(t,N(5:11));
    end
    V(:,N(1)) = 0;
    
     

    % M2*V + M3*U(t) = 0     
    if ~areCondens
        k = 1;
        for t = 0:step(1):step(2)
           V(k++,1:N(1)-2) = -M2\(M3*udet(t,N(5:11)));
        end
        t = 0:step(1):step(2);
       
        minim = min(V(:,c1)-V(:,c2)) - 1;
        maxim = max(V(:,c1)-V(:,c2)) + 1;
        
        subplot(2,1,2);
        plot(t,V(:,c1) - V(:,c2)); 
        axis([0 step(2) minim maxim]);
   else

   
		%writing on disk some characteristics (read them in the auxiliary function for dassl -> myres)
		fid = fopen('tra.txt','wt');
    
        fprintf(fid, '%i ', N(1)-2);
        fprintf(fid, '%f ', N(5:11));
    
        for i = 1:N(1)-2
            for j = 1:N(1)-2
                  fprintf(fid, '%f ', Mprim(i,j));
            end
            fprintf(fid, '\n');
        end
    
        
        for i = 1:N(1)-2
            for j = 1:N(1)-2
                  fprintf(fid, '%f ', M2(i,j));
            end
            fprintf(fid, '\n');
        end
    
        for i = 1:N(1)-2
            fprintf(fid, '%f ', M3(i));
        end
        
        for i = 1:N(1)-2
            fprintf(fid, '%f ', M3prim(i));
        end
    
        fclose(fid);
 


    

		%Mprim*V'+ M2*V + M3*U(t) + M3prim*slope(t) = 0
		%initial condition V_0 and solve differential system
		
		V_0 = -M2\(M3*udet(0,N(5:11)));
        dV_0 = zeros(1,N(1)-2);

        [V(:,1:N(1)-2) dV] = dassl(@myres,V_0,dV_0,0:step(1):step(2));
       
        subplot(2,1,2);
        plot(0:step(1):step(2),V(:,c1) - V(:,c2));
        
        minim = min(V(:,c1) - V(:,c2)) - 1;
        maxim = max(V(:,c1) - V(:,c2)) + 1;
        axis([0 step(2) minim maxim]);
        
    end
endfunction




    



   











