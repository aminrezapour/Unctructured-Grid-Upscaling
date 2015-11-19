clear all;
clc


%% extract Eclipse File
fid = fopen([pwd '/Ecl/CASE4.RSM']);
ecl = [];
% junk
for i = 1:9, tline = fgetl(fid); end

while 1
    tline = fgetl(fid);
    if ~ischar(tline),   break,   end
    
    
    % end of results
    temp = str2num(tline);
    if(temp == 1), break, end
    
    ecl = [ecl; temp];
end
fclose(fid);

%% Extract GPRS prod file

fid = fopen([pwd '/Gprs/RES1_PROD.out']);
gprsProd = [];
nPart = 1;

% junk
for i = 1:4, tline = fgetl(fid); end

while 1
    tline = fgetl(fid);
    if ~ischar(tline),   break,   end
    
    % end of results
    temp = str2num(tline);
   
    gprsProd = [gprsProd; temp];
end
fclose(fid);

%% Extract GPRS Inj file

fid = fopen([pwd '/Gprs/RES1_INJ.out']);
gprsInj = [];
nPart = 1;

% junk
for i = 1:4, tline = fgetl(fid); end

while 1
    tline = fgetl(fid);
    if ~ischar(tline),   break,   end
    
    % end of results
    temp = str2num(tline);
   
    gprsInj = [gprsInj; temp];
end
fclose(fid);

%% Compare

figure(1)
plot(ecl(:,1), ecl(:,4), gprsProd(:,1), gprsProd(:,3),'*');
legend('Ecl', 'GPRS')
title('GAS Production Rate')
xlabel('time/days')
ylabel('WGPR(MSCF/day)');

figure(2)
plot(ecl(:,1), ecl(:,3), gprsProd(:,1), gprsProd(:,4),'*');
legend('Ecl', 'GPRS')
title('Oil Production Rate')
xlabel('time/days')
ylabel('WOPR(STB/day)');


figure(3)
plot(ecl(:,1), ecl(:,5), gprsInj(:,1), -gprsInj(:,3),'*');
legend('Ecl', 'GPRS')
title('GAS Inj Rate')
xlabel('time/days')
ylabel('FGIR(MSCF/day)');



