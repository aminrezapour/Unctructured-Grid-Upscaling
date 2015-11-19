% this script works with GPRS, so far I have manually imported the data
% from a model different than FR11. In fact I modified the SPE1 to look
% like FR11. Files S_f_u_* and P_f_u_* are generated based on
% RES1_debug.out for three days at 120, 170 and 360.

% close all;
% clear all;

%% 
load myImageFR11u.mat;
myImage = myImageFR11u;
loc_mat = locMatFromMatrix(myImage);
loc_mat(loc_mat(:,3)==0,:) = [];

myImageVector = loc_mat(:,3);
nodeN = length(loc_mat);
myImageNode = (1:nodeN)'; %indexing all the nodes from 1 to N^2

loc_mat_for_area = loc_mat(:,1:2);
lower_bound = loc_mat_for_area(loc_mat_for_area(:,2)<2,:);
lower_bound = lower_bound - [zeros(length(lower_bound),1) ones(length(lower_bound),1)];
lower_bound = [lower_bound;10 -9;23 -2; 28 -2];
upper_bound = loc_mat_for_area(loc_mat_for_area(:,2)>39,:);
upper_bound = upper_bound + [zeros(length(upper_bound),1) ones(length(upper_bound),1)];
upper_bound = [upper_bound;13 43;18 43;23 43;28 43;33 43;38 43];
left_bound = loc_mat_for_area(loc_mat_for_area(:,1)<2,:);
left_bound = left_bound - [ones(length(left_bound),1) zeros(length(left_bound),1)];
left_bound = [left_bound;-9 10;-2 23];
right_bound = loc_mat_for_area(loc_mat_for_area(:,1)>39,:);
right_bound = right_bound + [ones(length(right_bound),1) zeros(length(right_bound),1)];
right_bound = [right_bound;43 38;43 33;43 28;43 23];
loc_mat_for_area = [loc_mat_for_area;lower_bound;upper_bound;left_bound;right_bound];
loc_mat_for_area = [loc_mat_for_area;[-10 -10];[43 43];[0 41];[41 0]];
loc_mat_for_area = [loc_mat_for_area [loc_mat(:,3);zeros(length(loc_mat_for_area)-length(loc_mat),1)]];
nodeN_modified = length(loc_mat_for_area);

loc_mat_for_area(:,1:2) = 5*loc_mat_for_area(:,1:2);
loc_mat(:,1:2) = 5*loc_mat(:,1:2);

TRI = delaunay(loc_mat_for_area(:,1),loc_mat_for_area(:,2));
A = sparse(TRI(1,1),TRI(1,2),1,nodeN_modified,nodeN_modified);
A(TRI(1,1),TRI(1,3)) = 1;
A(TRI(1,2),TRI(1,3)) = 1;
for i = 2:length(TRI)
   A(TRI(i,1),TRI(i,2)) = 1;
   A(TRI(i,1),TRI(i,3)) = 1;
   A(TRI(i,2),TRI(i,3)) = 1;
end
A = A + A';

%Adj matrix with transmissibility
[v,c]=voronoin([loc_mat_for_area(:,1),loc_mat_for_area(:,2)]);
h = 50;                        %reservoir thickness
for i = 1:length(A)
    kI = loc_mat_for_area(i,3);
    neighborNodesI = find(A(i,:)~=0)';
    cI = c{i};    
    for j = 1:length(neighborNodesI)
        kJ = loc_mat_for_area(neighborNodesI(j),3);
        cJ = c{neighborNodesI(j)};
        c1 = [];c2 = [];p = 1;
        while size(c1) < 1
            if size(find(cJ==cI(p)))>0
                c1 = cJ(find(cJ==cI(p)));
            end
            p = p+1;
        end
        while length(c2) < 1 && p <= length(cI)
            if size(find(cJ==cI(p)))>0
                c2 = cJ(find(cJ==cI(p)));
            end
            p = p+1;
        end
        if c1==1 || length(c2)<1 || c2==1
            weight = 0;  
        else
            N_orth = v(c1,:)-v(c2,:);
            Aij = h*norm(N_orth);
            c0 = 0.5*(v(c1,:)+v(c2,:));
            Fi = loc_mat_for_area(i,1:2)-c0;
            Fj = loc_mat_for_area(neighborNodesI(j),1:2)-c0;
            Di = norm(Fi);
            Dj = norm(Fj);
            sin_alpha1 = dot(Fi,N_orth)/(Di*Aij);
            sin_alpha2 = dot(Fj,N_orth)/(Dj*Aij);
            nf_i = sqrt(1-sin_alpha1^2);
            nf_j = sqrt(1-sin_alpha2^2);
            Alpha_i = Aij*kI*nf_i/Di;
            Alpha_j = Aij*kJ*nf_j/Dj;
            weight = Alpha_i*Alpha_j/(Alpha_i+Alpha_j);
        end        
        A(i,neighborNodesI(j)) = weight/100;
    end
