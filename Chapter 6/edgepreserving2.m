clear all
close all

load cool_mat_1;
loc_mat = cool_mat_1(:,[1 2 5]);
loc_mat(:,1:2) = loc_mat(:,1:2);
myImageVector = loc_mat(:,3);
nodeN = length(loc_mat);
myImageNode = (1:nodeN)';
loc_mat(:,1:2) = loc_mat(:,1:2);
drawImage(loc_mat);
%%
loc_mat_for_area = loc_mat(:,1:2);
lower_bound = loc_mat_for_area(loc_mat_for_area(:,2)<2,:);
lower_bound = lower_bound - [zeros(length(lower_bound),1) ones(length(lower_bound),1)];

upper_bound = loc_mat_for_area(loc_mat_for_area(:,2)>39,:);
upper_bound = upper_bound + [zeros(length(upper_bound),1) ones(length(upper_bound),1)];

left_bound = loc_mat_for_area(loc_mat_for_area(:,1)<2,:);
left_bound = left_bound - [ones(length(left_bound),1) zeros(length(left_bound),1)];

right_bound = loc_mat_for_area(loc_mat_for_area(:,1)>39,:);
right_bound = right_bound + [ones(length(right_bound),1) zeros(length(right_bound),1)];

loc_mat_for_area = [loc_mat_for_area;lower_bound;upper_bound;left_bound;right_bound];
loc_mat_for_area = [loc_mat_for_area;[0 0];[41 41];[0 41];[41 0]];
loc_mat_for_area = [loc_mat_for_area [loc_mat(:,3);zeros(length(loc_mat_for_area)-length(loc_mat),1)]];
nodeN_modified = length(loc_mat_for_area);
%%
loc_mat_for_area(:,1:2) = 0.5*loc_mat_for_area(:,1:2); %.5 is because the blocks are .5x.5
loc_mat(:,1:2) = 0.5*loc_mat(:,1:2);


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
h = 10;                        %reservoir thickness
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
counter1 = 0;
fileID = fopen('conn_temp.in','w');
for i = 1 : length(A_T)
    for j = i : length(A_T)
        if A_T(i,j) ~= 0
            counter1 = counter1 +1;
            fprintf(fileID,'%4d\t %4d\t %f\n',[i-1 j-1 full(A_T(i,j))]);
        end
    end
end
fclose(fileID);
text = fileread('conn_temp.in');
fileID = fopen('D:\Dropbox\USC - Amin\matlab\Chapter 6\GPRS\Coarse Scale 1\conn.in','w');
fprintf(fileID,[num2str(counter1) '\n']);
fprintf(fileID,text);
fclose(fileID);

%writing the volume file
fileID = fopen('D:\Dropbox\USC - Amin\matlab\Chapter 6\GPRS\Coarse Scale 1\volume.in','w');
for i = 1:nodeN
    fprintf(fileID,'%f\n',tess_area(i));
end
fclose(fileID);

%% importing the pressure at D = 100 (WBT at day = 130)
load P_f_u_1_GPRS;
figure;
[v,c]=voronoin(loc_mat(:,1:2)/10);
for i = 1:length(c) 
    if all(c{i}~=1)   % If at least one of the indices is 1, 
                      % then it is an open region and we can't 
                      % patch that.
        patch(v(c{i},1),v(c{i},2),P_f_u_1(i)); % use color i.
    end
end
figure;
scatter3(loc_mat(:,1),loc_mat(:,2),P_f_u_1,5,'fill');

%% pressure tree bipartition 
% graph based on inverse transmissibility G_T to be partitioned according to sunil
A = A_T;

F = randi(2,nodeN,1); %random assignment, 1 is even 2 is odd
F(1) = 1; F(nodeN) = 1;

%%%%%%
mean_var_mat = [];
%%%%%%

max_iter = 50000;
for i = 1:max_iter
    nodeIndex = 1+randi(nodeN-2,1,1);
    neighborNodes = find(A(nodeIndex,:)~=0)';
    neighborNodes_odd = neighborNodes(F(neighborNodes)==2);
    neighborNodes_even = neighborNodes(F(neighborNodes)==1);
    path_weight = [];
    for m = 1:length(neighborNodes)
        for n = (m+1):length(neighborNodes)
            path = A(nodeIndex,neighborNodes(m))+ A(nodeIndex,neighborNodes(n));
            path_weight = [path_weight; path];
        end
    end
    
    %%%%%%
    mean_var_mat = [mean_var_mat;mean(path_weight) var(path_weight)];
    %%%%%%
    
    if var(path_weight)<400 && mean(path_weight)<=30
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
    else
        if F(nodeIndex)==2
          F(nodeIndex)=1;
        end
    end
end

loc_mat_draw=loc_mat;
loc_mat_draw(find(F==2),:)=[];
drawImage(loc_mat_draw);

%% bipartition continued
% graph based on neighboring G_? to filter the pressure
A = (A_T);

tempL = diag(sum(A))-A;
[tempX,templamda] = eig(full(tempL));

tempf = P_f_u_1;
lamda = sum(templamda);
filter = diag(lamda);
tempf_out = tempX*filter*tempX'*tempf;
figure;
[v,c]=voronoin(loc_mat(:,1:2)/10);
for i = 1:length(c) 
    if all(c{i}~=1)   % If at least one of the indices is 1, 
                      % then it is an open region and we can't 
                      % patch that.
        patch(v(c{i},1),v(c{i},2),(abs(tempf_out(i)))^0.7); % use color i.
    end
end
beta = 1;F(abs(tempf_out).^0.7>=beta) = 1;

