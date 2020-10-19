// Frame Buffer

module framebuffer(clk, counterX, counterY, spi_shift_reg, spi_done, pixel_out);

input clk;	//Core Clock 50Mhz
input wire [9:0] counterX;
input wire [9:0] counterY;
input wire [2:0] spi_done;
input wire [7:0] spi_shift_reg;

output wire pixel_out;



wire [6:0] column;			//
wire [4:0] row;				//Row of pixel in 8x16 glyph matrix
wire [11:0] ascii_address;	
wire [7:0] ascii_value;		//

wire [13:0] glyph_address;	//Address of pixel for corresponding ASCII code


reg [2:0] glyph_pos_x;	//8
reg [3:0] glyph_pos_y;	//16

reg [11 : 0] write_address;	//Address to be written to
reg [7:0] data;	//data port from SPI shift reg
reg write_en;		//Enables RAM Write


assign column = counterX[9:3];
assign row = counterY[8:4];

assign ascii_address = column + (row * 80);


//Testing
//text_ram text_mem(.address(ascii_address), .clock(clk), .q(ascii_value));


// Two port RAM Block to store ASCII reference from SPI
twoport textRam(.clock(clk), .data(data), .rdaddress(ascii_address), .wraddress(write_address), .wren(write_en), .q(ascii_value));


always @(posedge clk) begin
	if(spi_done[2:1] == 1'b01) begin	// When a char has been re
		write_en = 1'b1;
		data = spi_shift_reg;
		write_address = write_address + 1; //Increment to next char
	end else
		write_en = 1'b0;
end



always @(posedge clk) begin
	glyph_pos_x <= counterX[2:0];	// Every
	glyph_pos_y <= counterY[3:0];
end

//Calculates Address Position in ROM from ASCII Code, then returns bit based on pixel position
assign glyph_address = (ascii_value << 7) + glyph_pos_x + (glyph_pos_y << 3);

//Glyph memory
glyph_rom glyph(.address(glyph_address),.clock(clk), .q(pixel_out));



endmodule 