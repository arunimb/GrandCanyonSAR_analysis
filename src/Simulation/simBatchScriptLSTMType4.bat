@echo off
set searchType=closedLoopType4
set participants=60730 19175 23623 70928 26906 42573 54659 63579 64444 64762 67901 90112 94517 11940 18867 20894 57621 45873 77028 66194
set trials=222 121 221 212 211 111 112 122
set auvNumber=5 10 15
set numRuns=1
set runPrefix=run
(for %%a in (%participants%) do (
	(for %%b in (%trials%) do (
		(for %%c in (%auvNumber%) do (
			(for %%d in (%numRuns%) do (
				echo %searchType%>H:\testingGround\trajData\closedLoopType4Parameters.txt
				echo %%a>>H:\testingGround\trajData\closedLoopType4Parameters.txt
				echo %%b>>H:\testingGround\trajData\closedLoopType4Parameters.txt
				echo %%c>>H:\testingGround\trajData\closedLoopType4Parameters.txt
				echo %runPrefix%%%d>>H:\testingGround\trajData\closedLoopType4Parameters.txt
				echo Running %searchType% %%a %%b %%c %runPrefix%%%d
				START /WAIT H:\testingGround\closedLoop4\MissingPersonSearchSim.exe -batchmode
				echo Run ended
))))))))

