#****************************************************************************
#* quartus_utils.tcl
#*
#* 
#****************************************************************************

load_package flow

proc main {argv} {
	set project "tmp"
	set output "output"
	
	set argv [build_arglist $argv]
	set argv_p ""

	# First, find the project
	for {set i 0} {$i < [llength $argv]} {incr i} {
		set arg [lindex $argv $i]
		set arg [expand_vars $arg]
		
		if {$arg == "-project"} {
			incr i
			set arg [lindex $argv $i]
			set arg [expand_vars $arg]
			set project $arg
		} elseif {$arg == "-o" || $arg == "-output"} {
			incr i
			set arg [lindex $argv $i]
			set arg [expand_vars $arg]
			set output $arg
		}
	}
	
	project_new -overwrite $project
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY "$output"

	# Now, apply arguments
	for {set i 0} {$i < [llength $argv]} {incr i} {
		set arg [lindex $argv $i]
		set arg [expand_vars $arg]
		
		if {$arg == "-project" || $arg == "-o" || $arg == "-output"} {
			incr i
		} elseif {$arg == "-top"} {
			incr i
			set arg [expand_vars [lindex $argv $i]]
			set_global_assignment -name TOP_LEVEL_ENTITY $arg
#			set_global_assignment -name FAMILY "Cyclone V"
#			set_global_assignment -name DEVICE 5CSXFC6D6F31C8ES
#			set_global_assignment -name TOP_LEVEL_ENTITY a23_dualcore_sys	
		} elseif {$arg == "-family"} {
			incr i
			set arg [expand_vars [lindex $argv $i]]
			puts "Note: Setting family $arg"
			set_global_assignment -name FAMILY "$arg"
		} elseif {$arg == "-device"} {
			incr i
			set arg [expand_vars [lindex $argv $i]]
			puts "Note: Setting device $arg"
			set_global_assignment -name DEVICE "$arg"
		} elseif {$arg == "-assign-pin"} {
			incr i
			set port [expand_vars [lindex $argv $i]]
			incr i
			set pin [expand_vars [lindex $argv $i]]
			
			set_location_assignment $pin -to $port
		} elseif {$arg == "-io-standard"} {
			incr i
			set port [expand_vars [lindex $argv $i]]
			incr i
			set io_std [expand_vars [lindex $argv $i]]
			
			set_instance_assignment -name IO_STANDARD "$io_std" -to $port
		} else {
			lappend argv_p $arg
		}
	}
	
	add_compile_options $argv_p
	execute_flow -compile
	
	project_close
}

proc add_compile_options {argv} {
	set argv [build_arglist $argv]
	for {set i 0} {$i < [llength $argv]} {incr i} {
		set arg [lindex $argv $i]
		set arg [expand_vars $arg]
		
		if {[string range $arg 0 7] == "+incdir+"} {
			set dir [string range $argv 8 [expr [string length $arg] - 1]]
			puts "Note: add include path $dir"
			set_global_assignment -name SEARCH_PATH "$dir"
		} elseif {[string range $arg 0 7] == "+define+"} {
			puts "define"
		} else {
			puts "Note: add file path $arg"
			set ext [file extension $arg]
			if {$ext == ".svh" || $ext == ".sv"} {
				set_global_assignment -name SYSTEMVERILOG_FILE "$arg"
			} elseif {$ext == ".v"} {
				set_global_assignment -name SYSTEMVERILOG_FILE "$arg"
			} elseif {$ext == ".sdc"} {
				set_global_assignment -name SDC_FILE "$arg"
			} else {
				puts "Error: Unknown file $arg"
			}
		}
	}
}

proc build_arglist {argv} {
	set ret ""
	
	_build_arglist "" $argv ret
	
	return $ret
}

