#!/usr/bin/perl

# Emily Mower Provost
# add sent-end and sent-start to wlist

use strict;

open(INFO, "wlist") || die ("Unable to open wlist for reading");;
my @lines = <INFO>;
close(INFO);


my $loc_end = 0;
my $loc_start = 0;
my $l = @lines;
for (my $i=0;$i<@lines;$i++) {
	if (@lines[$i] lt "SENT-END\n") {
		$loc_end = $i;
	}
	if (@lines[$i] lt "SENT-START\n") {
		$loc_start = $i;
	}
}

open(SOURCE, ">wlist");
print SOURCE "@lines[0..$loc_end] SENT-END\n@lines[$loc_end+1..$loc_start] SENT-START\n @lines[$loc_start+1..$l]";
close(SOURCE);
