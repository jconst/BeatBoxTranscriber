monophones()
{
	echo "Monophones:"
	# Run Viterbi for monophones
	HVite -H hmm10/macros -H hmm10/hmmdefs -S $1 -l 'TrainPrompts' -i recout.mlf -w wdnet -p 0.0 -s 5.0 dict monophones1
	HResults -I words.mlf monophones1 recout.mlf
}

# Generate test spec:
find TrainPromptsMFC -name \*.mfc > test.scp

#-------------------

echo "My Training Data Only"

monophones test.scp

#-------------------