clear all
close all

myImage = 0.1*ones(40,40);
myImage(1:20,5) = 50;
myImage(5,1:10) = 50;
myImage(30,15:35) = 50;
loc_mat = locMatFromMatrix(myImage);
myImageVector = loc_mat(:,3);
nodeN = length(loc_mat);
myImageNode = (1:nodeN)';
drawImage(loc_mat);
%%
% data = data_generator_HR11_gridding('resultFR11_1.rwo');
% data(:,1:2) = [];data(:,end) = [];
% i = 10:10:4580;data = data(i,:)';vector = data(:);
% i = 1:1600;P_f_1 = [loc_mat(:,1:2) vector(i)];

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
    linkWeight(i) = 20*weight; %gridblock is .5x.5x10
end
linkWeight = [linkWeight;linkWeight];
A_T = sparse(upperTriangLinks,lowerTriangLinks,linkWeight,nodeN,nodeN);

%% writing the conn file
counter0 = 0;
fileID = fopen('conn_temp.in','w');
for i = 1 : length(A_T)
    for j = i : length(A_T)
        if A_T(i,j) ~= 0
            counter0 = counter0 +1;
            fprintf(fileID,'%4d\t %4d\t %f\n',[i-1 j-1 full(A_T(i,j))]);
        end
    end
end
fclose(fileID);
text = fileread('conn_temp.in');
fileID = fopen('D:\Dropbox\USC - Amin\matlab\Chapter 6\GPRS\Fine Scale\conn.in','w');
fprintf(fileID,[num2str(counter0) '\n']);
fprintf(fileID,text);
fclose(fileID);

%writing the volume file
vol = 2.5*ones(length(A_T),1);
fileID = fopen('D:\Dropbox\USC - Amin\matlab\Chapter 6\GPRS\Fine Scale\volume.in','w');
for i = 1:length(A_T)
    fprintf(fileID,'%f\n',vol(i)); 
end
fclose(fileID);

%% importing the pressure at D = 50 (WBT at day = 71)
load P_f_1_GPRS;
X = reshape(loc_mat(:,1),40,40);
Y = reshape(loc_mat(:,2),40,40);
Z = reshape(P_f_1,40,40);
figure;surf(X,Y,Z)
% figure;
% scatter3(loc_mat(:,1)/2,loc_mat(:,2)/2,P_f_1,5,'fill');

%% bipartition 
% graph based on transmissibility G_T to be partitioned according to all
% path variance
A = A_T;

F = randi(2,nodeN,1); %random assignment, 1 is even 2 is odd
F(1) = 1; F(nodeN) = 1; %location of injector and producer

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
    
    if var(path_weight)== 0
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
        F(nodeIndex)=1;
    end
    
end


loc_mat_draw=loc_mat;
loc_mat_draw(find(F==2),:)=[];
drawImage(loc_mat_draw);

%% bipartition continued
% graph based on neighboring G_? to filter the pressure
A = sign(A_T);

tempL = diag(sum(A))-A;
[tempX,templamda] = eig(full(tempL));

%%
tempf = P_f_1;
lamda = sum(templamda);
filter = diag(lamda);
tempf_out = tempX*filter*tempX'*tempf;
beta = 2;F(abs(tempf_out).^0.7>=beta) = 1;
% tempf_out = tempX'*tempf;
% figure;
% [v,c]=voronoin(loc_mat(:,1:2)/10);
% for i = 1:length(c) 
%     if all(c{i}~=1)   % If at least one of the indices is 1, 
%                       % then it is an open region and we can't 
%                       % patch that.
%         patch(v(c{i},1),v(c{i},2),(abs(tempf_out(i)))); % use color i.
%     end
% end
% figure;
% for i = 1:length(c) 
%     if all(c{i}~=1)   % If at least one of the indices is 1, 
%                       % then it is an open region and we can't 
%                       % patch that.
%         patch(v(c{i},1),v(c{i},2),(abs(tempf_out(i)))^0.7); % use color i.
%     end
% end

% figure;
% X = reshape(loc_mat(:,1),40,40);
% Y = reshape(loc_mat(:,2),40,40);
% Z = reshape((abs(tempf_out)).^0.7,40,40);
% surf(X,Y,Z)
% 
% figure;
% X = reshape(loc_mat(:,1),40,40);
% Y = reshape(loc_mat(:,2),40,40);
% Z = reshape(abs(tempf-(tempf_out))*2,40,40);
% surf(X,Y,Z)

%%
F(1:40) = 1;
F(1561:end) = 1;
F(loc_mat(:,2)==1,:) = 1;
F(loc_mat(:,2)==40,:) = 1;

loc_mat_draw=loc_mat;
loc_mat_draw(find(F==2),:)=[];
drawImage(loc_mat_draw);

%%
cool_mat_0 = [loc_mat(:,1:2) F (1:nodeN)' myImageVector P_f_1];
cool_mat_1 = cool_mat_0;
cool_mat_1(find(F==2),:)=[];
save('cool_mat_0.mat','cool_mat_0');
save('cool_mat_1.mat','cool_mat_1');
