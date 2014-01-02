#!/usr/bin/perl
# script to generate a log of everything you watch on sagetv. run this for a few weeks
# in cron to see whether or not you can cancel cable.
#

$inputfile="/opt/sagetv/server/sagetv_*";
open (FIN,"cat $inputfile|") || die "unable to open $inputfile\n";
open (FOUT,"|sort -n") || die "unable to execute sort\n";

$/="\n";
while ( <FIN> ) {
	if ( $_ =~ /watchThisFile/ ) {
		if ( $_ !~ /null/ ) {
			@splitarray=split (' ',$_);
			@hour=split(':',$splitarray[2]);
			@data=split('"',$_);
			if ( $hour[0] < 10 ) {
				$hour[0]="0$hour[0]";
			}
			printf FOUT "$splitarray[1] $splitarray[0] $hour[0]:$hour[1] $data[1]\n";
		}
		
	}
}
close FIN;
