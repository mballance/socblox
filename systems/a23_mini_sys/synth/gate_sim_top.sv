
`timescale 1ps / 1ps

module gate_sim_top;

reg clk_r = 0;
wire clk_i;

initial begin
  forever begin
    #10ns;
    clk_r <= 1;
    #10ns;
    clk_r <= 0;
  end
end

assign clk_i = clk_r;

wire led0, led1, led2, led3;

a23_mini_sys u_sys(
  .clk_i(clk_i),
  .led0(led0),
  .led1(led1),
  .led2(led2),
  .led3(led3)
);

endmodule

