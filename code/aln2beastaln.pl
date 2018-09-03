#! /usr/bin/env perl
# Auth: Jennifer Chang
# Date: 2018/09/02
# format an alignment for beast xml file

use strict;
use warnings;

my $header="";
my $seq="";

sub printBeastSeq(){
    print "<sequence>\n";
    print "\t<taxon idref=\"$header\"/>\n";
    print "$seq\n";
    print "</sequence>\n";
}

while(<>){
    chomp;
    if(/>(.+)/){
	if(length($header)>1){
	    printBeastSeq();
	}
	$header=$1;
	$seq="";
    }else{
	$seq=$seq.+$_;
    }
}
printBeastSeq();
