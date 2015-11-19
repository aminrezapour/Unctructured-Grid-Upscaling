function [cool_mat_2,A_2] = pruning(cool_mat_1,l,grid_size,max_iter,c,folder,epsilon,days)

    cool_mat_2 = cool_mat_1;
    cool_mat_2(cool_mat_1(:,4) == 2,:) = [];
    f = lifting(cool_mat_1,l,grid_size);
    cool_mat_2(:,3) = f;
    cool_mat_2(:,5) = (1:length(f))';
    [A_2,V] = transmissibility(cool_mat_2(:,1:3),l,grid_size,c,length(f));
%     simulation_files(A_2,V,folder);
%     simulation_files_rest(folder,days,length(f),l,c);
    F = bipartition(A_2,max_iter);
    cool_mat_2(:,4) = F;
    cool_mat_2 = improve_bipartition(cool_mat_2,A_2,l,grid_size,epsilon);

end