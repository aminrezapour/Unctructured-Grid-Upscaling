The four cases here are those in Yi's thesis.
Case 1:
Pure delpletion case with a reservoir whose Bubble point is nonuniformly distributed.
Case 2-GAS:
Gas Injection
Case 3-WATER:
Water Injection
Case 4-WAG:
Gas and Water Injected alternatively.


All the cases have two folders:
Input:
gprs.in:      gprs input file for TPCA model
gprs-BO.in *: gprs input file for black oil model
ECL.data:     ECLIPSE 100 input file

Output:
RES1_INJ.out:   injection data for TPCA model
RES1_PROD.out:  production data for TPCA model
RES1_Debug.out: detailed saturation, pressure etc for TPCA model

RES1_INJ1.out:   injection data for black-oil model
RES1_PROD1.out:  production data for black-oil model
RES1_Debug1.out: detailed saturation, pressure etc for black-oil model


*It should be noticed that the black oil input file should be tested with the original version of GPRS. There are some input/output mismatches between the black-oil input files and new GPRS with TPCA model.
