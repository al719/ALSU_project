module D_Asynch(d,clk,rst,q);
input wire rst,clk;
input wire [2:0] d;
output reg [2:0] q;
//output wire [2:0] qbar;

always @(posedge clk or posedge rst) begin
	if (rst)
		q<=0;
	else begin
		q <= d;
	end
end
//assign qbar = ~q;
endmodule 