@echo off

rem:  
rem:  batch file: Batch2PSamples.bat to run all GPRS samples for two-point (2P) flux
rem:  Execute: type Batch2PSamples in the Command Window
rem:

rem: see GPRS-DOCS\Setups\BatchSamples.doc for detail description

rem:  Note that one can set the runSamples variable to run black, 
rem:            compositional or all samples 
rem:

rem:  
rem:  request -- set the following variables before executing the batch file
rem:    ExeFolder--absolute path of GPRS executable
rem:    blackOilPath -- absolute root path of black oil samples
rem:    compositionalPath -- absolute root path of compositional samples
rem:    GPRSExecute -- GPRS executable name, default GPRS
rem:    runSamples -- samples to be run: 
rem:    	blockOil--black oils
rem:    	composition--compositional samples
rem:    	all--all samples (both black and compositional oils)
rem:		default -- all samples
rem:	screenFileName -- file name of saving screen output (cout and cerr) 
rem:			  for each sample
rem:		default -- screenOutput.txt
rem:	

 
rem:  
rem: set variables section
rem:  

rem: set running samples
rem: blockOil--black oils
rem: composition--compositional samples
rem: all--all samples (both black and compositional oils)
rem: Note that select one and comment other two in the following
rem: set runSamples=all
set runSamples=MSWell
rem: set runSamples=blockOil
rem: set runSamples=composition


rem: set the folder of GPRS executable
set ExeFolder=D:\GPRS-samples\executables

rem: setup the GPRS executable directory to PATH enviroment variable
set PATH=%PATH%;%ExeFolder%

set pathSams=2P

rem: set the folder for black oil samples
set blackOilPath=D:\GPRS-samples\%pathSams%\BlackOil

rem: set the folder for compositional samples
set compositionalPath=D:\GPRS-samples\%pathSams%\Compositional

rem: set the folder for compositional-AIM samples
set compositionalPath-AIM=D:\GPRS-samples\%pathSams%\Compositional-AIM

rem: set the folder for compositional-CSAT samples
set compositionalPath-CSAT=D:\GPRS-samples\%pathSams%\CSAT

rem: set the folder for MSWell samples
set MSWellPath=D:\GPRS-samples\%pathSams%\MSWell

rem: set the folder for MSWell-Compositional samples
set MSWellCompPath=D:\GPRS-samples\%pathSams%\MSWell\Compositional

rem: set the folder for thermal samples
set thermalPath=D:\GPRS-samples\%pathSams%\thermal

rem: set the GPRS executable
set GPRSExecute=GPRSRelease

rem: set screen output file name (re-direct screen output, i.e. cout and cerr)
set screenFileName=screenOutput.txt

rem: pause is used for debug
rem: pause 

rem: 
rem: go to different sample directory and run GPRS
rem: 

echo start run %runSamples% samples

IF %runSamples%==composition goto compositional

IF %runSamples%==MSWell goto MSWELL

rem: 
rem: Black oil samples
rem: 
echo === Black Oils =====
echo run %blackOilPath%\Black3PInjGas sample
cd %blackOilPath%\Black3PInjGas
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %blackOilPath%\Black3pinjWater sample
cd %blackOilPath%\Black3pinjWater
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %blackOilPath%\BlackOW sample
cd %blackOilPath%\BlackOW
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %blackOilPath%\BOWAIM sample
cd %blackOilPath%\BOWAIM
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %blackOilPath%\BOWImpes sample
cd %blackOilPath%\BOWImpes
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %blackOilPath%\SPE1 sample
cd %blackOilPath%\SPE1
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %blackOilPath%\SPE1_HW sample
cd %blackOilPath%\SPE1_HW
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %blackOilPath%\SPE1-MultTime sample
cd %blackOilPath%\SPE1-MultTime
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %blackOilPath%\Multi_rockfluid sample
cd %blackOilPath%\Multi_rockfluid
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %blackOilPath%\SPE1-reStart sample
cd %blackOilPath%\SPE1-reStart
%GPRSExecute% > %screenFileName% 2>&1
rem: re-set reStart file
copy old_reStartFile.dat reStartFile.dat
echo.

:endBlackOils


IF %runSamples%==blockOil goto end

rem: 
rem: Compositional samples
rem: 
:compositional
echo === Compositional samples =====
echo run %compositionalPath%\CO2-H2O sample
cd %compositionalPath%\CO2-H2O
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %compositionalPath%\CO2-H2O-fast-C sample
cd %compositionalPath%\CO2-H2O-fast-C
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %compositionalPath%\CO2-H2O-fast-K sample
cd %compositionalPath%\CO2-H2O-fast-K
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %compositionalPath%\COMP sample
cd %compositionalPath%\COMP
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %compositionalPath%\Comp2PInjGas sample
cd %compositionalPath%\Comp2PInjGas
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %compositionalPath%\Comp3PInjGas sample
cd %compositionalPath%\Comp3PInjGas
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %compositionalPath%\Comp3PInjWater sample
cd %compositionalPath%\Comp3PInjWater
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %compositionalPath%\CompSPE3 sample
cd %compositionalPath%\CompSPE3
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %compositionalPath%\CompSPE3-3000 sample
cd %compositionalPath%\CompSPE3-3000
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %compositionalPath%\GasInj3phRate sample
cd %compositionalPath%\GasInj3phRate
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %compositionalPath%\SPE5IMM sample
cd %compositionalPath%\SPE5IMM
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %compositionalPath%\SPE5WAG sample
cd %compositionalPath%\SPE5WAG
%GPRSExecute% > %screenFileName% 2>&1
echo.


