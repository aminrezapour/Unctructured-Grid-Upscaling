clear all;
close all;

% baisc parameters
years = 3;          %lifecycle of the reservoir
date = Calendar_generator(years);

N = 90;             %length of experiment, 2 months
J = 100;            %nominal injection rate bbl/day
BHP = 2500;         %producer pressure psi
b = 0:0.02:0.5;     %amplitude percentage of the signal
f = 0.01:0.02:0.51; %upper freq band on variations

Ne = 26;            %please hand caldulate it

% water break through happens at 325 days (you should know this)
day1 = 120;         %before water break through
day2 = 320;         %during water break through
day3 = 900;         %after  water break through
days = [day1 day2 day3];

%% Generating the Training and Validation Data
% Training Data

U = zeros(N,Ne);
for i = 1:Ne
    U(:,i) = idinput([N 1],'prbs',[0 f(i)],[1-b(i) 1+b(i)]);
end
U = round(J*U);

% making the dat models
for i = 1:Ne
    copyfile('component1.txt',['model' num2str(i) '.dat']);
    fileID = fopen(['model' num2str(i) '.dat'],'a');
    fprintf(fileID,'\n');
    fprintf(fileID,['DATE ' num2str(date(1,:)) '.00000\n']);
    fprintf(fileID,'\n');
    fprintf(fileID,'**$\n');
    fprintf(fileID,'WELL  ''inj''\n');
    fprintf(fileID,'INJECTOR MOBWEIGHT ''inj''\n');
    fprintf(fileID,'INCOMP WATER\n');
    fprintf(fileID,['OPERATE MAX STW ' num2str(J) '.0 CONT\n']);
    fprintf(fileID,'**          rad  geofac  wfrac  skin\n');
    fprintf(fileID,'GEOMETRY  K  0.25  0.37  1.0  0.0\n');
    fprintf(fileID,'PERF  GEOA  ''inj''\n');
    fprintf(fileID,'** UBA      ff   Status  Connection\n');
    fprintf(fileID,'    1 40 1  1.0  OPEN    FLOW-FROM  ''SURFACE''\n');
    fprintf(fileID,'**\n');
    fprintf(fileID,'WELL  ''pro''\n');
    fprintf(fileID,'PRODUCER ''pro''\n');
    fprintf(fileID,['OPERATE  MIN  BHP ' num2str(BHP) '.0 CONT\n']);
    fprintf(fileID,'**          rad  geofac  wfrac  skin\n');
    fprintf(fileID,'GEOMETRY  K  0.25  0.37  1.0  0.0\n');
    fprintf(fileID,'PERF  GEOA  ''pro''\n');
    fprintf(fileID,'** UBA      ff   Status  Connection\n');
    fprintf(fileID,'    40 1 1  1.0  OPEN    FLOW-TO  ''SURFACE''\n');
    for j = 2:day1
        fprintf(fileID,['DATE ' num2str(date(j,:)) '.00000\n']);
    end
    temp = j+1;
    for j = temp:temp+N-1
        fprintf(fileID,['DATE ' num2str(date(j,:)) '.00000\n']);
        fprintf(fileID,'**$\n');
        fprintf(fileID,'WELL  ''inj''\n');
        fprintf(fileID,'INJECTOR MOBWEIGHT ''inj''\n');
        fprintf(fileID,'INCOMP WATER\n');
        fprintf(fileID,['OPERATE MAX STW ' num2str(U(j-day1,i)) '. CONT\n']);
    end
    j = j+1;
    fprintf(fileID,['DATE ' num2str(date(j,:)) '.00000\n']);
    fprintf(fileID,'**$\n');
    fprintf(fileID,'WELL  ''inj''\n');
    fprintf(fileID,'INJECTOR MOBWEIGHT ''inj''\n');
    fprintf(fileID,'INCOMP WATER\n');
    fprintf(fileID,['OPERATE MAX STW ' num2str(J) '. CONT\n']);
    for j = j+1:day2
        fprintf(fileID,['DATE ' num2str(date(j,:)) '.00000\n']);
    end
    temp = j+1;
    for j = temp:temp+N-1
        fprintf(fileID,['DATE ' num2str(date(j,:)) '.00000\n']);
        fprintf(fileID,'**$\n');
        fprintf(fileID,'WELL  ''inj''\n');
        fprintf(fileID,'INJECTOR MOBWEIGHT ''inj''\n');
        fprintf(fileID,'INCOMP WATER\n');
        fprintf(fileID,['OPERATE MAX STW ' num2str(U(j-day2,i)) '. CONT\n']);
    end
    j = j+1;
    fprintf(fileID,['DATE ' num2str(date(j,:)) '.00000\n']);
    fprintf(fileID,'**$\n');
    fprintf(fileID,'WELL  ''inj''\n');
    fprintf(fileID,'INJECTOR MOBWEIGHT ''inj''\n');
    fprintf(fileID,'INCOMP WATER\n');
    fprintf(fileID,['OPERATE MAX STW ' num2str(J) '. CONT\n']);
    for j = j+1:day3
        fprintf(fileID,['DATE ' num2str(date(j,:)) '.00000\n']);
    end
    temp = j+1;
    for j = temp:temp+N-1
        fprintf(fileID,['DATE ' num2str(date(j,:)) '.00000\n']);
        fprintf(fileID,'**$\n');
        fprintf(fileID,'WELL  ''inj''\n');
        fprintf(fileID,'INJECTOR MOBWEIGHT ''inj''\n');
        fprintf(fileID,'INCOMP WATER\n');
        fprintf(fileID,['OPERATE MAX STW ' num2str(U(j-day3,i)) '. CONT\n']);
    end
    j = j+1;
    fprintf(fileID,['DATE ' num2str(date(j,:)) '.00000\n']);
    fprintf(fileID,'**$\n');
    fprintf(fileID,'WELL  ''inj''\n');
    fprintf(fileID,'INJECTOR MOBWEIGHT ''inj''\n');
    fprintf(fileID,'INCOMP WATER\n');
    fprintf(fileID,['OPERATE MAX STW ' num2str(J) '. CONT\n']);
    for j = j+1:length(date)
        fprintf(fileID,['DATE ' num2str(date(j,:)) '.00000\n']);
    end
    fprintf(fileID,fileread('component2.txt'));
    fclose(fileID);
    
