#!/usr/bin/perl
#*****************************************************************************
#*                             runtest
#*
#* Run a test or tests
#*****************************************************************************

use Cwd;
use Cwd 'abs_path';
use POSIX ":sys_wait_h";
use File::Basename;

# Parameters
$SCRIPT=abs_path($0);
$SIM_DIR=dirname($SCRIPT);
$ENV{SIM_DIR}=$SIM_DIR;

# The parent of the sim directory is SOCBLOX
$SOCBLOX=dirname($SIM_DIR); # axi4_svm
$SOCBLOX=dirname($SOCBLOX); # interconnect
$SOCBLOX=dirname($SOCBLOX); # units_ve
$SOCBLOX=dirname($SOCBLOX); # units_ve
$ENV{SOCBLOX}=$SOCBLOX;

print "SOCBLOX=$SOCBLOX\n";

if (! -d "${SOCBLOX}/units_ve/interconnects/axi4_svm/sim") {
  print "[ERROR] runtest must be executed in the 'sim' directory\n";
  print "Working directory is: ${SIM_DIR}\n";
  exit 1
}

$test="";
@testlist;
$count=1;
$start=1;
$max_par=2;
$clean=0;
$build=1;
$cmd="";
$quiet="";
$interactive=0;
$builddir="";
$enable_qvip=0;

# Global PID list
@pid_list;

$run_root=getcwd();
$run_root .= "/rundir";

for ($i=0; $i <= $#ARGV; $i++) {
  $arg=$ARGV[$i];
  if ($arg =~ /^-/) {
    if ($arg eq "-test") {
      $i++;
      $test=$ARGV[$i];
      push(@testlist, $ARGV[$i]);
    } elsif ($arg eq "-count") {
      $i++;
      $count=$ARGV[$i];
    } elsif ($arg eq "-max_par") {
      $i++;
      $max_par=$ARGV[$i];
    } elsif ($arg eq "-rundir") {
       $i++;
       $run_root=$ARGV[$i];
    } elsif ($arg eq "-clean") {
       $clean=1;
    } elsif ($arg eq "-nobuild") {
       $build=0;
    } elsif ($arg eq "-builddir") {
       $i++;
       $builddir=$ARGV[$i];
    } elsif ($arg eq "-start") {
       $i++;
       $start=$ARGV[$i];
    } elsif ($arg eq "-i") {
       $interactive=1;
    } elsif ($arg eq "-quiet") {
       $quiet=1;
    } else {
      print "[ERROR] Unknown option $arg\n";
      printhelp();
      exit 1;
    }
  } else {
    if ($arg eq "build") {
      $cmd="build";
    } elsif ($arg eq "clean") {
      $cmd="clean";
    } else {
      printhelp();
      exit 1;
    }
  }
}

$ENV{ENABLE_QVIP}=$enable_qvip;

print "run_root=$run_root\n";
$ENV{RUN_ROOT}=$run_root;

if ($builddir eq "") {
  $builddir=$ENV{RUN_ROOT};
}
$ENV{BUILD_DIR}=$builddir;

if ($cmd eq "build") {
  build();
  exit 0;
} elsif ($cmd eq "clean") {
  clean();
  exit 0;
}

if ($test eq "") {
  print "[ERROR] no test specified\n";
  printhelp();
  exit 1
}

if ($interactive == 1 && $count > 1) {
  print "[ERROR] Cannot specify -i and -count > 1 together\n";
  exit 1
}

if ($build == 0 && $clean == 1) {
  print "[ERROR] Cannot specify -nobuild and -clean together\n";
  exit 1;
}


if ($quiet eq "") {
  if ($count == 1) {
    $quiet=0;
  } else {
    $quiet=1;
  }
}

$SIG{'INT'} = 'cleanup';

run_test($clean,$run_root,$test,$count,$quiet,$max_par,$start);

exit 0;

