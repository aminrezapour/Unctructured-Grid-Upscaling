function drawImage(loc_mat,l)

    [v,c]=voronoin(loc_mat(:,1:2)); 
%     figure;
    for i = 1:length(c) 
        if all(c{i}~=1)   % If at least one of the indices is 1, 
                          % then it is an open region and we can't 
                          % patch that.
            patch(v(c{i},1),v(c{i},2),10*(loc_mat(i,3))); % use color i.
        end
    end
    xlim([0.1/100 l]);
    ylim([0.1/100 l]);