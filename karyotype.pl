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
		
		if ($pipeData[0] eq "OBX"){            
            my @commaData = split('\,',$pipeData[5]);
            if(scalar(@commaData) == 1){
                my $karyotypeText = $commaData[0];
                if(uc($karyotypeText) eq "NORMAL FEMALE KARYOTYPE" || uc($karyotypeText) eq "NORMAL MALE KARYOTYPE" || uc($karyotypeText) eq "NO GROWTH" ||
				   uc($karyotypeText) eq "NORMAL FEMALE" || uc($karyotypeText) eq "NORMAL MALE"){
                    $foundNormal = 1;
                }
            }
            if(scalar(@commaData) == 2){
                my $chromosomes = trim($commaData[0]);
                my $genes = trim($commaData[1]);
                if($chromosomes eq "46" && (uc($genes) eq "XX" || uc($genes) eq "XY")){
                    $foundNormal = 1;
                }
            }
		}
	}        
}    

close $in or die "$in: $!";
close $out or die "$out: $!";