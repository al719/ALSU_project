module ALSU_TO_SEVEN_SEGMENT(
							input wire [2:0] A,
							input wire [2:0] B,
							input wire [2:0] opcode,
							input wire cin,
							input wire serial_in,
							input wire direction,
							input wire red_op_A,
							input wire red_op_B,
							input wire byPass_A,
							input wire byPass_B,
							input wire clk,
							input wire rst,

							output wire[3:0] anode,
							output wire[6:0] cathode,
							output wire[15:0] leds
								);
//internal wires
wire [5:0] out_ALSU;
wire valid;
wire [2:0] A_registered,B_registered;
D_Asynch A_(A,clk,rst,A_registered);
D_Asynch B_(B,clk,rst,B_registered);
// instance for ALSU block
ALSU_ ALSU(A_registered,B_registered,opcode,cin,serial_in,direction,red_op_A,red_op_B,byPass_A,byPass_B,clk,rst,valid,out_ALSU,leds);

//instance for 7 segment display
ALSU_Display ALSU_display_on_7segment(clk,rst,valid,out_ALSU,anode,cathode);

endmodule