end

% making the rwd files
for i = 1:Ne
    fileID = fopen(['result' num2str(i) '.rwd'],'w');
    fprintf(fileID,['*FILES ''model' num2str(i) '.irf''\n']);
    fprintf(fileID,'*TABLE-FOR\n');
    fprintf(fileID,'\n');
    fprintf(fileID,'*COLUMN-FOR *PARAMETERS ''Bottom Hole Fluid Rate RC'' *GROUPS ''Default-Field-INJ''\n');
    fprintf(fileID,'*COLUMN-FOR *PARAMETERS ''Bottom Hole Fluid Rate RC'' *GROUPS ''Default-Field-PRO''\n');
    fprintf(fileID,'\n');
    fprintf(fileID,'*TABLE-END');
    fclose(fileID);
end

% making rwd files for dynamic analysis

for i = 1:Ne
    fileID = fopen(['dynamical' num2str(i) '.rwd'],'w');
    fprintf(fileID,['*FILES ''model' num2str(i) '.irf''\n']);
    fprintf(fileID,'*TABLE-FOR\n');
    fprintf(fileID,'\n');
    fprintf(fileID,'*COLUMN-FOR *PARAMETERS ''Well Block Pressure'' *WELLS ''inj''\n');
    fprintf(fileID,'*COLUMN-FOR *SPECIAL ''PRES 20,20,1 Pressure.''\n');
    fprintf(fileID,'*COLUMN-FOR *PARAMETERS ''Well Block Pressure'' *WELLS ''pro''\n');
    fprintf(fileID,'*COLUMN-FOR *SPECIALS ''PRES  Average Reservoir Pressure.''\n');
    fprintf(fileID,'*COLUMN-FOR *SPECIAL ''SW 20,20,1 Water Saturation.''\n');
    fprintf(fileID,'*COLUMN-FOR *SPECIAL ''SW 40,1,1 Water Saturation.''\n');
    fprintf(fileID,'*COLUMN-FOR *PARAMETERS ''Cumulative Oil SC'' *WELLS ''pro''\n');
    fprintf(fileID,'\n');
    fprintf(fileID,'*TABLE-END');
    fclose(fileID);
end

% Validation Data (index _v for vaidation)
U_v = zeros(N,Ne);
for i = 1:Ne
    U_v(:,i) = idinput([N 1],'rbs',[0 f(i)],[1-b(i) 1+b(i)]);
end
U_v = round(J*U_v);

[N,Ne] = size(U_v);   %Ne is the number of experiments

