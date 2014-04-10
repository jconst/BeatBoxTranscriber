#!/usr/bin/perl

# Emily Mower Provost
# remove sp from monophones1 (save as monophones0)

use strict;

open(INFO, "monophones1");
my @lines = <INFO>;
close(INFO);

my $loc = 0;
for (my $i=0;$i<@lines;$i++) {
	if (@lines[$i] eq "sp\n") {
		@lines[$i] = ();
	}
}

open(SOURCE, ">monophones0");
print SOURCE @lines;
close(SOURCE);

open(INFO, "dict");
my @lines = <INFO>;
close(INFO);


