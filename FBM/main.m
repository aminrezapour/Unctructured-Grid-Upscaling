clear all;
close all;

load model1.mat

model = model1+1500;

% Gridblock thickness
c = 5;

% Bipartition cutoff
% epsilon = [20 40 60 80 100 120 140 160 200 240 280 320 360 400 450];

loc_mat = locMatFromMatrix(model);
myImageVector = loc_mat(:,3);
nodeN = length(loc_mat);

random_index = randi(nodeN,1,nodeN/8);
loc_mat(random_index,1) = loc_mat(random_index,1)+0.1;
loc_mat(random_index,2) = loc_mat(random_index,2)+0.15;
random_index = randi(nodeN,1,nodeN/8);
loc_mat(random_index,1) = loc_mat(random_index,1)-0.15;
loc_mat(random_index,2) = loc_mat(random_index,2)-0.1;

N = sqrt(nodeN);
loc_mat(1,1:2) = [1 1];
loc_mat(end,1:2) = [N N];
loc_mat(N,1:2) = [1 N];
loc_mat(nodeN-N+1,1:2) = [N 1];

% Zero cool_mat
[A_0,V] = transmissibility(loc_mat,N,c,nodeN);
simulation_files(A_0,V,'Big fine scale');
F1 = bipartition(A_0,2*nodeN,nodeN);
cool_mat_0_ = [loc_mat F1 (1:nodeN)' (1:nodeN)'];
%%
epsilon = [100 200 300 400 500 600 700];
cool_mat_0 = improve_bipartition2(cool_mat_0_,A_0,N,epsilon(1));

%% 
% folder names
folder_name = {'Big Coarse Scale 1','Big Coarse Scale 2',...
    'Big Coarse Scale 3','Big Coarse Scale 4',...
    'Big Coarse Scale 5','Big Coarse Scale 6','Big Coarse Scale 7',...
    'Big Coarse Scale 8','Big Coarse Scale 9','Big Coarse Scale 10',...
    'Big Coarse Scale 11','Big Coarse Scale 12','Big Coarse Scale 13',...
    'Big Coarse Scale 14','Big Coarse Scale 15'};
cool_mat = {cool_mat_0};
A_ = {A_0};
epsilon = [400 400 400 400 400 400 400 400 400 400 400 400 400]/4;
for i = 2:13
    i
    [cool_mat{i},A_{i}] = pruning(cool_mat{i-1},A_{i-1},2*length(A_{i-1}),N,c,folder_name{i},...
        epsilon(i));
end








% [cind1,nind1] = sunil_indexing(sqrt(nodeN));

% Laplacian of graph based on transmissibility G_T
% A_0 = transmissibility1(cind1,nind1,myImageVector,a,b,c,nodeN);

% Writing the simulation files
% simulation_files1(A_0,a,b,c,'Big fine scale');

% Bipartition
% F = bipartition(A_0,max_iter,nodeN);

% The fine scale cool_mat
% cool_mat_0 = [loc_mat F (1:nodeN)' (1:nodeN)'];
% F = improve_bipartition(cool_mat_0,A_0,epsilon,N); 
% cool_mat_0(:,4) = F;