% making the dat models
for i = 1:Ne
    copyfile('component1.txt',['model_v' num2str(i) '.dat']);
    fileID = fopen(['model_v' num2str(i) '.dat'],'a');
    fprintf(fileID,'\n');
    fprintf(fileID,['DATE ' num2str(date(1,:)) '.00000\n']);
    fprintf(fileID,'\n');
    fprintf(fileID,'**$\n');
    fprintf(fileID,'WELL  ''inj''\n');
    fprintf(fileID,'INJECTOR MOBWEIGHT ''inj''\n');
    fprintf(fileID,'INCOMP WATER\n');
    fprintf(fileID,['OPERATE MAX STW ' num2str(J) '.0 CONT\n']);
    fprintf(fileID,'**          rad  geofac  wfrac  skin\n');
    fprintf(fileID,'GEOMETRY  K  0.25  0.37  1.0  0.0\n');
    fprintf(fileID,'PERF  GEOA  ''inj''\n');
    fprintf(fileID,'** UBA      ff   Status  Connection\n');
    fprintf(fileID,'    1 40 1  1.0  OPEN    FLOW-FROM  ''SURFACE''\n');
    fprintf(fileID,'**\n');
    fprintf(fileID,'WELL  ''pro''\n');
    fprintf(fileID,'PRODUCER ''pro''\n');
    fprintf(fileID,['OPERATE  MIN  BHP ' num2str(BHP) '.0 CONT\n']);
    fprintf(fileID,'**          rad  geofac  wfrac  skin\n');
    fprintf(fileID,'GEOMETRY  K  0.25  0.37  1.0  0.0\n');
    fprintf(fileID,'PERF  GEOA  ''pro''\n');
    fprintf(fileID,'** UBA      ff   Status  Connection\n');
    fprintf(fileID,'    40 1 1  1.0  OPEN    FLOW-TO  ''SURFACE''\n');
    for j = 2:day1
        fprintf(fileID,['DATE ' num2str(date(j,:)) '.00000\n']);
    end
    temp = j+1;
    for j = temp:temp+N-1
        fprintf(fileID,['DATE ' num2str(date(j,:)) '.00000\n']);
        fprintf(fileID,'**$\n');
        fprintf(fileID,'WELL  ''inj''\n');
        fprintf(fileID,'INJECTOR MOBWEIGHT ''inj''\n');
        fprintf(fileID,'INCOMP WATER\n');
        fprintf(fileID,['OPERATE MAX STW ' num2str(U_v(j-day1,i)) '. CONT\n']);
    end
    j = j+1;
    fprintf(fileID,['DATE ' num2str(date(j,:)) '.00000\n']);
    fprintf(fileID,'**$\n');
    fprintf(fileID,'WELL  ''inj''\n');
    fprintf(fileID,'INJECTOR MOBWEIGHT ''inj''\n');
    fprintf(fileID,'INCOMP WATER\n');
    fprintf(fileID,['OPERATE MAX STW ' num2str(J) '. CONT\n']);
    for j = j+1:day2
        fprintf(fileID,['DATE ' num2str(date(j,:)) '.00000\n']);
    end
    temp = j+1;
    for j = temp:temp+N-1
        fprintf(fileID,['DATE ' num2str(date(j,:)) '.00000\n']);
        fprintf(fileID,'**$\n');
        fprintf(fileID,'WELL  ''inj''\n');
        fprintf(fileID,'INJECTOR MOBWEIGHT ''inj''\n');
        fprintf(fileID,'INCOMP WATER\n');
        fprintf(fileID,['OPERATE MAX STW ' num2str(U_v(j-day2,i)) '. CONT\n']);
    end
    j = j+1;
    fprintf(fileID,['DATE ' num2str(date(j,:)) '.00000\n']);
    fprintf(fileID,'**$\n');
    fprintf(fileID,'WELL  ''inj''\n');
    fprintf(fileID,'INJECTOR MOBWEIGHT ''inj''\n');
    fprintf(fileID,'INCOMP WATER\n');
    fprintf(fileID,['OPERATE MAX STW ' num2str(J) '. CONT\n']);
    for j = j+1:day3
        fprintf(fileID,['DATE ' num2str(date(j,:)) '.00000\n']);
    end
    temp = j+1;
    for j = temp:temp+N-1
        fprintf(fileID,['DATE ' num2str(date(j,:)) '.00000\n']);
        fprintf(fileID,'**$\n');
        fprintf(fileID,'WELL  ''inj''\n');
        fprintf(fileID,'INJECTOR MOBWEIGHT ''inj''\n');
        fprintf(fileID,'INCOMP WATER\n');
        fprintf(fileID,['OPERATE MAX STW ' num2str(U_v(j-day3,i)) '. CONT\n']);
    end
    j = j+1;
    fprintf(fileID,['DATE ' num2str(date(j,:)) '.00000\n']);
    fprintf(fileID,'**$\n');
    fprintf(fileID,'WELL  ''inj''\n');
    fprintf(fileID,'INJECTOR MOBWEIGHT ''inj''\n');
    fprintf(fileID,'INCOMP WATER\n');
    fprintf(fileID,['OPERATE MAX STW ' num2str(J) '. CONT\n']);
    for j = j+1:length(date)
        fprintf(fileID,['DATE ' num2str(date(j,:)) '.00000\n']);
    end
    fprintf(fileID,fileread('component2.txt'));
    fclose(fileID);
    
end

% making the rwd files
for i = 1:Ne
    fileID = fopen(['result_v' num2str(i) '.rwd'],'w');
    fprintf(fileID,['*FILES ''model_v' num2str(i) '.irf''\n']);
    fprintf(fileID,'*TABLE-FOR\n');
    fprintf(fileID,'\n');
    fprintf(fileID,'*COLUMN-FOR *PARAMETERS ''Bottom Hole Fluid Rate RC'' *GROUPS ''Default-Field-INJ''\n');
    fprintf(fileID,'*COLUMN-FOR *PARAMETERS ''Bottom Hole Fluid Rate RC'' *GROUPS ''Default-Field-PRO''\n');
    fprintf(fileID,'\n');
    fprintf(fileID,'*TABLE-END');
    fclose(fileID);
end

% making the batch file
fileID = fopen('myBatch.bat','w');
fprintf(fileID,'cd\\\n');
fprintf(fileID,'cd C:\\Users\\rezapour.CISOFTN1\\My Documents\\GEM\\2009.13\\TPL\n');
for i = 1:Ne
    fprintf(fileID,['echo model' num2str(i) '.dat | "C:\\Program Files (x86)\\CMG\\IMEX\\2013.12\\Win_x64\\EXE\\mx201312.exe"\n']);
    fprintf(fileID,'(\n');
    fprintf(fileID,['echo result' num2str(i) '.rwd\n']);
    fprintf(fileID,['echo result' num2str(i) '.rwo\n']);
    fprintf(fileID,') | "C:\\Program Files (x86)\\CMG\\BR\\2013.20\\Win_x64\\EXE\\report.exe"\n');
    fprintf(fileID,'(\n');
    fprintf(fileID,['echo dynamical' num2str(i) '.rwd\n']);
    fprintf(fileID,['echo dynamical' num2str(i) '.rwo\n']);
    fprintf(fileID,') | "C:\\Program Files (x86)\\CMG\\BR\\2013.20\\Win_x64\\EXE\\report.exe"\n');
end
for i = 1:Ne
    fprintf(fileID,['echo model_v' num2str(i) '.dat | "C:\\Program Files (x86)\\CMG\\IMEX\\2013.12\\Win_x64\\EXE\\mx201312.exe"\n']);
    fprintf(fileID,'(\n');
    fprintf(fileID,['echo result_v' num2str(i) '.rwd\n']);
    fprintf(fileID,['echo result_v' num2str(i) '.rwo\n']);
    fprintf(fileID,') | "C:\\Program Files (x86)\\CMG\\BR\\2013.20\\Win_x64\\EXE\\report.exe"\n');    
end
fclose(fileID);

%% Copy The RWO Files First in this Folder
% this part cleans up the measurement data, and order it in increasing
% daily measurement

