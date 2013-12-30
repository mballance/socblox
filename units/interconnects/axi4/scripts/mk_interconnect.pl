#!/usr/bin/perl

use File::Basename;

$name = "";
$outfile = "";
$n_masters = -1;
$n_slaves = -1;
$protocol = "";
$force = 0;

%REPLACE_TOKENS;

for ($i=0; $i<=$#ARGV; $i++) {
	if ($ARGV[$i] =~ /^-/) {
		if ($ARGV[$i] eq "-n_slaves") {
			$n_slaves = $ARGV[++$i];
		} elsif ($ARGV[$i] eq "-n_masters") {
			$n_masters = $ARGV[++$i];
		} elsif ($ARGV[$i] eq "-protocol") {
			$protocol = $ARGV[++$i];
		} elsif ($ARGV[$i] eq "-f") {
			$force = 1;
		} elsif ($ARGV[$i] eq "-o") {
			$outfile = $ARGV[++$i];
			$name = basename($outfile);
			$idx = index($name, ".");
			if ($idx != -1) {
				$name = substr($name, 0, $idx);
			}
		} else {
			die "Unknown option $ARGV[$i]\n";
		}
	} else {
		# Not option
		die "Unknown argument $ARGV[$i]\n";
	}
}

if ($protocol eq "") {
	die "-protocol not specified\n";
} else {
	$template = "scripts/${protocol}_interconnect_NxN.sv";
}

if ($n_masters == -1) {
	die "-n_masters not specified\n";
}
if ($n_slaves == -1) {
	die "-n_slaves not specified\n";
}

$REPLACE_TOKENS{"NAME"} = $name;
$REPLACE_TOKENS{"N_MASTERS"} = $n_masters;
$REPLACE_TOKENS{"N_SLAVES"} = $n_slaves;
$REPLACE_TOKENS{"AW_MASTER_ASSIGN"} = axi4_aw_master_assign($n_masters);
$REPLACE_TOKENS{"AR_MASTER_ASSIGN"} = axi4_ar_master_assign($n_masters);
$REPLACE_TOKENS{"W_MASTER_ASSIGN"} = axi4_w_master_assign($n_masters);
$REPLACE_TOKENS{"R_MASTER_ASSIGN"} = axi4_r_master_assign($n_masters);
$REPLACE_TOKENS{"B_MASTER_ASSIGN"} = axi4_b_master_assign($n_masters);
$REPLACE_TOKENS{"AW_SLAVE_ASSIGN"} = axi4_aw_slave_assign($n_slaves);
$REPLACE_TOKENS{"AR_SLAVE_ASSIGN"} = axi4_ar_slave_assign($n_slaves);
$REPLACE_TOKENS{"W_SLAVE_ASSIGN"} = axi4_w_slave_assign($n_slaves);
$REPLACE_TOKENS{"R_SLAVE_ASSIGN"} = axi4_r_slave_assign($n_slaves);
$REPLACE_TOKENS{"B_SLAVE_ASSIGN"} = axi4_b_slave_assign($n_slaves);
$REPLACE_TOKENS{"MASTER_PORTLIST"} = axi4_master_portlist($n_slaves);
$REPLACE_TOKENS{"SLAVE_PORTLIST"} = axi4_slave_portlist($n_slaves);
$REPLACE_TOKENS{"ADDRESS_RANGE_PARAMS"} = address_range_params($n_slaves);
$REPLACE_TOKENS{"ADDR2SLAVE_BODY"} = add2slave_body($n_slaves);

if (! -f $template) {
	die "template $template does not exist\n";
}

open(FILE, $template) or die "Failed to open template $template";
while (<FILE>) {
	$in .= $_;
}
close(FILE);

$out = replace_tokens($in);

# print "in=$in\n";

if (-f $outfile && $force == 0) {
	die "output file $outfile exists\n";
} else {
	open(FILE, ">$outfile") || die "Failed to open output file $outfile for writing\n";
	print FILE $out;
	print FILE "\n";
	close(FILE);
}

