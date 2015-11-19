% this code regards the signal analysis of the graph

% clear all;
% close all;

%% patch draw
myImage = 10*ones(40,40);
myImage(36,1:19) = 5000;
myImage(30:40,10) = 5000;
myImage(5:25,30) = 5000;
loc_mat = locMatFromMatrix(myImage);
myImageVector = loc_mat(:,3);
nodeN = length(loc_mat);
[v,c]=voronoin(loc_mat(:,1:2)/10); 
tempf = myImageVector;
figure;
for i = 1:length(c) 
    if all(c{i}~=1)   % If at least one of the indices is 1, 
                      % then it is an open region and we can't 
                      % patch that.
        patch(v(c{i},1),v(c{i},2),tempf(i)); % use color i.
    end
end
set(gca,'YDir','reverse');
% saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\unfilteredK', 'jpg')

%% 
tempA = A_f_T;
N = length(tempA);
tempL = diag(sum(tempA))-tempA;
% tempL = sqrt(inv(diag(sum(tempA))))*tempL*sqrt(inv(diag(sum(tempA))));
[tempX,templamda] = eig(full(tempL));
%% vertex filtering with lamda manipulation
tempf = myImageVector;
lamda = sum(templamda);
n = 16;
lamda(n+1:end) = 0;
filter = diag(lamda);
tempf_out = tempX*filter*tempX'*tempf;
figure;
for i = 1:length(c) 
    if all(c{i}~=1)   % If at least one of the indices is 1, 
                      % then it is an open region and we can't 
                      % patch that.
        patch(v(c{i},1),v(c{i},2),tempf_out(i)^0.5); % use color i.
    end
end
% set(gca,'XDir','reverse');
set(gca,'YDir','reverse');
% saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\filteredKLowEig16', 'jpg')

%% vertex filtering
tempf = myImageVector;
lamda = sum(templamda);
filter = diag(1*ones(1,N)+1*ones(1,N).*lamda+1*ones(1,N).*(lamda.^2)+1*ones(1,N).*(lamda.^3));
tempf_out = tempX*filter*tempX'*tempf;
figure;
for i = 1:length(c) 
    if all(c{i}~=1)   % If at least one of the indices is 1, 
                      % then it is an open region and we can't 
                      % patch that.
        patch(v(c{i},1),v(c{i},2),tempf_out(i)^0.5); % use color i.
    end
end
% set(gca,'XDir','reverse');
set(gca,'YDir','reverse');
% saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\filteredKLowVertex', 'jpg')

%% spectral filtering
tempf = myImageVector;
n = 800;
filter = diag([zeros(1,N-n) ones(1,n) ]);
tempf_out = tempX*filter*tempX'*tempf;
figure;
for i = 1:length(c) 
    if all(c{i}~=1)   % If at least one of the indices is 1, 
                      % then it is an open region and we can't 
                      % patch that.
        patch(v(c{i},1),v(c{i},2),tempf_out(i)); % use color i.
    end
end
% set(gca,'XDir','reverse');
set(gca,'YDir','reverse');
% saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\filteredKHigh1-16', 'jpg')

%% patch draw
load myImageFR11u.mat;
myImage = myImageFR11u;
loc_mat = locMatFromMatrix(myImage);
loc_mat(loc_mat(:,3)==0,:) = [];
myImageVector = loc_mat(:,3);
nodeN = length(loc_mat);
myImageNode = (1:nodeN)';
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
[v,c]=voronoin(loc_mat_for_area(:,1:2)/10); 
tempf = loc_mat_for_area(:,3);
figure;
for i = 1:length(c) 
    if all(c{i}~=1)   % If at least one of the indices is 1, 
                      % then it is an open region and we can't 
                      % patch that.
        patch(v(c{i},1),v(c{i},2),tempf(i)); % use color i.
    end
end
set(gca,'YDir','reverse');
axis([0 20 0 20])
% saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\unfilteredK', 'jpg')

%% 
tempA = A_f_T_u;
N = length(tempA);
tempL = diag(sum(tempA))-tempA;
% tempL = sqrt(inv(diag(sum(tempA))))*tempL*sqrt(inv(diag(sum(tempA))));
[tempX,templamda] = eig(full(tempL));
%% vertex filtering with lamda manipulation
tempf = myImageVector;
lamda = sum(templamda);
n = 16;
lamda(n+1:end) = 0;
filter = diag(lamda);
tempf_out = tempX*filter*tempX'*tempf;
figure;
for i = 1:length(c) 
    if all(c{i}~=1)   % If at least one of the indices is 1, 
                      % then it is an open region and we can't 
                      % patch that.
        patch(v(c{i},1),v(c{i},2),tempf_out(i)^0.5); % use color i.
    end
end
% set(gca,'XDir','reverse');
set(gca,'YDir','reverse');
% saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\filteredKLowEig16', 'jpg')

%% vertex filtering
tempf = myImageVector;
lamda = sum(templamda);
filter = diag(1*ones(1,N)+1*ones(1,N).*lamda+1*ones(1,N).*(lamda.^2)+1*ones(1,N).*(lamda.^3));
tempf_out = tempX*filter*tempX'*tempf;
figure;
for i = 1:length(c) 
    if all(c{i}~=1)   % If at least one of the indices is 1, 
                      % then it is an open region and we can't 
                      % patch that.
        patch(v(c{i},1),v(c{i},2),tempf_out(i)^0.5); % use color i.
    end
end
% set(gca,'XDir','reverse');
set(gca,'YDir','reverse');
% saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\filteredKLowVertex', 'jpg')

%% spectral filtering
tempf = loc_mat(:,3);
n = 100;
filter = diag([ones(1,n) zeros(1,N-n)]);
tempf_out = tempX*filter*tempX'*tempf;
loc_mat_for_area(1:577,3) = tempf_out;
tempf_out = loc_mat_for_area(:,3);
figure;
for i = 1:length(c) 
    if all(c{i}~=1)   % If at least one of the indices is 1, 
                      % then it is an open region and we can't 
                      % patch that.
        patch(v(c{i},1),v(c{i},2),tempf_out(i)); % use color i.
    end
end
% set(gca,'XDir','reverse');
set(gca,'YDir','reverse');
axis([0 20 0 20]);
% saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\filteredKHigh1-16', 'jpg')
