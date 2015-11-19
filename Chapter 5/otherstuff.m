% other stuff

%% HR11 and FR11 G_P zero crossing
load ZC_A_PP_1;
figure;
scatter(1:length(Z),Z);
hold on;
load ZC_A_f_PP_1;
scatter(1:length(Z),Z);
title('Zero crossing of Laplacian eig vectors of G_D');
xlabel('increasing order of Eigenvalue');
ylabel('Number of Zero Crossing');
legend('G_{D,HR11}','G_{D,FR11}');
saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\zeroCrossing', 'jpg');

%% HR11 and FR11 G_P_1_2_3 and G_S_1_2_3 zero crossing
A = cell(12,1);
A{1,2} = 'A_T';A{2,1} = 'A_P_1';A{3,1} = 'A_P_2';A{4,1} = 'A_P_3';
A{8,2} = 'A_D';A{5,1} = 'A_S_1';A{6,1} = 'A_S_2';A{7,1} = 'A_S_3';
A{9,1} = 'A_PP_1';A{10,1} = 'A_PP_2';A{11,1} = 'A_PP_3';
A{12,1} = 'A_PPD';

load ZC_A_P_1;
figure;
scatter(1:length(Z),Z);
title(['Zero crossing of Laplacian eigvectors of G_' A{2,1}]);
xlabel('increasing order of Eigenvalue');
ylabel('Number of Zero Crossing');
saveas(gcf,['D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\ZA_' A{2,1}], 'eps');

load ZC_A_P_2;
figure;
scatter(1:length(Z),Z);
title(['Zero crossing of Laplacian eigvectors of G_' A{3,1}]);
xlabel('increasing order of Eigenvalue');
ylabel('Number of Zero Crossing');
saveas(gcf,['D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\ZA_' A{3,1}], 'eps');

load ZC_A_P_3;
figure;
scatter(1:length(Z),Z);
title(['Zero crossing of Laplacian eigvectors of G_' A{4,1}]);
xlabel('increasing order of Eigenvalue');
ylabel('Number of Zero Crossing');
saveas(gcf,['D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\ZA_' A{4,1}], 'eps');

load ZC_A_S_1;
figure;
scatter(1:length(Z),Z);
title(['Zero crossing of Laplacian eigvectors of G_' A{5,1}]);
xlabel('increasing order of Eigenvalue');
ylabel('Number of Zero Crossing');
saveas(gcf,['D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\ZA_' A{5,1}], 'eps');

load ZC_A_S_2;
figure;
scatter(1:length(Z),Z);
title(['Zero crossing of Laplacian eigvectors of G_' A{6,1}]);
xlabel('increasing order of Eigenvalue');
ylabel('Number of Zero Crossing');
saveas(gcf,['D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\ZA_' A{6,1}], 'eps');

load ZC_A_S_3;
figure;
scatter(1:length(Z),Z);
title(['Zero crossing of Laplacian eigvectors of G_' A{7,1}]);
xlabel('increasing order of Eigenvalue');
ylabel('Number of Zero Crossing');
saveas(gcf,['D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\ZA_' A{7,1}], 'eps');

A = cell(12,1);
A{1,2} = 'A_f_T';A{2,1} = 'A_f_P_1';A{3,1} = 'A_f_P_2';A{4,1} = 'A_f_P_3';
A{8,2} = 'A_f_D';A{5,1} = 'A_f_S_1';A{6,1} = 'A_f_S_2';A{7,1} = 'A_f_S_3';
A{9,1} = 'A_PP_f_1';A{10,1} = 'A_PP_2';A{11,1} = 'A_PP_3';
A{12,1} = 'A_PPD_f';

load ZC_A_f_P_1;
figure;
scatter(1:length(Z),Z);
title(['Zero crossing of Laplacian eigvectors of G_' A{2,1}]);
xlabel('increasing order of Eigenvalue');
ylabel('Number of Zero Crossing');
saveas(gcf,['D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\ZA_' A{2,1}], 'eps');