end

%finding the area of the patch
for i = 1 : size(c ,1)
    ind = c{i}';
    area_i = polyarea( v(ind,1) , v(ind,2) );
    if area_i>0 
        tess_area(i,1)=area_i;
    else
        area_i = 0;
        tess_area(i,1)=area_i;
    end
end

%writing the conn file
fileID = fopen('conn.in','w');
counter = 1;
for i = 1 : length(A)
    for j = i : length(A)
        if A(i,j) ~= 0
            counter = counter +1;
            fprintf(fileID,'%4d\t %4d\t %f\n',[i-1 j-1 full(A(i,j))]);
        end
    end
end
fclose(fileID);

%writing the volume file
fileID = fopen('volume.in','w');
for i = 1:nodeN
    fprintf(fileID,'%f\n',tess_area(i));
end
fclose(fileID);

% graph based on transmissibility G_T
A_f_T_u = A;
A_f_T_u(nodeN+1:end,:) = [];
A_f_T_u(:,nodeN+1:end) = [];

% Graph based on permability G_K
TRI = delaunay(loc_mat(:,1),loc_mat(:,2));
A = sparse(TRI(1,1),TRI(1,2),1,nodeN,nodeN);
A(TRI(1,1),TRI(1,3)) = 1;
A(TRI(1,2),TRI(1,3)) = 1;
for i = 2:length(TRI)
   A(TRI(i,1),TRI(i,2)) = 1;
   A(TRI(i,1),TRI(i,3)) = 1;
   A(TRI(i,2),TRI(i,3)) = 1;
end
A = A + A';
for i = 1:length(A)
    kI = loc_mat(i,3);
    neighborNodesI = find(A(i,:)~=0)';
    for j = 1:length(neighborNodesI)
        kJ = loc_mat(neighborNodesI(j),3);
        weight = kI+kJ;
        A(i,neighborNodesI(j)) = weight;
    end
end
A_f_K_u = A;

%% Graph G_P and G_S

load 'P_f_u_1.mat';load 'P_f_u_2.mat';load 'P_f_u_3.mat';
load 'S_f_u_1.mat';load 'S_f_u_2.mat';load 'S_f_u_3.mat';

% % %Adj matrix with P_1
% % TRI = delaunay(loc_mat(:,1),loc_mat(:,2));
% % V = P_f_u_1;
% % weight = 1-exp(-((V(TRI(1,1),1)-V(TRI(1,2),1))^2)/2);
% % A = sparse(TRI(1,1),TRI(1,2),weight,nodeN,nodeN);
% % weight = 1-exp(-((V(TRI(1,1),1)-V(TRI(1,3),1))^2)/2);
% % A(TRI(1,1),TRI(1,3)) = weight;
% % weight = 1-exp(-((V(TRI(1,2),1)-V(TRI(1,3),1))^2)/2);
% % A(TRI(1,2),TRI(1,3)) = weight;
% % for i = 2:length(TRI)
% %     weight = 1-exp(-((V(TRI(i,1),1)-V(TRI(i,2),1))^2)/2);
% %     A(TRI(i,1),TRI(i,2)) = weight;
% %     weight = 1-exp(-((V(TRI(i,1),1)-V(TRI(i,3),1))^2)/2);
% %     A(TRI(i,1),TRI(i,3)) = weight;
% %     weight = 1-exp(-((V(TRI(i,2),1)-V(TRI(i,3),1))^2)/2);
% %     A(TRI(i,2),TRI(i,3)) = weight;
% % end
% % A = A + A';
% % A_f_P_u_1 = A;
% Adj matrix with PP_1
TRI = delaunay(loc_mat(:,1),loc_mat(:,2));
V = P_f_u_1;
teta = 2000;
weight = exp(-((V(TRI(1,1),1)-V(TRI(1,2),1))^2)/teta);
A = sparse(TRI(1,1),TRI(1,2),weight,nodeN,nodeN);
weight = exp(-((V(TRI(1,1),1)-V(TRI(1,3),1))^2)/teta);
A(TRI(1,1),TRI(1,3)) = weight;
weight = exp(-((V(TRI(1,2),1)-V(TRI(1,3),1))^2)/teta);
A(TRI(1,2),TRI(1,3)) = weight;
for i = 2:length(TRI)
    weight = exp(-((V(TRI(i,1),1)-V(TRI(i,2),1))^2)/teta);
    A(TRI(i,1),TRI(i,2)) = weight;
    weight = exp(-((V(TRI(i,1),1)-V(TRI(i,3),1))^2)/teta);
    A(TRI(i,1),TRI(i,3)) = weight;
    weight = exp(-((V(TRI(i,2),1)-V(TRI(i,3),1))^2)/teta);
    A(TRI(i,2),TRI(i,3)) = weight;
