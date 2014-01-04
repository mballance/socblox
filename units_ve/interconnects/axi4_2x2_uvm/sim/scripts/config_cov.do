
#**
#** config_cov.do
#**
#** Commands to setup saving of coverage data
#**
coverage attr -name TESTNAME -value [format "%s_%d" "$env(TESTNAME)" $Sv_Seed]

coverage save -onexit cov.ucdb