load ZC_A_f_P_2;
figure;
scatter(1:length(Z),Z);
title(['Zero crossing of Laplacian eigvectors of G_' A{3,1}]);
xlabel('increasing order of Eigenvalue');
ylabel('Number of Zero Crossing');
saveas(gcf,['D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\ZA_' A{3,1}], 'eps');

load ZC_A_f_P_3;
figure;
scatter(1:length(Z),Z);
title(['Zero crossing of Laplacian eigvectors of G_' A{4,1}]);
xlabel('increasing order of Eigenvalue');
ylabel('Number of Zero Crossing');
saveas(gcf,['D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\ZA_' A{4,1}], 'eps');

load ZC_A_f_S_1;
figure;
scatter(1:length(Z),Z);
title(['Zero crossing of Laplacian eigvectors of G_' A{5,1}]);
xlabel('increasing order of Eigenvalue');
ylabel('Number of Zero Crossing');
saveas(gcf,['D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\ZA_' A{5,1}], 'eps');

load ZC_A_f_S_2;
figure;
scatter(1:length(Z),Z);
title(['Zero crossing of Laplacian eigvectors of G_' A{6,1}]);
xlabel('increasing order of Eigenvalue');
ylabel('Number of Zero Crossing');
saveas(gcf,['D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\ZA_' A{6,1}], 'eps');

load ZC_A_f_S_3;
figure;
scatter(1:length(Z),Z);
title(['Zero crossing of Laplacian eigvectors of G_' A{7,1}]);
xlabel('increasing order of Eigenvalue');
ylabel('Number of Zero Crossing');
saveas(gcf,['D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\ZA_' A{7,1}], 'eps');

%% HR11 and FR11 looking at zero crossing G_PP_1_2_3
A = cell(6,1);
A{1,1} = 'A_PP_1';A{2,1} = 'A_PP_2';A{3,1} = 'A_PP_3';
A{4,1} = 'A_f_PP_1';A{5,1} = 'A_f_PP_2';A{6,1} = 'A_f_PP_3';

load ZC_A_PP_1;
figure;
scatter(1:length(Z),Z);
title(['Zero crossing of Laplacian eigvectors of G_' A{1,1}]);
xlabel('increasing order of Eigenvalue');
ylabel('Number of Zero Crossing');
saveas(gcf,['D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\ZA_' A{1,1}], 'eps');

load ZC_A_PP_2;
figure;
scatter(1:length(Z),Z);
title(['Zero crossing of Laplacian eigvectors of G_' A{2,1}]);
xlabel('increasing order of Eigenvalue');
ylabel('Number of Zero Crossing');
saveas(gcf,['D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\ZA_' A{2,1}], 'eps');

load ZC_A_PP_3;
figure;
scatter(1:length(Z),Z);
title(['Zero crossing of Laplacian eigvectors of G_' A{3,1}]);
xlabel('increasing order of Eigenvalue');
ylabel('Number of Zero Crossing');
saveas(gcf,['D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\ZA_' A{3,1}], 'eps');

load ZC_A_f_PP_1;
figure;
scatter(1:length(Z),Z);
title(['Zero crossing of Laplacian eigvectors of G_' A{4,1}]);
xlabel('increasing order of Eigenvalue');
ylabel('Number of Zero Crossing');
saveas(gcf,['D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\ZA_' A{4,1}], 'eps');

load ZC_A_f_PP_2;
figure;
scatter(1:length(Z),Z);
title(['Zero crossing of Laplacian eigvectors of G_' A{5,1}]);
xlabel('increasing order of Eigenvalue');
ylabel('Number of Zero Crossing');
saveas(gcf,['D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\ZA_' A{5,1}], 'eps');

load ZC_A_f_PP_3;
figure;
scatter(1:length(Z),Z);
title(['Zero crossing of Laplacian eigvectors of G_' A{6,1}]);
xlabel('increasing order of Eigenvalue');
ylabel('Number of Zero Crossing');
saveas(gcf,['D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\ZA_' A{6,1}], 'eps');

