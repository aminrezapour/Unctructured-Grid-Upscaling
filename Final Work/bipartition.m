function F = bipartition(A,max_iter)

    A = sign(A);
    nodeN = length(A);
    F = randi(2,nodeN,1); %random assignment, 1 is even 2 is odd
    F(1) = 1; F(nodeN) = 1; %location of injector and producer

    for i = 1:max_iter
        nodeIndex = 1+randi(nodeN-2,1,1);
        neighborNodes = find(A(nodeIndex,:)~=0)';
        neighborNodes_odd = neighborNodes(F(neighborNodes)==2);
        neighborNodes_even = neighborNodes(F(neighborNodes)==1);

        if F(nodeIndex)==2
           curr_weight_loss = 0;
           for k = 1:length(neighborNodes_odd)
                    curr_weight_loss = curr_weight_loss + A(nodeIndex,neighborNodes_odd(k));
           end
           alt_weight_loss = 0;
           for k = 1:length(neighborNodes_even)
               alt_weight_loss = alt_weight_loss + A(nodeIndex,neighborNodes_even(k));
           end
           if alt_weight_loss<curr_weight_loss
              F(nodeIndex) = 1;
           end
        else
           curr_weight_loss = 0;
           for k = 1:length(neighborNodes_even)
               curr_weight_loss = curr_weight_loss + A(nodeIndex,neighborNodes_even(k));
           end
           alt_weight_loss = 0;
           for k = 1:length(neighborNodes_odd)
               alt_weight_loss = alt_weight_loss + A(nodeIndex,neighborNodes_odd(k));
           end
           if alt_weight_loss<curr_weight_loss
              F(nodeIndex) = 2;
           end
        end   
    end

end