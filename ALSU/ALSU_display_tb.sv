module ALSU_display_tb();
reg clk,rst,valid;
reg[5:0] out;

wire [3:0] anode;
wire [6:0] cathode;

initial begin
	clk = 0;
	forever #1 clk = ~clk;
end
initial begin
	rst = 1;
	#4;
	rst = 0;
	out = 'b001111;
	valid = 1;
	#2;
	rst = 1;
	#2;
	$stop;
end
ALSU_Display DUT(clk,rst,valid,out,anode,cathode);
endmodule