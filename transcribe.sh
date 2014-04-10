#!/bin/sh
cd ~/BBT/
if [ -e rec.wav ]
then
	mv rec.wav HTKSystem/NewRec/newRec.wav
	cd HTKSystem

	# Generate test script:
	echo "NewRec/newRec.mfc" > NewRec/newRec.scp
	echo "NewRec/newRec.wav NewRec/newRec.mfc" > NewRec/codeNewRec.scp

	# encode wav file into MFCCs
	rm NewRec/newRec.mfc
	/usr/local/bin/HCopy -T 1 -C needed/config -S NewRec/codeNewRec.scp

	# Decode input into phones
	HVite -H hmm10/macros -H hmm10/hmmdefs -S NewRec/newRec.scp -l 'NewRec' -w wdnet -p 0.0 -s 5.0 dict monophones1

	cd ..
fi

/usr/local/bin/python3 parseAndPlayLabel.py HTKSystem/NewRec/newRec.rec