#************************************************************
#* Procedure: _build_arglist
#************************************************************
proc _build_arglist {file argv arglist_i} {
	upvar $arglist_i arglist
	
	for {set i 0} {$i < [llength $argv]} {incr i} {
		set arg [lindex $argv $i]
		if {$arg == "-f"} {
			incr i
			set target [expand_vars [lindex $argv $i]]
			if {[catch {open $target "r"} fd]} {
				error "Failed to open file $target while processing $file"
			}
			set file_args [_read_argument_file $target $fd]
			_build_arglist [lindex $argv $i] $file_args arglist
		} else {
			lappend arglist $arg
		}
	}
}

#************************************************************
#* Procedure: _read_argument_file
#************************************************************
proc _read_argument_file {file fd} {
	set last_ch -1
	set ret ""
	
	set content [read $fd]
	close $fd
	
	for {set i 0} {$i < [string length $content]} {incr i} {
		set ch [string index $content $i]

		if {$ch == "/"} {
			# May be a comment
			incr i
			set ch [string index $content $i]
			if {$ch == "/"} {
				# Single-line comment
				incr i
				while {$i < [string length $content]} {
					set ch [string index $content $i]
					if {$ch == "\n"} {
						break
					}
					incr i
				}
				set $last_ch $ch
				continue
			} elseif {$ch == "*"} {
				# multi-line comment
				incr i
				set last_ch -1
				while {$i < [string length $content]} {
					set ch [string index $content $i]
					if {$last_ch == "*" && $ch == "/"} {
						break
					}
					set last_ch $ch
					incr i
				}					
				set $last_ch $ch
				continue
			} else {
				# Neither
				incr i -1
			}
		} elseif {$ch == "#"} {
			# Single-line comment
			incr i
			while {$i < [string length $content]} {
				set ch [string index $content $i]
				if {$ch == "\n"} {
					break
				}
				incr i
			}
			set $last_ch $ch
			continue
		}
			
		if {$ch == "\"" && $last_ch != "\\"} {
			# Read a string
			set token ""
		
			# Skip quote
			incr i
			while {$i < [string length $content]} {
				set ch [string index $content $i]
				set $last_ch $ch
				if {$ch == "\"" || $ch == "\n"} {
					lappend ret $token
					break
				}
				set token "${token}${ch}"
				incr i
			}
		} elseif {[string trim $ch] == ""} {
			# Whitespace
			set $last_ch $ch
		} else {
			# Read up to the next whitespace
			set token ""
			
			while {$i < [string length $content]} {
				set ch [string index $content $i]
				set $last_ch $ch
				if {[string trim $ch] == ""} {
					lappend ret $token
					break
				}
				set token "${token}${ch}"
				incr i
			}
		}

		set last_ch $ch
	}
	
	return $ret
}

#************************************************************
#* Procedure: expand_vars
#*
#* Expand environment-variable references in the path string
#************************************************************
proc expand_vars {path} {
	global env
	set i 0
	set ret ""
	set last_ch -1

	while {$i < [string length $path]} {
		set ch [string index $path $i]
		if {$ch == "$" && $last_ch != "\\"} {
			set has_brace 0
			incr i
			if {[string index $path $i] == "\{" } {
				set has_brace 1
				incr i;
			}
			set start $i
			set end -1
			while {$i < [string length $path]} {
				set ch [string index $path $i]
				if {$ch == "\}"} {
					set end $i
					incr end -1
					if {$has_brace == 0} {
						incr i -1
					}
						
					break
				} elseif {$ch == "/" || [string trim $ch] == ""} {
					# Reached the end of the pattern
					incr i -1
					set end $i
					break
				}
				incr i
			}
			if {$end == -1} {
				# Set the end to the last legal index
				set end [expr [string length $path] - 1]
			}
			set var [string range $path $start $end]

			set val [lindex [array get env $var] 1]
			
			if {$val != ""} {
				set ret "${ret}${val}"
			} else {
				# Keep the original 
				set ret "${ret}\${${var}}"
			}
		} else {
			if {$ch != "\\"} {
				set ret "${ret}${ch}"
			}
		}
		incr i
		set last_ch $ch
	}
	return $ret
}

main $argv