F(1:40) = 1;
F(1561:end) = 1;
F(loc_mat(:,2)==1,:) = 1;
F(loc_mat(:,2)==40,:) = 1;

loc_mat_draw=loc_mat;
loc_mat_draw(find(F==2),:)=[];
drawImage(loc_mat_draw);

%%
cool_mat_1 = [loc_mat(:,1:2) F (1:nodeN)' myImageVector P_f_u_1];
cool_mat_2 = cool_mat_1;
cool_mat_2(find(F==2),:)=[];
save('cool_mat_1.mat','cool_mat_1');
save('cool_mat_2.mat','cool_mat_2');


% %% lifting
% A = A_f_PP_1;
% cool_mat = cool_mat_0;
% J = A;
% J(cool_mat(:,3)==1,:) = [];
% J(:,cool_mat(:,3)==2) = [];
% K = A;
% K(cool_mat(:,3)==2,:) = [];
% K(:,cool_mat(:,3)==1) = [];
% Vodd = P_f_1(cool_mat(:,3)==2,3);
% Veven = P_f_1(cool_mat(:,3)==1,3);
% Keven = cool_mat(cool_mat(:,3)==1,5);
% D = Vodd - J*Veven./(sum(J,2));
% S = Keven + K*D./(sum(K,2));
% drawImage([loc_mat_draw(:,1:2) S]);

% %%
% loc_mat = loc_mat_draw;
% myImageVector = loc_mat(:,3);
% nodeN = length(loc_mat);
% myImageNode = (1:nodeN)'; %indexing all the nodes from 1 to N^2
% 
% TRI = delaunay(loc_mat(:,1),loc_mat(:,2));
% V = cool_mat_1(:,6);
% teta = 200;
% g = 10000;
% weight = g*exp(-((V(TRI(1,1),1)-V(TRI(1,2),1))^2)/teta);
% A = sparse(TRI(1,1),TRI(1,2),weight,nodeN,nodeN);
% weight = g*exp(-((V(TRI(1,1),1)-V(TRI(1,3),1))^2)/teta);
% A(TRI(1,1),TRI(1,3)) = weight;
% weight = g*exp(-((V(TRI(1,2),1)-V(TRI(1,3),1))^2)/teta);
% A(TRI(1,2),TRI(1,3)) = weight;
% for i = 2:length(TRI)
%     weight = g*exp(-((V(TRI(i,1),1)-V(TRI(i,2),1))^2)/teta);
%     A(TRI(i,1),TRI(i,2)) = weight;
%     weight = g*exp(-((V(TRI(i,1),1)-V(TRI(i,3),1))^2)/teta);
%     A(TRI(i,1),TRI(i,3)) = weight;
%     weight = g*exp(-((V(TRI(i,2),1)-V(TRI(i,3),1))^2)/teta);
%     A(TRI(i,2),TRI(i,3)) = weight;
% end
% A = A + A';
% A_f_PP_u_1 = A/2;
% 
% %% bipartition based on if total weightloss was small, all nodes are even, else based on Sunil
% % beta = 10;
% A = A_f_PP_u_1;
% A(A<beta) = 0;
% F = randi(2,nodeN,1);       %random assignment, 1 is even 2 is odd
% F(1) = 1; F(nodeN) = 1;     %location of injector and producer
% 
% max_iter = 5000;
% for i = 1:max_iter
% %     sortIndex = randperm(nodeN-2)+2;
% %     for k = 1:length(sortIndex)
%     nodeIndex = 1+randi(nodeN-2,1,1);
%     neighborNodes = find(A(nodeIndex,:)~=0)';
%     neighborNodes_odd = neighborNodes(F(neighborNodes)==2);
%     neighborNodes_even = neighborNodes(F(neighborNodes)==1);
% 
% %     [temp,I] = min(A(i,neighborNodes));
% %     I1 = neighborNodes(I);
% %     neighborNodes(I) = [];
% %     [temp,I] = min(A(i,neighborNodes));
% %     I2 = neighborNodes(I);
% %     neighborNodes(I) = [];
% %     if F(I1)~=0
% %        F(nodeIndex) = F(I1);
% %        F(I2) = F(I1);
% %     elseif F(I2)~=0
% %         F(nodeIndex) = F(I2);
% %         F(I1)=F(I2);
% %     end
% %     if F(nodeIndex) == 1
% %         F(neighborNodes) = 2;
% %     elseif F(nodeIndex) == 2
% %         F(neighborNodes) = 1;
% %     end
%         loss = 0;
%         loss_a = 0;
%         if F(nodeIndex)==2
%            for j = 1:length(neighborNodes_odd)
%                loss = loss + A(nodeIndex,neighborNodes_odd(j)); 
%            end
%            for j = 1:length(neighborNodes_even)
%                loss_a = loss_a + A(nodeIndex,neighborNodes_even(j));
%            end
%     %        if loss+loss_a < beta
%     %            F(nodeIndex) = 1;
%            if loss_a<loss
%               F(nodeIndex) = 1;
%            end
%         else
%            for j = 1:length(neighborNodes_even)
%                loss = loss + A(nodeIndex,neighborNodes_even(j));
%            end
%            for j = 1:length(neighborNodes_odd)
%                loss_a = loss_a + A(nodeIndex,neighborNodes_odd(j)); 
%            end
%            if  loss_a<loss
%               F(nodeIndex) = 2;
%            end
%         end
% %     end
%     i
% end
% cool_mat_2 = cool_mat_1;
% cool_mat_2(:,4) = (1:nodeN)';
% cool_mat_2(find(F==2),:)=[];
% loc_mat_draw=loc_mat;
% loc_mat_draw(find(F==2),:)=[];
% 
% drawImage(loc_mat_draw);
% 
