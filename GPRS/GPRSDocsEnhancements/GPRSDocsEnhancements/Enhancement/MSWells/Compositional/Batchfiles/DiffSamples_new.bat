@echo off

rem:  
rem:  batch file to get the differences of well output between testing 
rem:  and standard results for all GPRS samples
rem:  
rem:  see GPRS-DOCS\Setups\BatchSamples.doc for detail description
rem:  

rem:  
rem:  Set the following variables before execute the batch file
rem:    diffExecPath--absolute path in which SS.exe resides
rem:    BatchFolder -- absolute path in which this batch file resides
rem:    ImpFolder -- absolute root path of testing samples
rem:    RefFolder -- absolute root path of standard samples
rem:



rem: set folder in which SS.exe resides
set diffExecPath=C:\Program Files\Microsoft Visual Studio\VSS\win32

rem: set the folder in which this batch file resides
set BatchFolder=D:\GPRS-samples\executables

rem: set the implementation root folder
set ImpFolder=D:\GPRS-samples

rem: set the reference root folder
set RefFolder=D:\GPRS-samples\RefResults

rem: set SS executable path to PATH variable
set PATH=%PATH%;%diffExecPath%

rem: set command and parameters for diff
set DiffCommand=SS Diff -DS -ICWE


rem: 
rem: Black oil samples for 2P
rem: 

set rootDir=\2P\BlackOil

echo Black oil samples for 2P

rem: Black3PInjGas
set sampleName=Black3PInjGas
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: Black3pinjWater
set sampleName=Black3pinjWater
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: BlackOW
set sampleName=BlackOW
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: BOWAIM
set sampleName=BOWAIM
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: BOWImpes
set sampleName=BOWImpes
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: Multi_rockfluid
set sampleName=Multi_rockfluid
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: SPE1
set sampleName=SPE1
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: SPE1_HW
set sampleName=SPE1_HW
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: SPE1-MultTime
set sampleName=SPE1-MultTime
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: SPE1-reStart
set sampleName=SPE1-reStart
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1


echo.


rem: 
rem: Compositional samples for 2P
rem: 

set rootDir=\2P\Compositional

echo Compositional samples for 2P

rem: CO2-H2O
set sampleName=CO2-H2O
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: CO2-H2O-fast-C
set sampleName=CO2-H2O-fast-C
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: CO2-H2O-fast-K
set sampleName=CO2-H2O-fast-K
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: COMP
set sampleName=COMP
set wellName1=RES1_PROD
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1

rem: Comp2PInjGas
set sampleName=Comp2PInjGas
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: Comp3PInjGas
set sampleName=Comp3PInjGas
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: Comp3PInjWater
set sampleName=Comp3PInjWater
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: CompSPE3
set sampleName=CompSPE3
set wellName1=RES1_PROD
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1

rem: CompSPE3-3000
set sampleName=CompSPE3-3000
set wellName1=RES1_PROD
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1

rem: GasInj3phRate
set sampleName=GasInj3phRate
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: SPE5IMM
set sampleName=SPE5IMM
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: SPE5WAG
set sampleName=SPE5WAG
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1


echo.


rem: 
rem: Compositional-AIM samples for 2P
rem: 

set rootDir=\2P\Compositional-AIM

echo Compositional-AIM samples for 2P

rem: CompOGAIM
set sampleName=CompOGAIM
set wellName1=RES1_PROD
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1

rem: CompOGAIMTypeB
set sampleName=CompOGAIMTypeB
set wellName1=RES1_PROD
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1

rem: CompOGImpsat
set sampleName=CompOGImpsat
set wellName1=RES1_PROD
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1

rem: CompOGTypeB
set sampleName=CompOGTypeB
set wellName1=RES1_PROD
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1



echo.


rem: 
rem: CSAT samples for 2P
rem: 

set rootDir=\2P\CSAT

echo CSAT samples for 2P

rem: 4comp
set sampleName=4comp
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: 4comp_iso
set sampleName=4comp_iso
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: SPE3
set sampleName=SPE3
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: SPE3_iso
set sampleName=SPE3_iso
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: SPE5
set sampleName=SPE5
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: SPE5_iso
set sampleName=SPE5_iso
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1


echo.





rem: 
rem: MSWell samples for 2P
rem: 

set rootDir=\2P\MSWell

echo MSWell samples for 2P
rem: 300SEGOG
set sampleName=300SEGOG
set wellName1=RES1_MSWell_1
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1

rem: 3Laterals2POG
set sampleName=3Laterals2POG
set wellName1=RES1_MSWell_1
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1

