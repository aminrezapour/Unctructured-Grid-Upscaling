% this function works based on modelFR11.dat and
% resultFR11.rwo 1,2,3. Note that I didn't write
% a code for generating the dat file, so it is
% expected to import rwo files if you wish to 
% change the model
% clear all;
% close all;

%% Graph Generation G
myImage = 10*ones(40,40);
myImage(36,1:19) = 5000;
myImage(30:40,10) = 5000;
myImage(5:25,30) = 5000;
loc_mat = locMatFromMatrix(myImage);
myImageVector = loc_mat(:,3);
nodeN = length(loc_mat);
myImageNode = (1:nodeN)'; %indexing all the nodes from 1 to N^2

%sunil's
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = sqrt(nodeN);
dim = [N N];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[alli,allj]=find(ones(dim));%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rectanglar links%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ci=[alli;alli];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cj=[allj;allj];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ni=[alli  ; alli+1];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nj=[allj+1; allj];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prune edges at boundary%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
valid=(ni>=1 & ni<=dim(1) & nj>=1 & nj<=dim(2));%%%%%%%%%%%%%%%%%%%%%%%%%%%
ni=ni(valid);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nj=nj(valid);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ci=ci(valid);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cj=cj(valid);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cind1=dim(1)*(cj-1)+ci;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nind1=dim(1)*(nj-1)+ni;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% graph based on Transmissibility G_T
upperTriangLinks = [cind1,nind1];
lowerTriangLinks = [nind1,cind1];
linkWeight = zeros(length(upperTriangLinks),1);
for i = 1:length(upperTriangLinks)
    weight = (myImageVector(upperTriangLinks(i,1))*myImageVector(upperTriangLinks(i,2)))/(myImageVector(upperTriangLinks(i,1))+ myImageVector(upperTriangLinks(i,2)));
    linkWeight(i) = 10*weight; %gridblock 5x5x10
end
linkWeight = [linkWeight;linkWeight];
A_f_T = sparse(upperTriangLinks,lowerTriangLinks,linkWeight,nodeN,nodeN);


% Graph based on permability G_KK
teta = 5000^2;
upperTriangLinks = [cind1,nind1];
lowerTriangLinks = [nind1,cind1];
linkWeight = zeros(length(upperTriangLinks),1);
for i = 1:length(upperTriangLinks)
    weight = exp(-((myImageVector(upperTriangLinks(i,1))-myImageVector(upperTriangLinks(i,2)))^2)/teta);
    linkWeight(i) = weight;
end
linkWeight = [linkWeight;linkWeight];
A_f_KK = sparse(upperTriangLinks,lowerTriangLinks,linkWeight,nodeN,nodeN);

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
A_f_K = A;


% Graph Generation G_P and G_S, three for each stage
% data import from rwo
data = data_generator_HR11_gridding('resultFR11_1.rwo');
data(:,1:2) = [];data(:,end) = [];
i = 10:10:4580;data = data(i,:)';vector = data(:);
i = 1:1600;P_f_1 = [loc_mat(:,1:2) vector(i)];
i = 1601:3200;S_f_1 = [loc_mat(:,1:2) vector(i)];

data = data_generator_HR11_gridding('resultFR11_2.rwo');
data(:,1:2) = [];data(:,end) = [];
i = 10:10:4580;data = data(i,:)';vector = data(:);
i = 1:1600;P_f_2 = [loc_mat(:,1:2) vector(i)];
i = 1601:3200;S_f_2 = [loc_mat(:,1:2) vector(i)];

data = data_generator_HR11_gridding('resultFR11_3.rwo');
data(:,1:2) = [];data(:,end) = [];
i = 10:10:4580;data = data(i,:)';vector = data(:);
i = 1:1600;P_f_3 = [loc_mat(:,1:2) vector(i)];
i = 1601:3200;S_f_3 = [loc_mat(:,1:2) vector(i)];