end
A = A + A';
A_f_PP_u_1 = A;

% % % Adj matrix with P_2
% % TRI = delaunay(loc_mat(:,1),loc_mat(:,2));
% % V = P_f_u_2;
% % weight = 1-exp(-((V(TRI(1,1),1)-V(TRI(1,2),1))^2)/2);
% % A = sparse(TRI(1,1),TRI(1,2),weight,nodeN,nodeN);
% % weight = 1-exp(-((V(TRI(1,1),1)-V(TRI(1,3),1))^2)/2);
% % A(TRI(1,1),TRI(1,3)) = weight;
% % weight = 1-exp(-((V(TRI(1,2),1)-V(TRI(1,3),1))^2)/2);
% % A(TRI(1,2),TRI(1,3)) = weight;
% % for i = 2:length(TRI)
% %     weight = 1-exp(-((V(TRI(i,1),1)-V(TRI(i,2),1))^2)/2);
% %     A(TRI(i,1),TRI(i,2)) = weight;
% %     weight = 1-exp(-((V(TRI(i,1),1)-V(TRI(i,3),1))^2)/2);
% %     A(TRI(i,1),TRI(i,3)) = weight;
% %     weight = 1-exp(-((V(TRI(i,2),1)-V(TRI(i,3),1))^2)/2);
% %     A(TRI(i,2),TRI(i,3)) = weight;
% % end
% % A = A + A';
% % A_f_P_u_2 = A;
%Adj matrix with PP_2
TRI = delaunay(loc_mat(:,1),loc_mat(:,2));
V = P_f_u_2;
weight = exp(-((V(TRI(1,1),1)-V(TRI(1,2),1))^2)/teta);
A = sparse(TRI(1,1),TRI(1,2),weight,nodeN,nodeN);
weight = exp(-((V(TRI(1,1),1)-V(TRI(1,3),1))^2)/teta);
A(TRI(1,1),TRI(1,3)) = weight;
weight = exp(-((V(TRI(1,2),1)-V(TRI(1,3),1))^2)/teta);
A(TRI(1,2),TRI(1,3)) = weight;
for i = 2:length(TRI)
    weight = exp(-((V(TRI(i,1),1)-V(TRI(i,2),1))^2)/teta);
    A(TRI(i,1),TRI(i,2)) = weight;
    weight = exp(-((V(TRI(i,1),1)-V(TRI(i,3),1))^2)/teta);
    A(TRI(i,1),TRI(i,3)) = weight;
    weight = exp(-((V(TRI(i,2),1)-V(TRI(i,3),1))^2)/teta);
    A(TRI(i,2),TRI(i,3)) = weight;
end
A = A + A';
A_f_PP_u_2 = A;

