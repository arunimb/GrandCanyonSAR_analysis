@echo off
set searchType=closedLoopType3
set participants=11940
set trials=111 121 212 222 221 211 112 122
set auvNumber=5 10 15
set numRuns=1
set runPrefix=run
(for %%a in (%participants%) do (
	(for %%b in (%trials%) do (
		(for %%c in (%auvNumber%) do (
			(for %%d in (%numRuns%) do (
				echo %searchType%>H:\testingGround\trajData\closedLoopType3Parameters.txt
				echo %%a>>H:\testingGround\trajData\closedLoopType3Parameters.txt
				echo %%b>>H:\testingGround\trajData\closedLoopType3Parameters.txt
				echo %%c>>H:\testingGround\trajData\closedLoopType3Parameters.txt
				echo %runPrefix%%%d>>H:\testingGround\trajData\closedLoopType3Parameters.txt
				echo Running %searchType% %%a %%b %%c %runPrefix%%%d
				START /WAIT H:\testingGround\closedLoop3\MissingPersonSearchSim.exe -batchmode
				echo Run ended
))))))))

