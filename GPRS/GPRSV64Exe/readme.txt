The files in the directory are GPRS executables and libraries which support to 
run a GPRS executable.


GPRS executables include:

	GPRSRelease.exe  -- release version
	GPRP.exe -- debug version

A release version usually uses less memory and runs faster than a debug 
version does. However a debug version usually is more stable than a release 
version is. One should use a release version first. If it has problem, then 
try the debug version.


Here are the steps to set environmental variables and run GPRS.
1. Set the directory in which these executables locate into the "PATH" 
   environmental variable. One can do it through windows  (see the "Execute 
   GPRS" section in the "GPRS build.doc" document), or type the following 
   command in the DOS prompt window (suppose the absolute path of the 
   directory is "C:GPRS\executables").

	set PATH=%PATH%;C:GPRS\executables

  To check the path setting, type the command: echo %PATH%

2. Once you set the executable directory into the "PATH" variable, now you 
   can run GPRS in any directory in a command window. For example, if you 
   want to run the "SPE1" example, go to the directory 
   (cd GPRS\Samples\BlackOil\SPE1), then type 

	GPRSRelease

   to start running GPRS. All output files will locate in the same 
   directory (GPRS\Samples\BlackOil\SPE1).


Please note that AIM (adoptive implicit method) does not work for 
the multi-point flux. 




