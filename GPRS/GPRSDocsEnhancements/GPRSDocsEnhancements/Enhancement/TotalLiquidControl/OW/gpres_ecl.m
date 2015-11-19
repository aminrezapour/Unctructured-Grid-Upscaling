close all;
clear;
clc;

load RES1_PROD.out
gprs = RES1_PROD;
gprs_t = gprs(:,1);
gprs_qo = gprs(:,3);
gprs_qw = gprs(:,4);

load OW.RSM
ecl = OW;
ecl_t = ecl(:,1);
ecl_qo = ecl(:,3);
ecl_qw = ecl(:,4);

figure
plot(ecl_t, ecl_qo,'.');
hold on
plot(gprs_t, gprs_qo,'r');
xlabel('Time (day)');
ylabel('Oil Rate (bbl/day)');
legend ('Eclipse','GPRS');
title ('Oil Production');
hold off


figure
plot(ecl_t, ecl_qw,'.');
hold on
plot(gprs_t, gprs_qw,'r');
xlabel('Time (day)');
ylabel('Water Rate (bbl/day)');
legend ('Eclipse','GPRS');
title ('Water Production');
hold off

figure
plot(ecl_t, ecl_qo+ecl_qw,'.');
hold on
plot(gprs_t, gprs_qo+gprs_qw,'r');
xlabel('Time (day)');
ylabel('Liquid Rate (bbl/day)');
legend ('Eclipse','GPRS');
title ('Liquid Production');
hold off

figure
plot(ecl_t, ecl_qw./(ecl_qo+ecl_qw),'.');
hold on
plot(gprs_t, gprs_qw./(gprs_qo+gprs_qw),'r');
xlabel('Time (day)');
ylabel('Water Cut');
legend ('Eclipse','GPRS',0);
title ('Water Cut');
hold off


gprs_p = gprs(:,2);

ecl_p = ecl(:,5);

figure
plot(ecl_t, ecl_p,'.');
hold on
plot(gprs_t, gprs_p,'r');
xlabel('Time (day)');
ylabel('Producer BHP');
legend ('Eclipse','GPRS',0);
title ('Producer BHP');
hold off

