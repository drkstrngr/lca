#!/usr/bin/perl

my $in1Filename = "NY1.dat";
my $in2Filename = "NY2.dat";
my $outFilename = "NY.dat";
open(my $in1, "<", $in1Filename) or die "Can't open " . $in1Filename;
open(my $in2, "<", $in2Filename) or die "Can't open " . $in2Filename;
open(my $out, ">", $outFilename) or die "Canot open " . $outFilename;

my $spec = "";
my @specArray = ();
    
while(my $line = <$in1>) {
    my @pipedata = split('\|',$line);            
    
    if ($pipedata[0] eq "PID") {
        my @caretdata = split('\^',$pipedata[3]);
        $spec = $caretdata[0];
    }
    if ($pipedata[0] eq "OBX") {
        my @caretdata = split('\^',$pipedata[5]);
        if ($caretdata[3] eq "NZVIB") {
            push @specArray, $spec;
        }
    }    
}

my $specArrayLength = @specArray;
my $mshData = "";
my $foundOBX = "0";

while(my $line2 = <$in2>) {
    my @pipedata = split('\|',$line2);

    if ($pipedata[0] eq "MSH") {
        $mshData = $line2;
        $foundOBX = "0";
    }
    if ($pipedata[0] eq "PID") {
        my @caretdata = split('\^',$pipedata[3]);
        $spec = $caretdata[0];
        my $specArrayCtr = 0;
        while ($specArrayCtr < $specArrayLength && $foundOBX eq "0") {
            if ($specArray[$specArrayCtr] eq $spec) {
                $foundOBX = "1";
            }
            $specArrayCtr = $specArrayCtr + 1;
        }
        if ($foundOBX eq "1") {
            print $out $mshData;
        }
    }
    if ($foundOBX eq "1") {
        print $out $line2;
    }
}

close $in1 or die "$in1: $!";
close $in2 or die "$in2: $!";
close $out or die "$out: $!";   