exit 0;

sub axi4_aw_master_assign($) {
	my($n_masters) = @_;
	my($i,$out,$name);
	my(@AWNAMES_LHS) = ("AWADDR", "AWID", "AWLEN", "AWSIZE", "AWBURST",
		"AWCACHE", "AWPROT", "AWQOS", "AWREGION", "AWVALID");
	my(@AWNAMES_RHS) = ("AWREADY");

	foreach (@AWNAMES_LHS) {
		$name=$_;
		for ($i=0; $i<$n_masters; $i++) {
			$out .= "\tassign ${name}[$i] = m${i}.${name};\n";
		}
	}
	
	foreach (@AWNAMES_RHS) {
		$name=$_;
		for ($i=0; $i<$n_masters; $i++) {
			$out .= "\tassign m${i}.${name} = ${name}[$i];\n";
		}
	}
	
	return $out;
}

sub axi4_ar_master_assign($) {
	my($n_masters) = @_;
	my($i,$out,$name);
	my(@LHS) = ("ARADDR", "ARID", "ARLEN", "ARSIZE", "ARBURST",
		"ARCACHE", "ARPROT", "ARREGION", "ARVALID");
	my(@RHS) = ("ARREADY");

	foreach (@LHS) {
		$name=$_;
		for ($i=0; $i<$n_masters; $i++) {
			$out .= "\tassign ${name}[$i] = m${i}.${name};\n";
		}
	}
	
	foreach (@RHS) {
		$name=$_;
		for ($i=0; $i<$n_masters; $i++) {
			$out .= "\tassign m${i}.${name} = ${name}[$i];\n";
		}
	}
	
	return $out;
}

sub axi4_w_master_assign($) {
	my($n_masters) = @_;
	my($i,$out,$name);
	my(@LHS) = ("WDATA", "WSTRB", "WLAST", "WVALID");
	my(@RHS) = ("WREADY");

	foreach (@LHS) {
		$name=$_;
		for ($i=0; $i<$n_masters; $i++) {
			$out .= "\tassign ${name}[$i] = m${i}.${name};\n";
		}
	}
	
	foreach (@RHS) {
		$name=$_;
		for ($i=0; $i<$n_masters; $i++) {
			$out .= "\tassign m${i}.${name} = ${name}[$i];\n";
		}
	}
	
	return $out;
}

sub axi4_r_master_assign($) {
	my($n_masters) = @_;
	my($i,$out,$name);
	my(@LHS) = ("RREADY");
	my(@RHS) = ("RDATA", "RLAST", "RVALID");

	foreach (@LHS) {
		$name=$_;
		for ($i=0; $i<$n_masters; $i++) {
			$out .= "\tassign ${name}[$i] = m${i}.${name};\n";
		}
	}
	
	foreach (@RHS) {
		$name=$_;
		for ($i=0; $i<$n_masters; $i++) {
			$out .= "\tassign m${i}.${name} = ${name}[$i];\n";
		}
	}
	
	return $out;
}

sub axi4_b_master_assign($) {
	my($n_masters) = @_;
	my($i,$out,$name);
	my(@AWNAMES_LHS) = ("BREADY");
	my(@AWNAMES_RHS) = ("BID", "BRESP", "BVALID");

	foreach (@AWNAMES_LHS) {
		$name=$_;
		for ($i=0; $i<$n_masters; $i++) {
			$out .= "\tassign ${name}[$i] = m${i}.${name};\n";
		}
	}
	
	foreach (@AWNAMES_RHS) {
		$name=$_;
		for ($i=0; $i<$n_masters; $i++) {
			$out .= "\tassign m${i}.${name} = ${name}[$i];\n";
		}
	}
	
	return $out;
}