% Training data - generating the training data
for i = 1:Ne
    temp = data_generator(['result' num2str(i) '.rwo']);
    eval(['data' num2str(i) ' = temp;']);
    eval(['data' num2str(i) '(:,1) = floor(data' num2str(i) '(:,1));']);
    k = 1;
    eval(['temp = data' num2str(i) ';']);
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
    eval(['data' num2str(i) ' = temp;']);
end


% Dynamical Analysis data - generating the training data
for i = 1:Ne
    temp = data_generator_dynamical(['dynamical' num2str(i) '.rwo']);
    eval(['data_dynamical' num2str(i) '= temp;']);
    eval(['data_dynamical' num2str(i) '(:,1) = floor(data_dynamical' num2str(i) '(:,1));']);
    k = 1;
    eval(['temp = data_dynamical' num2str(i) ';']);
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
    eval(['data_dynamical' num2str(i) ' = temp;']);
end

% Validation Data - generating the validation data
for i = 1:Ne
    temp = data_generator(['result_v' num2str(i) '.rwo']);
    eval(['data_v' num2str(i) '= temp;']);
    eval(['data_v' num2str(i) '(:,1) = floor(data_v' num2str(i) '(:,1));']);
    k = 1;
    eval(['temp = data_v' num2str(i) ';']);
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
    eval(['data_v' num2str(i) ' = temp;']);
end

%% Training Data Analysis and Visualization

% plotting the input training data
figure;hold on;
stairs(U(:,1),':','LineWidth',2);
stairs(U(:,13),'-.','LineWidth',5);
stairs(U(:,26),'LineWidth',1);
title('examples of input signal');
xlabel('Time (day)');
ylabel('Injection Rate (bbl/day)');
legend('TR1.IN','TR13.IN','TR26.IN');

% freq content of the input training data
U_demo = zeros(20000,Ne);
for i = 1:Ne
    U_demo(:,i) = idinput([20000 1],'prbs',[0 f(i)],[-J*b(i) J*b(i)]);
end
figure;hold on;
pwelchParam = [1000 800 20000];   % [window length, overlap length, nfft]
[pxx1,w] = pwelch(U_demo(:,1),pwelchParam(1),pwelchParam(2),pwelchParam(3));
pxx2 = pwelch(U_demo(:,7),pwelchParam(1),pwelchParam(2),pwelchParam(3));
pxx3 = pwelch(U_demo(:,13),pwelchParam(1),pwelchParam(2),pwelchParam(3));
pxx4 = pwelch(U_demo(:,19),pwelchParam(1),pwelchParam(2),pwelchParam(3));
pxx5 = pwelch(U_demo(:,26),pwelchParam(1),pwelchParam(2),pwelchParam(3));
s = 1;
scatter(w,(pxx1),3*s);scatter(w,(pxx2),s);scatter(w,(pxx3),s);
scatter(w,(pxx4),s);scatter(w,(pxx5),s);
title('examples of the freq content of the input signals');
legend('TR1.IN','TR7.IN','TR13.IN','TR19.IN','TR26.IN');
xlabel('normalized frequency (rad/sample)');
ylabel('magnitude');
xlim([0 pi]);grid on;

% plotting the output training data for stage: before water breakthrough
figure;hold on;
[r,c] = find(data1(:,1)==days(1)+1);y = data1(r:r+N-1,3);stairs(121:210,y,':','LineWidth',2);
[r,c] = find(data13(:,1)==days(1)+1);y = data13(r:r+N-1,3);stairs(121:210,y,'-.','LineWidth',5);
[r,c] = find(data26(:,1)==days(1)+1);y = data26(r:r+N-1,3);stairs(121:210,y,'LineWidth',1);
title('output signal: before water break through');
xlabel('Date (day)');
ylabel('Liquid Rate (bbl/day)');
legend('TR1\_1.OUT','TR13\_1.OUT','TR26\_1.OUT');

% plotting the output training data for stage: during water breakthrough
figure;hold on;
[r,c] = find(data1(:,1)==days(2)+1);y = data1(r:r+N-1,3);stairs(321:410,y,':','LineWidth',2);
[r,c] = find(data13(:,1)==days(2)+1);y = data13(r:r+N-1,3);stairs(321:410,y,'-.','LineWidth',5);
[r,c] = find(data26(:,1)==days(2)+1);y = data26(r:r+N-1,3);stairs(321:410,y,'LineWidth',1);
title('output signal: during water break through');
xlabel('Date (day)');
ylabel('Liquid Rate (bbl/day)');
legend('TR1\_2.OUT','TR13\_2.OUT','TR26\_2.OUT');

% plotting the output training data for stage: after water breakthrough
figure;hold on;
[r,c] = find(data1(:,1)==days(3)+1);y = data1(r:r+N-1,3);stairs(901:990,y,':','LineWidth',2);
[r,c] = find(data13(:,1)==days(3)+1);y = data13(r:r+N-1,3);stairs(901:990,y,'-.','LineWidth',5);
[r,c] = find(data26(:,1)==days(3)+1);y = data26(r:r+N-1,3);stairs(901:990,y,'LineWidth',1);
title('output signal: during water break through');
xlabel('Date (day)');
ylabel('Liquid Rate (bbl/day)');
legend('TR1\_3.OUT','TR13\_3.OUT','TR26\_3.OUT');

% plotting one training set for whole lifecycle
figure;
plot(data13(:,1),data13(:,2),'b',data13(:,1),data13(:,3),'r','LineWidth',2);
title('lifecycle of HR11 for the input signal of TR13');
xlabel('Date (day)');
ylabel('Liquid Rate (bbl/day)');
legend('injection rate','production rate');

