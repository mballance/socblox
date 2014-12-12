//***************************************************************************
//* altera_sockit_settings.f
//*
//* Quartus settings for the Altera SoCKit evaluation board
//***************************************************************************
-family "Arria II GX"
-device EP2AGX45DF29I5
-global-assignment OPTIMIZATION_TECHNIQUE=SPEED
-global-assignment PHYSICAL_SYNTHESIS_COMBO_LOGIC=ON
-global-assignment PHYSICAL_SYNTHESIS_REGISTER_DUPLICATION=ON
-global-assignment PHYSICAL_SYNTHESIS_REGISTER_RETIMING=ON
-global-assignment ROUTER_LCELL_INSERTION_AND_LOGIC_DUPLICATION=ON
-global-assignment ROUTER_TIMING_OPTIMIZATION_LEVEL=MAXIMUM
-global-assignment AUTO_PACKED_REGISTERS_STRATIXII=NORMAL
// -global-assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
// -global-assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
// -global-assignment -name PARTITION_COLOR 16764057 -section_id Top
-global-assignment MUX_RESTRUCTURE=OFF
-global-assignment ROUTER_CLOCKING_TOPOLOGY_ANALYSIS=ON
-global-assignment "FITTER_EFFORT=STANDARD FIT"
-global-assignment ENABLE_DRC_SETTINGS=ON
