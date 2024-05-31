// `timescale 1ns/10ps

// module uart_tb();

//     parameter CLK_PER_BIT = 8681; // [CLOCK PRINCIPAL / 115200] baud rate
//     parameter BIT_PERIOD = 9600;
//     parameter CLK_PERIOD_NS = 8600; 
//     wire byte_done;

//     reg clk = 0;
//     reg rx_serial = 1;
//     wire [7:0] byte_sent;
    

//     task send_byte_to_uart(
//         input [7:0] send_byte
//     );
//         integer  i;
//         begin
//             rx_serial <= 0;
//             #BIT_PERIOD;

//             for (i = 0; i < 8; i = i + 1)
//             begin
//                 rx_serial <= send_byte[i];
//                 #BIT_PERIOD;
//             end

//             rx_serial <= 1;
//             #BIT_PERIOD;
//             $display("Send byte, %h", send_byte);
//         end
        
//     endtask

//     uart #(.CLK_PER_BIT(CLK_PER_BIT)) uart_inst(
//         .clk(clk),
//         .rx(rx_serial),
//         .data(byte_sent),
//         .valid(byte_done)
//     );

//     always begin
//         #(CLK_PERIOD_NS/2) clk <= ~clk;
//     end

//     initial begin
//         @(posedge clk);
//         send_byte_to_uart(8'hFC);
//         @(posedge clk);
//         if (byte_sent != 8'hFC) begin
//             $display("Error: byte_sent = %h", byte_sent);
//         end
//         else begin
//             $display("Success: byte_sent = %h", byte_sent);
//         end
//         $finish();

//     end
//     initial begin
//        $dumpfile("uart_rx_tb.vcd");
//        $dumpvars(0);
//     end
// endmodule
//////////////////////////////////////////////////////////////////////
// File Downloaded from http://www.nandland.com
//////////////////////////////////////////////////////////////////////

// This testbench will exercise the UART RX.
// It sends out byte 0x37, and ensures the RX receives it correctly.
`timescale 1ns / 1ps
module uart_tb;

    // Parameter for the UART module
    parameter CLK_PER_BIT = 435; // Assuming a clock rate of 115200 baud

    // Testbench signals
    reg clk;
    reg rx;
    wire [7:0] data;
    wire valid;

    // Instantiate the UART module
    uart #(
        .CLK_PER_BIT(CLK_PER_BIT)
    ) uut (
        .clk(clk),
        .rx(rx),
        .data(data),
        .valid(valid)
    );

    // Generate a clock signal
    initial begin
        clk = 0;
        rx = 1;
        forever #0.5 clk = ~clk; // 1000 MHz clock (1ns period)
    end

    // Task to send a byte through RX line
    task send_byte;
        input [7:0] byte;
        integer i;
        begin
            // Send start bit (0)
            rx = 0;
            #(CLK_PER_BIT); // Wait one bit time
            
            // Send data bits (LSB first)
            for (i = 0; i < 8; i = i + 1) begin
                rx = byte[i];
                #(CLK_PER_BIT); // Wait one bit time
            end
            
            // Send stop bit (1)
            rx = 1;
            #(CLK_PER_BIT); // Wait one bit time
        end
    endtask

    // Initial block for test stimuli
    initial begin
        // Initialize RX line
        rx = 1;

        // Wait for the system to initialize
        #1000; // Wait 1000ns
        
        // Send a byte (example: 0x55)
        send_byte(8'h55);
    end

    initial begin
        @(posedge valid);
        if (data != 8'h55) begin
            $display("Error: data = %h", data);
        end
        else begin
            $display("Success: data = %h", data);
        end
        $finish();
    end

    // Monitor output for verification
    initial begin
        $monitor("Time: %t, RX: %b, Data: %h, Valid: %b", $time, rx, data, valid);
    end

endmodule