% plotting inj and pro block pressure
% before water breakthrough
figure;hold on;
[r,c] = find(data_dynamical5(:,1)==days(1)+1);y = data_dynamical5(r:r+N-1,2);stairs(121:210,y,':','LineWidth',2);
[r,c] = find(data_dynamical13(:,1)==days(1)+1);y = data_dynamical13(r:r+N-1,2);stairs(121:210,y,'-.','LineWidth',5);
[r,c] = find(data_dynamical26(:,1)==days(1)+1);y = data_dynamical26(r:r+N-1,2);stairs(121:210,y,'LineWidth',1);
[r,c] = find(data_dynamical5(:,1)==days(1)+1);y = data_dynamical5(r:r+N-1,3);stairs(121:210,y,'g:','LineWidth',2);
[r,c] = find(data_dynamical13(:,1)==days(1)+1);y = data_dynamical13(r:r+N-1,3);stairs(121:210,y,'g-.','LineWidth',5);
[r,c] = find(data_dynamical26(:,1)==days(1)+1);y = data_dynamical26(r:r+N-1,3);stairs(121:210,y,'g','LineWidth',1);
[r,c] = find(data_dynamical5(:,1)==days(1)+1);y = data_dynamical5(r:r+N-1,4);stairs(121:210,y,':','LineWidth',2);
[r,c] = find(data_dynamical13(:,1)==days(1)+1);y = data_dynamical13(r:r+N-1,4);stairs(121:210,y,'-.','LineWidth',5);
[r,c] = find(data_dynamical26(:,1)==days(1)+1);y = data_dynamical26(r:r+N-1,4);stairs(121:210,y,'LineWidth',1);
title('well block pressure: before water break through');
xlabel('Date (day)');
ylabel('Pressure (psi)');
% during water breakthrough
figure;hold on;
[r,c] = find(data_dynamical5(:,1)==days(2)+1);y = data_dynamical5(r:r+N-1,2);stairs(321:410,y,':','LineWidth',2);
[r,c] = find(data_dynamical13(:,1)==days(2)+1);y = data_dynamical13(r:r+N-1,2);stairs(321:410,y,'-.','LineWidth',5);
[r,c] = find(data_dynamical26(:,1)==days(2)+1);y = data_dynamical26(r:r+N-1,2);stairs(321:410,y,'LineWidth',1);
[r,c] = find(data_dynamical5(:,1)==days(2)+1);y = data_dynamical5(r:r+N-1,3);stairs(321:410,y,'g:','LineWidth',2);
[r,c] = find(data_dynamical13(:,1)==days(2)+1);y = data_dynamical13(r:r+N-1,3);stairs(321:410,y,'g-.','LineWidth',5);
[r,c] = find(data_dynamical26(:,1)==days(2)+1);y = data_dynamical26(r:r+N-1,3);stairs(321:410,y,'g','LineWidth',1);
[r,c] = find(data_dynamical5(:,1)==days(2)+1);y = data_dynamical5(r:r+N-1,4);stairs(321:410,y,':','LineWidth',2);
[r,c] = find(data_dynamical13(:,1)==days(2)+1);y = data_dynamical13(r:r+N-1,4);stairs(321:410,y,'-.','LineWidth',5);
[r,c] = find(data_dynamical26(:,1)==days(2)+1);y = data_dynamical26(r:r+N-1,4);stairs(321:410,y,'LineWidth',1);
title('well block pressure: during water break through');
xlabel('Date (day)');
ylabel('Pressure (psi)');
legend('TR5\_1.INJ','TR13\_1.INJ','TR26\_1.INJ','TR5\_1.AVE','TR13\_1.AVE','TR26\_1.AVE','TR5\_1.PRO','TR13\_1.PRO','TR26\_1.PRO');
% after water breakthrough
figure;hold on;
[r,c] = find(data_dynamical5(:,1)==days(3)+1);y = data_dynamical5(r:r+N-1,3);stairs(901:990,y,'g:','LineWidth',2);
[r,c] = find(data_dynamical13(:,1)==days(3)+1);y = data_dynamical13(r:r+N-1,3);stairs(901:990,y,'g-.','LineWidth',5);
[r,c] = find(data_dynamical26(:,1)==days(3)+1);y = data_dynamical26(r:r+N-1,3);stairs(901:990,y,'g','LineWidth',1);
[r,c] = find(data_dynamical5(:,1)==days(3)+1);y = data_dynamical5(r:r+N-1,2);stairs(901:990,y,':','LineWidth',2);
[r,c] = find(data_dynamical13(:,1)==days(3)+1);y = data_dynamical13(r:r+N-1,2);stairs(901:990,y,'-.','LineWidth',5);
[r,c] = find(data_dynamical26(:,1)==days(3)+1);y = data_dynamical26(r:r+N-1,2);stairs(901:990,y,'LineWidth',1);
[r,c] = find(data_dynamical5(:,1)==days(3)+1);y = data_dynamical5(r:r+N-1,4);stairs(901:990,y,':','LineWidth',2);
[r,c] = find(data_dynamical13(:,1)==days(3)+1);y = data_dynamical13(r:r+N-1,4);stairs(901:990,y,'-.','LineWidth',5);
[r,c] = find(data_dynamical26(:,1)==days(3)+1);y = data_dynamical26(r:r+N-1,4);stairs(901:990,y,'LineWidth',1);
title('well block pressure: during water break through');
xlabel('Date (day)');
ylabel('Pressure (psi)');

