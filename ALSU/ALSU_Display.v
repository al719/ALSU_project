module ALSU_Display(
                    input clock_100Mhz, // 100 Mhz clock source on Basys 3 FPGA
                    input reset,
                    input valid,
                    input wire[5:0] out_ALU,
                    output reg [3:0] Anode_Activate,
                    output reg [6:0] LED_out
                    );

    reg [3:0] LED_BCD;
   reg [19:0] refresh_counter; // 20-bit for creating 10.5ms refresh period or 380Hz refresh rate
   //reg [3:0] refresh_counter;       // the first 2 MSB bits for creating 4 LED-activating signals with 2.6ms digit period
    wire [1:0] LED_activating_counter; 
    //output reg [3:0] Anode_Activate, // anode signals of the 7-segment LED display
    //output reg [6:0] LED_out// cathode patterns of the 7-segment LED display
    //=======================================================================
    always @(posedge clock_100Mhz or posedge reset)
    begin 
        if(reset==1)
            refresh_counter <= 0;
        else
            refresh_counter <= refresh_counter + 1;
    end 
    assign LED_activating_counter = refresh_counter[19:18];
    // anode activating signals for 4 LEDs, digit period of 2.6ms
    // decoder to generate anode signals 
    always @(*)
    begin
        case(LED_activating_counter) //anode active high so invert all bits
        2'b00: begin
            Anode_Activate = 4'b1110;
            // activate LED4 and Deactivate LED2, LED3, LED1
            if(~valid)
                LED_BCD =  4'b1011;
            else LED_BCD = out_ALU[3:0];
              end
        2'b01: begin
            Anode_Activate = 4'b1101; 
            // activate LED3 and Deactivate LED1, LED2, LED4
            if(~valid)
                LED_BCD = 4'b0000;
            else LED_BCD = out_ALU[5:4];
              end
        2'b10: begin
            Anode_Activate = 4'b1011; 
            // activate LED2 and Deactivate LED3, LED1, LED4
            if(~valid)
                LED_BCD =  4'b0100;
            else LED_BCD = 4'bxxxx;
                end
        2'b11: begin
            Anode_Activate = 4'b0111; 
            // activate LED1 and Deactivate LED2, LED3, LED4
            if(~valid)
                LED_BCD =  4'b1110;
            else LED_BCD = 4'bxxxx;    
               end
        endcase
    end
    // Cathode patterns of the 7-segment LED display 
    always @(*)
    begin  
        case(LED_BCD) // cathode active low 
        4'b0000: LED_out = 7'b0000001; // "0"     
        4'b0001: LED_out = 7'b1001111; // "1" 
        4'b0010: LED_out = 7'b0010010; // "2" 
        4'b0011: LED_out = 7'b0000110; // "3" 
        4'b0100: LED_out = 7'b1001100; // "4" 
        4'b0101: LED_out = 7'b0100100; // "5" 
        4'b0110: LED_out = 7'b0100000; // "6" 
        4'b0111: LED_out = 7'b0001111; // "7" 
        4'b1000: LED_out = 7'b0000000; // "8"     
        4'b1001: LED_out = 7'b0000100; // "9"

        4'b1010: LED_out = 7'b0001000; // "10--> A"     
        4'b1011: LED_out = 7'b1100000; // "11--> b" 
        4'b1100: LED_out = 7'b0110001; // "12--> C" 
        4'b1101: LED_out = 7'b1000010; // "13--> d" 
        4'b1110: LED_out = 7'b0110000; // "14--> E" 
        4'b1111: LED_out = 7'b0111000; // "15--> F" 
        default: LED_out = 7'b1111110; // "- activate common G only"
        endcase
    end

endmodule