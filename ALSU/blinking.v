module blinking(clk,led );//input reset,
input wire clk;
reg [27:0] counter;
output reg [15:0] led;
reg clkout;

initial begin
    counter = 0;
    clkout = 0;
    led = 0; 
end
always @(posedge clk) begin
    if (counter == 0) begin
        counter <= 149999999;//actual value used to be shown on board blinking
        //counter <= 10; to be shown in simulation
        clkout <= ~clkout;
    end else begin
        counter <= counter - 1;
    end
end

always @(posedge clkout) begin
            led <= ~led;
    end
endmodule

/*

module blink (clk, LED);

input clk;
output LED;

reg [31:0] counter;
reg LED_status;

initial begin
counter <= 32'b0;
LED_status <= 1'b0;
end

always @ (posedge clk) 
begin
counter <= counter + 1'b1;
if (counter > 50000000)
begin
LED_status <= !LED_status;
counter <= 32'b0;
end


end

assign LED = LED_status;

endmodule 


*/