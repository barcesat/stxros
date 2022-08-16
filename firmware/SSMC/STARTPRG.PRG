'***************************************  startPRG Program  ***************************************
' File:			AX_SETUP.PRG
' Purpose:		Axes setup example
' Version:		V1.0.0.0
' History:		12:40:54 25/11/2020 - V1.0.0.0 Created
' Author:		AUTOMATICALLY GENERATED startPRG_Gen.py
' Description:	This script starts the prg's that the configurator generated 
'				the softMC Configurator.
'
'********************************************************************************************************

' module global variables
Program continue


	Load ECCONFIG.PRG
	Stas ECCONFIG.PRG

	while ECCONFIG.PRG.state <> 10
		sleep 10
	end while
	load RobLib.lib

	Load CANSETUP.PRG
	Stas CANSETUP.PRG

	while CANSETUP.PRG.state <> 10
		sleep 10
	end while
	Load CALIB.PRG
	Stas CALIB.PRG

	while CALIB.PRG.state <> 10
		sleep 10
	end while
	Load AX_SETUP.PRG
	Stas AX_SETUP.PRG

	while AX_SETUP.PRG.state <> 10
		sleep 10
	end while
	Load robot.prg
	Stas robot.prg

	while robot.prg.state <> 10
		sleep 10
	end while

End program
