#!/usr/bin/perl

$cnt=0;

open(FH, "<", $ARGV[0]) || die "cannot open file";

$out="";
$ch=-1;
$line="";
$record="";
$address=0;
$length=0;
$bytesperword=4;
$wordaddr=0;
$checksum=0;
$dataidx=0;

while (<FH>) {
	$line = $_;
	
	unless ($line =~ /^:/) {
		die "Unknown record: $line";
		last;
	}

	$length_s=substr($line, 1, 2);	
	$length=hex($length_s);
	$address_1=hex(substr($line, 3, 2));
	$address_2=hex(substr($line, 5, 2));
	$address=hex(substr($line, 3,4));
	$record=substr($line, 7,2);
	$record_i=hex($record);

    if ($record eq "01") {
    	$out .= ":00000001FF\n";
    	last;
    } elsif ($record eq "00") {
		$wordaddr = $address / $bytesperword;
		
		$dataidx=9;
		$checksum=$address_1 + $address_2 + $record_i + $length;
		for ($i=0; $i<$length; $i++) {
			$word = 0;
			$checksum = $bytesperword + ($wordaddr >> 8) + ($wordaddr & 0xFF);
			$out .= sprintf(":%02x%04x%s", ${bytesperword}, ${wordaddr}, ${record});
			for ($j=0; $j<$bytesperword; $j++,$i++) {
				$byte_s=substr($line, $dataidx, 2);
				$byte=hex($byte_s);
				$bytes[$j] = $byte;
				$checksum += $byte;
#				$out .= $byte_s;
				
				$dataidx += 2;
			}
			
			for ($j=$bytesperword-1; $j>=0; $j--) {
				$out .= sprintf("%02x", $bytes[$j]);
			}
			$out .= sprintf("%02x\n", ((0x100 - ($checksum & 0xFF)) & 0xFF));
			$wordaddr++;
		}
    } else {
    	die "Record type $record unsupported";
    }
}

#print "out=$out\n";

close(FH);

open(FH, ">", $ARGV[1]) || die "cannot open file";
print FH "$out";
close(FH);

