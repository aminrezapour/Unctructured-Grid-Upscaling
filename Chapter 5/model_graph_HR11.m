clear all;
close all;

%%
day1 = '2010 05 01';       %before water break through
day2 = '2010 12 01';       %during water break through
day3 = '2011 05 01';       %after  water break through

% making the cmg model
Nx = 40;Ny = 40;
Nt = Nx*Ny;                 %number of blocks
copyfile('component1.txt','modelHR11.dat');
fileID = fopen('modelHR11.dat','a');
fprintf(fileID,'\n');
for i = 1:Nx
    for j = 1:Ny
        fprintf(fileID,['OUTSRF SPECIAL ' num2str(i) ' ' num2str(j) ' 1 PRES\n']);
        fprintf(fileID,['OUTSRF SPECIAL ' num2str(i) ' ' num2str(j) ' 1 SW\n']);
    end
end
fprintf(fileID,fileread('component2.txt'));
fprintf(fileID,['DATE ' day1 '.00000\n']);
fprintf(fileID,['DATE ' day2 '.00000\n']);
fprintf(fileID,['DATE ' day3 '.00000\n']);
fprintf(fileID,fileread('component3.txt'));
fclose(fileID);

% making rwd files for 3 stages of production
fileID = fopen('resultHR11_1.rwd','w');
fprintf(fileID,'*FILES ''modelHR11.irf''\n');
fprintf(fileID,'*DATE OFF\n');
fprintf(fileID,['*DATES-FOR ''' day1 '''\n']);
fprintf(fileID,'*TABLE-FOR\n');
fprintf(fileID,'\n');
for i = 1:Nx
    for j = 1:Ny
    fprintf(fileID,['*COLUMN-FOR *SPECIAL ''PRES ' num2str(i) ',' num2str(j) ',1 Pressure.''\n']);
    fprintf(fileID,'\n');
    end
end
for i = 1:Nx
    for j = 1:Ny
    fprintf(fileID,['*COLUMN-FOR *SPECIAL ''SW ' num2str(i) ',' num2str(j) ',1 Water Saturation.''\n']);
    fprintf(fileID,'\n');
    end
end
fprintf(fileID,'*TABLE-END');
fclose(fileID);
fileID = fopen('resultHR11_2.rwd','w');
fprintf(fileID,'*FILES ''modelHR11.irf''\n');
fprintf(fileID,'*DATE OFF\n');
fprintf(fileID,['*DATES-FOR ''' day2 '''\n']);
fprintf(fileID,'*TABLE-FOR\n');
fprintf(fileID,'\n');
for i = 1:Nx
    for j = 1:Ny
    fprintf(fileID,['*COLUMN-FOR *SPECIAL ''PRES ' num2str(i) ',' num2str(j) ',1 Pressure.''\n']);
    fprintf(fileID,'\n');
    end
end
for i = 1:Nx
    for j = 1:Ny
    fprintf(fileID,['*COLUMN-FOR *SPECIAL ''SW ' num2str(i) ',' num2str(j) ',1 Water Saturation.''\n']);
    fprintf(fileID,'\n');
    end
end
fprintf(fileID,'*TABLE-END');
fclose(fileID);
fileID = fopen('resultHR11_3.rwd','w');
fprintf(fileID,'*FILES ''modelHR11.irf''\n');
fprintf(fileID,'*DATE OFF\n');
fprintf(fileID,['*DATES-FOR ''' day3 '''\n']);
fprintf(fileID,'*TABLE-FOR\n');
fprintf(fileID,'\n');
for i = 1:Nx
    for j = 1:Ny
    fprintf(fileID,['*COLUMN-FOR *SPECIAL ''PRES ' num2str(i) ',' num2str(j) ',1 Pressure.''\n']);
    fprintf(fileID,'\n');
    end
end
for i = 1:Nx
    for j = 1:Ny
    fprintf(fileID,['*COLUMN-FOR *SPECIAL ''SW ' num2str(i) ',' num2str(j) ',1 Water Saturation.''\n']);
    fprintf(fileID,'\n');
    end
end
fprintf(fileID,'*TABLE-END');
fclose(fileID);

% making the batch file
fileID = fopen('myBatch.bat','w');
fprintf(fileID,'cd\\\n');
fprintf(fileID,'cd C:\\Users\\rezapour.CISOFTN1\\My Documents\\GEM\\2009.13\\TPL\\HR11_FR11_gridding\n');
fprintf(fileID,'(\n');
fprintf(fileID,'echo resultHR11_1.rwd\n');
fprintf(fileID,'echo resultHR11_1.rwo\n');
fprintf(fileID,') | "C:\\Program Files (x86)\\CMG\\BR\\2013.20\\Win_x64\\EXE\\report.exe"\n');
fprintf(fileID,'(\n');
fprintf(fileID,'echo resultHR11_2.rwd\n');
fprintf(fileID,'echo resultHR11_2.rwo\n');
fprintf(fileID,') | "C:\\Program Files (x86)\\CMG\\BR\\2013.20\\Win_x64\\EXE\\report.exe"\n');
fprintf(fileID,'(\n');
fprintf(fileID,'echo resultHR11_3.rwd\n');
fprintf(fileID,'echo resultHR11_3.rwo\n');
fprintf(fileID,') | "C:\\Program Files (x86)\\CMG\\BR\\2013.20\\Win_x64\\EXE\\report.exe"\n');
fclose(fileID);

%% Graph Generation G_T
myImage = ones(40,40);
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

upperTriangLinks = [cind1,nind1];
lowerTriangLinks = [nind1,cind1];
linkWeight = ones(2*length(upperTriangLinks),1);

A_T = sparse(upperTriangLinks,lowerTriangLinks,linkWeight,nodeN,nodeN);

%% Graph Generation G_P and G_S, three for each stage

%data import from rwo
data = data_generator_HR11_gridding('resultHR11_1.rwo');
myImage = ones(40,40);
loc_mat = locMatFromMatrix(myImage);
data(:,1:2) = [];data(:,end) = [];
i = 10:10:4580;data = data(i,:)';vector = data(:);
i = 1:2:3200;P_1 = [loc_mat(:,1:2) vector(i)];
i = 2:2:3200;S_1 = [loc_mat(:,1:2) vector(i)];

data = data_generator_HR11_gridding('resultHR11_2.rwo');
myImage = ones(40,40);
loc_mat = locMatFromMatrix(myImage);
data(:,1:2) = [];data(:,end) = [];
i = 10:10:4580;data = data(i,:)';vector = data(:);
i = 1:2:3200;P_2 = [loc_mat(:,1:2) vector(i)];
i = 2:2:3200;S_2 = [loc_mat(:,1:2) vector(i)];

data = data_generator_HR11_gridding('resultHR11_3.rwo');
myImage = ones(40,40);
loc_mat = locMatFromMatrix(myImage);
data(:,1:2) = [];data(:,end) = [];
i = 10:10:4580;data = data(i,:)';vector = data(:);
i = 1:2:3200;P_3 = [loc_mat(:,1:2) vector(i)];
i = 2:2:3200;S_3 = [loc_mat(:,1:2) vector(i)];

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

% G_P
teta = 2000;
% % upperTriangLinks = [cind1,nind1];
% % lowerTriangLinks = [nind1,cind1];
% % linkWeight = zeros(length(upperTriangLinks),1);
% % for i = 1:length(upperTriangLinks)
% %     weight = 1-exp(-((P_1(upperTriangLinks(i,1),3)-P_1(upperTriangLinks(i,2),3))^2)/2);
% %     linkWeight(i) = weight;
% % end
% % linkWeight = [linkWeight;linkWeight];
% % A_P_1 = sparse(upperTriangLinks,lowerTriangLinks,linkWeight,nodeN,nodeN);
upperTriangLinks = [cind1,nind1];
lowerTriangLinks = [nind1,cind1];
linkWeight = zeros(length(upperTriangLinks),1);
for i = 1:length(upperTriangLinks)
    weight = exp(-((P_1(upperTriangLinks(i,1),3)-P_1(upperTriangLinks(i,2),3))^2)/teta);
    linkWeight(i) = weight;
end
linkWeight = [linkWeight;linkWeight];
A_PP_1 = sparse(upperTriangLinks,lowerTriangLinks,linkWeight,nodeN,nodeN);
% % upperTriangLinks = [cind1,nind1];
% % lowerTriangLinks = [nind1,cind1];
% % linkWeight = zeros(length(upperTriangLinks),1);
% % for i = 1:length(upperTriangLinks)
% %     weight = 1-exp(-((P_2(upperTriangLinks(i,1),3)-P_2(upperTriangLinks(i,2),3))^2)/2);
% %     linkWeight(i) = weight;
% % end
% % linkWeight = [linkWeight;linkWeight];
% % A_P_2 = sparse(upperTriangLinks,lowerTriangLinks,linkWeight,nodeN,nodeN);
upperTriangLinks = [cind1,nind1];
lowerTriangLinks = [nind1,cind1];
linkWeight = zeros(length(upperTriangLinks),1);
for i = 1:length(upperTriangLinks)
    weight = exp(-((P_2(upperTriangLinks(i,1),3)-P_2(upperTriangLinks(i,2),3))^2)/teta);
    linkWeight(i) = weight;
end
linkWeight = [linkWeight;linkWeight];
A_PP_2 = sparse(upperTriangLinks,lowerTriangLinks,linkWeight,nodeN,nodeN);
% % upperTriangLinks = [cind1,nind1];
% % lowerTriangLinks = [nind1,cind1];
% % linkWeight = zeros(length(upperTriangLinks),1);
% % for i = 1:length(upperTriangLinks)
% %     weight = 1-exp(-((P_3(upperTriangLinks(i,1),3)-P_3(upperTriangLinks(i,2),3))^2)/2);
% %     linkWeight(i) = weight;
% % end
% % linkWeight = [linkWeight;linkWeight];
% % A_P_3 = sparse(upperTriangLinks,lowerTriangLinks,linkWeight,nodeN,nodeN);
upperTriangLinks = [cind1,nind1];
lowerTriangLinks = [nind1,cind1];
linkWeight = zeros(length(upperTriangLinks),1);
for i = 1:length(upperTriangLinks)
    weight = exp(-((P_3(upperTriangLinks(i,1),3)-P_3(upperTriangLinks(i,2),3))^2)/teta);
    linkWeight(i) = weight;
end
linkWeight = [linkWeight;linkWeight];
A_PP_3 = sparse(upperTriangLinks,lowerTriangLinks,linkWeight,nodeN,nodeN);

% G_S
teta = 20; beta = 1000;
upperTriangLinks = [cind1,nind1];
lowerTriangLinks = [nind1,cind1];
linkWeight = zeros(length(upperTriangLinks),1);
for i = 1:length(upperTriangLinks)
    weight = exp(-((beta*(S_1(upperTriangLinks(i,1),3)-S_1(upperTriangLinks(i,2),3)))^2)/teta);
    linkWeight(i) = weight;
end
linkWeight = [linkWeight;linkWeight];
A_S_1 = sparse(upperTriangLinks,lowerTriangLinks,linkWeight,nodeN,nodeN);
upperTriangLinks = [cind1,nind1];
lowerTriangLinks = [nind1,cind1];
linkWeight = zeros(length(upperTriangLinks),1);
for i = 1:length(upperTriangLinks)
    weight = exp(-((beta*(S_2(upperTriangLinks(i,1),3)-S_2(upperTriangLinks(i,2),3)))^2)/teta);
    linkWeight(i) = weight;
end
linkWeight = [linkWeight;linkWeight];
A_S_2 = sparse(upperTriangLinks,lowerTriangLinks,linkWeight,nodeN,nodeN);
upperTriangLinks = [cind1,nind1];
lowerTriangLinks = [nind1,cind1];
linkWeight = zeros(length(upperTriangLinks),1);
for i = 1:length(upperTriangLinks)
    weight = exp(-((beta*(S_3(upperTriangLinks(i,1),3)-S_3(upperTriangLinks(i,2),3)))^2)/teta);
    linkWeight(i) = weight;
end
linkWeight = [linkWeight;linkWeight];
A_S_3 = sparse(upperTriangLinks,lowerTriangLinks,linkWeight,nodeN,nodeN);

% %% patch draw
% [v,c]=voronoin(loc_mat(:,1:2)/10); 
% figure;
% for i = 1:length(c) 
%     if all(c{i}~=1)   % If at least one of the indices is 1, 
%                       % then it is an open region and we can't 
%                       % patch that.
%         patch(v(c{i},1),v(c{i},2),100*(S_f_3(i,3))); % use color i.
%     end
% end

%% Graph generation of G_PPD
myImage = ones(40,40);
loc_mat = locMatFromMatrix(myImage);
myImageVector = loc_mat(:,3);
nodeN = length(loc_mat);
A_PPD = zeros(nodeN,nodeN);
teta1 = 2000; teta2 = 2;
for i = 1:nodeN
    for j = i:nodeN
       weight = (exp(-norm((P_1(i,3)-P_1(j,3)))^2/teta1))+(exp(norm((loc_mat(i,1:2)-loc_mat(j,1:2)))^2/teta2));
       if weight<0.2
           weight = 0;
       end
       A_PPD(i,j) = weight;
    end 
end
A_PPD = A_PPD+A_PPD';

%% Graph analysis
A = cell(12,2);
A{1,1} = A_T;%A{2,1} = A_P_1;A{3,1} = A_P_2;A{4,1} = A_P_3;
A{5,1} = A_S_1;A{6,1} = A_S_2;A{7,1} = A_S_3;
A{9,1} = A_PP_1;A{10,1} = A_PP_2;A{11,1} = A_PP_3;
A{12,1} = A_PPD;

A{1,2} = 'A_T';%A{2,2} = 'A_P_1';A{3,2} = 'A_P_2';A{4,2} = 'A_P_3';
A{5,2} = 'A_S_1';A{6,2} = 'A_S_2';A{7,2} = 'A_S_3';
A{9,2} = 'A_PP_1';A{10,2} = 'A_PP_2';A{11,2} = 'A_PP_3';
A{12,2} = 'A_PPD';

for i = 12:length(A)
    tempA = A{i,1};
    tempL = diag(sum(tempA))-tempA;
    [tempX,templamda] = eig(full(tempL));
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
    title(['Eigenvalues of Laplacian of ' A{i,2}]);
    xlabel('increasing order of Eigenvalue');
    ylabel('magnitude');
    saveas(gcf, ['D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\N_' A{i,2}], 'eps')
end

%% Spectrum Analysis (zero crossing)
A = cell(12,2);
A{1,1} = A_T;%A{2,1} = A_P_1;A{3,1} = A_P_2;A{4,1} = A_P_3;
A{5,1} = A_S_1;A{6,1} = A_S_2;A{7,1} = A_S_3;
A{9,1} = A_PP_1;A{10,1} = A_PP_2;A{11,1} = A_PP_3;
A{12,1} = A_PPD;

A{1,2} = 'A_T';%A{2,2} = 'A_P_1';A{3,2} = 'A_P_2';A{4,2} = 'A_P_3';
A{5,2} = 'A_S_1';A{6,2} = 'A_S_2';A{7,2} = 'A_S_3';
A{9,2} = 'A_PP_1';A{10,2} = 'A_PP_2';A{11,2} = 'A_PP_3';
A{12,2} = 'A_PPD';

for i = 9:9;%length(A)
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
A = cell(12,2);
A{1,1} = A_T;%A{2,1} = A_P_1;A{3,1} = A_P_2;A{4,1} = A_P_3;
A{5,1} = A_S_1;A{6,1} = A_S_2;A{7,1} = A_S_3;
A{9,1} = A_PP_1;A{10,1} = A_PP_2;A{11,1} = A_PP_3;
A{12,1} = A_PPD;

A{1,2} = 'A_T';%A{2,2} = 'A_P_1';A{3,2} = 'A_P_2';A{4,2} = 'A_P_3';
A{5,2} = 'A_S_1';A{6,2} = 'A_S_2';A{7,2} = 'A_S_3';
A{9,2} = 'A_PP_1';A{10,2} = 'A_PP_2';A{11,2} = 'A_PP_3';
A{12,2} = 'A_PPD';

for i = 1:length(A)
    tempA = A{i,1};
    tempL = diag(sum(tempA))-tempA;
    [tempX,templamda] = eig(full(tempL));
    TV_eig_v = [];
    for k = 1:length(tempX)
        TV_eig_v = [TV_eig_v norm(tempX(:,k)-(tempA*tempX(:,k))/max(max(abs(templamda))))/norm(tempX(:,k))]; 
    end
    figure;
    scatter(1:length(templamda),TV_eig_v);
    title(['Total variation of Laplacian eig vectors of ' A{i,2}]);
    xlabel('increasing order of Eigenvalue');
    ylabel('Total Variation');
    saveas(gcf, ['D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\TV_' A{i,2}], 'eps')
end