clear all; close all;

load model1.mat

model = model1+1500;

loc_mat = locMatFromMatrix(model);
myImageVector = loc_mat(:,3);
nodeN = length(loc_mat);
myImageNode = (1:nodeN)';
drawImage(loc_mat);
%%
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

% graph based on transmissibility G_T (to write conn.in file)
upperTriangLinks = [cind1,nind1];
lowerTriangLinks = [nind1,cind1];
linkWeight = zeros(length(upperTriangLinks),1);
for i = 1:length(upperTriangLinks)
    weight = (myImageVector(upperTriangLinks(i,1))*myImageVector(upperTriangLinks(i,2)))/(myImageVector(upperTriangLinks(i,1))+ myImageVector(upperTriangLinks(i,2)));
    linkWeight(i) = 10*weight; %gridblock is 1*1*5
end
linkWeight = [linkWeight;linkWeight];
A_T = sparse(upperTriangLinks,lowerTriangLinks,linkWeight,nodeN,nodeN);

%% writing the conn file
A_T_conn = triu(A_T);
counter0 = 0;
fileID = fopen('conn_temp.in','w');
for i = 1 : length(A_T_conn)
    J = find(A_T_conn(i,:));
    for j = 1 : length(J)
        counter0 = counter0 +1;
        fprintf(fileID,'%4d\t %4d\t %f\n',[i-1 J(j)-1 full(A_T_conn(i,J(j)))]);
    end
end
fclose(fileID);
text = fileread('conn_temp.in');
fileID = fopen('D:\Dropbox\USC - Amin\matlab\FBM\GPRS\Big Fine Scale\conn.in','w');
fprintf(fileID,[num2str(counter0) '\n']);
fprintf(fileID,text);
fclose(fileID);

%writing the volume file
vol = 5*ones(length(A_T),1);
fileID = fopen('D:\Dropbox\USC - Amin\matlab\FBM\GPRS\Big Fine Scale\volume.in','w');
for i = 1:length(A_T)
    fprintf(fileID,'%f\n',vol(i)); 
end
fclose(fileID);

%% bipartition
A = A_T;

F = randi(2,nodeN,1); %random assignment, 1 is even 2 is odd
F(1) = 1; F(nodeN) = 1; %location of injector and producer

max_iter = 1000000;
for i = 1:max_iter
    nodeIndex = 1+randi(nodeN-2,1,1);
    neighborNodes = find(A(nodeIndex,:)~=0)';
    neighborNodes_odd = neighborNodes(F(neighborNodes)==2);
    neighborNodes_even = neighborNodes(F(neighborNodes)==1);
    path_weight = [];

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

