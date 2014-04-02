#!/bin/bash

# make all directories in advance
mkdir hmm{0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15}

# convert grammar to HTK Standard Lattice Format
HParse needed/gram wdnet

# find the list of words (prompts is given)
perl needed/prompts2wlist prompts wlist

# add sent-start and sent-end to the word list
perl needed/addsentstart.pl

# construct your dictionary
HDMan -m -w wlist -n monophones1 -l dlog dict needed/beatDict

# make monophones0 -- remove sp from monophones1
perl needed/createmonophones0.pl

perl needed/prompts2mlf words.mlf prompts
HLEd -l '*' -d dict -i phones0.mlf mkphones0.led words.mlf

# create training scripts
perl needed/createscript.pl

HCopy -T 1 -C needed/config -S codetr.scp

# create proto
perl needed/createproto.pl
HCompV -C needed/config -f 0.01 -m -S train.scp -M hmm0 proto
perl needed/createhmmdefs.pl hmm0

# do for hmm1, hmm2, hmm3
HERest -C needed/config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm0/macros -H hmm0/hmmdefs -M hmm1/ monophones0
HERest -C needed/config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm1/macros -H hmm1/hmmdefs -M hmm2/ monophones0
HERest -C needed/config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm2/macros -H hmm2/hmmdefs -M hmm3/ monophones0

# create an sp model
perl needed/makeSPmodel.pl hmm3

# tie sp to center sil state
HHEd -H hmm4/macros -H hmm4/hmmdefs -M hmm5 sil.hed monophones1

# two more passes of HERest
HERest -C needed/config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm5/macros -H hmm5/hmmdefs -M hmm6/ monophones1
HERest -C needed/config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm6/macros -H hmm6/hmmdefs -M hmm7/ monophones1

# add silence to the dictionary
perl needed/addsilence.pl

# create label files
perl needed/createlab.pl

# run Viterbi decoding
HVite -l '*' -o SWT -b silence -C needed/config -a -H hmm7/macros -H hmm7/hmmdefs -i aligned.mlf -m -t 250.0 150.0 1000.0 -y lab -I words.mlf -S train.scp dict monophones1

# two more passes of HERest
HERest -C needed/config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm7/macros -H hmm7/hmmdefs -M hmm8/ monophones1
HERest -C needed/config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm8/macros -H hmm8/hmmdefs -M hmm9/ monophones1

HHEd -H hmm9/macros -H hmm9/hmmdefs -M hmm10/ needed/mix.hed monophones0

# two more passes of HERest
HERest -C needed/config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm10/macros -H hmm10/hmmdefs -M hmm11/ monophones1
HERest -C needed/config -I phones0.mlf -t 250.0 150.0 1000.0 -S train.scp -H hmm11/macros -H hmm11/hmmdefs -M hmm12/ monophones1

