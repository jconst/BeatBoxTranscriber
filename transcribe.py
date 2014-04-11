import os
import parseAndPlayLabel
from subprocess import call

home = os.getenv("HOME")
bbtDir = os.path.join(home, 'BBT/')
os.chdir(bbtDir)

if os.path.isfile('rec.wav'):
	print(os.getcwd())
	os.rename('rec.wav', 'HTKSystem/NewRec/newRec.wav')
	os.chdir('HTKSystem')

	print(os.getcwd())
	# Generate test script:
	with open('NewRec/newRec.scp', 'w') as f:
		print("opened 1")
		f.write('NewRec/newRec.mfc')
	with open('NewRec/codeNewRec.scp', 'w') as f:
		print("opened 2")
		f.write('NewRec/newRec.wav NewRec/newRec.mfc')

	# encode wav file into MFCCs
	if os.path.exists('NewRec/newRec.mfc'):
		os.remove('NewRec/newRec.mfc')
	print ("here")
	print(call('/usr/local/bin/HCopy -T 1 -C needed/config -S NewRec/codeNewRec.scp'.split()))
	# Decode input into phones
	print(call("/usr/local/bin/HVite -H hmm12/macros -H hmm12/hmmdefs -S NewRec/newRec.scp -l NewRec -w wdnet -p 0.0 -s 5.0 dict monophones1".split()))
	os.chdir('..')

parseAndPlayLabel.main('HTKSystem/NewRec/newRec.rec')