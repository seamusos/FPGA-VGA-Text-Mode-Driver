// Frame Buffer

module framebuffer(clk,counterX, counterY, pixel_out);

input clk;
input wire [9:0] counterX;
input wire [9:0] counterY;

output wire pixel_out;



wire [6:0] column;
wire [4:0] row;
wire [11:0] ascii_address;
wire [7:0] ascii_value;

wire [13:0] glyph_address;


reg [2:0] glyph_pos_x;	//8
reg [3:0] glyph_pos_y;	//16


assign column = counterX[9:3];
assign row = counterY[8:4];

assign ascii_address = column + (row * 80);




//text memory
text_ram text_mem(.address(ascii_address), .clock(clk), .q(ascii_value));


always @(posedge clk) begin
	glyph_pos_x <= counterX[2:0];
	glyph_pos_y <= counterY[3:0];

end

//Calculates Position in ROM
assign glyph_address = (ascii_value << 7) + glyph_pos_x + (glyph_pos_y << 3);

//Glyph memory

glyph_rom glyph(.address(glyph_address),.clock(clk), .q(pixel_out));



endmodule