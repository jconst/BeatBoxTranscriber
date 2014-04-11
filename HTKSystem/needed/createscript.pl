#!/usr/bin/perl
#Usage: perl createscript.pl wavDirNoSlashes mfcDirNoSlashes HCopyScript.scp HViteScript.scp

# Emily Mower Provost
# February 4, 2014

# This will take files in a directory and put them into the script format

use strict;

my ($loc, $dest, $codescp, $testscp);
($loc, $dest, $codescp, $testscp) = @ARGV;

my @files = <$loc/*>;

open(SOURCE, ">$codescp");
open(TRAIN, ">$testscp");
foreach my $file (@files) {
	if ($file =~ '.wav') {
		$_ = $file;
		s/.wav//;
		my $short = $`;
		$_ = $short;
		s/$loc/$dest/;
		print SOURCE "$short.wav $_.mfc\n";
		print TRAIN "$short.wav\n";
	}
}
close (TRAIN);
close (SOURCE);