% well block saturation
% before water breakthrough
figure;hold on;
[r,c] = find(data_dynamical5(:,1)==days(1)+1);y = data_dynamical5(r:r+N-1,7);stairs(121:210,y,':','LineWidth',2);
[r,c] = find(data_dynamical13(:,1)==days(1)+1);y = data_dynamical13(r:r+N-1,7);stairs(121:210,y,'-.','LineWidth',5);
[r,c] = find(data_dynamical26(:,1)==days(1)+1);y = data_dynamical26(r:r+N-1,7);stairs(121:210,y,'LineWidth',1);
[r,c] = find(data_dynamical5(:,1)==days(1)+1);y = data_dynamical5(r:r+N-1,6);stairs(121:210,y,'g:','LineWidth',2);
[r,c] = find(data_dynamical13(:,1)==days(1)+1);y = data_dynamical13(r:r+N-1,6);stairs(121:210,y,'g-.','LineWidth',5);
[r,c] = find(data_dynamical26(:,1)==days(1)+1);y = data_dynamical26(r:r+N-1,6);stairs(121:210,y,'g','LineWidth',1);
title('well block saturation: before water break through');
xlabel('Date (day)');
ylabel('Saturation (%)');
axis([121 210 0.1 0.7]);
% during water breakthrough
figure;hold on;
[r,c] = find(data_dynamical5(:,1)==days(2)+1);y = data_dynamical5(r:r+N-1,7);stairs(321:410,y,':','LineWidth',2);
[r,c] = find(data_dynamical13(:,1)==days(2)+1);y = data_dynamical13(r:r+N-1,7);stairs(321:410,y,'-.','LineWidth',5);
[r,c] = find(data_dynamical26(:,1)==days(2)+1);y = data_dynamical26(r:r+N-1,7);stairs(321:410,y,'LineWidth',1);
[r,c] = find(data_dynamical5(:,1)==days(2)+1);y = data_dynamical5(r:r+N-1,6);stairs(321:410,y,'g:','LineWidth',2);
[r,c] = find(data_dynamical13(:,1)==days(2)+1);y = data_dynamical13(r:r+N-1,6);stairs(321:410,y,'g-.','LineWidth',5);
[r,c] = find(data_dynamical26(:,1)==days(2)+1);y = data_dynamical26(r:r+N-1,6);stairs(321:410,y,'g','LineWidth',1);
title('well block saturation: during water break through');
xlabel('Date (day)');
ylabel('Saturation (%)');
axis([321 410 0.1 0.7]);
% after water breakthrough
figure;hold on;
[r,c] = find(data_dynamical5(:,1)==days(3)+1);y = data_dynamical5(r:r+N-1,6);stairs(901:990,y,'g:','LineWidth',2);
[r,c] = find(data_dynamical13(:,1)==days(3)+1);y = data_dynamical13(r:r+N-1,6);stairs(901:990,y,'g-.','LineWidth',5);
[r,c] = find(data_dynamical26(:,1)==days(3)+1);y = data_dynamical26(r:r+N-1,6);stairs(901:990,y,'g','LineWidth',1);
[r,c] = find(data_dynamical5(:,1)==days(3)+1);y = data_dynamical5(r:r+N-1,7);stairs(901:990,y,':','LineWidth',2);
[r,c] = find(data_dynamical13(:,1)==days(3)+1);y = data_dynamical13(r:r+N-1,7);stairs(901:990,y,'-.','LineWidth',5);
[r,c] = find(data_dynamical26(:,1)==days(3)+1);y = data_dynamical26(r:r+N-1,7);stairs(901:990,y,'LineWidth',1);
title('well block saturation: during water break through');
xlabel('Date (day)');
ylabel('Saturation (%)');
axis([901 990 0.1 0.7]);
legend('TR5\_1.PRO','TR13\_1.PRO','TR26\_1.PRO','TR5\_1.AVE','TR13\_1.AVE','TR26\_1.AVE');

% cummulative oil
figure;
plot(data_dynamical1(:,1),data_dynamical1(:,8),data_dynamical5(:,1),data_dynamical5(:,8),...
    data_dynamical10(:,1),data_dynamical10(:,8),data_dynamical15(:,1),data_dynamical15(:,8),...
    data_dynamical20(:,1),data_dynamical20(:,8),data_dynamical26(:,1),data_dynamical26(:,8));
title('cumulative produced oil for 6 training data');
xlabel('Date (day)');
ylabel('Produced Oil (bbl)');
legend('TR1','TR5','TR10','TR15','TR20','TR26');


%% Data Pre-Processing

N = 60;   % change the length of the experiment
% training data in form of 3 sets of iddata for 3 stages
for i = 1:Ne
    for j = 1:3
        eval(['[r,c] = find(data' num2str(i) '(:,1)==days(j)+1);']);
%         u = U(1:N,i) - J*ones(N,1);
        eval(['u = detrend(data' num2str(i) '(r:r+N-1,2));']);
        eval(['y = detrend(data' num2str(i) '(r:r+N-1,3));']);
        eval(['training' num2str(i) '_' num2str(j) ' = iddata(y,u,1);']);
    end
end

% validation data in form of iddata
for i = 1:Ne
    for j = 1:3
        eval(['[r,c] = find(data_v' num2str(i) '(:,1)==days(j)+1);']);
%         u = U_v(1:N,i) - J*ones(N,1);
        eval(['u = detrend(data_v' num2str(i) '(r:r+N-1,2));']);
        eval(['y = detrend(data_v' num2str(i) '(r:r+N-1,3));']);
        eval(['validation' num2str(i) '_' num2str(j) ' = iddata(y,u,1);']);
    end
end

%% Identification of CM models

% estimating CM models
arxParameters = [1 1 0]; 

for i = 1:Ne
    for j = 1:3
        eval(['ARX' num2str(i) '_' num2str(j) ' = arx(training' num2str(i) '_' num2str(j) ',arxParameters);']);
    end
