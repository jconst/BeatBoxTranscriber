import sys
import pyaudio
import wave
import time
import sched

wavNames = ["K", "P", "S"]
pa = pyaudio.PyAudio()
CHUNK = 1024

dummyWav = wave.open("K.wav", 'rb')
sampWidth = dummyWav.getsampwidth()
stream = pa.open(format=pa.get_format_from_width(sampWidth),
				 channels=dummyWav.getnchannels(),
				 rate=dummyWav.getframerate(),
				 output=True)
schedule = sched.scheduler(time.time, time.sleep)

class Sound:
	def __init__(self, name, length):
		self.name = name
		self.length = length

def parseLabel(f):
	sounds = {}
	for line in f:
		startStr, endStr, name, prob = line.split()
		start = float(startStr)/10000000.0
		end = float(endStr)/10000000.0
		print name + " " + str(start)
		# note: length isn't actually accurate atm
		length = end - start
		if name in wavNames:
			sounds[start] = Sound(name, length)
	return sounds

def scheduleSounds(sounds):
	wavList = [wave.open(name + ".wav", 'rb') for name in wavNames]
	wavs = dict(zip(wavNames, wavList))
	first = time.time()
	for start, sound in sounds.items():
		schedule.enter(start, 1, playWav, (wavs[sound.name],))
	schedule.run()

def playWav(wav):
	print "playing wav " + str(wav)
	data = wav.readframes(CHUNK)

	while data != '':
		stream.write(data)
		data = wav.readframes(CHUNK)

	wav.rewind()


labelFN = sys.argv[1]
with open(labelFN) as f:
	sounds = parseLabel(f)
	scheduleSounds(sounds)

	stream.stop_stream()
	stream.close()
	pa.terminate()
