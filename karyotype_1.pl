#!/usr/bin/perl

use strict;
use warnings;

sub  trim { my $s = shift; $s =~ s/^\s+|\s+$//g; return $s };

my $inFilename = "in.dat";
my $outFilename = "out.dat";
open(my $in, "<", $inFilename) or die "Can't open " . $inFilename;
open(my $out, ">", $outFilename) or die "Canot open " . $outFilename;

my @specimenData;

my $foundNormal = 1;
    
while(my $line = <$in>) {    
    my @pipeData = split('\|',$line);
    
    if ($pipeData[0] eq "MSH" || $pipeData[0] eq "BTS"){
        if ($foundNormal == 0) {
            foreach my $dataLine (@specimenData){
                print $out $dataLine;
            }
        }        
        $foundNormal = 0;
        undef @specimenData;        
        my @specimenData;        
    }    
    
    if ($pipeData[0] ne "FHS" && $pipeData[0] ne "BHS" && $pipeData[0] ne "BTS" && $pipeData[0] ne "FTS") {
        push @specimenData, $line;
        
        my @caretData = split('\^',$pipeData[3]);        
        
        if ($pipeData[0] eq "OBX"){            
#            if(uc($caretData[1]) eq "KARYOTYPE"){
                my @commaData = split('\,',$pipeData[5]);
                if(scalar(@commaData) == 2){
                    my $chromosomes = trim($commaData[0]);
                    my $genes = trim($commaData[1]);
                    if($chromosomes eq "46" && (uc($genes) eq "XX" || uc($genes) eq "XY")){
                        $foundNormal = 1;
                    }
                }
#            }
        }
    }        
}    

close $in or die "$in: $!";
close $out or die "$out: $!";