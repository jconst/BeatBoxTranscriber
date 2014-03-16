#!/usr/bin/perl

# Emily Mower Provost
# Create the "lab" files

use strict;

open(INFO, "words.mlf");
my @lines = <INFO>;
close(INFO);

foreach my $line (@lines) {
	chomp($line);
	if ($line =~ /\"/) {
		$_ = $line;
		s/\"//g;
		close(SOURCE);
		open(SOURCE, ">needed/TestPrompts/$_");
	}
	else {print SOURCE "$line\n"}
}
