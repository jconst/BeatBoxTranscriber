#!/bin/bash
# Usage: testHTK.sh dirContainingWavs dirToStoreMFCs correctMLF

# Generate test scripts:
perl needed/createscript.pl $1 $2 codetest.scp test.scp

# Create label files from mlf in same dir as wavs
perl needed/createlab.pl $3 $1

# Encode mfccs
HCopy -T 1 -C needed/config -S codetest.scp

# Run viterbi to transcribe MFCCs
HVite -C needed/config -H hmm12/macros -H hmm12/hmmdefs -S test.scp -l $1 -i recout.mlf -w wdnet -p 0.0 -s 5.0 dict monophones1

# Output results analysis
HResults -I $3 monophones1 recout.mlf
