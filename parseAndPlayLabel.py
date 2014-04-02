import sys
import pyaudio
import wave
import time

wavNames = ["K", "P", "S"]
pa = pyaudio.PyAudio()
CHUNK = 1024

dummyWav = wave.open("K.wav", 'rb')
sampWidth = dummyWav.getsampwidth()
stream = pa.open(format=pa.get_format_from_width(sampWidth),
				 channels=dummyWav.getnchannels(),
				 rate=dummyWav.getframerate(),
				 output=True)

class Sound:
	def __init__(self, name, length):
		self.name = name
		self.length = length

def parseLabel(f):
	sounds = {}
	for line in f:
		startStr, endStr, name, prob = line.split()
		start = float(startStr)/2000000
		end = float(endStr)/2000000
		print name + " " + str(start)
		# note: length isn't actually accurate atm
		length = end - start
		if name in wavNames:
			sounds[start] = Sound(name, length)
	return sounds

def playSounds(sounds):
	wavList = [wave.open(name + ".wav", 'rb') for name in wavNames]
	wavs = dict(zip(wavNames, wavList))
	first = time.time()
	while len(sounds):
		start, sound = sounds.items()[0]
		cur = time.time() - first
		if cur >= start:
			playWav(wavs[sound.name], sound.name)
			del sounds[start]
		else:
			time.sleep((start - cur))

def playWav(wav, name):
	print "playing wav " + str(name)
	data = wav.readframes(CHUNK)

	while data != '':
		stream.write(data)
		data = wav.readframes(CHUNK)

	wav.rewind()


labelFN = sys.argv[1]
with open(labelFN) as f:
	sounds = parseLabel(f)
	playSounds(sounds)

	stream.stop_stream()
	stream.close()
	pa.terminate()
