from simplecoremidi import send_midi
import sys
import time
import sched

beatNames = ['P', 'S', 'K']
channel = 1  # This is MIDI channel 1
note_on_action = 0x90
schedule = sched.scheduler(time.time, time.sleep)
send_midi((note_on_action | channel, 0, 127)) # warm up the channel

def parseLabel(f):
	sounds = {}
	for line in f:
		startStr, endStr, name, prob = line.split()
		start = float(startStr)/10000000.0
		if name in beatNames:
			sounds[start] = name
	return sounds

def scheduleSounds(sounds):
	for start, sound in sounds.items():
		schedule.enter(start, 1, playSound, sound)
	schedule.run()

def playSound(name):
	note = beatNames.index(name)
	print(note)
	send_midi((note_on_action | channel, note+1, 127))

labelFN = sys.argv[1]
with open(labelFN) as f:
	sounds = parseLabel(f)
	scheduleSounds(sounds)
