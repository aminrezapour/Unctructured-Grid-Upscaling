clear all
% close all

load cool_mat_2;
loc_mat = cool_mat_2(:,[1 2 5]);
loc_mat(:,1:2) = loc_mat(:,1:2);
myImageVector = loc_mat(:,3);
nodeN = length(loc_mat);
myImageNode = (1:nodeN)';
loc_mat(:,1:2) = 2*loc_mat(:,1:2);
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
loc_mat_for_area = [loc_mat_for_area;[-1 -1];[41 41];[-1 41];[41 -1]];
loc_mat_for_area = [loc_mat_for_area [loc_mat(:,3);zeros(length(loc_mat_for_area)-length(loc_mat),1)]];
nodeN_modified = length(loc_mat_for_area);

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
fileID = fopen('D:\Dropbox\USC - Amin\matlab\Chapter 6\GPRS\Coarse Scale 2\conn.in','w');
fprintf(fileID,[num2str(counter1) '\n']);
fprintf(fileID,text);
fclose(fileID);

%writing the volume file
fileID = fopen('D:\Dropbox\USC - Amin\matlab\Chapter 6\GPRS\Coarse Scale 2\volume.in','w');
for i = 1:nodeN
    fprintf(fileID,'%f\n',tess_area(i));
end
fclose(fileID);

%% importing the pressure at D = 120 (WBT at day = 150)
load P_f_uu_1_GPRS;
figure;
[v,c]=voronoin(loc_mat(:,1:2));
for i = 1:length(c) 
    if all(c{i}~=1)   % If at least one of the indices is 1, 
                      % then it is an open region and we can't 
                      % patch that.
        patch(v(c{i},1),v(c{i},2),P_f_uu_1(i)); % use color i.
    end
end
figure;
scatter3(loc_mat(:,1),loc_mat(:,2),P_f_uu_1,5,'fill');