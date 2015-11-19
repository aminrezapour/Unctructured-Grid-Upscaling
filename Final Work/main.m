clear all;
close all;

load model.mat

% Gridblock thickness
c = 5;
% size of reservoir in ft
l = 256;
% reservoir lifecycle
days = 200;
% bipartition threshhold
epsilon = [0.3 0.6]; % epsilon can also be chosen manually. see inside the improve_bipartition function

% adjustment
N = length(model);
nodeN = N^2;
c_l = N/l;
grid_size = l/N;

loc_mat = locMatFromMatrix(model,c_l);
myImageVector = loc_mat(:,3);

% adding some noise to patch centers coordinates
loc_mat = make_unstructured(loc_mat,nodeN,c_l);

% Zero cool_mat
[A_0,V] = transmissibility(loc_mat,l,grid_size,c,nodeN);
%%
simulation_files(A_0,V,'Huge fine scale');
simulation_files_rest('Huge fine scale',days,nodeN,l,c);
F1 = bipartition(A_0,3*nodeN); % currently bipartition works on sign(A)
cool_mat_0_ = [loc_mat F1 (1:nodeN)' (1:nodeN)'];
cool_mat_0 = improve_bipartition(cool_mat_0_,A_0,l,grid_size,epsilon(1));

% folder names must be entered here
folder_name = {'Huge Coarse Scale 1','Huge Coarse Scale 2',...
    'Huge Coarse Scale 3','Huge Coarse Scale 4',...
    'Huge Coarse Scale 5','Huge Coarse Scale 6','Huge Coarse Scale 7',...
    'Huge Coarse Scale 8','Huge Coarse Scale 9','Huge Coarse Scale 10',...
    'Huge Coarse Scale 11','Huge Coarse Scale 12','Huge Coarse Scale 13',...
    'Huge Coarse Scale 14','Hige Coarse Scale 15'};
cool_mat = {cool_mat_0};
A_ = {A_0};
%%
for i = 1:15
    display(i);
    [cool_mat{i+1},A_{i+1}] = pruning(cool_mat{i},l,grid_size,2*length(A_{i}),c,folder_name{i},epsilon(1),days);
end
