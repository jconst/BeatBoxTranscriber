#!/usr/bin/perl

# Emily Mower Provost
# Create the hmmdefs file

use strict;

if ($ARGV[0] eq '') {
	die "Please enter an hmm iteration (e.g., hmm0)\n";
}
my $hmm = $ARGV[0];

if (!(-d "$hmm")) {system("mkdir $hmm")}

open(INFO, "monophones0");
my @mono = <INFO>;
close(INFO);

open(INFO, "hmm0/proto");
my @proto = <INFO>;
close(INFO);

open(SOURCE, ">hmm0/hmmdefs");
foreach my $mono (@mono) {
	chomp($mono);
	my @temp = @proto;
	$_ = @temp[3];
	s/proto/$mono/;
	@temp[3] = $_;

	print SOURCE "@temp\n";
}
close(SOURCE);

open(INFO, "hmm0/vFloors");
my @vfloor = <INFO>;
close(INFO);

open(SOURCE, ">hmm0/macros");

print SOURCE "~o <MFCC_0_D_A> <VecSize> 39\n";
print SOURCE @vfloor;

close(SOURCE);
