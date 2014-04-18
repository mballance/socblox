#!/usr/bin/perl

$cnt=0;

open(FH, "<", $ARGV[0]) || die "cannot open file";

$out="";
$ch=-1;

while (<FH>) {
  if ($_ =~ /^@/) {
    # Address line 
    $out .= $_;
  } else {
    # Data line
    @elems = split(' ', $_);
    $i=0;
    for (;$i<=$#elems; $i++) {
#      print "elem=$elems[$i]\n";
      if ($i > 0 && ($i % 4) == 0) {
        $out .= "\n";
      }
      $out .= $elems[$i];
    }
    $out .= "\n";
  } 
}

close(FH);

open(FH, ">", $ARGV[0]) || die "cannot open file";
print FH "$out";
close(FH);

