use strict;
use warnings;
use Excel::Writer::XLSX;
use feature "switch";
use Cwd;

my $dir = getcwd();
$dir =~ s/\//\\/g;
$dir = $dir . "\\";
opendir(DIR, $dir) or die $!;

my $workbook = Excel::Writer::XLSX->new('./test.xlsx');
my $worksheet = $workbook->add_worksheet();

my $lineCtr = 0;

while (my $file = readdir(DIR)) {    
    next unless (-f "$dir/$file");    
    next if ($file =~ m/\.pl$/);
    next if ($file =~ m/\.xlsx$/);
    next if ($file =~ m/\.vbs$/);
    
    open(my $in, "<", $file) or die "Can't open " . $file;
    
    my $line = "";
    my @csvArray = ();
        
    while(my $line = <$in>) {
        my @csvArray = split(',',$line);            
        for my $colCtr (0 .. $#csvArray){
            $worksheet->write($lineCtr, $colCtr, $csvArray[$colCtr]);
        }
        $lineCtr = $lineCtr + 1;
    }    
    
    close $in or die "$in: $!";
}

$workbook->close;
closedir(DIR);