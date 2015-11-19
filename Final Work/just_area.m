function Areas = just_area(loc_mat,l,nodeN,grid_size)

    loc_mat_for_area = loc_mat_for_volume(loc_mat,grid_size,l);

    [v,c] = voronoin([loc_mat_for_area(:,1),loc_mat_for_area(:,2)]);

    for i = 1 : size(c ,1)
        ind = c{i}';
        area_i = polyarea( v(ind,1) , v(ind,2) );
        if area_i>0 
            tess_area(i,1)= area_i;
        else
            area_i = 0;
            tess_area(i,1)= area_i;
        end
    end
    Areas = tess_area(1:nodeN);

end