%% normalized eigenvalue of G_P of FR11 and FR11u
load lamda_N_A_f_PP_1;
figure;
scatter(1:length(templamda),sort(sum(templamda)));
hold on;
load lamda_N_A_f_PP_u_1;
scatter(1:1600/length(templamda):1600,sort(sum(templamda)));
title('Eigenvalues of normalized Laplacian of G_P');
xlabel('increasing order of Eigenvalues: 1600 for FR11 and 577 for FR11u');
ylabel('magnitude');
legend('G_{P,FR11}','G_{P,FR11u}');
saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\eigenValueUpscale', 'jpg');

%% Total variation of G_P of FR11 and FR11u
load TV_A_f_P_1;
figure;
scatter(1:length(TV_eig_v),TV_eig_v);
hold on;
load TV_A_f_P_u_1;
scatter(1:1600/length(TV_eig_v):1600,TV_eig_v);
title('Total variation of Laplacian eigenvectors of G_P');
xlabel('Eigenvalue index:1600 for FR11 and 577 for FR11u');
ylabel('Total Variation');
legend('G_{P,FR11}','G_{P,FR11u}');
saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\totalVariationUpscale', 'jpg');

%% Everything about FR11 and FR11u
% normalized lamda
load lamda_N_A_f_P_1;
figure;
scatter(1:length(templamda),sort(sum((templamda))));
hold on;
load lamda_N_A_f_P_u_1;
scatter(1:1600/length(templamda):1600,sort(sum((templamda))));
title('Eigenvalues of Laplacian of G_P');
xlabel('increasing order of Eigenvalue');
ylabel('magnitude');
legend('G_{P,FR11}','G_{P,FR11u}');
saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\NeigPUpscale', 'jpg');

load lamda_N_A_f_S_1;
figure;
scatter(1:length(templamda),sort(sum((templamda))));
hold on;
load lamda_N_A_f_S_u_1;
scatter(1:1600/length(templamda):1600,sort(sum((templamda))));
title('Eigenvalues of normalized Laplacian of G_S');
xlabel('increasing order of Eigenvalue');
ylabel('magnitude');
legend('G_{S,FR11}','G_{S,FR11u}');
saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\NeigS1Upscale', 'jpg');


load lamda_N_A_f_S_2;
figure;
scatter(1:length(templamda),sort(sum((templamda))));
hold on;
load lamda_N_A_f_S_u_2;
scatter(1:1600/length(templamda):1600,sort(sum((templamda))));
title('Eigenvalues of normalized Laplacian of G_S');
xlabel('increasing order of Eigenvalue');
ylabel('magnitude');
legend('G_{S2,FR11}','G_{S2,FR11u}');
saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\NeigS2Upscale', 'jpg');


load lamda_N_A_f_S_3;
figure;
scatter(1:length(templamda),sort(sum((templamda))));
hold on;
load lamda_N_A_f_S_u_3;
scatter(1:1600/length(templamda):1600,sort(sum((templamda))));
title('Eigenvalues of normalized Laplacian of G_S');
xlabel('increasing order of Eigenvalue');
ylabel('magnitude');
legend('G_{S3,FR11}','G_{S3,FR11u}');
saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\NeigS3Upscale', 'jpg');

load lamda_N_A_f_PP_1;
figure;
scatter(1:length(templamda),sort(sum((templamda))));
hold on;
load lamda_N_A_f_PP_u_1;
scatter(1:1600/length(templamda):1600,sort(sum((templamda))));
title('Eigenvalues of normalized Laplacian of G_PP');
xlabel('increasing order of Eigenvalue');
ylabel('magnitude');
legend('G_{PP,FR11}','G_{PP,FR11u}');
saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\NeigPPUpscale', 'jpg');

load lamda_N_A_f_K;
figure;
scatter(1:length(templamda),sort(sum((templamda))));
hold on;
load lamda_N_A_f_K_u;
scatter(1:1600/length(templamda):1600,sort(sum((templamda))));
title('Eigenvalues of normalized Laplacian of G_K');
xlabel('increasing order of Eigenvalue');
ylabel('magnitude');
legend('G_{K,FR11}','G_{K,FR11u}');
saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\NeigKUpscale', 'jpg');

