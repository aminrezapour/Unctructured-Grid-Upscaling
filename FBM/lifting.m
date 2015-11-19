function f = lifting(cool_mat)

    N = 256;
%     F = cool_mat(:,4);
%     A = sign(A);
%     even_nodes = find(F~=2);
%     odd_nodes = find(F==2);
    cool_mat_1 = cool_mat;
    cool_mat_2 = cool_mat;
    cool_mat_2(cool_mat(:,4)==2,:) = [];
    f = cool_mat_2(:,3);
    
%     [A_2_temp,V_null] = transmissibility(cool_mat_2(:,1:3),N,1,length(cool_mat_2));
    
    loc_mat_1 = cool_mat_1(:,1:3);
    loc_mat_2 = cool_mat_2(:,1:3);
    
    Area1 = just_area(loc_mat_1(:,1:3),N,length(cool_mat_1));
%     Area2 = just_area(loc_mat_2(:,1:3),N,length(cool_mat_2));
    
    loc_mat_for_area_1 = loc_mat_for_volume(loc_mat_1,N);
    loc_mat_for_area_2 = loc_mat_for_volume(loc_mat_2,N);
    A_1_area = transmissibility3(cool_mat_1(:,1:3),N,1,length(cool_mat_1));
    A_2_area = transmissibility3(cool_mat_2(:,1:3),N,1,length(cool_mat_2));
    cool_mat_1_area = [cool_mat_1;[loc_mat_for_area_1(length(loc_mat_1)+1:end,:) 4*ones(length(loc_mat_for_area_1)-length(loc_mat_1),3)]];
    cool_mat_2_area = [cool_mat_2;[loc_mat_for_area_2(length(loc_mat_2)+1:end,:) 4*ones(length(loc_mat_for_area_2)-length(loc_mat_2),3)]];
    
    [Corners1,Cells1] = voronoin(loc_mat_for_area_1(:,1:2));
    [Corners2,Cells2] = voronoin(loc_mat_for_area_2(:,1:2));
    
    for i = 1:length(loc_mat_2)
        c_coordinates = cool_mat_2(i,1:2);
        [~,c_index_in_coolmat1] = ismember(c_coordinates,cool_mat_1(:,1:2),'rows');
        c_neighbors_in_coolmat1 = find(A_1_area(c_index_in_coolmat1,:));
        c_neighbors_in_coolmat2 = find(A_2_area(i,:));
        patches_to_calculate = [];
        for j = 1 : length(c_neighbors_in_coolmat1)
           if ~ismember(loc_mat_for_area_1(c_neighbors_in_coolmat1(j),1:2),loc_mat_for_area_2(c_neighbors_in_coolmat2,1:2),'rows')
               patches_to_calculate = [patches_to_calculate;c_neighbors_in_coolmat1(j)];
           end
        end
        patches_area = [];
        ind_c_in1 = Cells1{c_index_in_coolmat1};
        ind_c_in2 = Cells2{i};
        areas = [];
        for j = 1:length(patches_to_calculate)
            ind_c_j = Cells1{patches_to_calculate(j)};
            two_corners = intersect(ind_c_in1 , ind_c_j);
            cj_neighbors_in_coolmat1 = find(A_1_area(patches_to_calculate(j),:));
            foofi = [];
            for k = 1 : length(cj_neighbors_in_coolmat1)
               if (cool_mat_1_area(cj_neighbors_in_coolmat1(k),4)==2) 
                   cj_neighborneighbor_in_coolmat1 = find(A_1_area(cj_neighbors_in_coolmat1(k),:));
                   cj_neighbors_in_coolmat1 = [cj_neighbors_in_coolmat1 cj_neighborneighbor_in_coolmat1];
                   foofi = [foofi,k];
               elseif (cool_mat_1_area(cj_neighbors_in_coolmat1(k),4)==4)
                   cj_neighborneighbor_in_coolmat1 = find(A_1_area(cj_neighbors_in_coolmat1(k),:));
                   cj_neighbors_in_coolmat1 = [cj_neighbors_in_coolmat1 cj_neighborneighbor_in_coolmat1];
               end
            end
            cj_neighbors_in_coolmat1(foofi) = [];
            cj_neighbors_in_coolmat1 = unique(cj_neighbors_in_coolmat1,'stable');
            [~,foofo] = ismember(c_index_in_coolmat1,cj_neighbors_in_coolmat1);
            cj_neighbors_in_coolmat1(foofo) = [];
            cj_neighbors_in_coolmat2 = [];
            for k = 1 : length(cj_neighbors_in_coolmat1)
                [~,foofa] = ismember(cool_mat_1_area(cj_neighbors_in_coolmat1(k),1:2),cool_mat_2_area(:,1:2),'rows');
                cj_neighbors_in_coolmat2 = [cj_neighbors_in_coolmat2,foofa];
            end 
            cj_neighbors_in_coolmat2 = cj_neighbors_in_coolmat2(find(cj_neighbors_in_coolmat2));
            other_corners = [];
            for k = 1 : length(cj_neighbors_in_coolmat2)
               other_corners = [other_corners, intersect(Cells2{cj_neighbors_in_coolmat2(k)},ind_c_in2)];
            end
            all_corners_index = 1:length(other_corners);
            [~,ia,~] = unique(other_corners);
            foofe = setdiff(all_corners_index,ia);
            other_corners = unique(other_corners(foofe));
            
            all_corners_x = [Corners1(two_corners,1);Corners2(other_corners,1)];
            all_corners_y = [Corners1(two_corners,2);Corners2(other_corners,2)];
            
            cx = mean(all_corners_x);
            cy = mean(all_corners_y);
            a = atan2(all_corners_y - cy, all_corners_x - cx);
            [~, order] = sort(a);
            all_corners_x = all_corners_x(order);
            all_corners_y = all_corners_y(order);
            area = polyarea( all_corners_x , all_corners_y );
            areas = [areas;area cool_mat_1(patches_to_calculate(j),3)];
        end
        
        if (~isempty(areas))
            f(i) = equivalent_permeability2(Area1(c_index_in_coolmat1),cool_mat_1(c_index_in_coolmat1,3),areas);
        end
        
    end
    
end