rem: 
rem: Compositional-AIM samples
rem: 
:Compositional-AIM
echo === Compositional-AIM samples =====
echo run %compositionalPath-AIM%\CompOGAIM sample
cd %compositionalPath-AIM%\CompOGAIM
%GPRSExecute% > %screenFileName% 2>&1
echo.

rem: echo run %compositionalPath-AIM%\CompOGAIMTypeB sample
rem: cd %compositionalPath-AIM%\CompOGAIMTypeB
rem: %GPRSExecute% > %screenFileName% 2>&1
rem: echo.

echo run %compositionalPath-AIM%\CompOGImpsat sample
cd %compositionalPath-AIM%\CompOGImpsat
%GPRSExecute% > %screenFileName% 2>&1
echo.

rem: echo run %compositionalPath-AIM%\CompOGTypeB sample
rem: cd %compositionalPath-AIM%\CompOGTypeB
rem: %GPRSExecute% > %screenFileName% 2>&1
rem: echo.


rem: 
rem: Compositional-CSAT samples
rem: 
:Compositional-CSAT
echo === CSAT samples =====
echo run %compositionalPath-CSAT%\4comp sample
cd %compositionalPath-CSAT%\4comp
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %compositionalPath-CSAT%\4comp_iso sample
cd %compositionalPath-CSAT%\4comp_iso
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %compositionalPath-CSAT%\SPE3 sample
cd %compositionalPath-CSAT%\SPE3
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %compositionalPath-CSAT%\SPE3_iso sample
cd %compositionalPath-CSAT%\SPE3_iso
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %compositionalPath-CSAT%\SPE5 sample
cd %compositionalPath-CSAT%\SPE5
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %compositionalPath-CSAT%\SPE5_iso sample
cd %compositionalPath-CSAT%\SPE5_iso
%GPRSExecute% > %screenFileName% 2>&1
echo.


rem: 
rem: MSWell samples (2P only)
rem: 

echo === Multi-segment well samples =====
:MSWell
echo = Black Oil =
echo run %MSWellPath%\300SEGOG sample
cd %MSWellPath%\300SEGOG
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %MSWellPath%\3Laterals2POG sample
cd %MSWellPath%\3Laterals2POG
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %MSWellPath%\3Laterals3P sample
cd %MSWellPath%\3Laterals3P
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %MSWellPath%\3P45devHO sample
cd %MSWellPath%\3P45devHO
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %MSWellPath%\3P-DF-Inclined sample
cd %MSWellPath%\3P-DF-Inclined
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %MSWellPath%\3P-DF-Vertical sample
cd %MSWellPath%\3P-DF-Vertical
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %MSWellPath%\3P-DF-vert-WRate sample
cd %MSWellPath%\3P-DF-vert-WRate
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo = Compositional =
echo run %MSWellCompPath%\Isothermal\2P_Vertical sample
cd %MSWellCompPath%\Isothermal\2P_Vertical
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %MSWellCompPath%\Isothermal\2P_Vertical_immiscible_inj sample
cd %MSWellCompPath%\Isothermal\2P_Vertical_immiscible_inj
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %MSWellCompPath%\Isothermal\2P_Vertical_miscible_inj sample
cd %MSWellCompPath%\Isothermal\2P_Vertical_miscible_inj
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %MSWellCompPath%\Isothermal\3P_Inclined sample
cd %MSWellCompPath%\Isothermal\3P_Inclined
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %MSWellCompPath%\Isothermal\3P_Multilateral sample
cd %MSWellCompPath%\Isothermal\3P_Multilateral
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %MSWellCompPath%\Isothermal\3P_Multilateral_Water_inj sample
cd %MSWellCompPath%\Isothermal\3P_Multilateral_Water_inj
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %MSWellCompPath%\Isothermal\3P_Vertical_Gas_inj sample
cd %MSWellCompPath%\Isothermal\3P_Vertical_Gas_inj
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %MSWellCompPath%\Thermal\3P_Inclined sample
cd %MSWellCompPath%\Thermal\3P_Inclined
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %MSWellCompPath%\Thermal\3P_Inclined_hot_Water_inj sample
cd %MSWellCompPath%\Thermal\3P_Inclined_hot_Water_inj
%GPRSExecute% > %screenFileName% 2>&1
echo.

IF %runSamples%==MSWell goto end

rem: 
rem: thermal samples (2P only)
rem: 

:thermal
echo === Thermal Samples =====
echo run %thermalPath%\GasInj2PhaseComp sample
cd %thermalPath%\GasInj2PhaseComp
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %thermalPath%\GasInj3PhaseBO sample
cd %thermalPath%\GasInj3PhaseBO
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %thermalPath%\WaterInj2Phase sample
cd %thermalPath%\WaterInj2Phase
%GPRSExecute% > %screenFileName% 2>&1
echo.

echo run %thermalPath%\WaterInj3PhaseComp sample
cd %thermalPath%\WaterInj3PhaseComp
%GPRSExecute% > %screenFileName% 2>&1
echo.



:end
rem: back to batch file folder
cd %ExeFolder%

echo end GPRS execution




