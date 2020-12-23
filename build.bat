@echo off
copy main.py main.pyw
if exist "dist" rd /s /q "dist"
pyinstaller --onefile --noconsole --noupx main.pyw && (
	pushD dist
	md assets
	popD
	xcopy assets dist\assets
	rd /s /q build
	rd /s /q __pycache__
	del main.spec
	del main.pyw
	cd dist
	ren main.exe StrawberryCatcher.exe
	cd ..
	aut2exe /in settings.au3 /out StrawberryCatcherSettings.exe /comp 4 /nopack
	move StrawberryCatcherSettings.exe dist
	copy settings.json dist
)
@ping localhost -n 2 >nul
exit /b