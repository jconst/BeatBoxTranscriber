monophones()
{
	echo "Monophones:"
	# Run Viterbi for monophones
	HVite -H hmm9/macros -H hmm9/hmmdefs -S $1 -l 'needed/TestPrompts' -i recout.mlf -w wdnet -p 0.0 -s 5.0 dict monophones1
	HResults -I words.mlf monophones1 recout.mlf
}

triphones()
{
	echo "Triphones:"
	# Run Viterbi for triphones
	HVite -H hmm15/macros -H hmm15/hmmdefs -S $1 -l 'needed/TestPrompts' -i recout.mlf -w wdnet -p 0.0 -s 5.0 dict tiedlist
	HResults -I words.mlf tiedlist recout.mlf
}

# Generate test spec:
find needed/TestPromptsMFC -name \*.mfc > test.scp

#-------------------

echo "Their Testing Data Only"

grep "/test" test.scp > testingData.scp

monophones testingData.scp
triphones testingData.scp

#-------------------

echo "Their Sample Data Only"

grep "/sample" test.scp > sampleData.scp

monophones sampleData.scp
triphones sampleData.scp

#-------------------

echo "Their Testing & Training Data"

grep -E '(/test)|(/sample)' test.scp > theirData.scp

monophones theirData.scp
triphones theirData.scp

#-------------------

echo "My Data Only"

grep "my" test.scp > myData.scp

monophones myData.scp
triphones myData.scp

#-------------------

echo "All Data"

monophones test.scp
triphones test.scp
