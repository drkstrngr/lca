#!/usr/bin/perl

use feature "switch";
use Cwd;
my $dir = getcwd();
$dir =~ s/\//\\/g;
$dir = $dir . "\\";
opendir(DIR, $dir) or die $!;

my $outFilename = "fileMerge.dat";
open(my $out, ">", $outFilename) or die "Canot open ";    

while (my $file = readdir(DIR)) {    
    next unless (-f "$dir/$file");
    #next unless ($file =~ m/\.HL7$/);
    next if ($file =~ m/\.pl$/);
    next if ($file =~ m/\.dat$/);
    
    open(my $in, "<", $file) or die "Can't open " . $file;
    
    
    while(my $line = <$in>) {            
        #print $out $line;        
        
        my @filedata = split('\|',$line);        
        my $msh = "";
        my $printLine = 0;
        
        if ($filedata[0] eq "MSH") {
            $msh = $line;
            $printLine = 0;
        }
        if ($filedata[0] eq "PID") {
            my @segdata = split('\|',$filedata[3]);        
        }       
    }
    
    close $in or die "$in: $!";
}

close $out or die "$out: $!";
    
closedir(DIR);