%sunil's
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
N = sqrt(nodeN);
dim = [N N];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
[alli,allj]=find(ones(dim));%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% rectanglar links%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ci=[alli;alli];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cj=[allj;allj];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ni=[alli  ; alli+1];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nj=[allj+1; allj];%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% prune edges at boundary%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
valid=(ni>=1 & ni<=dim(1) & nj>=1 & nj<=dim(2));%%%%%%%%%%%%%%%%%%%%%%%%%%%
ni=ni(valid);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nj=nj(valid);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ci=ci(valid);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cj=cj(valid);%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cind1=dim(1)*(cj-1)+ci;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
nind1=dim(1)*(nj-1)+ni;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% graph based on pressure G_P
teta = 2000;
% % upperTriangLinks = [cind1,nind1];
% % lowerTriangLinks = [nind1,cind1];
% % linkWeight = zeros(length(upperTriangLinks),1);
% % for i = 1:length(upperTriangLinks)
% %     weight = 1-exp(-((P_f_1(upperTriangLinks(i,1),3)-P_f_1(upperTriangLinks(i,2),3))^2)/2);
% %     linkWeight(i) = weight;
% % end
% % linkWeight = [linkWeight;linkWeight];
% % A_f_P_1 = sparse(upperTriangLinks,lowerTriangLinks,linkWeight,nodeN,nodeN);
upperTriangLinks = [cind1,nind1];
lowerTriangLinks = [nind1,cind1];
linkWeight = zeros(length(upperTriangLinks),1);
for i = 1:length(upperTriangLinks)
    weight = exp(-((P_f_1(upperTriangLinks(i,1),3)-P_f_1(upperTriangLinks(i,2),3))^2)/teta);
    linkWeight(i) = weight;
end
linkWeight = [linkWeight;linkWeight];
A_f_PP_1 = sparse(upperTriangLinks,lowerTriangLinks,linkWeight,nodeN,nodeN);
%
% % upperTriangLinks = [cind1,nind1];
% % lowerTriangLinks = [nind1,cind1];
% % linkWeight = zeros(length(upperTriangLinks),1);
% % for i = 1:length(upperTriangLinks)
% %     weight = 1-exp(-((P_f_2(upperTriangLinks(i,1),3)-P_f_2(upperTriangLinks(i,2),3))^2)/2);
% %     linkWeight(i) = weight;
% % end
% % linkWeight = [linkWeight;linkWeight];
% % A_f_P_2 = sparse(upperTriangLinks,lowerTriangLinks,linkWeight,nodeN,nodeN);
upperTriangLinks = [cind1,nind1];
lowerTriangLinks = [nind1,cind1];
linkWeight = zeros(length(upperTriangLinks),1);
for i = 1:length(upperTriangLinks)
    weight = exp(-((P_f_2(upperTriangLinks(i,1),3)-P_f_2(upperTriangLinks(i,2),3))^2)/teta);
    linkWeight(i) = weight;
end
linkWeight = [linkWeight;linkWeight];
A_f_PP_2 = sparse(upperTriangLinks,lowerTriangLinks,linkWeight,nodeN,nodeN);
%
% % upperTriangLinks = [cind1,nind1];
% % lowerTriangLinks = [nind1,cind1];
% % linkWeight = zeros(length(upperTriangLinks),1);
% % for i = 1:length(upperTriangLinks)
% %     weight = 1-exp(-((P_f_3(upperTriangLinks(i,1),3)-P_f_3(upperTriangLinks(i,2),3))^2)/2);
% %     linkWeight(i) = weight;
% % end
% % linkWeight = [linkWeight;linkWeight];
% % A_f_P_3 = sparse(upperTriangLinks,lowerTriangLinks,linkWeight,nodeN,nodeN);
upperTriangLinks = [cind1,nind1];
lowerTriangLinks = [nind1,cind1];
linkWeight = zeros(length(upperTriangLinks),1);
for i = 1:length(upperTriangLinks)
    weight = exp(-((P_f_3(upperTriangLinks(i,1),3)-P_f_3(upperTriangLinks(i,2),3))^2)/teta);
    linkWeight(i) = weight;
end
linkWeight = [linkWeight;linkWeight];
A_f_PP_3 = sparse(upperTriangLinks,lowerTriangLinks,linkWeight,nodeN,nodeN);

% Graph based on saturation G_S
teta = 20; beta = 1000;
upperTriangLinks = [cind1,nind1];
lowerTriangLinks = [nind1,cind1];
linkWeight = zeros(length(upperTriangLinks),1);
for i = 1:length(upperTriangLinks)
    weight = exp(-((beta*(S_f_1(upperTriangLinks(i,1),3)-S_f_1(upperTriangLinks(i,2),3)))^2)/teta);
    linkWeight(i) = weight;
