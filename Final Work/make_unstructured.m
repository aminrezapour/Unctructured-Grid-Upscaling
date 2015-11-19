function out = make_unstructured(loc_mat,nodeN,c_l)

k = 1/c_l/10;
m = 1/c_l/8;
N = sqrt(nodeN);
out = loc_mat;

random_index = randi(nodeN,1,nodeN/8);

out(random_index,1) = out(random_index,1) + k;
out(random_index,2) = out(random_index,2) + m;

random_index = randi(nodeN,1,nodeN/8);

out(random_index,1) = out(random_index,1) - m;
out(random_index,2) = out(random_index,2) - k;

out(1,1:2) = [1 1]/c_l;
out(end,1:2) = [N N]/c_l;
out(N,1:2) = [1 N]/c_l;
out(nodeN-N+1,1:2) = [N 1]/c_l;