end

% Model Validation of CM

% training error
fit = zeros(Ne,3);
for j = 1:3
    for i = 1:Ne
        eval(['[temp,fit(i,j),temp1] = compare(training' num2str(i) '_' num2str(j) ',ARX' num2str(i) '_' num2str(j) ');']);
    end
end
figure;
plot(1:Ne,fit(:,1),'o-',1:Ne,fit(:,2),'+-',1:Ne,fit(:,3),'*-');
title('Capacitance Model - TRAINING data simulation error');
xlabel('CM_index (excitation increases with index)');
ylabel('Fit (%)');
legend('before','during','after');
axis([0 Ne+1 0 100]);

% validation error
fit_v = zeros(Ne,3);
for j = 1:3
    for i = 1:Ne
        eval(['[temp,fit_v(i,j),temp1] = compare(validation' num2str(i) '_' num2str(j) ',ARX' num2str(i) '_' num2str(j) ');']);
    end
end
figure;
plot(1:Ne,fit_v(:,1),'o-',1:Ne,fit_v(:,2),'+-',1:Ne,fit_v(:,3),'*-');
title('Capacitance Model - VALIDATION data simulations error');
xlabel('CM_index (excitation increases with index)');
ylabel('Fit (%)');
legend('before','during','after');
axis([0 Ne+1 0 100]);

% validation error for only 1 validation set VA13
fit_v_special = zeros(Ne,3);
for j = 1:3
    for i = 1:Ne
        eval(['[temp,fit_v_special(i,j),temp1] = compare(validation13_' num2str(j) ',ARX' num2str(i) '_' num2str(j) ');']);
    end
end
figure;
plot(1:Ne,fit_v_special(:,1),'o-',1:Ne,fit_v_special(:,2),'+-',1:Ne,fit_v_special(:,3),'*-');
title('Capacitance Model - VALIDATION VA13 simulation error');
xlabel('CM_index (excitation increases with index)');
ylabel('Fit (%)');
legend('before','during','after');
axis([0 Ne+1 0 100]);

%% Identification of DCM models

% estimating DCM models
arxParameters = [2 1 0]; 

for i = 1:Ne
    for j = 1:3
        eval(['ARX' num2str(i) '_' num2str(j) ' = arx(training' num2str(i) '_' num2str(j) ',arxParameters);']);
    end
end

% Model Validation of DCM

% training error
fit = zeros(Ne,3);
for j = 1:3
    for i = 1:Ne
        eval(['[temp,fit(i,j),temp1] = compare(training' num2str(i) '_' num2str(j) ',ARX' num2str(i) '_' num2str(j) ');']);
    end
end
figure;
plot(1:Ne,fit(:,1),'o-',1:Ne,fit(:,2),'+-',1:Ne,fit(:,3),'*-');
title('Distributed Capacitance Model - TRAINING data simulation error');
xlabel('DCM_index (excitation increases with index)');
ylabel('Fit (%)');
legend('before','during','after');
axis([0 Ne+1 0 100]);

% validation error
fit_v = zeros(Ne,3);
for j = 1:3
    for i = 1:Ne
        eval(['[temp,fit_v(i,j),temp1] = compare(validation' num2str(i) '_' num2str(j) ',ARX' num2str(i) '_' num2str(j) ');']);
    end
end
figure;
plot(1:Ne,fit_v(:,1),'o-',1:Ne,fit_v(:,2),'+-',1:Ne,fit_v(:,3),'*-');
title('Distributed Capacitance Model - VALIDATION data simulations error');
xlabel('DCM_index (excitation increases with index)');
ylabel('Fit (%)');
legend('before','during','after');
axis([0 Ne+1 0 100]);

% validation error for only 1 validation set VA13
fit_v_special = zeros(Ne,3);
for j = 1:3
    for i = 1:Ne
        eval(['[temp,fit_v_special(i,j),temp1] = compare(validation13_' num2str(j) ',ARX' num2str(i) '_' num2str(j) ');']);
    end
end
figure;
plot(1:Ne,fit_v_special(:,1),'o-',1:Ne,fit_v_special(:,2),'+-',1:Ne,fit_v_special(:,3),'*-');
title('Distributed Capacitance Model - VALIDATION VA13 simulation error');
xlabel('DCM_index (excitation increases with index)');
ylabel('Fit (%)');
legend('before','during','after');
axis([0 Ne+1 0 100]);

%% Identification of ARX models

% estimating ARX models
arxParameters = [2 2 0]; 

for i = 1:Ne
    for j = 1:3
        eval(['ARX' num2str(i) '_' num2str(j) ' = arx(training' num2str(i) '_' num2str(j) ',arxParameters);']);
    end
end

% Model Validation of ARX

% training error
fit = zeros(Ne,3);
for j = 1:3
    for i = 1:Ne
        eval(['[temp,fit(i,j),temp1] = compare(training' num2str(i) '_' num2str(j) ',ARX' num2str(i) '_' num2str(j) ');']);
    end
end
figure;
plot(1:Ne,fit(:,1),'o-',1:Ne,fit(:,2),'+-',1:Ne,fit(:,3),'*-');
title('ARX Model - TRAINING data simulation error');
xlabel('ARX_index (excitation increases with index)');
ylabel('Fit (%)');
legend('before','during','after');
axis([0 Ne+1 0 100]);

% validation error
fit_v = zeros(Ne,3);
for j = 1:3
    for i = 1:Ne
        eval(['[temp,fit_v(i,j),temp1] = compare(validation' num2str(i) '_' num2str(j) ',ARX' num2str(i) '_' num2str(j) ');']);
    end
