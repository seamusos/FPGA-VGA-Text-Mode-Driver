// Frame Buffer

module framebuffer(clk, counterX, counterY, spi_shift_reg, spi_done, pixel_out);

input clk;
input wire [9:0] counterX;
input wire [9:0] counterY;
input wire [2:0] spi_done;
input wire [7:0] spi_shift_reg;

output wire pixel_out;



wire [6:0] column;
wire [4:0] row;
wire [11:0] ascii_address;
wire [7:0] ascii_value;

wire [13:0] glyph_address;


reg [2:0] glyph_pos_x;	//8
reg [3:0] glyph_pos_y;	//16

reg [2399 : 0] write_address;
reg [7:0] data;
reg write_en;


assign column = counterX[9:3];
assign row = counterY[8:4];

assign ascii_address = column + (row * 80);


//text memory
//text_ram text_mem(.address(ascii_address), .clock(clk), .q(ascii_value));



twoport textRam(.clock(clk), .data(data), .rdaddress(ascii_address), .wraddress(write_address), .wren(write_en), .q(ascii_value));


always @(posedge clk) begin
	if(spi_done[2:1] == 2'b01) begin	// When a char has been re
		write_en = 1'b1;
		data = spi_shift_reg;
		write_address = write_address + 1; //Increment to next char
	end else
		write_en <= 1'b0;
end



always @(posedge clk) begin
	glyph_pos_x <= counterX[2:0];
	glyph_pos_y <= counterY[3:0];
end

//Calculates Position in ROM
assign glyph_address = (ascii_value << 7) + glyph_pos_x + (glyph_pos_y << 3);

//Glyph memory

glyph_rom glyph(.address(glyph_address),.clock(clk), .q(pixel_out));



endmodule