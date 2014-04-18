
+incdir+${UVM_HOME}/src
${UVM_HOME}/src/uvm_pkg.sv

-f ${SOCBLOX}/common/rtl/common_rtl.f
-f ${SOCBLOX}/units/units.f
-f ${SOCBLOX}/common/sram/common_sram.f
-f ${SOCBLOX}/common/bfm/bfm.f
-f ${SOCBLOX}/systems/systems.f

${PROJECT_LOC}/systems/a23_mini_sys/a23_mini_sys.sv
${PROJECT_LOC}/systems_ve/a23_mini_sys/tb/a23_mini_sys_tb.sv
