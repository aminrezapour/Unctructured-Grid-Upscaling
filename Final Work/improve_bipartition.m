function cool_mat_improved = improve_bipartition(cool_mat,A,l,gridSize,epsilon)

    F1 = cool_mat(:,4);
    F2 = F1;
    [even_index,~]= find(F2 == 1);
    [odd_index,~] = find(F2 == 2);
    f_odd = cool_mat(odd_index,3);
    f_even = cool_mat(even_index,3);

    A_tilde = A(:,[odd_index;even_index]');
    A_tilde = A_tilde([odd_index;even_index],:);

    J = A_tilde(1:length(odd_index),length(odd_index)+1:end);
    
    D = f_odd - (sum(J,2).^(-1)).*(J*f_even);
    for i = 1:length(D)
       if isnan(D(i)) % this indicates that the odd node is only connected to other odd nodes
           D(i) = 0;
           F2(odd_index(i)) = 1; % we cahnge it to even
       end
    end
    
    % putting four blocks at the corners of the reservoir as even node
    [mike_a,~] = find(cool_mat(:,1) == gridSize);
    [mark_a,~] = find(cool_mat(mike_a,2) == l);
    [meg_a,~] = find(cool_mat(:,2) == gridSize);
    [suzi_a,~] = find(cool_mat(meg_a,1) == l);
    F2(1) = 1;
    F2(end) = 1;
    F2(mike_a(mark_a)) = 1;
    F2(meg_a(suzi_a)) = 1;
    
    % recalculating the detail coeff
    [even_index,~]= find(F2 == 1);
    [odd_index,~] = find(F2 == 2);
    f_odd = cool_mat(odd_index,3);
    f_even = cool_mat(even_index,3);

    A_tilde = A(:,[odd_index;even_index]');
    A_tilde = A_tilde([odd_index;even_index],:);

    J = A_tilde(1:length(odd_index),length(odd_index)+1:end);
    
    D = f_odd - (sum(J,2).^(-1)).*(J*f_even);

    cut = epsilon*max(abs(D));
    high_pass_nodes = odd_index(abs(D)>cut);
    F3 = F2;
    F3(high_pass_nodes) = 3; % 1 is even, 2 is odd and 3 is the new even
    
    % redoing the above process 5 times (based on experience)
    for k = 1:5
        [even_index,~]= find(F3 == 1 | F3 == 3);
        [odd_index,~] = find(F3 == 2);
        f_odd = cool_mat(odd_index,3);
        f_even = cool_mat(even_index,3);

        A_tilde = A(:,[odd_index;even_index]');
        A_tilde = A_tilde([odd_index;even_index],:);

        J = A_tilde(1:length(odd_index),length(odd_index)+1:end);
    
        D = f_odd - (sum(J,2).^(-1)).*(J*f_even);
        for i = 1:length(D)
           if isnan(D(i))
               D(i) = 0;
           end
        end
        
        high_pass_nodes = odd_index(abs(D)>cut);
        F3(high_pass_nodes) = 3;

    end

    % uncomment this if you want to keep more nodes
%     [high_pass_nodes,dum] = find(F3==3);
%     high_pass_nodes_neighbors = [];
%     for i = 1 : length(high_pass_nodes)
%         [hpnn,dum] = find(A(high_pass_nodes(i),:));
% %         for j = 1 : length(dum)
% %             if F(dum(j))==1
%                 high_pass_nodes_neighbors = [high_pass_nodes_neighbors dum];
% %             end
% %         end
%     end
%     high_pass_nodes_neighbors = unique(high_pass_nodes_neighbors,'rows','stable');
%     F3(high_pass_nodes_neighbors) = 4;
    
    cool_mat_improved = cool_mat;
    cool_mat_improved(:,4) = F3;
    
end