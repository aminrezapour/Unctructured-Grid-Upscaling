function drawImage(loc_mat)

    [v,c]=voronoin(loc_mat(:,1:2)/100); 
    figure;
    for i = 1:length(c) 
        if all(c{i}~=1)   % If at least one of the indices is 1, 
                          % then it is an open region and we can't 
                          % patch that.
            patch(v(c{i},1),v(c{i},2),10*(loc_mat(i,3))); % use color i.
        end
    end
    xlim([0 2.56]);
    ylim([0 2.56]);