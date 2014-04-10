#!/usr/bin/perl

# Emily Mower Provost
# Copy middle state of "sil"

use strict;

if ($ARGV[0] eq '') {
	die "Please enter an hmm iteration (e.g., hmm0)\n";
}
my $hmm = $ARGV[0];

open(INFO, "$hmm/hmmdefs");
my @lines = <INFO>;
close(INFO);

$_ = $hmm;
s/\d//;
my $num = 1*$&+1;
my $hmm_next = "$_$num";

open(SOURCE, ">$hmm_next/hmmdefs");

my $start = 0;
my $end = 0;
my $foundFlag = 0;
my $silStart = 0;
my @out = ();
for (my $i=0;$i<@lines;$i++) {
	my $line = @lines[$i];
	if ($line =~ 'sil') {
		$foundFlag = 1;
		$silStart = $i;
	}
	if ($foundFlag == 1 && $line =~ '<STATE> 3') {
		$start = $i;
		$foundFlag = 0;
	}
	if ($foundFlag == 0 && $start > 0 && $line =~ '<STATE> 4') {
		$end = $i-1;
		
		@out = "~h \"sp\"\n<BEGINHMM>\n<NUMSTATES> 3\n<STATE> 2\n@lines[$start+1..$end]\n<TransP> 3\n0.0 1.0 0.0\n0.0 0.6 0.4\n0.0 0.0 0.0\n<EndHMM>\n";
	}
}

print SOURCE "@lines\n@out";
close(SOURCE);

system("cp $hmm/macros $hmm_next/macros");