load lamda_N_A_f_T;
figure;
scatter(1:length(templamda),sort(sum((templamda))));
hold on;
load lamda_N_A_f_T_u;
scatter(1:1600/length(templamda):1600,sort(sum((templamda))));
title('Eigenvalues of normalized Laplacian of G_T');
xlabel('increasing order of Eigenvalue');
ylabel('magnitude');
legend('G_{T,FR11}','G_{T,FR11u}');
saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\NeigTUpscale', 'jpg');

load lamda_N_A_f_D;
figure;
scatter(1:length(templamda),sort(sum((templamda))));
hold on;
load lamda_N_A_f_D_u;
scatter(1:1600/length(templamda):1600,sort(sum((templamda))));
title('Eigenvalues of Laplacian of G_D');
xlabel('increasing order of Eigenvalue');
ylabel('magnitude');
legend('G_{D,FR11}','G_{D,FR11u}');
saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\NeigDUpscale', 'jpg');

load lamda_N_A_f_PPD;
figure;
scatter(1:length(templamda),sort(sum((templamda))));
hold on;
load lamda_N_A_f_PPD_u;
scatter(1:1600/length(templamda):1600,sort(sum((templamda))));
title('Eigenvalues of normalized Laplacian of G_PPD');
xlabel('increasing order of Eigenvalue');
ylabel('magnitude');
legend('G_{PPD,FR11}','G_{PPD,FR11u}');
saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\NeigPPDUpscale', 'jpg');

% Total Variation
load TV_A_f_P_1;
figure;
scatter(1:length(TV_eig_v),TV_eig_v);
hold on;
load TV_A_f_P_u_1;
scatter(1:1600/length(TV_eig_v):1600,TV_eig_v);
title('Total Variation of eigenvectors of Laplacian of G_P');
xlabel('increasing order of Eigenvalue');
ylabel('Total Variation');
legend('G_{P,FR11}','G_{P,FR11u}');
saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\tvPUpscale', 'jpg');

load TV_A_f_S_1;
figure;
scatter(1:length(TV_eig_v),TV_eig_v);
hold on;
load TV_A_f_S_u_1;
scatter(1:1600/length(TV_eig_v):1600,TV_eig_v);
title('Total Variation of eigenvectors of Laplacian of G_S');
xlabel('increasing order of Eigenvalue');
ylabel('Total Variation');
legend('G_{S,FR11}','G_{S,FR11u}');
saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\tvSUpscale', 'jpg');

load TV_A_f_PP_1;
figure;
scatter(1:length(TV_eig_v),TV_eig_v);
hold on;
load TV_A_f_PP_u_1;
scatter(1:1600/length(TV_eig_v):1600,TV_eig_v);
title('Total Variation of eigenvectors of Laplacian of G_PP');
xlabel('increasing order of Eigenvalue');
ylabel('Total Variation');
legend('G_{PP,FR11}','G_{PP,FR11u}');
saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\tvPPUpscale', 'jpg');

load TV_A_f_K;
figure;
scatter(1:length(TV_eig_v),TV_eig_v);
hold on;
load TV_A_f_K_u;
scatter(1:1600/length(TV_eig_v):1600,TV_eig_v);
title('Total Variation of eigenvectors of Laplacian of G_K');
xlabel('increasing order of Eigenvalue');
ylabel('Total Variation');
legend('G_{K,FR11}','G_{K,FR11u}');
saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\tvKUpscale', 'jpg');

load TV_A_f_T;
figure;
scatter(1:length(TV_eig_v),TV_eig_v);
hold on;
load TV_A_f_T_u;
scatter(1:1600/length(TV_eig_v):1600,TV_eig_v);
title('Total Variation of eigenvectors of Laplacian of G_T');
xlabel('increasing order of Eigenvalue');
ylabel('Total Variation');
legend('G_{T,FR11}','G_{T,FR11u}');
saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\tvTUpscale', 'jpg');

