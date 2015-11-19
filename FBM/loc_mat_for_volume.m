function loc_mat_out = loc_mat_for_volume(loc_mat,N)

    K = 100;
    loc_mat_for_area = loc_mat(:,1:2)/K;
    [v,c] = voronoin(loc_mat_for_area(:,1:2));
    index = [1 0];
    for i = 2:length(v)
        if v(i,1)<0.5/K
            index = [index;i,1];
        elseif v(i,2)<0.5/K
            index = [index;i,2];
        elseif v(i,1)>(N+0.5)/K
            index = [index;i,3];
        elseif v(i,2)>(N+0.5)/K
            index = [index;i,4];
        end
    end

    % adding the four corners
    corners = [0 0;0 1;1 0;...
               N+1 N+1;N+1 N;N N+1;...
               0 N;1 N+1;0 N+1;...
               N+1 1;N+1 0; N 0]/K;
    loc_mat_for_area = [loc_mat_for_area;corners];

    for i = 1:length(c)
        [lis_a,lis_b] = ismember(c{i},index(:,1));
        if sum(lis_b)>0
            p = loc_mat(i,1:2);
            test_p_1 = dot(p,[1 -1]);
            test_p_2 = dot(p-[0 N+1],[-1 -1]);
            if ismember(1,c{i})
                if test_p_1>0 && test_p_2>0
                    loc_mat_for_area = [loc_mat_for_area;[p(1) 0.5-(p(2)-0.5)]/K];
                elseif test_p_1>0 && test_p_2<0
                    loc_mat_for_area = [loc_mat_for_area;[2*N+1-p(1) p(2)]/K];
                elseif test_p_1<0 && test_p_2<0
                    loc_mat_for_area = [loc_mat_for_area;[p(1) 2*N+1-p(2)]/K];
                elseif test_p_1<0 && test_p_2>0
                    loc_mat_for_area = [loc_mat_for_area;[0.5-(p(1)-0.5) p(2)]/K];
                end
            else
                for j = 1:length(lis_a)
                    if lis_a(j) 
                        if index(lis_b(j),2) == 1
                            loc_mat_for_area = [loc_mat_for_area;[0.5-(p(1)-0.5) p(2)]/K];
                        elseif index(lis_b(j),2) == 2
                            loc_mat_for_area = [loc_mat_for_area;[p(1) 0.5-(p(2)-0.5)]/K];
                        elseif index(lis_b(j),2) == 3
                            loc_mat_for_area = [loc_mat_for_area;[2*N+1-p(1) p(2)]/K];
                        elseif index(lis_b(j),2) == 4
                            loc_mat_for_area = [loc_mat_for_area;[p(1) 2*N+1-p(2)]/K];
                        end
                    end
                end
            end
        end
    end
    loc_mat_out = [K*loc_mat_for_area [loc_mat(:,3);ones(length(loc_mat_for_area)-length(loc_mat),1)]];
    loc_mat_out = unique(loc_mat_out,'rows','stable');
end