end
linkWeight = [linkWeight;linkWeight];
A_f_S_1 = sparse(upperTriangLinks,lowerTriangLinks,linkWeight,nodeN,nodeN);

upperTriangLinks = [cind1,nind1];
lowerTriangLinks = [nind1,cind1];
linkWeight = zeros(length(upperTriangLinks),1);
for i = 1:length(upperTriangLinks)
    weight = exp(-((beta*(S_f_2(upperTriangLinks(i,1),3)-S_f_2(upperTriangLinks(i,2),3)))^2)/teta);
    linkWeight(i) = weight;
end
linkWeight = [linkWeight;linkWeight];
A_f_S_2 = sparse(upperTriangLinks,lowerTriangLinks,linkWeight,nodeN,nodeN);


upperTriangLinks = [cind1,nind1];
lowerTriangLinks = [nind1,cind1];
linkWeight = zeros(length(upperTriangLinks),1);
for i = 1:length(upperTriangLinks)
    weight = exp(-((beta*(S_f_3(upperTriangLinks(i,1),3)-S_f_3(upperTriangLinks(i,2),3)))^2)/teta);
    linkWeight(i) = weight;
end
linkWeight = [linkWeight;linkWeight];
A_f_S_3 = sparse(upperTriangLinks,lowerTriangLinks,linkWeight,nodeN,nodeN);

%% patch draw
[v,c]=voronoin(loc_mat(:,1:2)/10); 
figure;
for i = 1:length(c) 
    if all(c{i}~=1)   % If at least one of the indices is 1, 
                      % then it is an open region and we can't 
                      % patch that.
        patch(v(c{i},1),v(c{i},2),(P_f_1(i,3))); % use color i.
    end
end
saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\tttttest', 'jpg')

% % Graph generation of G_PPD
% myImage = 10*ones(40,40);
% myImage(36,1:19) = 5000;
% myImage(30:40,10) = 5000;
% myImage(5:25,30) = 5000;
% loc_mat = locMatFromMatrix(myImage);
% myImageVector = loc_mat(:,3);
% nodeN = length(loc_mat);
% A_f_PPD = zeros(nodeN,nodeN);
% teta1 = 2; teta2 = 0.5;
% for i = 1:nodeN
%     for j = i+1:nodeN
%        weight = ((exp(-norm((P_f_1(i,3)-P_f_1(j,3)))^2/teta1))+9*(exp(-norm((loc_mat(i,1:2)-loc_mat(j,1:2)))^2/teta2)))/10;
%        if weight<0.05
%            weight = 0;
%        end
%        A_f_PPD(i,j) = weight;
%     end 
% end
% A_f_PPD = A_f_PPD+A_f_PPD';

%% Graph analysis
A = cell(10,2);
A{1,1} = A_f_PP_1;A{2,1} = A_f_PP_2;A{3,1} = A_f_PP_3;% A{2,1} = A_f_P_1;A{3,1} = A_f_P_2;A{4,1} = A_f_P_3;
A{4,1} = A_f_S_1;A{5,1} = A_f_S_2;A{6,1} = A_f_S_3;
A{7,1} = A_f_T;A{8,1} = A_f_KK;A{9,1} = A_f_K;
A{10,1} = sign(A_f_T);
% A{13,1} = A_f_PPD;

A{1,2} = 'A_f_PP_1';A{2,2} = 'A_f_PP_2';A{3,2} = 'A_f_PP_3';
A{4,2} = 'A_f_S_1';A{5,2} = 'A_f_S_2';A{6,2} = 'A_f_S_3';
A{7,2} = 'A_f_T';A{8,2} = 'A_f_KK';A{9,2} = 'A_f_K';% A{2,2} = 'A_f_P_1';A{3,2} = 'A_f_P_2';A{4,2} = 'A_f_P_3';
A{10,2} = 'A_f_D';

for i = 1:10
    tempA = A{i,1};
    tempL = diag(sum(tempA))-tempA;
    [tempX,templamda] = eig(full(tempL));
    save(['lamda_' A{i,2}],'templamda');
    figure;
    scatter(1:length(templamda),sum(templamda));
    title(['Eigenvalues of Laplacian of ' A{i,2}]);
    xlabel('increasing order of Eigenvalue');
    ylabel('magnitude');