sub axi4_aw_slave_assign($) {
	my($n_slaves) = @_;
	my($i,$out,$name);
	my(@LHS) = ("AWREADY");
	my(@RHS) = ("AWADDR", "AWID", "AWLEN", "AWSIZE", "AWBURST", "AWCACHE", "AWPROT", "AWQOS", "AWREGION", "AWVALID");

	foreach (@LHS) {
		$name=$_;
		for ($i=0; $i<=$n_slaves; $i++) {
			if ($i == $n_slaves) {
				$out .= "\tassign S${name}[$i] = serr.master.${name};\n";
			} else {
				$out .= "\tassign S${name}[$i] = s${i}.${name};\n";
			}
		}
	}
	
	foreach (@RHS) {
		$name=$_;
		for ($i=0; $i<=$n_slaves; $i++) {
			if ($i == $n_slaves) {
				$out .= "\tassign serr.master.${name} = S${name}[$i];\n";
			} else {
				$out .= "\tassign s${i}.${name} = S${name}[$i];\n";
			}
		}
	}
	
	return $out;
}

sub axi4_ar_slave_assign($) {
	my($n_slaves) = @_;
	my($i,$out,$name);
	my(@LHS) = ("ARREADY");
	my(@RHS) = ("ARADDR", "ARID", "ARLEN", "ARSIZE", "ARBURST", "ARCACHE", "ARPROT", "ARREGION", "ARVALID");

	foreach (@LHS) {
		$name=$_;
		for ($i=0; $i<=$n_slaves; $i++) {
			if ($i == $n_slaves) {
				$out .= "\tassign S${name}[$i] = serr.master.${name};\n";
			} else {
				$out .= "\tassign S${name}[$i] = s${i}.${name};\n";
			}
		}
	}
	
	foreach (@RHS) {
		$name=$_;
		for ($i=0; $i<=$n_slaves; $i++) {
			if ($i == $n_slaves) {
				$out .= "\tassign serr.master.${name} = S${name}[$i];\n";
			} else {
				$out .= "\tassign s${i}.${name} = S${name}[$i];\n";
			}
		}
	}
	
	return $out;
}

sub axi4_w_slave_assign($) {
	my($n_slaves) = @_;
	my($i,$out,$name);
	my(@LHS) = ("WREADY");
	my(@RHS) = ("WDATA", "WSTRB", "WLAST", "WVALID");

	foreach (@LHS) {
		$name=$_;
		for ($i=0; $i<=$n_slaves; $i++) {
			if ($i == $n_slaves) {
				$out .= "\tassign S${name}[$i] = serr.master.${name};\n";
			} else {
				$out .= "\tassign S${name}[$i] = s${i}.${name};\n";
			}
		}
	}
	
	foreach (@RHS) {
		$name=$_;
		for ($i=0; $i<=$n_slaves; $i++) {
			if ($i == $n_slaves) {
				$out .= "\tassign serr.master.${name} = S${name}[$i];\n";
			} else {
				$out .= "\tassign s${i}.${name} = S${name}[$i];\n";
			}
		}
	}
	
	return $out;
}

sub axi4_r_slave_assign($) {
	my($n_slaves) = @_;
	my($i,$out,$name);
	my(@LHS) = ("RDATA", "RLAST", "RVALID");
	my(@RHS) = ("RREADY");

	foreach (@LHS) {
		$name=$_;
		for ($i=0; $i<=$n_slaves; $i++) {
			if ($i == $n_slaves) {
				$out .= "\tassign S${name}[$i] = serr.master.${name};\n";
			} else {
				$out .= "\tassign S${name}[$i] = s${i}.${name};\n";
			}
		}
	}
	
	foreach (@RHS) {
		$name=$_;
		for ($i=0; $i<=$n_slaves; $i++) {
			if ($i == $n_slaves) {
				$out .= "\tassign serr.master.${name} = S${name}[$i];\n";
			} else {
				$out .= "\tassign s${i}.${name} = S${name}[$i];\n";
			}
		}
	}
	
	return $out;
}

