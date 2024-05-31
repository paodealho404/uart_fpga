module uart
#(
    parameter CLK_PER_BIT = 435 // [CLOCK PRINCIPAL / 115200] baud rate
)
(
    input wire clk,
    input wire rx,
    output [7:0] data,
    output valid
);

    parameter STATE_IDLE = 3'b000;
    parameter STATE_START = 3'b001;
    parameter STATE_RECEIVING = 3'b010;
    parameter STATE_STOP = 3'b011;
    parameter STATE_CLR = 3'b100;

    reg [15:0] channel_clk_cnt = 16'b0;
    reg [7:0] data_reg = 8'b0;
    reg [2:0] bit_index = 3'b0;
    reg [2:0] state = 3'b0;
    reg valid_reg;
  
    always @(posedge clk)
    begin
        case (state)
            STATE_IDLE:
            begin
                bit_index <= 3'b0;
                channel_clk_cnt <= 16'b0;
                data_reg <= 8'b0;
                valid_reg <= 1'b0;
                if (rx == 1'b0)
                begin
                    state <= STATE_START;
                end
            end
            STATE_START:
            begin
                if (channel_clk_cnt != (CLK_PER_BIT-1)/2)
                begin
                    channel_clk_cnt <= channel_clk_cnt + 1;
                    valid_reg <= 1'b0;
                end
                else
                begin
                    if (rx == 1'b0)
                    begin
                        channel_clk_cnt <= 8'b0;
                        state <= STATE_RECEIVING;
                    end
                end
            end
            STATE_RECEIVING:
            begin
                if (channel_clk_cnt < CLK_PER_BIT-1)
                begin
                    channel_clk_cnt <= channel_clk_cnt + 1;
                end
                else
                begin
                    channel_clk_cnt <= 16'b0;
                    data_reg[bit_index] <= rx;

                    if (bit_index < 7)
                    begin
                        bit_index <= bit_index + 1;
                    end
                    else
                    begin
                        state <= STATE_STOP;
                        bit_index <= 3'b0;
                    end
                end
            end
            STATE_STOP:
            begin
                if (channel_clk_cnt < CLK_PER_BIT-1)
                begin
                    channel_clk_cnt <= channel_clk_cnt + 1;
                end
                else
                begin
                    if (rx == 1'b1)
                    begin
                        state <= STATE_CLR;
                        channel_clk_cnt <= 16'b0;
                        valid_reg <= 1'b1;
                    end
                end
            end
            STATE_CLR:
            begin
                valid_reg <= 1'b0;
                state <= STATE_IDLE;
            end

        endcase
    end
    assign data = data_reg;
    assign valid = valid_reg;
endmodule