#!/usr/bin/perl

# Emily Mower Provost
# Create the "lab" files

use strict;

my ($mlf, $labDir);

($mlf, $labDir) = @ARGV;

open(INFO, $mlf);
my @lines = <INFO>;
close(INFO);

foreach my $line (@lines) {
	chomp($line);
	if ($line =~ /\"/) {
		$_ = $line;
		s/\"//g;
		close(SOURCE);
		open(SOURCE, ">$labDir/$_");
	}
	else {print SOURCE "$line\n"}
}