cool_mat_0 = [loc_mat F (1:nodeN)'];

%% rearranging f and A
f = cool_mat_0(:,3);
even_index = cool_mat_0(cool_mat_0(:,4)==1,5);
odd_index = cool_mat_0(cool_mat_0(:,4)==2,5);
f_odd = f(odd_index);
f_even = f(even_index);
f_tilde = [f_odd;f_even];

A = A_T;
A_tilde = A(:,[odd_index;even_index]');
A_tilde = A_tilde([odd_index;even_index],:);

J = A_tilde(1:length(odd_index),length(odd_index)+1:end);
K = A_tilde(length(odd_index)+1:end,1:length(odd_index));

D = f_odd - (sum(J,2).^(-1)).*(J*f_even);
for i = 1:length(D)
   if isnan(D(i))
       D(i) = 0;
   end
end

%% removing nodes
epsilon = 300; % this can be determined more intuitively
high_pass_nodes = odd_index(abs(D)>epsilon);
new_F = F;
new_F(high_pass_nodes) = 1;
new_F(1:256) = 1;
new_F(65281:end) = 1;
new_F(1:256:65536,:) = 1;
new_F(64:256:65536,:) = 1;

cool_mat_0 = [loc_mat new_F (1:nodeN)'];

loc_mat_draw = loc_mat;
loc_mat_draw(find(new_F==2),:) = [];
% drawImage(loc_mat_draw);

%% rearranging f and A
even_index = cool_mat_0(cool_mat_0(:,4)==1,5);
odd_index = cool_mat_0(cool_mat_0(:,4)==2,5);
f_odd = f(odd_index);
f_even = f(even_index);
f_tilde = [f_odd;f_even];

A = A_T;
A_tilde = A(:,[odd_index;even_index]');
A_tilde = A_tilde([odd_index;even_index],:);

J = A_tilde(1:length(odd_index),length(odd_index)+1:end);
K = A_tilde(length(odd_index)+1:end,1:length(odd_index));

% lifting
D = f_odd - (sum(J,2).^(-1)).*(J*f_even);
for i = 1:length(D)
   if isnan(D(i))
       D(i) = 0;
   end
end
S = f_even + (sum(K,2).^(-1)).*(K*D);

for i = 1:length(S)
   if isnan(S(i))
       S(i) = f_even(i);
   end
end

% inverse lifting
upsilon = 300;
D_modified = D;
D_modified(abs(D) <= upsilon) = 0;
f_even_reconstructed = S - (sum(K,2).^(-1)).*(K*D_modified);

for i = 1:length(f_even_reconstructed)
   if isnan(f_even_reconstructed(i))
       f_even_reconstructed(i) = S(i);
   end
end

cool_mat_1 = cool_mat_0;
cool_mat_1(find(new_F==2),:) = [];
cool_mat_1(:,3) = f_even_reconstructed; %later add the current node index to this cool_mat
loc_mat_draw = cool_mat_1(:,1:3);
% drawImage(loc_mat_draw);

%% bipartition 2 begins here
loc_mat = cool_mat_1(:,1:3);
myImageVector = loc_mat(:,3);
nodeN = length(loc_mat);
myImageNode = (1:nodeN)';
% drawImage(loc_mat);

%%
loc_mat_for_area = loc_mat(:,1:2);
lower_bound = loc_mat_for_area(loc_mat_for_area(:,2)<2,:);
lower_bound = lower_bound - [zeros(length(lower_bound),1) ones(length(lower_bound),1)];

upper_bound = loc_mat_for_area(loc_mat_for_area(:,2)>255,:);
upper_bound = upper_bound + [zeros(length(upper_bound),1) ones(length(upper_bound),1)];

left_bound = loc_mat_for_area(loc_mat_for_area(:,1)<2,:);
left_bound = left_bound - [ones(length(left_bound),1) zeros(length(left_bound),1)];

right_bound = loc_mat_for_area(loc_mat_for_area(:,1)>255,:);
right_bound = right_bound + [ones(length(right_bound),1) zeros(length(right_bound),1)];

loc_mat_for_area = [loc_mat_for_area;lower_bound;upper_bound;left_bound;right_bound];
loc_mat_for_area = [loc_mat_for_area;[0 0];[257 257];[0 257];[257 0]];
loc_mat_for_area = [loc_mat_for_area [loc_mat(:,3);zeros(length(loc_mat_for_area)-length(loc_mat),1)]];
nodeN_modified = length(loc_mat_for_area);

%%
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

%% Adj matrix with transmissibility
[v,c]=voronoin([loc_mat_for_area(:,1),loc_mat_for_area(:,2)]);
h = 5;                        %reservoir thickness
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
            c0 = (v(c1,:)+v(c2,:))/2;
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
        A(i,neighborNodesI(j)) = weight;
    end
end

%% finding the volume of the patch
for i = 1 : size(c ,1)
    ind = c{i}';
    area_i = polyarea( v(ind,1) , v(ind,2) );
    if area_i>0 
        tess_area(i,1)=h*area_i;
    else
        area_i = 0;
        tess_area(i,1)=h*area_i;
    end
end

A_T = A;
A_T(nodeN+1:end,:) = [];
A_T(:,nodeN+1:end) = [];

%% writing the conn file
A_T_conn = triu(A_T);
counter1 = 0;
fileID = fopen('conn_temp.in','w');
for i = 1 : length(A_T_conn)
    J = find(A_T_conn(i,:));
    for j = 1 : length(J)
        counter1 = counter1 +1;
        fprintf(fileID,'%4d\t %4d\t %f\n',[i-1 J(j)-1 full(A_T_conn(i,J(j)))]);
    end
end
fclose(fileID);
text = fileread('conn_temp.in');
fileID = fopen('D:\Dropbox\USC - Amin\matlab\FBM\GPRS\Big Coarse Scale 1\conn.in','w');
fprintf(fileID,[num2str(counter1) '\n']);
fprintf(fileID,text);
fclose(fileID);

%writing the volume file
fileID = fopen('D:\Dropbox\USC - Amin\matlab\FBM\GPRS\Big Coarse Scale 1\volume.in','w');
for i = 1:nodeN
    fprintf(fileID,'%f\n',tess_area(i));
end
fclose(fileID);

%% bipartition
A = A_T;

F = randi(2,nodeN,1); %random assignment, 1 is even 2 is odd
F(1) = 1; F(nodeN) = 1; %location of injector and producer

max_iter = 1000000;
for i = 1:max_iter
    nodeIndex = 1+randi(nodeN-2,1,1);
    neighborNodes = find(A(nodeIndex,:)~=0)';
    neighborNodes_odd = neighborNodes(F(neighborNodes)==2);
    neighborNodes_even = neighborNodes(F(neighborNodes)==1);
    path_weight = [];

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

cool_mat_1 = [loc_mat F (1:nodeN)'];

%% rearranging f and A
f = cool_mat_1(:,3);
even_index = cool_mat_1(cool_mat_1(:,4)==1,5);
odd_index = cool_mat_1(cool_mat_1(:,4)==2,5);
f_odd = f(odd_index);
f_even = f(even_index);
f_tilde = [f_odd;f_even];

A = A_T;
A_tilde = A(:,[odd_index;even_index]');
A_tilde = A_tilde([odd_index;even_index],:);

J = A_tilde(1:length(odd_index),length(odd_index)+1:end);
K = A_tilde(length(odd_index)+1:end,1:length(odd_index));

D = f_odd - (sum(J,2).^(-1)).*(J*f_even);
for i = 1:length(D)
   if isnan(D(i))
       D(i) = 0;
   end
end

%% removing nodes
epsilon = 300; % this can be determined more intuitively
high_pass_nodes = odd_index(abs(D)>epsilon);
new_F = F;
new_F(high_pass_nodes) = 1;
new_F(1:256) = 1;
new_F(loc_mat(1,:)==256,:) = 1;
new_F(loc_mat(:,2)==1,:) = 1;
new_F(loc_mat(:,2)==256,:) = 1;

cool_mat_1 = [loc_mat new_F (1:nodeN)'];

loc_mat_draw = loc_mat;
loc_mat_draw(find(new_F==2),:) = [];
% drawImage(loc_mat_draw);

%% rearranging f and A
even_index = cool_mat_1(cool_mat_1(:,4)==1,5);
odd_index = cool_mat_1(cool_mat_1(:,4)==2,5);
f_odd = f(odd_index);
f_even = f(even_index);
f_tilde = [f_odd;f_even];

A = A_T;
A_tilde = A(:,[odd_index;even_index]');
A_tilde = A_tilde([odd_index;even_index],:);

J = A_tilde(1:length(odd_index),length(odd_index)+1:end);
K = A_tilde(length(odd_index)+1:end,1:length(odd_index));

% lifting
D = f_odd - (sum(J,2).^(-1)).*(J*f_even);
for i = 1:length(D)
   if isnan(D(i))
       D(i) = 0;
   end
end
S = f_even + (sum(K,2).^(-1)).*(K*D);

for i = 1:length(S)
   if isnan(S(i))
       S(i) = f_even(i);
   end
end

% inverse lifting
upsilon = 300;
D_modified = D;
D_modified(abs(D) <= upsilon) = 0;
f_even_reconstructed = S - (sum(K,2).^(-1)).*(K*D_modified);

for i = 1:length(f_even_reconstructed)
   if isnan(f_even_reconstructed(i))
       f_even_reconstructed(i) = S(i);
   end
end

cool_mat_2 = cool_mat_1;
cool_mat_2(find(new_F==2),:) = [];
cool_mat_2(:,3) = f_even_reconstructed; %later add the current node index to this cool_mat
loc_mat_draw = cool_mat_2(:,1:3);
% drawImage(loc_mat_draw);

%% bipartition 3 begins here
loc_mat = cool_mat_2(:,1:3);
myImageVector = loc_mat(:,3);
nodeN = length(loc_mat);
myImageNode = (1:nodeN)';
% drawImage(loc_mat);
3
%%
loc_mat_for_area = loc_mat(:,1:2);
lower_bound = loc_mat_for_area(loc_mat_for_area(:,2)<2,:);
lower_bound = lower_bound - [zeros(length(lower_bound),1) ones(length(lower_bound),1)];

upper_bound = loc_mat_for_area(loc_mat_for_area(:,2)>255,:);
upper_bound = upper_bound + [zeros(length(upper_bound),1) ones(length(upper_bound),1)];

left_bound = loc_mat_for_area(loc_mat_for_area(:,1)<2,:);
left_bound = left_bound - [ones(length(left_bound),1) zeros(length(left_bound),1)];

right_bound = loc_mat_for_area(loc_mat_for_area(:,1)>255,:);
right_bound = right_bound + [ones(length(right_bound),1) zeros(length(right_bound),1)];

loc_mat_for_area = [loc_mat_for_area;lower_bound;upper_bound;left_bound;right_bound];
loc_mat_for_area = [loc_mat_for_area;[0 0];[257 257];[0 257];[257 0]];
loc_mat_for_area = [loc_mat_for_area [loc_mat(:,3);zeros(length(loc_mat_for_area)-length(loc_mat),1)]];
nodeN_modified = length(loc_mat_for_area);

%%
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
h = 5;                        %reservoir thickness
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
            c0 = (v(c1,:)+v(c2,:))/2;
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
        A(i,neighborNodesI(j)) = weight;
    end
end

%finding the volume of the patch
for i = 1 : size(c ,1)
    ind = c{i}';
    area_i = polyarea( v(ind,1) , v(ind,2) );
    if area_i>0 
        tess_area(i,1)=h*area_i;
    else
        area_i = 0;
        tess_area(i,1)=h*area_i;
    end
end

A_T = A;
A_T(nodeN+1:end,:) = [];
A_T(:,nodeN+1:end) = [];

%writing the conn file
A_T_conn = triu(A_T);
counter1 = 0;
fileID = fopen('conn_temp.in','w');
for i = 1 : length(A_T_conn)
    J = find(A_T_conn(i,:));
    for j = 1 : length(J)
        counter1 = counter1 +1;
        fprintf(fileID,'%4d\t %4d\t %f\n',[i-1 J(j)-1 full(A_T_conn(i,J(j)))]);
    end
end
fclose(fileID);
text = fileread('conn_temp.in');
fileID = fopen('D:\Dropbox\USC - Amin\matlab\FBM\GPRS\Big Coarse Scale 2\conn.in','w');
fprintf(fileID,[num2str(counter1) '\n']);
fprintf(fileID,text);
fclose(fileID);

%writing the volume file
fileID = fopen('D:\Dropbox\USC - Amin\matlab\FBM\GPRS\Big Coarse Scale 2\volume.in','w');
for i = 1:nodeN
    fprintf(fileID,'%f\n',tess_area(i));
end
fclose(fileID);

%% bipartition
A = A_T;

F = randi(2,nodeN,1); %random assignment, 1 is even 2 is odd
F(1) = 1; F(nodeN) = 1; %location of injector and producer

max_iter = 1000000;
for i = 1:max_iter
    nodeIndex = 1+randi(nodeN-2,1,1);
    neighborNodes = find(A(nodeIndex,:)~=0)';
    neighborNodes_odd = neighborNodes(F(neighborNodes)==2);
    neighborNodes_even = neighborNodes(F(neighborNodes)==1);
    path_weight = [];

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

cool_mat_2 = [loc_mat F (1:nodeN)'];

%% rearranging f and A
f = cool_mat_2(:,3);
even_index = cool_mat_2(cool_mat_2(:,4)==1,5);
odd_index = cool_mat_2(cool_mat_2(:,4)==2,5);
f_odd = f(odd_index);
f_even = f(even_index);
f_tilde = [f_odd;f_even];

A = A_T;
A_tilde = A(:,[odd_index;even_index]');
A_tilde = A_tilde([odd_index;even_index],:);

J = A_tilde(1:length(odd_index),length(odd_index)+1:end);
K = A_tilde(length(odd_index)+1:end,1:length(odd_index));

D = f_odd - (sum(J,2).^(-1)).*(J*f_even);
for i = 1:length(D)
   if isnan(D(i))
       D(i) = 0;
   end
end

%% removing nodes
epsilon = 300; % this can be determined more intuitively
high_pass_nodes = odd_index(abs(D)>epsilon);
new_F = F;
new_F(high_pass_nodes) = 1;
new_F(1:256) = 1;
new_F(loc_mat(1,:)==256,:) = 1;
new_F(loc_mat(:,2)==1,:) = 1;
new_F(loc_mat(:,2)==256,:) = 1;

cool_mat_2 = [loc_mat new_F (1:nodeN)'];

loc_mat_draw = loc_mat;
loc_mat_draw(find(new_F==2),:) = [];
% drawImage(loc_mat_draw);

%% rearranging f and A
even_index = cool_mat_2(cool_mat_2(:,4)==1,5);
odd_index = cool_mat_2(cool_mat_2(:,4)==2,5);
f_odd = f(odd_index);
f_even = f(even_index);
f_tilde = [f_odd;f_even];

A = A_T;
A_tilde = A(:,[odd_index;even_index]');
A_tilde = A_tilde([odd_index;even_index],:);

J = A_tilde(1:length(odd_index),length(odd_index)+1:end);
K = A_tilde(length(odd_index)+1:end,1:length(odd_index));

% lifting
D = f_odd - (sum(J,2).^(-1)).*(J*f_even);
for i = 1:length(D)
   if isnan(D(i))
       D(i) = 0;
   end
end
S = f_even + (sum(K,2).^(-1)).*(K*D);

for i = 1:length(S)
   if isnan(S(i))
       S(i) = f_even(i);
   end
end

% inverse lifting
upsilon = 300;
D_modified = D;
D_modified(abs(D) < upsilon) = 0;
f_even_reconstructed = S - (sum(K,2).^(-1)).*(K*D_modified);

for i = 1:length(f_even_reconstructed)
   if isnan(f_even_reconstructed(i))
       f_even_reconstructed(i) = S(i);
   end
end

cool_mat_3 = cool_mat_2;
cool_mat_3(find(new_F==2),:) = [];
cool_mat_3(:,3) = f_even_reconstructed; %later add the current node index to this cool_mat
loc_mat_draw = cool_mat_3(:,1:3);
% drawImage(loc_mat_draw);

%% bipartition 3 begins here
loc_mat = cool_mat_3(:,1:3);
myImageVector = loc_mat(:,3);
nodeN = length(loc_mat);
myImageNode = (1:nodeN)';
% drawImage(loc_mat);

%%
loc_mat_for_area = loc_mat(:,1:2);
lower_bound = loc_mat_for_area(loc_mat_for_area(:,2)<2,:);
lower_bound = lower_bound - [zeros(length(lower_bound),1) ones(length(lower_bound),1)];

upper_bound = loc_mat_for_area(loc_mat_for_area(:,2)>255,:);
upper_bound = upper_bound + [zeros(length(upper_bound),1) ones(length(upper_bound),1)];

left_bound = loc_mat_for_area(loc_mat_for_area(:,1)<2,:);
left_bound = left_bound - [ones(length(left_bound),1) zeros(length(left_bound),1)];

right_bound = loc_mat_for_area(loc_mat_for_area(:,1)>255,:);
right_bound = right_bound + [ones(length(right_bound),1) zeros(length(right_bound),1)];

loc_mat_for_area = [loc_mat_for_area;lower_bound;upper_bound;left_bound;right_bound];
loc_mat_for_area = [loc_mat_for_area;[0 0];[257 257];[0 257];[257 0]];
loc_mat_for_area = [loc_mat_for_area [loc_mat(:,3);zeros(length(loc_mat_for_area)-length(loc_mat),1)]];
nodeN_modified = length(loc_mat_for_area);

%%
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
h = 5;                        %reservoir thickness
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
            c0 = (v(c1,:)+v(c2,:))/2;
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
        A(i,neighborNodesI(j)) = weight;
    end
end

%finding the volume of the patch
for i = 1 : size(c ,1)
    ind = c{i}';
    area_i = polyarea( v(ind,1) , v(ind,2) );
    if area_i>0 
        tess_area(i,1)=h*area_i;
    else
        area_i = 0;
        tess_area(i,1)=h*area_i;
    end
end

A_T = A;
A_T(nodeN+1:end,:) = [];
A_T(:,nodeN+1:end) = [];

%writing the conn file
A_T_conn = triu(A_T);
counter1 = 0;
fileID = fopen('conn_temp.in','w');
for i = 1 : length(A_T_conn)
    J = find(A_T_conn(i,:));
    for j = 1 : length(J)
        counter1 = counter1 +1;
        fprintf(fileID,'%4d\t %4d\t %f\n',[i-1 J(j)-1 full(A_T_conn(i,J(j)))]);
    end
end
fclose(fileID);
text = fileread('conn_temp.in');
fileID = fopen('D:\Dropbox\USC - Amin\matlab\FBM\GPRS\Big Coarse Scale 3\conn.in','w');
fprintf(fileID,[num2str(counter1) '\n']);
fprintf(fileID,text);
fclose(fileID);

%writing the volume file
fileID = fopen('D:\Dropbox\USC - Amin\matlab\FBM\GPRS\Big Coarse Scale 3\volume.in','w');
for i = 1:nodeN
    fprintf(fileID,'%f\n',tess_area(i));
end
fclose(fileID);