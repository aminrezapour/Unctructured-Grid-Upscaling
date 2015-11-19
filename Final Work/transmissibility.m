function [A,V] = transmissibility(loc_mat,l,grid_size,C,nodeN)

    loc_mat_for_area = loc_mat_for_volume(loc_mat,grid_size,l);

    nodeN_modified = length(loc_mat_for_area);

    % 
    TRI = delaunay(loc_mat_for_area(:,1),loc_mat_for_area(:,2));
    A = sparse(TRI(1,1),TRI(1,2),1,nodeN_modified,nodeN_modified);
    A(TRI(1,1),TRI(1,3)) = 1;
    A(TRI(1,2),TRI(1,3)) = 1;
    for i = 2:length(TRI)
        A(TRI(i,1),TRI(i,2)) = 1;
        A(TRI(i,1),TRI(i,3)) = 1;
        A(TRI(i,2),TRI(i,3)) = 1;
    end
    A = A + A';

    % Adj matrix with transmissibility
    [v,c] = voronoin([loc_mat_for_area(:,1),loc_mat_for_area(:,2)]);
    for i = 1:length(A)
        kI = loc_mat_for_area(i,3);
        neighborNodesI = find(A(i,:)~=0)';
        cI = c{i};    
        for j = 1:length(neighborNodesI)
            kJ = loc_mat_for_area(neighborNodesI(j),3);
            cJ = c{neighborNodesI(j)};
            c1 = [];c2 = [];p = 1;
            while size(c1) < 1
                if size(find(cJ == cI(p)))>0
                    c1 = cJ((cJ == cI(p)));
                end
                p = p+1;
            end
            while (length(c2) < 1 && p <= length(cI))
                if size(find(cJ == cI(p)))>0
                    c2 = cJ((cJ == cI(p)));
                end
                p = p+1;
            end
            if (c1 == 1 || length(c2) < 1 || c2 == 1)
                weight = 0;  
            else
                N_orth = v(c1,:)-v(c2,:);
                Aij = C*norm(N_orth);
                c0 = (v(c1,:)+v(c2,:))/2;
                Fi = loc_mat_for_area(i,1:2) - c0;
                Fj = loc_mat_for_area(neighborNodesI(j),1:2) - c0;
                Di = norm(Fi);
                Dj = norm(Fj);
                sin_alpha1 = dot(Fi,N_orth)/(Di*Aij);
                sin_alpha2 = dot(Fj,N_orth)/(Dj*Aij);
                nf_i = sqrt(1-sin_alpha1^2);
                nf_j = sqrt(1-sin_alpha2^2);
                Alpha_i = Aij*kI*nf_i/Di;
                Alpha_j = Aij*kJ*nf_j/Dj;
                weight = Alpha_i*Alpha_j/(Alpha_i+Alpha_j);
            end        
            A(i,neighborNodesI(j)) = weight;
        end
    end
    A(nodeN+1:end,:) = [];
    A(:,nodeN+1:end) = [];
    
    for i = 1 : size(c ,1)
        ind = c{i}';
        area_i = polyarea( v(ind,1) , v(ind,2) );
        if area_i>0 
            tess_area(i,1) = C*area_i;
        else
            area_i = 0;
            tess_area(i,1) = C*area_i;
        end
    end
    V = tess_area(1:nodeN);

end