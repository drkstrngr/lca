#!/usr/bin/perl

#Eric

use strict;
use warnings;

use feature "switch";
use Cwd;
my $dir = getcwd();
$dir =~ s/\//\\/g;
$dir = $dir . "\\input\\";
opendir(DIR, $dir) or die $!;

my $outFilename = "fileMerge.dat";
open(my $out, ">", $outFilename) or die "Canot open ";        

while (my $file = readdir(DIR)) {    
    next unless (-f "$dir/$file");
    #next unless ($file =~ m/\.HL7$/);
    next if ($file =~ m/\.pl$/);
    next if ($file =~ m/\.dat$/);
    
    open(my $in, "<", $dir . $file) or die "Can't open " . $file;    
    
    while(my $line = <$in>) {            
        print $out $line;    
    }   
    
    close $in or die "$in: $!";    
}

close $out or die "$out: $!";
    
closedir(DIR);
