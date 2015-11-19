function A = adjacency(loc_mat_for_area)
    
    nodeN_modified = length(loc_mat_for_area);
    
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
    
    [~,c]=voronoin([loc_mat_for_area(:,1),loc_mat_for_area(:,2)]);
    for i = 1:length(A)
%         kI = loc_mat_for_area(i,3);
        neighborNodesI = find(A(i,:)~=0)';
        cI = c{i};    
        for j = 1:length(neighborNodesI)
%             kJ = loc_mat_for_area(neighborNodesI(j),3);
            cJ = c{neighborNodesI(j)};
            c1 = [];c2 = [];p = 1;
            while size(c1) < 1
                if size(find(cJ==cI(p)))>0
                    c1 = cJ((cJ==cI(p)));
                end
                p = p+1;
            end
            while length(c2) < 1 && p <= length(cI)
                if size(find(cJ==cI(p)))>0
                    c2 = cJ((cJ==cI(p)));
                end
                p = p+1;
            end
            if c1==1 || length(c2)<1 || c2==1
                weight = 0;  
            else
                weight = 1;
            end        
            A(i,neighborNodesI(j)) = weight;
        end
    end
end