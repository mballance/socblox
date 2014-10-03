#!/usr/bin/perl

open(FH, "arm-none-eabi-objdump --disassemble $ARGV[0] |");

$sym="";
$start="";

while (<FH>) {
  $line=$_;

  chomp $line;

  if ($line =~ /<.*>:/) {
#    print "SYMB: $line\n";
    $new_sym = $line;
    $new_sym =~ s/^.*<//g;
    $new_sym =~ s/>:.*$//g;

    $new_addr = $line;
    $new_addr =~ s/ <.*$//g;
    $new_addr = hex($new_addr);

#    print "SYM: $new_addr $new_sym\n";

    $sym=$new_sym;

    unless ($start eq "") {
      $size = $new_addr - $start;
      print "$size: $sym\n";
    }

    $start = $new_addr;
  }

}

close(FH);