sub axi4_b_slave_assign($) {
	my($n_slaves) = @_;
	my($i,$out,$name);
	my(@LHS) = ("BID", "BRESP", "BVALID");
	my(@RHS) = ("BREADY");

	foreach (@LHS) {
		$name=$_;
		for ($i=0; $i<=$n_slaves; $i++) {
			if ($i == $n_slaves) {
				$out .= "\tassign S${name}[$i] = serr.master.${name};\n";
			} else {
				$out .= "\tassign S${name}[$i] = s${i}.${name};\n";
			}
		}
	}
	
	foreach (@RHS) {
		$name=$_;
		for ($i=0; $i<=$n_slaves; $i++) {
			if ($i == $n_slaves) {
				$out .= "\tassign serr.master.${name} = S${name}[$i];\n";
			} else {
				$out .= "\tassign s${i}.${name} = S${name}[$i];\n";
			}
		}
	}
	
	return $out;
}

sub axi4_master_portlist($) {
	my($n_masters) = @_;
	my($i);
	my($portlist);
	
	for ($i=0; $i<$n_masters; $i++) {
		$portlist .= "\t\taxi4_if.master\t\t\t\t\tm${i}";
		if ($i+1 < $n_masters) {
			$portlist .= ",\n";
		}
	}
	
	return $portlist;
}

sub axi4_slave_portlist($) {
	my($n_slaves) = @_;
	my($i);
	my($portlist);

	# For now, do not emit an error port	
	for ($i=0; $i<$n_slaves; $i++) {
		if ($i == $n_slaves) {
			$portlist .= "\t\taxi4_if.slave\t\t\t\t\tserr";
		} else {
			$portlist .= "\t\taxi4_if.slave\t\t\t\t\ts${i}";
		}
#		if ($i+1 <= $n_slaves) {
		if ($i+1 < $n_slaves) {
			$portlist .= ",\n";
		}
	}
	
	return $portlist;
}

sub address_range_params($) {
	my($n_slaves) = @_;
	my($i);
	my($params) = ",\n";
	
	for ($i=0; $i<$n_slaves; $i++) {
		$params .= "\t\tparameter bit[AXI4_ADDRESS_WIDTH-1:0] SLAVE" . $i . "_ADDR_BASE='h0,\n";
		$params .= "\t\tparameter bit[AXI4_ADDRESS_WIDTH-1:0] SLAVE" . $i . "_ADDR_LIMIT='h0";
		if ($i+1 < $n_slaves) {
			$params .= ",\n";
		}
	}

	return $params;
}

sub add2slave_body($) {
	my($n_slaves) = @_;
	my($i);
	my($n) = 0;
	my($params) = "";

	$params .= "\t\taddr_o = addr;\n";	
	for ($i=0; $i<$n_slaves; $i++) {
		$params .= "\t\tif (addr >= SLAVE" . $i . "_ADDR_BASE && addr <= SLAVE" . $i . "_ADDR_LIMIT) begin\n";
		$params .= "\t\t\treturn " . $i . ";\n";
		$params .= "\t\tend\n";
		$n++;
	}

	return $params;
	
}

sub replace_tokens($)
{
	my($in) = @_;
	my($out) = "";
	my($i,$c,$in_len,$idx,$var,$val);
	my($n_replacements);

	do {
		$n_replacements = 0;
		$out = "";
		$in_len = length($in);
		for ($i=0; $i<$in_len; $i++) {
			if ($i+2 < $in_len && substr($in, $i, 2) eq "\${") {
				$idx = index($in, "}", $i);
				
				if ($idx >= 0) {
					# Found the end
					$var=substr($in, $i+2, ($idx-$i-2));
					if (exists $REPLACE_TOKENS{$var}) {
#						print("$var = $REPLACE_TOKENS{$var}\n");
						$n_replacements++;
						$out .= $REPLACE_TOKENS{$var};
						$i = $idx;
					} else {
						# Does not exist
						$out .= "\$";
					}
#					print("var=$var\n");
				} else {
					# Failed to find the end
				}
			} else {
				$out .= substr($in, $i, 1);
			}
		}
		
		$in = $out;
	} while ($n_replacements > 0);
	
	return $out;
}
