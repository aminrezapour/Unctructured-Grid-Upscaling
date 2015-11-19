function loc_mat_out = loc_mat_for_volume(loc_mat,grid_size,l)

    K = 50; % don't touch this. To avoid numerical errors for voronoin function
    f = grid_size/2/K;
    loc_mat_for_area = loc_mat(:,1:2)/K;
    [v,c] = voronoin(loc_mat_for_area);
    index = [1 0];
    for i = 2:length(v)
        if v(i,1)<f
            index = [index;i,1];
        elseif v(i,2)<f
            index = [index;i,2];
        elseif v(i,1)>(l/K+f)
            index = [index;i,3];
        elseif v(i,2)>(l/K+f)
            index = [index;i,4];
        end
    end

    % adding the 3 (yes! three) extra nodes for four corners
    corners = [0 0;0 grid_size;grid_size 0;...
               l+grid_size l+grid_size;l+grid_size l;l l+grid_size;...
               0 l;grid_size l+grid_size;0 l+grid_size;...
               l+grid_size grid_size;l+grid_size 0;l 0]/K;
    loc_mat_for_area = [loc_mat_for_area;corners];

    for i = 1:length(c)
        [lis_a,lis_b] = ismember(c{i},index(:,1));
        if sum(lis_b)>0
            p = loc_mat(i,1:2);
            test_p_1 = dot(p,[1 -1]);
            test_p_2 = dot(p-[0 l+grid_size],[-1 -1]);
            if ismember(1,c{i})
                if test_p_1>0 && test_p_2>0
                    loc_mat_for_area = [loc_mat_for_area;[p(1) grid_size/2-(p(2)-grid_size/2)]/K];
                elseif test_p_1>0 && test_p_2<0
                    loc_mat_for_area = [loc_mat_for_area;[2*l+grid_size-p(1) p(2)]/K];
                elseif test_p_1<0 && test_p_2<0
                    loc_mat_for_area = [loc_mat_for_area;[p(1) 2*l+grid_size-p(2)]/K];
                elseif test_p_1<0 && test_p_2>0
                    loc_mat_for_area = [loc_mat_for_area;[grid_size/2-(p(1)-grid_size/2) p(2)]/K];
                end
            else
                for j = 1:length(lis_a)
                    if lis_a(j) 
                        if index(lis_b(j),2) == 1
                            loc_mat_for_area = [loc_mat_for_area;[grid_size/2-(p(1)-grid_size/2) p(2)]/K];
                        elseif index(lis_b(j),2) == 2
                            loc_mat_for_area = [loc_mat_for_area;[p(1) grid_size/2-(p(2)-grid_size/2)]/K];
                        elseif index(lis_b(j),2) == 3
                            loc_mat_for_area = [loc_mat_for_area;[2*l+grid_size-p(1) p(2)]/K];
                        elseif index(lis_b(j),2) == 4
                            loc_mat_for_area = [loc_mat_for_area;[p(1) 2*l+grid_size-p(2)]/K];
                        end
                    end
                end
            end
        end
    end
    loc_mat_out = [K*loc_mat_for_area [loc_mat(:,3);ones(length(loc_mat_for_area)-length(loc_mat),1)]];
    loc_mat_out = unique(loc_mat_out,'rows','stable');
end