load TV_A_f_D;
figure;
scatter(1:length(TV_eig_v),TV_eig_v);
hold on;
load TV_A_f_D_u;
scatter(1:1600/length(TV_eig_v):1600,TV_eig_v);
title('Total Variation of eigenvectors of Laplacian of G_D');
xlabel('increasing order of Eigenvalue');
ylabel('Total Variation');
legend('G_{D,FR11}','G_{D,FR11u}');
saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\tvDUpscale', 'jpg');

load TV_A_f_PPD;
figure;
scatter(1:length(TV_eig_v),TV_eig_v);
hold on;
load TV_A_f_PPD_u;
scatter(1:1600/length(TV_eig_v):1600,TV_eig_v);
title('Total Variation of eigenvectors of Laplacian of G_PPD');
xlabel('increasing order of Eigenvalue');
ylabel('Total Variation');
legend('G_{PPD,FR11}','G_{PPD,FR11u}');
saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\tvPPDUpscale', 'jpg');

% Zero Crossing
load ZC_A_f_P_1;
figure;
scatter(1:length(Z),Z);
hold on;
load ZC_A_f_P_u_1;
scatter(1:length(Z),Z);
title('Zero Crossing of eigenvectors of Laplacian of G_P');
xlabel('increasing order of Eigenvalue');
ylabel('number of zero crossing');
legend('G_{P,FR11}','G_{P,FR11u}');
saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\zcPUpscale', 'jpg');

load ZC_A_f_S_1;
figure;
scatter(1:length(Z),Z);
hold on;
load ZC_A_f_S_u_1;
scatter(1:length(Z),Z);
title('Zero Crossing of eigenvectors of Laplacian of G_S');
xlabel('increasing order of Eigenvalue');
ylabel('number of zero crossing');
legend('G_{S,FR11}','G_{S,FR11u}');
saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\zcSUpscale', 'jpg');

load ZC_A_f_PP_1;
figure;
scatter(1:length(Z),Z);
hold on;
load ZC_A_f_PP_u_1;
scatter(1:length(Z),Z);
title('Zero Crossing of eigenvectors of Laplacian of G_PP');
xlabel('increasing order of Eigenvalue');
ylabel('number of zero crossing');
legend('G_{PP,FR11}','G_{PP,FR11u}');
saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\zcPPUpscale', 'jpg');

load ZC_A_f_K;
figure;
scatter(1:length(Z),Z);
hold on;
load ZC_A_f_K_u;
scatter(1:length(Z),Z);
title('Zero Crossing of eigenvectors of Laplacian of G_K');
xlabel('increasing order of Eigenvalue');
ylabel('number of zero crossing');
legend('G_{K,FR11}','G_{K,FR11u}');
saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\zcKUpscale', 'jpg');

load ZC_A_f_T;
figure;
scatter(1:length(Z),Z);
hold on;
load ZC_A_f_T_u;
scatter(1:length(Z),Z);
title('Zero Crossing of eigenvectors of Laplacian of G_T');
xlabel('increasing order of Eigenvalue');
ylabel('number of zero crossing');
legend('G_{T,FR11}','G_{T,FR11u}');
saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\zcTUpscale', 'jpg');

load ZC_A_f_D;
figure;
scatter(1:length(Z),Z);
hold on;
load ZC_A_f_D_u;
scatter(1:length(Z),Z);
title('Zero Crossing of eigenvectors of Laplacian of G_D');
xlabel('increasing order of Eigenvalue');
ylabel('number of zero crossing');
legend('G_{D,FR11}','G_{D,FR11u}');
saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\zcDUpscale', 'jpg');

load ZC_A_f_PPD;
figure;
scatter(1:length(Z),Z);
hold on;
load ZC_A_f_PPD_u;
scatter(1:length(Z),Z);
title('Zero Crossing of eigenvectors of Laplacian of G_PPD');
xlabel('increasing order of Eigenvalue');
ylabel('number of zero crossing');
legend('G_{PPD,FR11}','G_{PPD,FR11u}');
saveas(gcf,'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\zcPPDUpscale', 'jpg');