% % %Adj matrix with P_3
% % TRI = delaunay(loc_mat(:,1),loc_mat(:,2));
% % V = P_f_u_3;
% % weight = 1-exp(-((V(TRI(1,1),1)-V(TRI(1,2),1))^2)/2);
% % A = sparse(TRI(1,1),TRI(1,2),weight,nodeN,nodeN);
% % weight = 1-exp(-((V(TRI(1,1),1)-V(TRI(1,3),1))^2)/2);
% % A(TRI(1,1),TRI(1,3)) = weight;
% % weight = 1-exp(-((V(TRI(1,2),1)-V(TRI(1,3),1))^2)/2);
% % A(TRI(1,2),TRI(1,3)) = weight;
% % for i = 2:length(TRI)
% %     weight = 1-exp(-((V(TRI(i,1),1)-V(TRI(i,2),1))^2)/2);
% %     A(TRI(i,1),TRI(i,2)) = weight;
% %     weight = 1-exp(-((V(TRI(i,1),1)-V(TRI(i,3),1))^2)/2);
% %     A(TRI(i,1),TRI(i,3)) = weight;
% %     weight = 1-exp(-((V(TRI(i,2),1)-V(TRI(i,3),1))^2)/2);
% %     A(TRI(i,2),TRI(i,3)) = weight;
% % end
% % A = A + A';
% % A_f_P_u_3 = A;
%Adj matrix with PP_3
TRI = delaunay(loc_mat(:,1),loc_mat(:,2));
V = P_f_u_3;
weight = exp(-((V(TRI(1,1),1)-V(TRI(1,2),1))^2)/teta);
A = sparse(TRI(1,1),TRI(1,2),weight,nodeN,nodeN);
weight = exp(-((V(TRI(1,1),1)-V(TRI(1,3),1))^2)/teta);
A(TRI(1,1),TRI(1,3)) = weight;
weight = exp(-((V(TRI(1,2),1)-V(TRI(1,3),1))^2)/teta);
A(TRI(1,2),TRI(1,3)) = weight;
for i = 2:length(TRI)
    weight = exp(-((V(TRI(i,1),1)-V(TRI(i,2),1))^2)/teta);
    A(TRI(i,1),TRI(i,2)) = weight;
    weight = exp(-((V(TRI(i,1),1)-V(TRI(i,3),1))^2)/teta);
    A(TRI(i,1),TRI(i,3)) = weight;
    weight = exp(-((V(TRI(i,2),1)-V(TRI(i,3),1))^2)/teta);
    A(TRI(i,2),TRI(i,3)) = weight;
end
A = A + A';
A_f_PP_u_3 = A;

%Adj matrix with S_1
teta = 100; beta = 1000;
TRI = delaunay(loc_mat(:,1),loc_mat(:,2));
V = S_f_u_1;
weight = exp(-((beta*(V(TRI(1,1),1)-V(TRI(1,2),1)))^2)/teta);
A = sparse(TRI(1,1),TRI(1,2),weight,nodeN,nodeN);
weight = exp(-((beta*(V(TRI(1,1),1)-V(TRI(1,3),1)))^2)/teta);
A(TRI(1,1),TRI(1,3)) = weight;
weight = exp(-((beta*(V(TRI(1,2),1)-V(TRI(1,3),1)))^2)/teta);
A(TRI(1,2),TRI(1,3)) = weight;
for i = 2:length(TRI)
    weight = exp(-((beta*(V(TRI(i,1),1)-V(TRI(i,2),1)))^2)/teta);
    A(TRI(i,1),TRI(i,2)) = weight;
    weight = exp(-((beta*(V(TRI(i,1),1)-V(TRI(i,3),1)))^2)/teta);
    A(TRI(i,1),TRI(i,3)) = weight;
    weight = exp(-((beta*(V(TRI(i,2),1)-V(TRI(i,3),1)))^2)/teta);
    A(TRI(i,2),TRI(i,3)) = weight;
end
A = A + A';
A_f_S_u_1 = A;

%Adj matrix with S_2
TRI = delaunay(loc_mat(:,1),loc_mat(:,2));
V = S_f_u_2;
weight = exp(-((beta*(V(TRI(1,1),1)-V(TRI(1,2),1)))^2)/teta);
A = sparse(TRI(1,1),TRI(1,2),weight,nodeN,nodeN);
weight = exp(-((beta*(V(TRI(1,1),1)-V(TRI(1,3),1)))^2)/teta);
A(TRI(1,1),TRI(1,3)) = weight;
weight = exp(-((beta*(V(TRI(1,2),1)-V(TRI(1,3),1)))^2)/teta);
A(TRI(1,2),TRI(1,3)) = weight;
for i = 2:length(TRI)
    weight = exp(-((beta*(V(TRI(i,1),1)-V(TRI(i,2),1)))^2)/teta);
    A(TRI(i,1),TRI(i,2)) = weight;
    weight = exp(-((beta*(V(TRI(i,1),1)-V(TRI(i,3),1)))^2)/teta);
    A(TRI(i,1),TRI(i,3)) = weight;
    weight = exp(-((beta*(V(TRI(i,2),1)-V(TRI(i,3),1)))^2)/teta);
    A(TRI(i,2),TRI(i,3)) = weight;
end
A = A + A';
A_f_S_u_2 = A;

