
" ======== binding key to run Quick Player for the project of this Lua file.====
" Check if Vim support Python
if !has('python')
    echo "Error: Run Player Required vim compiled with +python"
   	echo "Vim for Windows,please check Python & Vim both are 32bit version!"
    finish
endif

python << EOF
playerProcess = None
EOF

fu! RunPlayer()
" start python code
python << EOF
import vim
import os
import codecs
import re
import subprocess
import platform
import time
import psutil

def pyrun():
	# get project "src" dir
	curLuaFilePath = vim.current.buffer.name
	index = curLuaFilePath.rfind("src" + os.sep)
	if index == -1:
		print("Worning:Can't find project dir")
		return
	workDir = curLuaFilePath[0:index]
	srcDir = os.path.join(workDir, "src")

	# get run args from config.lua
	configPath = os.path.join(srcDir, "config.lua")
	mainPath = os.path.join(srcDir, "main.lua")

	# player path for platform
	playerPath = None
	sysstr = platform.system()
	if(sysstr == "Windows"):
		playerPath = "xxx"
		rootFilePath = os.environ.get('QUICK_V3_ROOT')
		playerPath = os.path.join(rootFilePath, "quick/player/win32/player3.exe")
	elif(sysstr == "Darwin"):
		rootFilePath =  "/Applications/"#os.path.join(os.path.expanduser('~'), ".QUICK_V3_ROOT")
		playerPath = os.path.join(rootFilePath, "player3.app/Contents/MacOS/player3")
	else:
		print("Error:Wrong host system!")
		return

	# param
	args = [playerPath]
	args.append("-workdir")
	args.append(workDir)
	args.append("-file")
	args.append(mainPath)
	# parse config.lua & add to args
	if os.path.exists(configPath):
		f = codecs.open(configPath,"r","utf-8")
		width = "640"
		height = "960"
		while True:
			line = f.readline()
			if line:
				# debug
				m = re.match("^DEBUG\s*=\s*(\d+)",line)
				if m:
					debug = m.group(1)
					if debug == "0":
						args.append("-disable-write-debug-log")
						args.append("-disable-console")
					elif debug == "1":
						args.append("-disable-write-debug-log")
						args.append("-console")
					else:
						args.append("-write-debug-log")
						args.append("-console")
				# resolution
				m = re.match("^CONFIG_SCREEN_WIDTH\s*=\s*(\d+)",line)
				if m:
					width = m.group(1)
				m = re.match("^CONFIG_SCREEN_HEIGHT\s*=\s*(\d+)",line)
				if m:
					height = m.group(1)
			else:
				break
		f.close()
		args.append("-size")
		args.append(width + "x" + height)
	
	# kill running Player3
	procs = psutil.Process().children()
	for p in procs:
		if p.name() == "player3":
			p.terminate()
			p.wait()

	# run a new player
	subprocess.Popen(args)

pyrun()
EOF
endfunction

map <F5> :call RunPlayer()<CR>
