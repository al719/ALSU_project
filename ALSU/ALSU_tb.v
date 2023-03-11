module ALSU_tb();
reg rst,clk,cin,serial_in,direction,red_op_A,red_op_B,byPass_A,byPass_B;
reg [2:0] A,B,opcode;
wire [5:0] out ;
wire [15:0] leds;
wire valid;
initial begin
	clk = 0;
	forever #1 clk = ~clk;
end
integer i ;
initial begin
	rst = 1;
	cin = 0;
	serial_in = 0;
	direction = 1;// for left
	red_op_B = 0;
	red_op_A = 0;
	byPass_A = 0;
	byPass_B = 0;
	A = 'b001;
	B = 'b010;
	opcode = 000; // for AND operation
	#2;
	// for checking bypass A
	byPass_A = 1;
	//byPass_B = 0;
	rst = 0;
	#2;
	// for checking bypass B
	byPass_A = 0;
	byPass_B = 1;
	#2;
	//for checking input priority
	A = 'b111;
	B = 'b100;
	#2;
	byPass_A = 1;
	#2;
	byPass_A = 0;
	byPass_B = 0;
	rst = 1;
	#2;
	//then go through opcode case
	rst = 0;
	//#2;
	// for reduction A 
	red_op_A = 1;
	red_op_B = 0;
	#2;
	//for reduction B
	red_op_A = 0;
	red_op_B = 1;
	#2;
	// checking input priority to reduction operation opcode = 000 (AND)
	red_op_A = 1;
	#2;
	// bitwise AND --> out = A & B
	red_op_A = 0;
	red_op_B = 0;
	#2;
	// the same operation at opcode = 001 XOR(^) so i'll write only one case
	// bit wise XOR
	opcode = 'b001;
	#2;
	//addition
	A = 'b010;
	B = 'b011;
	opcode = 'b010;
	#2;
	opcode = 'b011;//multplication
	#2;
	// check invalid case when not logic opcode but use red-op-a
	red_op_A = 1;
	#20;// blinking working well
	rst = 1;
	red_op_A = 0;
	red_op_B = 0;
	#2;
	rst = 0;
	opcode = 'b100;// left operation for each clk posedge then put long delay and random for serial_in
	for(i = 0;i<10;i = i+1) begin
		@(negedge clk)
		serial_in = $random;
	end
	#2;
	direction = 0;
	for(i = 0;i<10;i = i+1) begin
		@(negedge clk)
		serial_in = $random;
	end
	#2;
	opcode = 'b101;
	#2;
	direction = 1;
	#10;
	direction = 0;
	#10;
	$stop;
end
ALSU_ DUT(A,B,opcode,cin,serial_in,direction,red_op_A,red_op_B,byPass_A,byPass_B,clk,rst,valid,out,leds);
endmodule