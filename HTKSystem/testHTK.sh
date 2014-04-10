#!/bin/bash
# Usage: testHTK.sh dirToStoreLabels dirContainingMFCs correctMLF

# Generate test script:
find $2 -name \*.mfc > test.scp

HVite -H hmm10/macros -H hmm10/hmmdefs -S test.scp -l $1 -i recout.mlf -w wdnet -p 0.0 -s 5.0 dict monophones1
HResults -I $3 monophones1 recout.mlf
