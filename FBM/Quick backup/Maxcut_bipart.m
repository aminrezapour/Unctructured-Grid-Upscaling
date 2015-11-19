function index = Maxcut_bipart(Adj)
% Adj: Adjacency matrix 
% index: the cell consists of two vectors with node indices of two subsets
% Use the first vector for approximation

index = cell(1,2);
N = length(Adj); 
d = sum(Adj, 2);
d(d == 0) = 1;
Gain = d;
[maxG, node] = max(Gain);
U = []; P = (1:N)';

    while maxG > 0 
       U = [U; node];
       P = setdiff(P, node);
       nn = find(Adj(node,:) > 0);
       valid_nn = intersect(nn,P); % find node's neighbors in set P
       weight = Adj(node, valid_nn);
       if ~isempty(find(weight < 0, 1))
          display('error! the incident weights from neighbors in P should be positive') 
       end
       d(valid_nn) = d(valid_nn) - 2*weight'; %% update the degree of the neighbors in set P   
       Gain = d(P); %% calculate gains for P set
       [maxG, nodeG] = max(Gain);
       node = P(nodeG);
    end
    
    index{1} = U;
    index{2} = P;
end