// VGA 
module vga(clk, vga_h_sync, vga_v_sync, vga_r, vga_g, vga_b, stupid_buzzer, sck, mosi, cs);

input clk; //Pin 23

input sck; //Pin_32
input mosi;	//Pin_31
input cs;	//Pin_30

/* VGA Pin Parameters */
output vga_h_sync; //Pin 101
output vga_v_sync; //Pin 103
output reg vga_r; //Pin 106
output reg vga_g; //Pin 105
output reg vga_b; //Pin 104


// buzzer is going off, idk why
output stupid_buzzer;
assign stupid_buzzer = 1'b1;



wire pixel_clock;		//~25Mhz Clock for VGA Pulse Signals
wire inDisplayArea;	// If pixel is within display limits
wire [9:0] CounterX;	// Tracks horizontal pulse
wire [9:0] CounterY;	// Tracks Verticle pulse

//wire [3:0] selector;

wire [2:0] pixel_out;	//Output from Fram Buffer

wire [7:0] ascii_shift_reg;	//Output from SPI driver

wire spi_done;
wire [2:0] spi_rising;	// Rising CS signal for end of transaction

// Divides core clock for pixel Clock
frac_clock_divider clk_divider(.clk(clk), .clk_div(pixel_clock));

// Generates Horizontal and Verticle sync pulses
sync_generator hvsync(.clk(pixel_clock), .vga_h_sync(vga_h_sync), .vga_v_sync(vga_v_sync), .inDisplayArea(inDisplayArea), .CounterX(CounterX), .CounterY(CounterY));

// 8-Bit SPI Slave driver
SPI_Module SPI(.clk(clk), .sck(sck), .mosi(mosi), .cs(cs), .input_shiftreg(ascii_shift_reg), .done(spi_done), .cs_record(spi_rising));

// Generates Image from memory for VGA
framebuffer buffer(.clk(clk), .counterX(CounterX), .counterY(CounterY), .spi_shift_reg(ascii_shift_reg), .spi_done(spi_rising), .pixel_out(pixel_out));

always @(posedge pixel_clock)
begin
	if (inDisplayArea) begin	// If within display Region
		vga_r <= 1'b1;
		vga_g <= 1'b1;
		vga_b	<= 1'b1;
	end
	else begin// if it's not to display, go dark
	  vga_r <= 1'b0;
	  vga_g <= 1'b0;
	  vga_b <= 1'b0;
	end
end


endmodule

