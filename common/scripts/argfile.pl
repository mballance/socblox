#!/usr/bin/perl

use File::Basename;
use Cwd;

$unget_ch_1 = -1;
$unget_ch_2 = -1;
@plusargs;
@paths;

$print_plusargs=1;
$print_paths=0;
$makevars=0;
$dir=getcwd();
$dir_set=0;
@argfiles;

for ($i=0; $i<=$#ARGV; $i++) {
	if ($ARGV[$i] =~ /^-/) {
		if ($ARGV[$i] eq "-m") {
			$makevars=1
		} elsif ($ARGV[$i] eq "-wd") {
			$i++;
			$dir=$ARGV[$i];
			$dir_set = 1;
		} elsif ($ARGV[$i] eq "-print-paths") {
			$print_paths=1;
		} else {
			fatal("unknown option $ARGV[$i]");
		}
	} else {
		push(@argfiles, $ARGV[$i]);
	}
}

for ($i=0; $i<=$#argfiles; $i++) {
	$argfile = $argfiles[$i];
	process_argfile($dir, $argfiles[$i]);
}

if ($print_plusargs) {
	for ($i=0; $i<=$#plusargs; $i++) {
		$val = $plusargs[$i];
		if ($makevars) {
			$val =~ s/{/(/g;
			$val =~ s/}/)/g;
		}
		print "$val ";
	}
	print "\n";
}

if ($print_paths) {
	for ($i=0; $i<=$#paths; $i++) {
		$val = $paths[$i];
		if ($makevars) {
			$val =~ s/{/(/g;
			$val =~ s/}/)/g;
		}
		print "$val\n";
	}
}

sub process_argfile {
	my($dir,$file) = @_;
	my($ch,$ch2,$tok);
	my($argfile,$subdir);
	my($l_unget_ch_1, $l_unget_ch_2);
	
	open(my $fh,"<", $file) or die "Failed to open $file";
	$unget_ch_1 = -1;
	$unget_ch_2 = -1;
	
	while (!(($tok = read_tok($fh)) eq "")) {
		if ($tok =~ /^\+/) {
			push(@plusargs, $tok);
		} elsif ($tok =~ /^-/) {
			# Option
			if (($tok eq "-f") || ($tok eq "-F")) {
				# Read the next token
				$argfile = read_tok($fh);
				
				# Resolve argfile path
				$argfile = expand($argfile);
				
				unless (-f $argfile) {
					if (-f "$dir/$argfile") {
						$argfile = "$dir/$argfile";
					}
				}
				
				if ($tok eq "-F") {
					$subdir = dirname($argfile);
				} else {
					$subdir = $dir;
				}
				
				$l_unget_ch_1 = $unget_ch_1;
				$l_unget_ch_2 = $unget_ch_2;
				
				process_argfile($subdir, $argfile);

				$unget_ch_1 = $l_unget_ch_1;	
				$unget_ch_2 = $l_unget_ch_2;	
			} else {
				print("Unknown option\n");
				push(@paths, $tok);
			}
		} else {
			push(@paths, $tok);
		}		
	}

	close($fh);
}

sub read_tok($) {
	my($fh) = @_;
	my($ch,$ch2,$tok);
	my($cc1,$cc2);
	
	while (($ch = get_ch($fh)) != -1) {
		if ($ch eq "/") {
			$ch2 = get_ch($fh);
			if ($ch2 eq "*") {
				$cc1 = -1;
				$cc2 = -1;
			
				while (($ch = get_ch($fh)) != -1) {
					$cc2 = $cc1;
					$cc1 = $ch;
					if ($cc1 eq "/" && $cc2 eq "*") {
						last;
					}
				}
			
				next;
			} elsif ($ch2 eq "/") {
				while (($ch = get_ch($fh)) != -1 && !($ch eq "\n")) {
					;
				}
				unget_ch($ch);
				next;
			} else {
				unget_ch($ch2);
			}
		} elsif ($ch =~/^\s*$/) {
			while (($ch = get_ch($fh)) != -1 && $ch =~/^\s*$/) { }
			unget_ch($ch);
			next;
		} else {
			last;
		}
	}

	$tok = "";
		
	while ($ch != -1 && !($ch =~/^\s*$/)) {
		$tok .= $ch;
		$ch = get_ch($fh);
	}
	unget_ch($ch);	
		
	return $tok;
}

sub unget_ch($) {
	my($ch) = @_;

	$unget_ch_2 = $unget_ch_1;	
	$unget_ch_1 = $ch;
}

sub get_ch($) {
	my($fh) = @_;
	my($ch) = -1;
	my($count);
	
	if ($unget_ch_1 != -1) {
		$ch = $unget_ch_1;
		$unget_ch_1 = $unget_ch_2;
		$unget_ch_2 = -1;
	} else {
		$count = read($fh, $ch, 1);
		
		if ($count <= 0) {
			$ch = -1;
		}
	}
	
	return $ch;
}

sub fatal {
	my($msg) = @_;
	die $msg;
}

sub expand($) {
	my($val) = @_;
	my($offset) = 0;
	my($ind,$end,$tok);
	
	while (($ind = index($val, "\$", $offset)) != -1) {
		$end = index($val, "}", $index);
		$tok = substr($val, $ind+2, ($end-($ind+2)));

		if (exists $ENV{${tok}}) {
			$val = substr($val, 0, $ind) . $ENV{${tok}} . 
				substr($val, $end+1, length($val)-$end);
		}
		
		$offset = $ind+1;
	}
	
	return $val;
}
