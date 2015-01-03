
create_clock -period 20 [get_ports clk_i]
# create_generated_clock -name core_clk -source [get_ports {clk_i}] -divide_by 2 [get_registers {core_clk_r}]
# create_generated_clock -name core_clk -source [get_ports {clk_i}] -divide_by 16 [get_registers {core_clk_r}]

derive_pll_clocks

derive_clock_uncertainty