sub printhelp {
  print "runtest [options]\n";
  print "    -test <testname>    -- Name of the test to run\n";
  print "    -count <count>      -- Number of simulations to run\n";
  print "    -max_par <n>        -- Number of runs to issue in parallel\n";
  print "    -rundir  <path>     -- Specifies the root of the run directory\n";
  print "    -builddir <path>   -- Specifies the root of the build directory\n";
  print "    -clean              -- Remove contents of the run directory\n";
  print "    -nobuild            -- Do not automatically build the bench\n";
  print "    -i                  -- Run simulation in GUI mode\n";
  print "    -quiet              -- Suppress console output from simulation\n";
  print "\n";
  print "Example:\n";
  print "    runtest -test ethmac_simple_rxtx_test\n";
}

#*********************************************************************
#* run_jobs
#*********************************************************************
sub run_test {
    my($clean,$run_root,$test,$count,$quiet,$max_par,$start) = @_;


    if ($build == 1) {
      build();
    }

    # Now, 
    run_jobs($run_root,$test,$count,$quiet,$max_par,$start);
}

sub build {
    my($ret);

    if ($clean == 1) {
      system("rm -rf ${builddir}") && die;
    }

    system("mkdir -p ${builddir}") && die;
    chdir("$builddir");

    # First, build the testbench
    open(CP, "${SIM_DIR}/scripts/build.sh |");
    open(LOG,"> ${builddir}/compile.log");
    while (<CP>) {
       print($_);
       print(LOG  $_);
    }
    close(LOG);
    close(CP);
    $ret = $? >> 8;
    if ($ret != 0) {
      die "Compilation Failed";
    }
}

sub clean {
    my($ret);

    system("rm -rf ${builddir}") && die;

    open(CP, "${SIM_DIR}/scripts/clean.sh |");
    while (<CP>) {
      print($_);
    }
    close(CP);
}

#*********************************************************************
#* run_jobs
#*********************************************************************
sub run_jobs {
    my($run_root,$test,$count,$quiet,$max_par,$start) = @_;
    my($run_dir,$i, $alive, $pid);
    my(@pid_list_tmp,@cmdline);
    my($launch_sims, $n_complete, $n_started, $wpid);
    my($seed,$report_interval,$seed_str);

    $report_interval=20;

    if ($start eq "") {
      $start=1;
    }
    $seed=$start;

    $launch_sims = 1;
    $n_started = 0;

    while ($launch_sims || $#pid_list >= 0) {

        if ($launch_sims) {
            # Start up as many clients as possible (1-N)
            while ($#pid_list+1 < $max_par && $n_started < $count) {

                $seed_str = sprintf("%04d", $seed);
                $run_dir="${run_root}/rundir_${seed_str}";

                $pid = fork();
                if ($pid == 0) {
                    setpgrp;
                    system("rm -rf $run_dir");
                    system("mkdir ${run_dir}");
                    chdir("$run_dir");
print "running test\n";
                    print "$SIM_DIR/scripts/runone.sh\n";
                    system("$SIM_DIR/scripts/runone.sh", "-seed", "$seed", "-quiet", "$quiet", "$test", "-interactive", $interactive);
                    exit 0;
                }

                push(@pid_list, $pid);
                $n_started++;
                $seed++;

                # Launched the number requested
                if ($n_started >= $count) {
                  $launch_sims = 0;
                }
            }
        }

        # Wait for a client to die
        $pid = waitpid(-1, WNOHANG);
        if ($pid == 0) {
            $pid = wait();
        }

        # If -1 is returned, there are no child processes
        if ($pid == -1) {
            last;
        }

        # Update the PID list
        do {
            $n_completed++;
            if (($n_completed) % $report_interval == 0) {
              print "$n_completed Complete\n";
            }
            @pid_list_tmp = (); # empty pid list
            for ($i=0; $i<=$#pid_list; $i++) {
                if ($pid_list[$i] != $pid) {
                    push(@pid_list_tmp, $pid_list[$i]);
                }
            }
            @pid_list = @pid_list_tmp;
            $pid = waitpid(-1, WNOHANG);
        } while ($pid > 0);
    }
    print "$n_completed Complete\n";
}

sub cleanup {
    print "CLEANUP\n";
    for ($i=0; $i<=$#pid_list; $i++) {
        printf("KILL %d\n", $pid_list[$i]);
        kill -9, $pid_list[$i];
    }
    exit(1);
}



