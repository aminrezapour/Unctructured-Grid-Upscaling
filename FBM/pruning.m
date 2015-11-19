function [cool_mat_2,A_2] = pruning(cool_mat_1,A_1,max_iter,N,c,folder,epsilon)

    cool_mat_2 = cool_mat_1;
    cool_mat_2(cool_mat_1(:,4)==2,:) = [];
    f = lifting(cool_mat_1);
    cool_mat_2(:,3) = f;
    cool_mat_2(:,5) = [1:length(f)]';
    [A_2,V] = transmissibility(cool_mat_2(:,1:3),N,c,length(f));
    simulation_files(A_2,V,folder);
    F = bipartition(A_2,max_iter,length(cool_mat_2));
    cool_mat_2(:,4) = F;
    cool_mat_2 = improve_bipartition2(cool_mat_2,A_2,N,epsilon);

end