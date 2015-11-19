function [cool_mat_improved,epsilon] = improve_bipartition(cool_mat,A,N)

    F1 = cool_mat(:,4);
    F2 = F1;
    [even_index even_index_dummy]= find(F1==1);
    [odd_index odd_index_dummy] = find(F1==2);
    f_odd = cool_mat(odd_index,3);
    f_even = cool_mat(even_index,3);

    A_tilde = A(:,[odd_index;even_index]');
    A_tilde = A_tilde([odd_index;even_index],:);

    J = A_tilde(1:length(odd_index),length(odd_index)+1:end);
    
    D = f_odd - (sum(J,2).^(-1)).*(J*f_even);
    for i = 1:length(D)
       if isnan(D(i))
           D(i) = 0; %flag
           F2(odd_index(i)) = 1;
       end
    end
    
    [mike_a,mike_b] = find(cool_mat(:,1)==1);
    [mark_a,mark_b] = find(cool_mat(mike_a,2)==N);
    [meg_a,meg_b] = find(cool_mat(:,2)==1);
    [suzi_a,suzi_b] = find(cool_mat(meg_a,1)==N);
    F2(1) = 1;
    F2(end) = 1;
    F2(mike_a(mark_a)) = 1;
    F2(meg_a(suzi_a)) = 1;
    
    [even_index,even_index_dummy]= find(F2==1);
    [odd_index,odd_index_dummy] = find(F2==2);
    f_odd = cool_mat(odd_index,3);
    f_even = cool_mat(even_index,3);

    A_tilde = A(:,[odd_index;even_index]');
    A_tilde = A_tilde([odd_index;even_index],:);

    J = A_tilde(1:length(odd_index),length(odd_index)+1:end);
    
    D = f_odd - (sum(J,2).^(-1)).*(J*f_even);

    epsilon_index = floor(0.90*length(D));
    sorted_D = sort(abs(D));
    epsilon = sorted_D(epsilon_index);
    high_pass_nodes = odd_index(abs(D)>epsilon);
    F3 = F2;
    F3(high_pass_nodes) = 3;
    
    for k = 1:5
        [even_index,even_index_dummy]= find(F3==1 | F3==3);
        [odd_index,odd_index_dummy] = find(F3==2);
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
        
        high_pass_nodes = odd_index(abs(D)>epsilon);
        F3(high_pass_nodes) = 3;

    end

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
%     F4 = F3;
%     F4(high_pass_nodes_neighbors) = 4;
    
    cool_mat_improved = cool_mat;
    cool_mat_improved(:,4) = F3;
    
end