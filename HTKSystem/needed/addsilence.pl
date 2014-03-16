#!/usr/bin/perl

# Emily Mower Provost
# add silence to the dictionary

use strict;

open(INFO, "dict");
my @lines = <INFO>;
close(INFO);

my @new;
my $before = 0;
for (my $i=0;$i<@lines;$i++) {
	my @temp = split(/\t/, @lines[$i]);
	if (lc(@temp[0]) lt "silence") {$before = $i}
}

my $l = @lines;
open(SOURCE, ">dict");
print SOURCE "@lines[0..$before] silence\t\t sil\n @lines[$before+1..$l]";
close(SOURCE);
