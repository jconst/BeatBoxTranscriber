import pyaudio
import wave
from kivy.app import App
from kivy.uix.widget import Widget
from kivy.uix.button import Button
from kivy.uix.boxlayout import BoxLayout
from kivy.graphics import Color, Rectangle


def RecordStart(instance):
	instance.text = "RECORDING..."
	instance.canvas.ask_update()
	Record()
	instance.text = "Record"
	instance.canvas.ask_update()




def Record():
	print "Record was pressed"

	CHUNK = 1024
	FORMAT = pyaudio.paInt16
	CHANNELS = 2
	RATE = 44100
	RECORD_SECONDS = 4
	WAVE_OUTPUT_FILENAME = "newRec.wav"
	p = pyaudio.PyAudio()

	stream = p.open(format=FORMAT,
                channels=CHANNELS,
                rate=RATE,
                input=True,
                frames_per_buffer=CHUNK)

	print("* recording")

	frames = []

	for i in range(0, int(RATE / CHUNK * RECORD_SECONDS)):
	    data = stream.read(CHUNK)
	    frames.append(data)

	print("* done recording")

	stream.stop_stream()
	stream.close()
	p.terminate()

	wf = wave.open(WAVE_OUTPUT_FILENAME, 'wb')
	wf.setnchannels(CHANNELS)
	wf.setsampwidth(p.get_sample_size(FORMAT))
	wf.setframerate(RATE)
	wf.writeframes(b''.join(frames))
	wf.close()






class BeatBoxApp(App):

	def build(self):
		layout = BoxLayout(padding=10)
		recButton = Button(
							text="Record",
							font_size = 20,
							size_hint = (1,1),
							pos_hint = {'center_x':.5,
										'center_y':.5})
		recButton.bind(on_press=RecordStart)
		layout.add_widget(recButton)
		return layout 

BeatBoxApp().run()