rem: 3Laterals3P
set sampleName=3Laterals3P
set wellName1=RES1_MSWell_1
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1

rem: 3P45devHO
set sampleName=3P45devHO
set wellName1=RES1_MSWell_1
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1

rem: 3P-DF-Inclined
set sampleName=3P-DF-Inclined
set wellName1=RES1_MSWell_1
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1

rem: 3P-DF-Vertical
set sampleName=3P-DF-Vertical
set wellName1=RES1_MSWell_1
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1

rem: 3P-DF-vert-WRate
set sampleName=3P-DF-vert-WRate
set wellName1=RES1_MSWell_1
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1

echo MSWell Compositional samples - Isothermal
set rootDir=\2P\MSWell\Compositional\Isothermal

rem: 2P_Vertical
set sampleName=2P_Vertical
set wellName1=RES1_PROD
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1

rem: 2P_Vertical_immiscible_inj
set sampleName=2P_Vertical_immiscible_inj
set wellName1=RES1_PROD
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1

rem: 2P_Vertical_miscible_inj
set sampleName=2P_Vertical_miscible_inj
set wellName1=RES1_PROD
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1

rem: 3P_Inclined
set sampleName=3P_Inclined
set wellName1=RES1_PROD
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1

rem: 3P_Multilateral
set sampleName=3P_Multilateral
set wellName1=RES1_PROD
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1

rem: 3P_Multilateral_Water_inj
set sampleName=3P_Multilateral_Water_inj
set wellName1=RES1_PROD
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1

rem: 3P_Vertical_Gas_inj
set sampleName=3P_Vertical_Gas_inj
set wellName1=RES1_PROD
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1

echo MSWell Compositional samples - Thermal
set rootDir=\2P\MSWell\Compositional\Thermal

rem: 3P_Inclined
set sampleName=3P_Inclined
set wellName1=RES1_PROD
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1

rem: 3P_Inclined_hot_Water_inj
set sampleName=3P_Inclined_hot_Water_inj
set wellName1=RES1_PROD
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1

echo.


rem: 
rem: thermal samples for 2P
rem: 

set rootDir=\2P\thermal

echo thermal samples for 2P
rem: GasInj2PhaseComp
set sampleName=GasInj2PhaseComp
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: GasInj3PhaseBO
set sampleName=GasInj3PhaseBO
set wellName1=FIELD_P1_PROD
set wellName2=FIELD_I1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: WaterInj2Phase
set sampleName=WaterInj2Phase
set wellName1=FIELD_P1_PROD
set wellName2=FIELD_I1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: WaterInj3PhaseComp
set sampleName=WaterInj3PhaseComp
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

echo.



rem: pause



rem: 
rem: Black oil samples for MP
rem: 

set rootDir=\MP\BlackOil

echo Black oil samples for MP

rem: Black3PInjGas
set sampleName=Black3PInjGas
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: Black3pinjWater
set sampleName=Black3pinjWater
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: BlackOW
set sampleName=BlackOW
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: Multi_rockfluid
set sampleName=Multi_rockfluid
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: SPE1
set sampleName=SPE1
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: SPE1_HW
set sampleName=SPE1_HW
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: SPE1-MultTime
set sampleName=SPE1-MultTime
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: unstruc_mp
set sampleName=unstruc_mp
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1
echo.


rem: 
rem: Compositional samples for MP
rem: 

set rootDir=\MP\Compositional

echo Compositional samples for MP

rem: COMP
rem: CO2-H2O
set sampleName=CO2-H2O
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1


set sampleName=COMP
set wellName1=RES1_PROD
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1


rem: Comp2PInjGas
set sampleName=Comp2PInjGas
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1


rem: Comp3PInjGas
set sampleName=Comp3PInjGas
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: Comp3PInjWater
set sampleName=Comp3PInjWater
set wellName1=RES1_PROD
set wellName2=RES1_INJ
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1
%DiffCommand% %wellName2%.out %RefFolder%\%rootDir%\%sampleName%\%wellName2%.out > %wellName2%_out.log 2>&1

rem: CompSPE3
set sampleName=CompSPE3
set wellName1=RES1_PROD
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1

rem: CompSPE3-3000
set sampleName=CompSPE3-3000
set wellName1=RES1_PROD
cd %ImpFolder%\%rootDir%\%sampleName%
echo in %sampleName% ...
%DiffCommand% %wellName1%.out %RefFolder%\%rootDir%\%sampleName%\%wellName1%.out > %wellName1%_out.log 2>&1


:end
rem: back to batch file folder
cd %BatchFolder%
echo end diff files