%Adj matrix with S_3
TRI = delaunay(loc_mat(:,1),loc_mat(:,2));
V = S_f_u_3;
weight = exp(-((beta*(V(TRI(1,1),1)-V(TRI(1,2),1)))^2)/teta);
A = sparse(TRI(1,1),TRI(1,2),weight,nodeN,nodeN);
weight = exp(-((beta*(V(TRI(1,1),1)-V(TRI(1,3),1)))^2)/teta);
A(TRI(1,1),TRI(1,3)) = weight;
weight = exp(-((beta*(V(TRI(1,2),1)-V(TRI(1,3),1)))^2)/teta);
A(TRI(1,2),TRI(1,3)) = weight;
for i = 2:length(TRI)
    weight = exp(-((beta*(V(TRI(i,1),1)-V(TRI(i,2),1)))^2)/teta);
    A(TRI(i,1),TRI(i,2)) = weight;
    weight = exp(-((beta*(V(TRI(i,1),1)-V(TRI(i,3),1)))^2)/teta);
    A(TRI(i,1),TRI(i,3)) = weight;
    weight = exp(-((beta*(V(TRI(i,2),1)-V(TRI(i,3),1)))^2)/teta);
    A(TRI(i,2),TRI(i,3)) = weight;
end
A = A + A';
A_f_S_u_3 = A;

%% Graph generation of G_PPD
load myImageFR11u.mat;
myImage = myImageFR11u;
loc_mat = locMatFromMatrix(myImage);
loc_mat(loc_mat(:,3)==0,:) = [];
myImageVector = loc_mat(:,3);
nodeN = length(loc_mat);
A_f_PPD_u = zeros(nodeN,nodeN);
teta1 = 2; teta2 = 0.5;
for i = 1:nodeN
    for j = i+1:nodeN
       weight = ((exp(-norm((P_f_u_1(i,1)-P_f_u_1(j,1)))^2/teta1))+9*(exp(-norm((loc_mat(i,1:2)-loc_mat(j,1:2)))^2/teta2)))/10;
       if weight<0.0001
           weight = 0;
       end
       A_f_PPD_u(i,j) = weight;
    end 
end
A_f_PPD_u = A_f_PPD_u+A_f_PPD_u';
single_nodes = find(sum(sign((A_f_PPD_u)))==0);
A_f_PPD_u(:,single_nodes) = [];
A_f_PPD_u(single_nodes,:) = [];

%% Graph analysis
A = cell(13,2);
A{1,1} = A_f_T_u;%A{2,1} = A_f_P_u_1;A{3,1} = A_f_P_u_2;A{4,1} = A_f_P_u_3;
A{8,1} = A_f_K_u;A{5,1} = A_f_S_u_1;A{6,1} = A_f_S_u_2;A{7,1} = A_f_S_u_3;
A{10,1} = A_f_PP_u_1;A{11,1} = A_f_PP_u_2;A{12,1} = A_f_PP_u_3;
A{13,1} = A_f_PPD_u;

A{1,2} = 'A_f_T_u';%A{2,2} = 'A_f_P_u_1';A{3,2} = 'A_f_P_u_2';A{4,2} = 'A_f_P_u_3';
A{8,2} = 'A_f_K_u';A{5,2} = 'A_f_S_u_1';A{6,2} = 'A_f_S_u_2';A{7,2} = 'A_f_S_u_3';
A{10,2} = 'A_f_PP_u_1';A{11,2} = 'A_f_PP_u_2';A{12,2} = 'A_f_PP_u_3';
A{13,2} = 'A_f_PPD_u';

