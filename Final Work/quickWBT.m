% %% high variance threshold 100
% Log = {highvariancethreshold100 highvariancethreshold100S1 highvariancethreshold100S2 highvariancethreshold100S3...
%        highvariancethreshold100S4 highvariancethreshold100S5 highvariancethreshold100S6 highvariancethreshold100S7...
%        highvariancethreshold100S8 highvariancethreshold100S9 highvariancethreshold100S10 highvariancethreshold100S11...
%        highvariancethreshold100S12 highvariancethreshold100S13 highvariancethreshold100S14 highvariancethreshold100S15};
% r = [508 353 272 212 171 145 129 122 117 114 113 112 107 105 104 103];
% 
% for i = 1:length(r)
%     wbt(i) = (0.01-Log{i}(r(i),5))*(Log{i}(r(i),1)-Log{i}(r(i)+1,1))/(Log{i}(r(i),5)-Log{i}(r(i)+1,5))+Log{i}(r(i),1);
%     wbt0 = wbt(1);
%     error(i) = abs(wbt(i) - wbt0)/wbt0;
% end
% 
% block = [262144,132061,67044,35324,19825,12363,8504,6373,5094,4278,3709,3241,2904,2664,2452,2301];
% figure;bar(block);figure(gcf);
% xlabel('pruning iteration');
% ylabel('number of gridblocks');
% 
% figure;plot((block(1)-block)/block(1)*100,error*100,'-*')
% xlabel('percentage of removed nodes');
% ylabel('error % in predicting wbt');
% 
% for i = 1:length(r)
%     totalq(i) = sum(diff(Log{i}(:,1)).*Log{i}(2:end,4));
% end
% figure;plot((block(1)-block)/block(1)*100,abs(totalq(1)-totalq)/totalq(1)*100,'-*')
% xlabel('percentage of removed nodes');
% ylabel('error % in predicting total produced oil');
% 
% %% 
% %low variance threshold 100
% Log = {lowvariancethreshold100 lowvariancethreshold100S1 lowvariancethreshold100S2 lowvariancethreshold100S3...
%        lowvariancethreshold100S4 lowvariancethreshold100S5 lowvariancethreshold100S6 lowvariancethreshold100S7...
%        lowvariancethreshold100S8 lowvariancethreshold100S9};
% r = [511 356 272 209 169 148 133 117 106 95];
% 
% for i = 1:length(r)
%     wbt(i) = (0.01-Log{i}(r(i),5))*(Log{i}(r(i),1)-Log{i}(r(i)+1,1))/(Log{i}(r(i),5)-Log{i}(r(i)+1,5))+Log{i}(r(i),1);
%     wbt0 = wbt(1);
%     error100(i) = abs(wbt(i) - wbt0)/wbt0;
% end
% 
% block100 = [262144,131054 65524 32743 16376 8203 4092 2046 1023 511];
% 
% for i = 1:length(r)
%     totalq100(i) = sum(diff(Log{i}(:,1)).*Log{i}(2:end,4));
% end
% 
% %low variance threshold 10
% Log = {lowvariancethreshold10 lowvariancethreshold10S1 lowvariancethreshold10S2 lowvariancethreshold10S3...
%        lowvariancethreshold10S4 lowvariancethreshold10S5 lowvariancethreshold10S6 lowvariancethreshold10S7...
%        lowvariancethreshold10S8 lowvariancethreshold10S9 lowvariancethreshold10S10 lowvariancethreshold10S11};
% r = [511 358 274 209 168 149 135 125 122 115 107 104];
% 
% for i = 1:length(r)
%     wbt(i) = (0.01-Log{i}(r(i),5))*(Log{i}(r(i),1)-Log{i}(r(i)+1,1))/(Log{i}(r(i),5)-Log{i}(r(i)+1,5))+Log{i}(r(i),1);
%     wbt0 = wbt(1);
%     error10(i) = abs(wbt(i) - wbt0)/wbt0;
% end
% 
% block10 = [262144 131185 65620 32826 16486 8478 4530 2605 1645 1136 868 695];
% 
% for i = 1:length(r)
%     totalq10(i) = sum(diff(Log{i}(:,1)).*Log{i}(2:end,4));
% end
% 
% % low variance threshold 400
% Log = {lowvariancethreshold400 lowvariancethreshold400S1 lowvariancethreshold400S2 lowvariancethreshold400S3...
%        lowvariancethreshold400S4 lowvariancethreshold400S5 lowvariancethreshold400S6 lowvariancethreshold400S7...
%        lowvariancethreshold400S8 lowvariancethreshold400S9};
% r = [511 355 270 206 169 147 130 118 106 95];
% 
% for i = 1:length(r)
%     wbt(i) = (0.01-Log{i}(r(i),5))*(Log{i}(r(i),1)-Log{i}(r(i)+1,1))/(Log{i}(r(i),5)-Log{i}(r(i)+1,5))+Log{i}(r(i),1);
%     wbt0 = wbt(1);
%     error400(i) = abs(wbt(i) - wbt0)/wbt0;
% end
% 
% block400 = [262144 131142 65595 32842 16432 8230 4106 2050 1026 510];
% 
% for i = 1:length(r)
%     totalq400(i) = sum(diff(Log{i}(:,1)).*Log{i}(2:end,4));
% end
% 
% figure;bar([block10' [block100 0 0]' [block400 0 0]']);figure(gcf);
% xlabel('pruning iteration');
% ylabel('number of gridblocks');
% legend('\epsilon=10','\epsilon=100','\epsilon=400');
% 
% figure;plot((block10(1)-block10)/block10(1)*100,error10*100,'-*');hold on;
% plot((block100(1)-block100)/block100(1)*100,error100*100,'-or');
% plot((block400(1)-block400)/block400(1)*100,error400*100,'-xg');
% xlabel('percentage of removed nodes');
% ylabel('error % in predicting wbt');
% legend('\epsilon=10','\epsilon=100','\epsilon=400');
% 
% figure;plot((block10(1)-block10)/block10(1)*100,abs(totalq10(1)-totalq10)/totalq10(1)*100,'-*');hold on;
% plot((block100(1)-block100)/block100(1)*100,abs(totalq100(1)-totalq100)/totalq100(1)*100,'-or');
% plot((block400(1)-block400)/block400(1)*100,abs(totalq400(1)-totalq400)/totalq400(1)*100,'-xg');
% xlabel('percentage of removed nodes');
% ylabel('error % in predicting total produced oil');
% legend('\epsilon=10','\epsilon=100','\epsilon=400');
% 
% 
% 
% %%
% % extreme variance threshold 400
% Log = {extremevariancethreshold400 extremevariancethreshold400S1 extremevariancethreshold400S2 extremevariancethreshold400S3...
%        extremevariancethreshold400S4 extremevariancethreshold400S5 extremevariancethreshold400S6 extremevariancethreshold400S7...
%        extremevariancethreshold400S8 extremevariancethreshold400S9 extremevariancethreshold400S10 extremevariancethreshold400S11...
%        extremevariancethreshold400S12 extremevariancethreshold400S13 extremevariancethreshold400S14 extremevariancethreshold400S15};
%  r = [508 357 273 210 172 147 132 124 119 117 116 114 112 112 108 107];
%  
%  for i = 1:length(r)
%     wbt(i) = (0.01-Log{i}(r(i),5))*(Log{i}(r(i),1)-Log{i}(r(i)+1,1))/(Log{i}(r(i),5)-Log{i}(r(i)+1,5))+Log{i}(r(i),1);
%     wbt0 = wbt(1);
%     errorE400(i) = abs(wbt(i) - wbt0)/wbt0;
% end
% 
% blockE400 = [262144 132135 67250 35383 19986 12320 8419 6312 5058 4257 3689 3266 2924 2687 2486 2308];
% 
% for i = 1:length(r)
%     totalqE400(i) = sum(diff(Log{i}(:,1)).*Log{i}(2:end,4));
% end
% 
% % extreme variance threshold 700
% Log = {extremevariancethreshold700 extremevariancethreshold700S1 extremevariancethreshold700S2 extremevariancethreshold700S3...
%        extremevariancethreshold700S4 extremevariancethreshold700S5 extremevariancethreshold700S6 extremevariancethreshold700S7...
%        extremevariancethreshold700S8 extremevariancethreshold700S9 extremevariancethreshold700S10};
% r = [508 355 269 204 158 128 111 100 90 84 79];
% 
% for i = 1:length(r)
%     wbt(i) = (0.01-Log{i}(r(i),5))*(Log{i}(r(i),1)-Log{i}(r(i)+1,1))/(Log{i}(r(i),5)-Log{i}(r(i)+1,5))+Log{i}(r(i),1);
%     wbt0 = wbt(1);
%     errorE700(i) = abs(wbt(i) - wbt0)/wbt0;
% end
% 
% blockE700 = [262144 131052 65615 32846 16450 8308 4311 2348 1392 906 650];
% 
% for i = 1:length(r)
%     totalqE700(i) = sum(diff(Log{i}(:,1)).*Log{i}(2:end,4));
% end
% 
% figure;bar([blockE400' [blockE700 0 0 0 0 0]']);figure(gcf);
% xlabel('pruning iteration');
% ylabel('number of gridblocks');
% legend('\epsilon=400','\epsilon=700');
% 
% figure;plot((blockE400(1)-blockE400)/blockE400(1)*100,errorE400*100,'-*');hold on;
% plot((blockE700(1)-blockE700)/blockE700(1)*100,errorE700*100,'-or');
% xlabel('percentage of removed nodes');
% ylabel('error % in predicting wbt');
% legend('\epsilon=400','\epsilon=700');
% 
% figure;plot((blockE400(1)-blockE400)/blockE400(1)*100,abs(totalqE400(1)-totalqE400)/totalqE400(1)*100,'-*');hold on;
% plot((blockE700(1)-blockE700)/blockE700(1)*100,abs(totalqE700(1)-totalqE700)/totalqE700(1)*100,'-or');
% xlabel('percentage of removed nodes');
% ylabel('error % in predicting total produced oil');
% legend('\epsilon=400','\epsilon=700');

%% variance 50-50000 threshold 700
Log = {threshold700 threshold700S1 threshold700S2 threshold700S3...
       threshold700S4 threshold700S5 threshold700S6 threshold700S7...
       threshold700S8 threshold700S9 threshold700S10 threshold700S11...
       threshold700S12 threshold700S13 threshold700S14 threshold700S15};
r = [510 356 273 210 164 133 117 108 101 97 90 87 84 86 82 82];

for i = 1:length(r)
    wbt(i) = (0.01-Log{i}(r(i),5))*(Log{i}(r(i),1)-Log{i}(r(i)+1,1))/(Log{i}(r(i),5)-Log{i}(r(i)+1,5))+Log{i}(r(i),1);
    wbt0 = wbt(1);
    error(i) = abs(wbt(i) - wbt0)/wbt0;
end

block = [262144,131180,65719,33274,17237,9444,5691,3813,2786,2191,1822,1549,1357,1212,1086,992];
figure;bar(block);figure(gcf);
xlabel('pruning iteration');
ylabel('number of gridblocks');

figure;plot((block(1)-block)/block(1)*100,error*100,'-*')
xlabel('percentage of removed nodes');
ylabel('error % in predicting wbt');

for i = 1:length(r)
    totalq(i) = sum(diff(Log{i}(:,1)).*Log{i}(2:end,4));
end
figure;plot((block(1)-block)/block(1)*100,abs(totalq(1)-totalq)/totalq(1)*100,'-*')
xlabel('percentage of removed nodes');
ylabel('error % in predicting total produced oil');

Leg = {pressure700 pressure700S1 pressure700S2 pressure700S3 pressure700S4 ...
       pressure700S5 pressure700S6 pressure700S7 pressure700S8 pressure700S9 ...
       pressure700S10 pressure700S11 pressure700S12 pressure700S13 pressure700S14 pressure700S15};
figure;
plot(Leg{1}(:,1),Leg{1}(:,2),Leg{2}(:,1),Leg{2}(:,2),Leg{3}(:,1),Leg{3}(:,2),Leg{4}(:,1),Leg{4}(:,2)...
     ,Leg{5}(:,1),Leg{5}(:,2),Leg{6}(:,1),Leg{6}(:,2),Leg{7}(:,1),Leg{7}(:,2),Leg{8}(:,1),Leg{8}(:,2)...
     ,Leg{9}(:,1),Leg{9}(:,2),Leg{10}(:,1),Leg{10}(:,2),Leg{11}(:,1),Leg{11}(:,2),Leg{12}(:,1),Leg{12}(:,2)...
     ,Leg{13}(:,1),Leg{13}(:,2),Leg{14}(:,1),Leg{14}(:,2),Leg{15}(:,1),Leg{15}(:,2),Leg{16}(:,1),Leg{16}(:,2));
xlabel('time (day)');
ylabel('reservoir average pressure (psi)');

%% variance 50-50000 threshold 300
Log = {threshold300 threshold300S1 threshold300S2 threshold300S3...
       threshold300S4 threshold300S5 threshold300S6 threshold300S7...
       threshold300S8 threshold300S9 threshold300S10 threshold300S11...
       threshold300S12 threshold300S13 threshold300S14 threshold300S15};
r = [510 369 297 250 215 193 178 166 158 154 147 143 139 137 134 131];

for i = 1:length(r)
    wbt(i) = (0.01-Log{i}(r(i),5))*(Log{i}(r(i),1)-Log{i}(r(i)+1,1))/(Log{i}(r(i),5)-Log{i}(r(i)+1,5))+Log{i}(r(i),1);
    wbt0 = wbt(1);
    error(i) = abs(wbt(i) - wbt0)/wbt0;
end

block = [262144,141250,80132,49573,33715,24984,19635,16284,13974,12300,11059,10095,9301,8573,7991,7507];
figure;bar(block);figure(gcf);
xlabel('pruning iteration');
ylabel('number of gridblocks');

figure;plot((block(1)-block)/block(1)*100,error*100,'-*')
xlabel('percentage of removed nodes');
ylabel('error % in predicting wbt');

for i = 1:length(r)
    totalq(i) = sum(diff(Log{i}(:,1)).*Log{i}(2:end,4));
end
figure;plot((block(1)-block)/block(1)*100,abs(totalq(1)-totalq)/totalq(1)*100,'-*')
xlabel('percentage of removed nodes');
ylabel('error % in predicting total produced oil');

Leg = {pressure300 pressure300S1 pressure300S2 pressure300S3 pressure300S4 ...
       pressure300S5 pressure300S6 pressure300S7 pressure300S8 pressure300S9 ...
       pressure300S10 pressure300S11 pressure300S12 pressure300S13 pressure300S14 pressure300S15};
figure;
plot(Leg{1}(:,1),Leg{1}(:,2),Leg{2}(:,1),Leg{2}(:,2),Leg{3}(:,1),Leg{3}(:,2),Leg{4}(:,1),Leg{4}(:,2)...
     ,Leg{5}(:,1),Leg{5}(:,2),Leg{6}(:,1),Leg{6}(:,2),Leg{7}(:,1),Leg{7}(:,2),Leg{8}(:,1),Leg{8}(:,2)...
     ,Leg{9}(:,1),Leg{9}(:,2),Leg{10}(:,1),Leg{10}(:,2),Leg{11}(:,1),Leg{11}(:,2),Leg{12}(:,1),Leg{12}(:,2)...
     ,Leg{13}(:,1),Leg{13}(:,2),Leg{14}(:,1),Leg{14}(:,2),Leg{15}(:,1),Leg{15}(:,2),Leg{16}(:,1),Leg{16}(:,2));
xlabel('time (day)');
ylabel('reservoir average pressure (psi)');