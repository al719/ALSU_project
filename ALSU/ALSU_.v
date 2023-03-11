module ALSU_(
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

				output reg valid,
				output reg [5:0] out,
				output reg [15:0] leds
			);
//parameters
parameter INPUT_PRIORITY = "A";
parameter FULL_ADDER = "ON";
//internal signals
wire [15:0] led_blink;

always @(posedge clk or posedge rst) begin
	//valid <=1;
	if (rst) begin
		// reset
		out <= 'b0;
		leds <= 'b0;
		valid <= 1;
	end
	else if(byPass_A && ~byPass_B) begin 
		out <= A;
		valid <= 1;
	end
	else if(byPass_B && ~byPass_A) begin 
		out <= B;
		valid <= 1;
	end 
	else if(byPass_A && byPass_B) begin
		out <= INPUT_PRIORITY;
		valid <= 1;
	end 
	else begin

		case (opcode) 
			3'b000 : begin	
				valid <= 1;					// AND
				if(red_op_A && ~red_op_B)
					out <= &A;
				else if(~red_op_A && red_op_B)
					out <= &B;
				else if(red_op_A && red_op_B)
					out <= &INPUT_PRIORITY;
				else
					out <= A & B;
			end
				
			3'b001 : begin
			    valid <= 1;						// XOR
				if(red_op_A && ~red_op_B)
					out <= ^A;
				else if(~red_op_A && red_op_B)
					out <= ^B;
				else if(red_op_A && red_op_B)
					out <= ^INPUT_PRIORITY;
				else
					out <= A ^ B;
			end 

			3'b010 : begin						// Addition
				if(red_op_A || red_op_B) begin
					out <= 0;
					leds <= led_blink;
					valid <=0;
				end
				else begin
					valid <= 1;
				if(FULL_ADDER == "ON")
					out <= A + B + cin;
				else
					out <= A + B;
				end
			end
			3'b011 : begin						// Multiplication
				if(red_op_A || red_op_B) begin
					out <= 0;
					leds <= led_blink;
					valid <=0;
				end
				else 
					valid <= 1;
					out <= A * B;
			end
			3'b100 : begin						// Shift output
				if(red_op_A || red_op_B) begin
					out <= 0;
					leds <= led_blink;
					valid <=0;
				end
				else begin 
					valid <= 1;
					if(direction)
						out <= {out[4:0], serial_in};
					else
						out <= {serial_in, out[5:1]};
				end
			end	
			3'b101 : begin						// Rotation
				if(red_op_A || red_op_B) begin
					out <= 0;
					leds <= led_blink;
					valid <=0;
				end
				else begin 
					valid <= 1;
					if(direction)
						out <= {out[4:0], out[5]};
					else
						out <= {out[0], out[5:1]};
				end
			end	
			3'b110 || 3'b111 : begin			// Invalid opcode
				out <= 0;
				leds <= led_blink;
				valid <=0;
			end
			default :	begin 					// to be continued
				out <= 0;
				leds <= 0;
				valid <= 1;
				end
	endcase
	end
end
blinking blink(clk,led_blink);
endmodule