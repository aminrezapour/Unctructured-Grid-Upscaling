clear all;
close all;

% baisc parameters
years = 5;          %lifecycle of the reservoir
date = Calendar_generator(years);

Ts = 0.5;           %sampling time (day)
N = 60;             %length of experiment (days)
J = 100;            %nominal injection rate bbl/day
BHP = 2500;         %producer pressure psi
b = 0.5;            %amplitude percentage of the signal
f = 0.2/Ts;         %upper freq band on variations

Ne = 3;             %please hand calculate it

% water break through happens at 325 days (you should know this)
day1 = 365;

%% Generating the Data

% Training data
% U = idinput([N Ne],'rbs',[0 f],[J J+J*2*b]);
load U;
U_k = kron(U,ones(1/Ts,1));

figure;
stairs(Ts:Ts:N,U_k(:,1)','LineWidth',2);
title('INJ1 injection rate sequences for training');
xlabel('Time (day)');
ylabel('Injection Rate (bbl/day)');
ylim([90 210]);

figure;
stairs(Ts:Ts:N,U_k(:,2)','--','LineWidth',2);
title('INJ2 injection rate sequences for training');
xlabel('Time (day)');
ylabel('Injection Rate (bbl/day)');
ylim([90,210]);

figure;
stairs(Ts:Ts:N,U_k(:,3)',':','LineWidth',2);
title('INJ3 injection rate sequences for training');
xlabel('Time (day)');
ylabel('Injection Rate (bbl/day)');
ylim([90,210]);

% Validation data
U_v = idinput([N Ne],'rbs',[0 f],[J J+J*2*b]);
U_v_k = kron(U_v,ones(1/Ts,1));

%% Analyzing the training data
U_c = detrend(U_k);
lag = 10;
figure;
subplot(3,1,1);
[c_ww,lags] = xcorr(U_c(:,1),U_c(:,2),lag,'coeff');
stem(lags,c_ww)
ylim([-1,1]);
title('cross correlation between INJ1 and INJ2');
ylabel('normalized energy');
subplot(3,1,2);
[c_ww,lags] = xcorr(U_c(:,1),U_c(:,3),lag,'coeff');
stem(lags,c_ww)
ylim([-1,1]);
title('cross correlation between INJ1 and INJ3');
ylabel('normalized energy');
subplot(3,1,3);
[c_ww,lags] = xcorr(U_c(:,2),U_c(:,3),lag,'coeff');
stem(lags,c_ww)
ylim([-1,1]);
title('cross correlation between INJ2 and INJ3');
ylabel('normalized energy');
xlabel('lag (half day)');

% freq content analysis
UU = idinput([50*N Ne],'rbs',[0 f],[J J+J*2*b]);
UU_k = kron(UU,ones(1/Ts,1));
UU_c = detrend(UU_k);
figure;hold on;
pwelchParam = [1000 800 50*N];   % [window length, overlap length, nfft]
[pxx1,w] = pwelch(UU_c(:,1),pwelchParam(1),pwelchParam(2),pwelchParam(3));
pxx2 = pwelch(UU_c(:,1),pwelchParam(1),pwelchParam(2),pwelchParam(3));
pxx3 = pwelch(UU_c(:,2),pwelchParam(1),pwelchParam(2),pwelchParam(3));
pxx4 = pwelch(UU_c(:,3),pwelchParam(1),pwelchParam(2),pwelchParam(3));
s = 3;
scatter(w,(pxx1),s);scatter(w,(pxx2),s);scatter(w,(pxx3),s);
title('examples of the freq content of the input signals');
legend('INJ1','INJ2','INJ3');
xlabel('normalized frequency (rad/sample)');
ylabel('magnitude');
xlim([0 pi]);grid on;

%% Generating the Model

% Training model
copyfile('component1.txt','model.dat');
fileID = fopen('model.dat','a');
fprintf(fileID,'\n');
fprintf(fileID,['DATE ' num2str(date(1,:)) '.00000\n']);
fprintf(fileID,'\n');
fprintf(fileID,'**$\n');
fprintf(fileID,'WELL  ''INJ1''\n');
fprintf(fileID,'INJECTOR MOBWEIGHT ''INJ1''\n');
fprintf(fileID,'INCOMP WATER\n');
fprintf(fileID,['OPERATE MAX STW ' num2str(J) '.0 CONT\n']);
fprintf(fileID,'**          rad  geofac  wfrac  skin\n');
fprintf(fileID,'GEOMETRY  K  0.25  0.37  1.0  0.0\n');
fprintf(fileID,'PERF  GEOA  ''INJ1''\n');
fprintf(fileID,'** UBA      ff   Status  Connection\n');
fprintf(fileID,'    25 50 1  1.0  OPEN    FLOW-FROM  ''SURFACE''\n');
fprintf(fileID,'**\n');
fprintf(fileID,'WELL  ''INJ2''\n');
fprintf(fileID,'INJECTOR MOBWEIGHT ''INJ2''\n');
fprintf(fileID,'INCOMP WATER\n');
fprintf(fileID,['OPERATE MAX STW ' num2str(J) '.0 CONT\n']);
fprintf(fileID,'**          rad  geofac  wfrac  skin\n');
fprintf(fileID,'GEOMETRY  K  0.25  0.37  1.0  0.0\n');
fprintf(fileID,'PERF  GEOA  ''INJ2''\n');
fprintf(fileID,'** UBA      ff   Status  Connection\n');
fprintf(fileID,'    75 50 1  1.0  OPEN    FLOW-FROM  ''SURFACE''\n');
fprintf(fileID,'**\n');
fprintf(fileID,'WELL  ''INJ3''\n');
fprintf(fileID,'INJECTOR MOBWEIGHT ''INJ3''\n');
fprintf(fileID,'INCOMP WATER\n');
fprintf(fileID,['OPERATE MAX STW ' num2str(J) '.0 CONT\n']);
fprintf(fileID,'**          rad  geofac  wfrac  skin\n');
fprintf(fileID,'GEOMETRY  K  0.25  0.37  1.0  0.0\n');
fprintf(fileID,'PERF  GEOA  ''INJ3''\n');
fprintf(fileID,'** UBA      ff   Status  Connection\n');
fprintf(fileID,'    125 50 1  1.0  OPEN    FLOW-FROM  ''SURFACE''\n');
fprintf(fileID,'**\n');

fprintf(fileID,'WELL  ''PRO1''\n');
fprintf(fileID,'PRODUCER ''PRO1''\n');
fprintf(fileID,['OPERATE  MIN  BHP ' num2str(BHP) '.0 CONT\n']);
fprintf(fileID,'**          rad  geofac  wfrac  skin\n');
fprintf(fileID,'GEOMETRY  K  0.25  0.37  1.0  0.0\n');
fprintf(fileID,'PERF  GEOA  ''PRO1''\n');
fprintf(fileID,'** UBA      ff   Status  Connection\n');
fprintf(fileID,'    1 1 1  1.0  OPEN    FLOW-TO  ''SURFACE''\n');
fprintf(fileID,'**\n');
fprintf(fileID,'WELL  ''PRO2''\n');
fprintf(fileID,'PRODUCER ''PRO2''\n');
fprintf(fileID,['OPERATE  MIN  BHP ' num2str(BHP) '.0 CONT\n']);
fprintf(fileID,'**          rad  geofac  wfrac  skin\n');
fprintf(fileID,'GEOMETRY  K  0.25  0.37  1.0  0.0\n');
fprintf(fileID,'PERF  GEOA  ''PRO2''\n');
fprintf(fileID,'** UBA      ff   Status  Connection\n');
fprintf(fileID,'    50 1 1  1.0  OPEN    FLOW-TO  ''SURFACE''\n');
fprintf(fileID,'**\n');
fprintf(fileID,'WELL  ''PRO3''\n');
fprintf(fileID,'PRODUCER ''PRO3''\n');
fprintf(fileID,['OPERATE  MIN  BHP ' num2str(BHP) '.0 CONT\n']);
fprintf(fileID,'**          rad  geofac  wfrac  skin\n');
fprintf(fileID,'GEOMETRY  K  0.25  0.37  1.0  0.0\n');
fprintf(fileID,'PERF  GEOA  ''PRO3''\n');
fprintf(fileID,'** UBA      ff   Status  Connection\n');
fprintf(fileID,'    100 1 1  1.0  OPEN    FLOW-TO  ''SURFACE''\n');
fprintf(fileID,'**\n');
fprintf(fileID,'WELL  ''PRO4''\n');
fprintf(fileID,'PRODUCER ''PRO4''\n');
fprintf(fileID,['OPERATE  MIN  BHP ' num2str(BHP) '.0 CONT\n']);
fprintf(fileID,'**          rad  geofac  wfrac  skin\n');
fprintf(fileID,'GEOMETRY  K  0.25  0.37  1.0  0.0\n');
fprintf(fileID,'PERF  GEOA  ''PRO4''\n');
fprintf(fileID,'** UBA      ff   Status  Connection\n');
fprintf(fileID,'    150 1 1  1.0  OPEN    FLOW-TO  ''SURFACE''\n');

for j = 2:day1
    fprintf(fileID,['DATE ' num2str(date(j,:)) '.00000\n']);
end
temp = j+1;
for j = temp:temp+N-1
    fprintf(fileID,['DATE ' num2str(date(j,:)) '.00000\n']);
    fprintf(fileID,'**$\n');
    fprintf(fileID,'WELL  ''INJ1''\n');
    fprintf(fileID,'INJECTOR MOBWEIGHT ''INJ1''\n');
    fprintf(fileID,'INCOMP WATER\n');
    fprintf(fileID,['OPERATE MAX STW ' num2str(U(j-day1,1)) '.0 CONT\n']);
    fprintf(fileID,'**          rad  geofac  wfrac  skin\n');
    fprintf(fileID,'GEOMETRY  K  0.25  0.37  1.0  0.0\n');
    fprintf(fileID,'PERF  GEOA  ''INJ1''\n');
    fprintf(fileID,'** UBA      ff   Status  Connection\n');
    fprintf(fileID,'    25 50 1  1.0  OPEN    FLOW-FROM  ''SURFACE''\n');
    fprintf(fileID,'**\n');
    fprintf(fileID,'WELL  ''INJ2''\n');
    fprintf(fileID,'INJECTOR MOBWEIGHT ''INJ2''\n');
    fprintf(fileID,'INCOMP WATER\n');
    fprintf(fileID,['OPERATE MAX STW ' num2str(U(j-day1,2)) '.0 CONT\n']);
    fprintf(fileID,'**          rad  geofac  wfrac  skin\n');
    fprintf(fileID,'GEOMETRY  K  0.25  0.37  1.0  0.0\n');
    fprintf(fileID,'PERF  GEOA  ''INJ2''\n');
    fprintf(fileID,'** UBA      ff   Status  Connection\n');
    fprintf(fileID,'    75 50 1  1.0  OPEN    FLOW-FROM  ''SURFACE''\n');
    fprintf(fileID,'**\n');
    fprintf(fileID,'WELL  ''INJ3''\n');
    fprintf(fileID,'INJECTOR MOBWEIGHT ''INJ3''\n');
    fprintf(fileID,'INCOMP WATER\n');
    fprintf(fileID,['OPERATE MAX STW ' num2str(U(j-day1,3)) '.0 CONT\n']);
    fprintf(fileID,'**          rad  geofac  wfrac  skin\n');
    fprintf(fileID,'GEOMETRY  K  0.25  0.37  1.0  0.0\n');
    fprintf(fileID,'PERF  GEOA  ''INJ3''\n');
    fprintf(fileID,'** UBA      ff   Status  Connection\n');
    fprintf(fileID,'    125 50 1  1.0  OPEN    FLOW-FROM  ''SURFACE''\n');
end

for j = j+1:length(date)
    fprintf(fileID,['DATE ' num2str(date(j,:)) '.00000\n']);
end

fprintf(fileID,fileread('component2.txt'));
fclose(fileID);

% Validation model
copyfile('component1.txt','model_v.dat');
fileID = fopen('model_v.dat','a');
fprintf(fileID,'\n');
fprintf(fileID,['DATE ' num2str(date(1,:)) '.00000\n']);
fprintf(fileID,'\n');
fprintf(fileID,'**$\n');
fprintf(fileID,'WELL  ''INJ1''\n');
fprintf(fileID,'INJECTOR MOBWEIGHT ''INJ1''\n');
fprintf(fileID,'INCOMP WATER\n');
fprintf(fileID,['OPERATE MAX STW ' num2str(J) '.0 CONT\n']);
fprintf(fileID,'**          rad  geofac  wfrac  skin\n');
fprintf(fileID,'GEOMETRY  K  0.25  0.37  1.0  0.0\n');
fprintf(fileID,'PERF  GEOA  ''INJ1''\n');
fprintf(fileID,'** UBA      ff   Status  Connection\n');
fprintf(fileID,'    25 50 1  1.0  OPEN    FLOW-FROM  ''SURFACE''\n');
fprintf(fileID,'**\n');
fprintf(fileID,'WELL  ''INJ2''\n');
fprintf(fileID,'INJECTOR MOBWEIGHT ''INJ2''\n');
fprintf(fileID,'INCOMP WATER\n');
fprintf(fileID,['OPERATE MAX STW ' num2str(J) '.0 CONT\n']);
fprintf(fileID,'**          rad  geofac  wfrac  skin\n');
fprintf(fileID,'GEOMETRY  K  0.25  0.37  1.0  0.0\n');
fprintf(fileID,'PERF  GEOA  ''INJ2''\n');
fprintf(fileID,'** UBA      ff   Status  Connection\n');
fprintf(fileID,'    75 50 1  1.0  OPEN    FLOW-FROM  ''SURFACE''\n');
fprintf(fileID,'**\n');
fprintf(fileID,'WELL  ''INJ3''\n');
fprintf(fileID,'INJECTOR MOBWEIGHT ''INJ3''\n');
fprintf(fileID,'INCOMP WATER\n');
fprintf(fileID,['OPERATE MAX STW ' num2str(J) '.0 CONT\n']);
fprintf(fileID,'**          rad  geofac  wfrac  skin\n');
fprintf(fileID,'GEOMETRY  K  0.25  0.37  1.0  0.0\n');
fprintf(fileID,'PERF  GEOA  ''INJ3''\n');
fprintf(fileID,'** UBA      ff   Status  Connection\n');
fprintf(fileID,'    125 50 1  1.0  OPEN    FLOW-FROM  ''SURFACE''\n');
fprintf(fileID,'**\n');

fprintf(fileID,'WELL  ''PRO1''\n');
fprintf(fileID,'PRODUCER ''PRO1''\n');
fprintf(fileID,['OPERATE  MIN  BHP ' num2str(BHP) '.0 CONT\n']);
fprintf(fileID,'**          rad  geofac  wfrac  skin\n');
fprintf(fileID,'GEOMETRY  K  0.25  0.37  1.0  0.0\n');
fprintf(fileID,'PERF  GEOA  ''PRO1''\n');
fprintf(fileID,'** UBA      ff   Status  Connection\n');
fprintf(fileID,'    1 1 1  1.0  OPEN    FLOW-TO  ''SURFACE''\n');
fprintf(fileID,'**\n');
fprintf(fileID,'WELL  ''PRO2''\n');
fprintf(fileID,'PRODUCER ''PRO2''\n');
fprintf(fileID,['OPERATE  MIN  BHP ' num2str(BHP) '.0 CONT\n']);
fprintf(fileID,'**          rad  geofac  wfrac  skin\n');
fprintf(fileID,'GEOMETRY  K  0.25  0.37  1.0  0.0\n');
fprintf(fileID,'PERF  GEOA  ''PRO2''\n');
fprintf(fileID,'** UBA      ff   Status  Connection\n');
fprintf(fileID,'    50 1 1  1.0  OPEN    FLOW-TO  ''SURFACE''\n');
fprintf(fileID,'**\n');
fprintf(fileID,'WELL  ''PRO3''\n');
fprintf(fileID,'PRODUCER ''PRO3''\n');
fprintf(fileID,['OPERATE  MIN  BHP ' num2str(BHP) '.0 CONT\n']);
fprintf(fileID,'**          rad  geofac  wfrac  skin\n');
fprintf(fileID,'GEOMETRY  K  0.25  0.37  1.0  0.0\n');
fprintf(fileID,'PERF  GEOA  ''PRO3''\n');
fprintf(fileID,'** UBA      ff   Status  Connection\n');
fprintf(fileID,'    100 1 1  1.0  OPEN    FLOW-TO  ''SURFACE''\n');
fprintf(fileID,'**\n');
fprintf(fileID,'WELL  ''PRO4''\n');
fprintf(fileID,'PRODUCER ''PRO4''\n');
fprintf(fileID,['OPERATE  MIN  BHP ' num2str(BHP) '.0 CONT\n']);
fprintf(fileID,'**          rad  geofac  wfrac  skin\n');
fprintf(fileID,'GEOMETRY  K  0.25  0.37  1.0  0.0\n');
fprintf(fileID,'PERF  GEOA  ''PRO4''\n');
fprintf(fileID,'** UBA      ff   Status  Connection\n');
fprintf(fileID,'    150 1 1  1.0  OPEN    FLOW-TO  ''SURFACE''\n');

for j = 2:day1
    fprintf(fileID,['DATE ' num2str(date(j,:)) '.00000\n']);
end
temp = j+1;
for j = temp:temp+N-1
    fprintf(fileID,['DATE ' num2str(date(j,:)) '.00000\n']);
    fprintf(fileID,'**$\n');
    fprintf(fileID,'WELL  ''INJ1''\n');
    fprintf(fileID,'INJECTOR MOBWEIGHT ''INJ1''\n');
    fprintf(fileID,'INCOMP WATER\n');
    fprintf(fileID,['OPERATE MAX STW ' num2str(U_v(j-day1,1)) '.0 CONT\n']);
    fprintf(fileID,'**          rad  geofac  wfrac  skin\n');
    fprintf(fileID,'GEOMETRY  K  0.25  0.37  1.0  0.0\n');
    fprintf(fileID,'PERF  GEOA  ''INJ1''\n');
    fprintf(fileID,'** UBA      ff   Status  Connection\n');
    fprintf(fileID,'    25 50 1  1.0  OPEN    FLOW-FROM  ''SURFACE''\n');
    fprintf(fileID,'**\n');
    fprintf(fileID,'WELL  ''INJ2''\n');
    fprintf(fileID,'INJECTOR MOBWEIGHT ''INJ2''\n');
    fprintf(fileID,'INCOMP WATER\n');
    fprintf(fileID,['OPERATE MAX STW ' num2str(U_v(j-day1,2)) '.0 CONT\n']);
    fprintf(fileID,'**          rad  geofac  wfrac  skin\n');
    fprintf(fileID,'GEOMETRY  K  0.25  0.37  1.0  0.0\n');
    fprintf(fileID,'PERF  GEOA  ''INJ2''\n');
    fprintf(fileID,'** UBA      ff   Status  Connection\n');
    fprintf(fileID,'    75 50 1  1.0  OPEN    FLOW-FROM  ''SURFACE''\n');
    fprintf(fileID,'**\n');
    fprintf(fileID,'WELL  ''INJ3''\n');
    fprintf(fileID,'INJECTOR MOBWEIGHT ''INJ3''\n');
    fprintf(fileID,'INCOMP WATER\n');
    fprintf(fileID,['OPERATE MAX STW ' num2str(U_v(j-day1,3)) '.0 CONT\n']);
    fprintf(fileID,'**          rad  geofac  wfrac  skin\n');
    fprintf(fileID,'GEOMETRY  K  0.25  0.37  1.0  0.0\n');
    fprintf(fileID,'PERF  GEOA  ''INJ3''\n');
    fprintf(fileID,'** UBA      ff   Status  Connection\n');
    fprintf(fileID,'    125 50 1  1.0  OPEN    FLOW-FROM  ''SURFACE''\n');
end

for j = j+1:length(date)
    fprintf(fileID,['DATE ' num2str(date(j,:)) '.00000\n']);
end

fprintf(fileID,fileread('component2.txt'));
fclose(fileID);
    
%%  Making the RWD file

% Training RWD
fileID = fopen('result.rwd','w');
fprintf(fileID,'*FILES ''model.irf''\n');
fprintf(fileID,'*TABLE-FOR\n');
fprintf(fileID,'\n');
fprintf(fileID,'*COLUMN-FOR *PARAMETERS ''Liquid Rate SC - Daily'' *WELLS ''INJ1''\n');
fprintf(fileID,'*COLUMN-FOR *PARAMETERS ''Liquid Rate SC - Daily'' *WELLS ''INJ2''\n');
fprintf(fileID,'*COLUMN-FOR *PARAMETERS ''Liquid Rate SC - Daily'' *WELLS ''INJ3''\n');
fprintf(fileID,'*COLUMN-FOR *PARAMETERS ''Liquid Rate SC - Daily'' *WELLS ''PRO1''\n');
fprintf(fileID,'*COLUMN-FOR *PARAMETERS ''Liquid Rate SC - Daily'' *WELLS ''PRO2''\n');
fprintf(fileID,'*COLUMN-FOR *PARAMETERS ''Liquid Rate SC - Daily'' *WELLS ''PRO3''\n');
fprintf(fileID,'*COLUMN-FOR *PARAMETERS ''Liquid Rate SC - Daily'' *WELLS ''PRO4''\n');
fprintf(fileID,'\n');
fprintf(fileID,'*TABLE-END');
fclose(fileID);

% Validation
fileID = fopen('result_v.rwd','w');
fprintf(fileID,'*FILES ''model_v.irf''\n');
fprintf(fileID,'*TABLE-FOR\n');
fprintf(fileID,'\n');
fprintf(fileID,'*COLUMN-FOR *PARAMETERS ''Liquid Rate SC - Daily'' *WELLS ''INJ1''\n');
fprintf(fileID,'*COLUMN-FOR *PARAMETERS ''Liquid Rate SC - Daily'' *WELLS ''INJ2''\n');
fprintf(fileID,'*COLUMN-FOR *PARAMETERS ''Liquid Rate SC - Daily'' *WELLS ''INJ3''\n');
fprintf(fileID,'*COLUMN-FOR *PARAMETERS ''Liquid Rate SC - Daily'' *WELLS ''PRO1''\n');
fprintf(fileID,'*COLUMN-FOR *PARAMETERS ''Liquid Rate SC - Daily'' *WELLS ''PRO2''\n');
fprintf(fileID,'*COLUMN-FOR *PARAMETERS ''Liquid Rate SC - Daily'' *WELLS ''PRO3''\n');
fprintf(fileID,'*COLUMN-FOR *PARAMETERS ''Liquid Rate SC - Daily'' *WELLS ''PRO4''\n');
fprintf(fileID,'\n');
fprintf(fileID,'*TABLE-END');
fclose(fileID);

%% from RWO file to matlab data
% import the RWO to this folder first

temp = data_generator_FR34('result.rwo');
data = temp;
data(:,1) = floor(data(:,1));
k = 1;
temp = data;
while k <= length(temp)-1
      if temp(k,1)==temp(k+1,1)
         temp(k+1,:)=[];
      elseif temp(k+1,1)-temp(k,1) ~=1
         temp_temp = [temp(k,1)+1 mean(temp(k:k+1,2:end))];
         temp = insertrows(temp,temp_temp,k);
         k = k+1;
      else k = k+1;      
      end
end
data = temp;

temp = data_generator_FR34('result_v.rwo');
data_v = temp;
data_v(:,1) = floor(data_v(:,1));
k = 1;
temp = data_v;
while k <= length(temp)-1
      if temp(k,1)==temp(k+1,1)
         temp(k+1,:)=[];
      elseif temp(k+1,1)-temp(k,1) ~=1
         temp_temp = [temp(k,1)+1 mean(temp(k:k+1,2:end))];
         temp = insertrows(temp,temp_temp,k);
         k = k+1;
      else k = k+1;      
      end
end
data_v = temp;

%% Data Pre-Processing

N = 60;   % change the length of the experiment
% Training
[r,c] = find(data(:,1)==day1+1);
% u = U(1:N,i) - J*ones(N,1);
u = detrend(data(r:r+N-1,2:4));
u = kron(u,ones(1/Ts,1));
yy = detrend(data(r:r+N-1,5:8));
y = [];
y(:,1) = interp(yy(:,1),1/Ts);
y(:,2) = interp(yy(:,2),1/Ts);
y(:,3) = interp(yy(:,3),1/Ts);
y(:,4) = interp(yy(:,4),1/Ts);
training_1 = iddata(y(:,1),u,Ts);
training_2 = iddata(y(:,2),u,Ts);
training_3 = iddata(y(:,3),u,Ts);
training_4 = iddata(y(:,4),u,Ts);

% validation data in form of iddata
[r,c] = find(data_v(:,1)==day1+1);
% u = U_v(1:N,i) - J*ones(N,1);
u = detrend(data_v(r:r+N-1,2:4));
u = kron(u,ones(1/Ts,1));
yy = detrend(data_v(r:r+N-1,5:8));
y = [];
y(:,1) = interp(yy(:,1),1/Ts);
y(:,2) = interp(yy(:,2),1/Ts);
y(:,3) = interp(yy(:,3),1/Ts);
y(:,4) = interp(yy(:,4),1/Ts);
validation_1 = iddata(y(:,1),u,Ts);
validation_2 = iddata(y(:,2),u,Ts);
validation_3 = iddata(y(:,3),u,Ts);
validation_4 = iddata(y(:,4),u,Ts);

%% Identification of ARX models

% estimating ARX models
na = 1;
nb = [1 1 1];
nk = [0 0 0];
ARX_FR34_PRO1 = arx(training_1,[na nb nk]);
ARX_FR34_PRO2 = arx(training_2,[na nb nk]);
ARX_FR34_PRO3 = arx(training_3,[na nb nk]);
ARX_FR34_PRO4 = arx(training_4,[na nb nk]);

% Model Validation of ARX
% training error
figure;
subplot(2,2,1);
[y_sim,fit,temp] = compare(training_1,ARX_FR34_PRO1);
plot(Ts:Ts:N,training_1.OutputData,Ts:Ts:N,y_sim.OutputData)
title('TRAINING data simulation error PRO1');
xlabel('Time (day)');
ylabel('detrended production rate');
legend('measured',['simulated: fit = ' num2str(round(fit)) '%']);
subplot(2,2,2);
[y_sim,fit,temp] = compare(training_2,ARX_FR34_PRO2);
plot(Ts:Ts:N,training_2.OutputData,Ts:Ts:N,y_sim.OutputData)
title('TRAINING data simulation error PRO2');
xlabel('Time (day)');
ylabel('detrended production rate');
legend('measured',['simulated: fit = ' num2str(round(fit)) '%']);
subplot(2,2,3);
[y_sim,fit,temp] = compare(training_3,ARX_FR34_PRO3);
plot(Ts:Ts:N,training_3.OutputData,Ts:Ts:N,y_sim.OutputData)
title('TRAINING data simulation error PRO3');
xlabel('Time (day)');
ylabel('detrended production rate');
legend('measured',['simulated: fit = ' num2str(round(fit)) '%']);
subplot(2,2,4);
[y_sim,fit,temp] = compare(training_4,ARX_FR34_PRO4);
plot(Ts:Ts:N,training_4.OutputData,Ts:Ts:N,y_sim.OutputData)
title('TRAINING data simulation error PRO4');
xlabel('Time (day)');
ylabel('detrended production rate');
legend('measured',['simulated: fit = ' num2str(round(fit)) '%']);
saveas(gcf, 'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\trainingFit', 'eps')

% validation error
figure;
subplot(2,2,1);
[y_sim,fit,temp] = compare(validation_1,ARX_FR34_PRO1);
plot(Ts:Ts:N,validation_1.OutputData,Ts:Ts:N,y_sim.OutputData)
title('VALIDATION data simulation error PRO1');
xlabel('Time (day)');
ylabel('detrended production rate');
legend('measured',['simulated: fit = ' num2str(round(fit)) '%']);
subplot(2,2,2);
[y_sim,fit,temp] = compare(validation_2,ARX_FR34_PRO2);
plot(Ts:Ts:N,validation_2.OutputData,Ts:Ts:N,y_sim.OutputData)
title('VALIDATION data simulation error PRO2');
xlabel('Time (day)');
ylabel('detrended production rate');
legend('measured',['simulated: fit = ' num2str(round(fit)) '%']);
subplot(2,2,3);
[y_sim,fit,temp] = compare(validation_3,ARX_FR34_PRO3);
plot(Ts:Ts:N,validation_3.OutputData,Ts:Ts:N,y_sim.OutputData)
title('VALIDATION data simulation error PRO3');
xlabel('Time (day)');
ylabel('detrended production rate');
legend('measured',['simulated: fit = ' num2str(round(fit)) '%']);
subplot(2,2,4);
[y_sim,fit,temp] = compare(validation_4,ARX_FR34_PRO4);
plot(Ts:Ts:N,validation_4.OutputData,Ts:Ts:N,y_sim.OutputData)
title('VALIDATION data simulation error PRO4');
xlabel('Time (day)');
ylabel('detrended production rate');
legend('measured',['simulated: fit = ' num2str(round(fit)) '%']);
saveas(gcf, 'D:\Dropbox\USC - Amin\Qual exam\Chapters\Figures\validationFit', 'eps')
