import os
from string import replace

os.chdir('RoomPrompts')
for fn in os.listdir('.'):
	if "train-" in fn:
		os.rename(fn, replace(fn, "train", "test"))