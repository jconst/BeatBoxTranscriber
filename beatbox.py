import pyaudio
import wave
import time
from recorder import Recorder
from kivy.app import App
from kivy.uix.widget import Widget
from kivy.uix.button import Button
from kivy.uix.boxlayout import BoxLayout
from kivy.graphics import Color, Rectangle

#Globals
p = pyaudio.PyAudio()

wf = wave.open("newRec.wav", 'wb')


def RecordStart(instance):
	instance.text = "RECORDING..."
	#instance.canvas.ask_update()
	print ("***Recording")
	Record()

	"""rec = Recorder(channels=2)
	with rec.open('nonblocking.wav', 'wb') as recfile2:
		recfile2.start_recording()
		time.sleep(5.0)
		recfile2.stop_recording()"""

	print ("***Done Recording")
	instance.text = "Record"
	#instance.canvas.ask_update()



def callback(in_data, frame_count, time_info, status):
	wf.writeframes(in_data)
	return (in_data, pyaudio.paContinue)



def Record():
	print "Record was pressed"

	CHUNK = 1024
	FORMAT = pyaudio.paInt16
	CHANNELS = 2
	RATE = 44100
	RECORD_SECONDS = 5
	wf.setnchannels(CHANNELS)
	wf.setsampwidth(p.get_sample_size(FORMAT))
	wf.setframerate(RATE)
	frames = []


	stream = p.open(format=FORMAT,
                channels=CHANNELS,
                rate=RATE,
                input=True,
                stream_callback=callback,
                frames_per_buffer=CHUNK)

	stream.start_stream()

	"""for i in range(0, int(RATE / CHUNK * RECORD_SECONDS)):
	    data = stream.read(CHUNK)
	    frames.append(data)"""
	for i in range(0, int(RATE / CHUNK * RECORD_SECONDS)):
		time.sleep(RATE / CHUNK)


	stream.stop_stream()
	stream.close()
	p.terminate()

	wf.writeframes(b''.join(frames))
	wf.close()






class BeatBoxApp(App):

	def build(self):
		layout = BoxLayout(padding=10)
		recButton = Button(
							font_size = 20,
							size_hint = (1,1),
							pos_hint = {'center_x':.5,
										'center_y':.5})
		recButton.bind(on_press=RecordStart)
		recButton.text = 'RECORD' if recButton.state == 'normal' else 'RECORDING'
		layout.add_widget(recButton)
		return layout 

BeatBoxApp().run()
