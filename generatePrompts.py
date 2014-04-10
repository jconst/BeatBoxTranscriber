import sys
from random import randint

vocab = ['P', 'S', 'K']
maxLen = 15
numPrompts = int(sys.argv[1])
filename = sys.argv[2]
lines = []

with open(filename, 'w') as f:
	for i in range(numPrompts):
		lineLen = randint(1, maxLen)
		words = [vocab[randint(0, 2)] for _ in range(lineLen)]
		line = ' '.join(words)
		lines.append(line)
	linesStr = '\n'.join(lines)
	f.write(linesStr)