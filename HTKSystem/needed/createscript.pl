#!/usr/bin/perl

# Emily Mower Provost
# February 4, 2014

# This will take files in a directory and put them into the script format

use strict;

my $loc = 'needed/TestPrompts';
my @files = <$loc/*>;

open(SOURCE, ">codetr.scp");
open(TRAIN, ">train.scp");
foreach my $file (@files) {
	if ($file =~ '.wav') {
		$_ = $file;
		s/.wav//;
		my $short = $`;
		$_ = $short;
		s/TestPrompts/TestPromptsMFC/;
		print SOURCE "$short.wav $_.mfc\n";
		print TRAIN "$short.wav\n";
	}
}
close (TRAIN);
close (SOURCE);