%     saveas(gcf, ['D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\' A{i,2}], 'eps')
    tempL = sqrt(inv(diag(sum(tempA))))*tempL*sqrt(inv(diag(sum(tempA))));
    [tempX,templamda] = eig(full(tempL));
    save(['lamda_N_' A{i,2}],'templamda');
    figure;
    scatter(1:length(templamda),sort(sum(templamda)));
    title(['Eigenvalues of normalized Laplacian of ' A{i,2}]);
    xlabel('increasing order of Eigenvalue');
    ylabel('magnitude');
%     saveas(gcf, ['D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\N_' A{i,2}], 'eps')
end

%% Spectrum Analysis (total variation)
A = cell(10,2);
A{1,1} = A_f_PP_1;A{2,1} = A_f_PP_2;A{3,1} = A_f_PP_3;% A{2,1} = A_f_P_1;A{3,1} = A_f_P_2;A{4,1} = A_f_P_3;
A{4,1} = A_f_S_1;A{5,1} = A_f_S_2;A{6,1} = A_f_S_3;
A{7,1} = A_f_T;A{8,1} = A_f_KK;A{9,1} = A_f_K;
A{10,1} = sign(A_f_T);
% A{13,1} = A_f_PPD;

A{1,2} = 'A_f_PP_1';A{2,2} = 'A_f_PP_2';A{3,2} = 'A_f_PP_3';
A{4,2} = 'A_f_S_1';A{5,2} = 'A_f_S_2';A{6,2} = 'A_f_S_3';
A{7,2} = 'A_f_T';A{8,2} = 'A_f_KK';A{9,2} = 'A_f_K';% A{2,2} = 'A_f_P_1';A{3,2} = 'A_f_P_2';A{4,2} = 'A_f_P_3';
A{10,2} = 'A_f_D';

for i = 1:10
    tempA = A{i,1};
    tempL = diag(sum(tempA))-tempA;
    [tempX,templamda] = eig(full(tempL));
    TV_eig_v = [];
    for k = 1:length(tempX)
        TV_eig_v = [TV_eig_v norm(tempX(:,k)-(tempA*tempX(:,k))/max(max(abs(templamda))))/norm(tempX(:,k))]; 
    end
%     save(['TV_' A{i,2}],'TV_eig_v');
    figure;
    scatter(1:length(templamda),TV_eig_v);
    title(['Total variation of Laplacian eig vectors of ' A{i,2}]);
    xlabel('increasing order of Eigenvalue');
    ylabel('Total Variation');
%     saveas(gcf, ['D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\TV_' A{i,2}], 'eps')
end

%% Spectrum Analysis (zero crossing)
A = cell(10,2);
A{1,1} = A_f_PP_1;A{2,1} = A_f_PP_2;A{3,1} = A_f_PP_3;% A{2,1} = A_f_P_1;A{3,1} = A_f_P_2;A{4,1} = A_f_P_3;
A{4,1} = A_f_S_1;A{5,1} = A_f_S_2;A{6,1} = A_f_S_3;
A{7,1} = A_f_T;A{8,1} = A_f_KK;A{9,1} = A_f_K;
A{10,1} = sign(A_f_T);
% A{13,1} = A_f_PPD;

A{1,2} = 'A_f_PP_1';A{2,2} = 'A_f_PP_2';A{3,2} = 'A_f_PP_3';
A{4,2} = 'A_f_S_1';A{5,2} = 'A_f_S_2';A{6,2} = 'A_f_S_3';
A{7,2} = 'A_f_T';A{8,2} = 'A_f_KK';A{9,2} = 'A_f_K';% A{2,2} = 'A_f_P_1';A{3,2} = 'A_f_P_2';A{4,2} = 'A_f_P_3';
A{10,2} = 'A_f_DD';

for i = [8,10]
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
%     figure;
%     scatter(1:length(templamda),Z);
%     title(['Zero crossing of Laplacian eig vectors of ' A{i,2}]);
%     xlabel('increasing order of Eigenvalue');
%     ylabel('Number of Zero Crossing');
%     saveas(gcf, ['D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\ZC_' A{i,2}], 'eps')
end