for i = [1,5,6,7,8,10,11,12,13]
    tempA = A{i,1};
    tempL = diag(sum(tempA))-tempA;
    [tempX,templamda] = eig(full(tempL));
    save(['lamda_' A{i,2}],'templamda');
    figure;
    scatter(1:length(templamda),sum(templamda));
    title(['Eigenvalues of Laplacian of ' A{i,2}]);
    xlabel('increasing order of Eigenvalue');
    ylabel('magnitude');
    saveas(gcf, ['D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\' A{i,2}], 'eps')
    tempL = sqrt(inv(diag(sum(tempA))))*tempL*sqrt(inv(diag(sum(tempA))));
    [tempX,templamda] = eig(full(tempL));
    save(['lamda_N_' A{i,2}],'templamda');
    figure;
    scatter(1:length(templamda),sort(sum(templamda)));
    title(['Eigenvalues of normalized Laplacian of ' A{i,2}]);
    xlabel('increasing order of Eigenvalue');
    ylabel('magnitude');
    saveas(gcf, ['D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\N_' A{i,2}], 'eps')
end

%% Spectrum Analysis (zero crossing)
A = cell(13,2);
A{1,1} = A_f_T_u;%A{2,1} = A_f_P_u_1;A{3,1} = A_f_P_u_2;A{4,1} = A_f_P_u_3;
A{8,1} = A_f_K_u;A{5,1} = A_f_S_u_1;A{6,1} = A_f_S_u_2;A{7,1} = A_f_S_u_3;
A{10,1} = A_f_PP_u_1;A{11,1} = A_f_PP_u_2;A{12,1} = A_f_PP_u_3;
A{13,1} = A_f_PPD_u;

A{1,2} = 'A_f_T_u';%A{2,2} = 'A_f_P_u_1';A{3,2} = 'A_f_P_u_2';A{4,2} = 'A_f_P_u_3';
A{8,2} = 'A_f_K_u';A{5,2} = 'A_f_S_u_1';A{6,2} = 'A_f_S_u_2';A{7,2} = 'A_f_S_u_3';
A{10,2} = 'A_f_PP_u_1';A{11,2} = 'A_f_PP_u_2';A{12,2} = 'A_f_PP_u_3';
A{13,2} = 'A_f_PPD_u';

for i = [1,5,6,7,8,10,11,12,13]
    tempA = A{i,1};
    tempL = diag(sum(tempA))-tempA;
    [tempX,templamda] = eig(full(tempL));
    Z = zeros(length(tempA),1);
    [temp1,temp2]=find(tempA~=0);
    for j = 1:length(tempX)
        for k = 1:length(temp1)
            if  tempX(temp1(k),j)*tempX(temp2(k),j)<0
                Z(j,1) = Z(j,1) + 1;
                [k,j]
            end
        end
    end
    save(['ZC_' A{i,2}],'Z');
    figure;
    scatter(1:length(templamda),Z);
    title(['Zero crossing of Laplacian eig vectors of ' A{i,2}]);
    xlabel('increasing order of Eigenvalue');
    ylabel('Number of Zero Crossing');
    saveas(gcf, ['D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\ZC_' A{i,2}], 'eps')
end

%% Spectrum Analysis (total variation)
A = cell(13,2);
A{1,1} = A_f_T_u;%A{2,1} = A_f_P_u_1;A{3,1} = A_f_P_u_2;A{4,1} = A_f_P_u_3;
A{8,1} = A_f_K_u;A{5,1} = A_f_S_u_1;A{6,1} = A_f_S_u_2;A{7,1} = A_f_S_u_3;
A{10,1} = A_f_PP_u_1;A{11,1} = A_f_PP_u_2;A{12,1} = A_f_PP_u_3;
A{13,1} = A_f_PPD_u;

A{1,2} = 'A_f_T_u';%A{2,2} = 'A_f_P_u_1';A{3,2} = 'A_f_P_u_2';A{4,2} = 'A_f_P_u_3';
A{8,2} = 'A_f_K_u';A{5,2} = 'A_f_S_u_1';A{6,2} = 'A_f_S_u_2';A{7,2} = 'A_f_S_u_3';
A{10,2} = 'A_f_PP_u_1';A{11,2} = 'A_f_PP_u_2';A{12,2} = 'A_f_PP_u_3';
A{13,2} = 'A_f_PPD_u';

for i = [1,5,6,7,8,10,11,12,13]
    tempA = A{i,1};
    tempL = diag(sum(tempA))-tempA;
    [tempX,templamda] = eig(full(tempL));
    TV_eig_v = [];
    for k = 1:length(tempX)
        TV_eig_v = [TV_eig_v norm(tempX(:,k)-(tempA*tempX(:,k))/max(max(abs(templamda))))/norm(tempX(:,k))]; 
    end
    save(['TV_' A{i,2}],'TV_eig_v');
    figure;
    scatter(1:length(templamda),TV_eig_v);
    title(['Total variation of Laplacian eig vectors of ' A{i,2}]);
    xlabel('increasing order of Eigenvalue');
    ylabel('Total Variation');
    saveas(gcf, ['D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\TV_' A{i,2}], 'eps')
end

% %% patch draw
% [v,c]=voronoin([loc_mat_for_area(:,2) loc_mat_for_area(:,1)]/10); 
% figure;
% for i = 1:length(c) 
%     if all(c{i}~=1)   % If at least one of the indices is 1, 
%                       % then it is an open region and we can't 
%                       % patch that.
%         patch(v(c{i},1),v(c{i},2),(loc_mat_for_area(i,3))); % use color i.
%     end
% end
% axis([0.5 20 0.5 20]);
% set(gca,'YDir','reverse');
% axis off;