end
figure;
plot(1:Ne,fit_v(:,1),'o-',1:Ne,fit_v(:,2),'+-',1:Ne,fit_v(:,3),'*-');
title('ARX Model - VALIDATION data simulations error');
xlabel('ARX_index (excitation increases with index)');
ylabel('Fit (%)');
legend('before','during','after');
axis([0 Ne+1 0 100]);

% validation error for only 1 validation set VA13
fit_v_special = zeros(Ne,3);
for j = 1:3
    for i = 1:Ne
        eval(['[temp,fit_v_special(i,j),temp1] = compare(validation12_' num2str(j) ',ARX' num2str(i) '_' num2str(j) ');']);
    end
end
figure;
plot(1:Ne,fit_v_special(:,1),'o-',1:Ne,fit_v_special(:,2),'+-',1:Ne,fit_v_special(:,3),'*-');
title('ARX Model - VALIDATION VA13 simulation error');
xlabel('ARX_index (excitation increases with index)');
ylabel('Fit (%)');
legend('before','during','after');
axis([0 Ne+1 0 100]);

%% Identification of FIR models

% estimating FIR models
arxParameters = [0 14 0]; 

for i = 1:Ne
    for j = 1:3
        eval(['ARX' num2str(i) '_' num2str(j) ' = arx(training' num2str(i) '_' num2str(j) ',arxParameters);']);
    end
end

% Model Validation of FIR

% training error
fit = zeros(Ne,3);
for j = 1:3
    for i = 1:Ne
        eval(['[temp,fit(i,j),temp1] = compare(training' num2str(i) '_' num2str(j) ',ARX' num2str(i) '_' num2str(j) ');']);
    end
end
figure;
plot(1:Ne,fit(:,1),'o-',1:Ne,fit(:,2),'+-',1:Ne,fit(:,3),'*-');
title('FIR Model - TRAINING data simulation error');
xlabel('FIR_index (excitation increases with index)');
ylabel('Fit (%)');
legend('before','during','after');
axis([0 Ne+1 0 100]);

% validation error
fit_v = zeros(Ne,3);
for j = 1:3
    for i = 1:Ne
        eval(['[temp,fit_v(i,j),temp1] = compare(validation' num2str(i) '_' num2str(j) ',ARX' num2str(i) '_' num2str(j) ');']);
    end
end
figure;
plot(1:Ne,fit_v(:,1),'o-',1:Ne,fit_v(:,2),'+-',1:Ne,fit_v(:,3),'*-');
title('FIR Model - VALIDATION data simulations error');
xlabel('FIR_index (excitation increases with index)');
ylabel('Fit (%)');
legend('before','during','after');
axis([0 Ne+1 0 100]);

% validation error for only 1 validation set VA13
fit_v_special = zeros(Ne,3);
for j = 1:3
    for i = 1:Ne
        eval(['[temp,fit_v_special(i,j),temp1] = compare(validation12_' num2str(j) ',ARX' num2str(i) '_' num2str(j) ');']);
    end
end
figure;
plot(1:Ne,fit_v_special(:,1),'o-',1:Ne,fit_v_special(:,2),'+-',1:Ne,fit_v_special(:,3),'*-');
title('FIR Model - VALIDATION VA13 simulation error');
xlabel('FIR_index (excitation increases with index)');
ylabel('Fit (%)');
legend('before','during','after');
axis([0 Ne+1 0 100]);

%% Identification of SubID

% estimating SUBID models
subidParameters = 2; % model order

for i = 1:Ne
    for j = 1:3
        eval(['SUBID' num2str(i) '_' num2str(j) ' = n4sid(training' num2str(i) '_' num2str(j) ',subidParameters);']);
    end
end

% Model Validation of SubID

% training error
fit = zeros(Ne,3);
for j = 1:3
    for i = 1:Ne
        eval(['[temp,fit(i,j),temp1] = compare(training' num2str(i) '_' num2str(j) ',SUBID' num2str(i) '_' num2str(j) ');']);
    end
end
figure;
plot(1:Ne,fit(:,1),'o-',1:Ne,fit(:,2),'+-',1:Ne,fit(:,3),'*-');
title('State Space Model - TRAINING simulation error');
xlabel('SUBID_index (excitation increases with index)');
ylabel('Fit (%)');
legend('before','during','after');
axis([0 Ne+1 0 100]);

% validation error
fit_v = zeros(Ne,3);
for j = 1:3
    for i = 1:Ne
        eval(['[temp,fit_v(i,j),temp1] = compare(validation' num2str(i) '_' num2str(j) ',SUBID' num2str(i) '_' num2str(j) ');']);
    end
end
figure;
plot(1:Ne,fit_v(:,1),'o-',1:Ne,fit_v(:,2),'+-',1:Ne,fit_v(:,3),'*-');
title('State Space Model - VALIDATION simulation error');
xlabel('SUBID_index (excitation increases with index)');
ylabel('Fit (%)');
legend('before','during','after');
axis([0 Ne+1 0 100]);

% validation error for only 1 validation set
fit_v_special = zeros(Ne,3);
for j = 1:3
    for i = 1:Ne
        eval(['[temp,fit_v_special(i,j),temp1] = compare(validation12_' num2str(j) ',SUBID' num2str(i) '_' num2str(j) ');']);
    end
end
figure;
plot(1:Ne,fit_v_special(:,1),'o-',1:Ne,fit_v_special(:,2),'+-',1:Ne,fit_v_special(:,3),'*-');
title('State Space Model - VALIDATION VA13 simulation error');
xlabel('SUBID_index (excitation increases with index)');
ylabel('Fit (%)');
legend('before','during','after');
axis([0 Ne+1 0 100]);
