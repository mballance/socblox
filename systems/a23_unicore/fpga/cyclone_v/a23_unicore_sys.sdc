
create_clock -period 20 [get_ports brdclk]

derive_pll_clocks

derive_clock_uncertainty
